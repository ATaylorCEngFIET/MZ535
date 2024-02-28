library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Declare entity
entity axi_protocol is
	port(	
			--Master clock & reset
			clk 			 :in std_ulogic;                                            --System clock
			reset			 :in std_ulogic;                                            --System reset, async active low

			eop_reset		: in std_ulogic; -- spw end of packet used for resync

            --! Master AXIS Interface  
            m_axis_tready : in  std_logic;
            m_axis_tdata  : out std_logic_vector(7 downto 0);
            m_axis_tvalid : out std_logic;

            --! Slave AXIS Interface
            s_axis_tready : out  std_logic;
            s_axis_tdata  : in std_logic_vector(7 downto 0);
            s_axis_tvalid : in std_logic;
            
            --! register Interface 
            reg_0 : out std_logic_vector(20 downto 0);
            reg_1 : out std_logic_vector(20 downto 0);
            reg_2 : out std_logic_vector(20 downto 0);
            reg_3 : out std_logic_vector(20 downto 0);
            reg_4 : out std_logic_vector(20 downto 0);
            reg_5 : out std_logic_vector(20 downto 0);
			reg_6 : out std_logic_vector(20 downto 0);
			reg_7 : out std_logic_vector(20 downto 0)
		);
		
end entity axi_protocol;

architecture rtl of axi_protocol is 

    constant C_SINGLE_READ            : std_logic_vector(7 downto 0) := x"05";
    constant C_SINGLE_WRITE           : std_logic_vector(7 downto 0) := x"09";

    constant C_NUMB_ADDR_BYTES        : integer := 4;
    constant C_NUMB_LENGTH_BYTES      : integer := 1;
    constant C_NUMB_DATA_BYTES        : integer := 4;
    constant C_NUMB_AXIL_DATA_BYTES   : integer := 4;
    --constant C_NUMB_CRC_BYTES         : integer := 4;   
    constant C_MAX_NUMB_BYTES         : integer := 4; -- max number of the above constant for number of bytes 
    constant C_ZERO_PAD               : std_logic_vector(7 downto 0) := (others => '0');
    
    type t_fsm is (idle, address, length, dummy, write_payload, read_payload, crc, write_axil, write_axi, read_axi, read_axil);
    type t_op_fsm is (idle, output, check);
    type t_array is array (0 to 7) of std_logic_vector(31 downto 0);
    type axil_read_fsm is (IDLE, START, CHECK_ADDR_RESP, READ_DATA, DONE);
    type axil_write_fsm is (IDLE, START, CHECK_ADDR_RESP, WRITE_DATA, RESP_READY, CHECK_RESP, DONE);
    signal write_state : axil_write_fsm;
    signal read_state  : axil_read_fsm;

    signal s_current_state : t_fsm;

    signal s_command            : std_logic_vector(7 downto 0);
    signal s_address            : std_logic_vector((C_NUMB_ADDR_BYTES * 8)-1 downto 0);
    signal s_length             : std_logic_vector(7 downto 0);
    signal s_length_axi         : std_logic_vector(7 downto 0);
    signal s_buf_cnt            : unsigned(7 downto 0);
    signal s_byte_pos           : integer range 0 to C_MAX_NUMB_BYTES; 
    signal s_num_bytes          : integer range 0 to C_MAX_NUMB_BYTES; 
    signal s_s_tready           : std_logic;
    signal s_write_buffer       : t_array :=(others=>(others=>'0'));
    signal s_read_buffer        : t_array :=(others=>(others=>'0'));
    signal s_write_buffer_temp  : std_logic_vector(31 downto 0);
    signal s_read_buffer_temp   : std_logic_vector(31 downto 0);

    --axil lite data interface 
    signal s_axil_data          : std_logic_vector(7 downto 0);
    signal s_axil_valid         : std_logic;
    signal s_axil_idata         : std_logic_vector(7 downto 0);


    --axi mstream 
    signal s_opptr              : unsigned(7 downto 0);
    signal s_start              : std_logic;
    signal s_op_state           : t_op_fsm;
    signal s_op_byte            : integer range 0 to C_MAX_NUMB_BYTES; 
    signal start_read           : std_logic;
    signal start_write          : std_logic;
    signal s_m_axis_tvalid      : std_logic;

begin

    s_axis_tready <= s_s_tready;

