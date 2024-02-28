library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package uart_bfm_pkg is
    generic(
        G_BIT_PERIOD      : time    := 8.68 us
    );		
    ------------------------------------------------------------------------------------
    --Constants - can be used to parameterise test benches
    constant c_bit_period         : time := G_BIT_PERIOD;
    constant c_start_bit          : std_logic := '0';   
    constant c_stop_bit : std_logic := '0';   

    ------------------------------------------------------------------------------------
    --Procedure used to reset the bus to its initial state			
	procedure reset_bus (signal tx  : out std_logic);

    ------------------------------------------------------------------------------------
    --Procedure to read and write data from a slave
    procedure send_tx (             i_data    : in std_logic_vector; 
                             signal tx        : out std_logic);           --number of bytes to receive

end package uart_bfm_pkg;
 


package body uart_bfm_pkg is 

procedure reset_bus (signal tx  : out std_logic) is
     
begin    
    tx <= '1';
end procedure;

procedure send_tx (             i_data    : in std_logic_vector; 
                             signal tx    : out std_logic) is
                             
     variable shift_reg : std_logic_vector(9 downto 0);
                             
begin 
    shift_reg := c_stop_bit & i_data & c_start_bit; 
    for i in 0 to 9 loop
        tx <= shift_reg(shift_reg'low);
        wait for c_bit_period;
        shift_reg := '1' & shift_reg(shift_reg'high downto shift_reg'low+1);
    end loop;
    tx <= '1';
    wait for c_bit_period;
                             
end procedure; 
                             
                                   

end package body;