FSM : process(clk, reset )
begin 
    if (reset = '0') then 
        start_read  <= '0';
        start_write <= '0';
        s_current_state <= idle;
        s_s_tready  <= '0';
    elsif rising_edge(clk) then
        s_s_tready  <= '1';
        s_start     <= '0';
        start_read  <= '0';
        start_write <= '0';
		if eop_reset = '1' then 
			s_current_state <= idle;
		else
			case s_current_state is
            when idle => -- to do needs to check the command is valid
                s_buf_cnt           <= (others =>'0');
                if (s_axis_tvalid = '1' and s_s_tready = '1') and 
                    (s_axis_tdata = C_SINGLE_READ  or s_axis_tdata = C_SINGLE_WRITE) then
                        s_s_tready <= '0';
                        s_command <= s_axis_tdata;
                        s_current_state <= address;
                        s_byte_pos <= C_NUMB_ADDR_BYTES;
                end if;

            when address =>
                if s_byte_pos = 0 then
                    s_s_tready <= '0';
                    s_byte_pos <= C_NUMB_LENGTH_BYTES;
                    s_current_state <= length;    
                elsif s_axis_tvalid = '1' and s_s_tready = '1'  then
                    s_address <= s_address(s_address'length-8-1 downto 0) & s_axis_tdata;
                    s_byte_pos <= s_byte_pos - 1;
                    if s_byte_pos = 1 then 
                        s_s_tready <= '0';
                    end if; 
                end if;

            when length => 
                if s_byte_pos = 0 then
                    s_s_tready <= '0';
                    if s_command = C_SINGLE_READ and unsigned(s_length) = 1 then
                        s_current_state <= read_axil; 
                        start_read      <= '1';
                        s_num_bytes     <= C_NUMB_AXIL_DATA_BYTES;
                    elsif s_command = C_SINGLE_WRITE then
                        s_buf_cnt       <= (others =>'0');
                        s_byte_pos      <= C_NUMB_AXIL_DATA_BYTES;
                        s_num_bytes     <= C_NUMB_AXIL_DATA_BYTES;
                        s_current_state <= write_payload;
                    end if;    
                elsif s_axis_tvalid = '1' and s_s_tready = '1'  then
                    s_length            <= s_axis_tdata;
                    s_length_axi        <= std_logic_vector(unsigned(s_axis_tdata)-1);
                    s_byte_pos          <= s_byte_pos - 1;
                    s_s_tready <= '0';
                end if;

            when read_axil =>  
                    s_start             <= '1';
                    s_read_buffer(0) <= s_write_buffer(to_integer(unsigned(s_address)));
                    s_current_state <= read_payload;
            
            when write_payload =>
                if s_buf_cnt = unsigned(s_length) then 
                    s_s_tready <= '0';
                    s_current_state <= idle;
                else
                    if s_byte_pos = 0 then 
                        s_s_tready <= '0';
                        s_byte_pos <= s_num_bytes;
                        s_write_buffer(to_integer(unsigned(s_address))) <= s_write_buffer_temp;
                        s_buf_cnt <= s_buf_cnt + 1;  
                    elsif (s_axis_tvalid = '1' and s_s_tready = '1')  then
                        s_write_buffer_temp <= s_write_buffer_temp(s_write_buffer_temp'length-8-1 downto 0) & s_axis_tdata;
                        s_byte_pos <= s_byte_pos - 1;  
                        if s_byte_pos = 1 then 
                            s_s_tready <= '0';
                        end if;   
                    end if;
                end if;

            when read_payload =>
                s_current_state <= idle;
            when others => null;
        end case;
		end if;
	end if;

end process;

reg_0 <= s_write_buffer(0)(20 downto 0);
reg_1 <= s_write_buffer(1)(20 downto 0);
reg_2 <= s_write_buffer(2)(20 downto 0);
reg_3 <= s_write_buffer(3)(20 downto 0);
reg_4 <= s_write_buffer(4)(20 downto 0);
reg_5 <= s_write_buffer(5)(20 downto 0);
reg_6 <= s_write_buffer(6)(20 downto 0);
reg_7 <= s_write_buffer(7)(20 downto 0);

m_axis_tvalid <= s_m_axis_tvalid;

process(clk, reset)
begin
    if (reset = '0') then 
        s_m_axis_tvalid     <= '0';
        s_op_state          <= idle;
        m_axis_tdata        <= (others =>'0');
        s_opptr             <= (others => '0');
        s_op_byte           <= C_NUMB_AXIL_DATA_BYTES;
    elsif rising_edge(clk) then 
        case s_op_state is  
            when idle => 
                s_m_axis_tvalid <= '0';
                if s_start = '1' then 
                    s_opptr     <= (others => '0');
                    s_read_buffer_temp <= s_read_buffer(0);
                    s_op_byte   <= s_num_bytes;
                    s_op_state  <= output;
                end if;
            when output =>
                if s_opptr = unsigned(s_length) then 
                    s_op_state <= idle;
                    s_m_axis_tvalid <= '0';
                else 
                    s_m_axis_tvalid <= '1';
                    m_axis_tdata <= s_read_buffer_temp(7 downto 0);
                    if s_op_byte = 0 then 
                        s_op_byte   <= s_num_bytes;
                        s_opptr     <= s_opptr + 1;
                        s_m_axis_tvalid <= '0';   
                    elsif m_axis_tready = '1'  then 
                        s_m_axis_tvalid <= '1';                  
                        s_read_buffer_temp <= C_ZERO_PAD & s_read_buffer_temp(s_read_buffer_temp'length-1 downto 8);
                        s_op_byte <= s_op_byte - 1; 
                        s_op_state  <= check;  
                    end if;      
                end if;
            when check =>
                s_m_axis_tvalid <= '0';   
                s_op_state  <= output;
        end case;
    end if;

end process;

end architecture;