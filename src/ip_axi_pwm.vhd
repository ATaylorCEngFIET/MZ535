library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_func is port(
    resetn      : in std_logic;
    clk         : in std_logic;
    pwm_reg     : in std_logic_vector(20 downto 0);
    pwm_op      : out std_logic
);
end entity;

Architecture rtl of pwm_func is 
    constant max_count : unsigned(20 downto 0) := to_unsigned(1_666_666,21);
    signal count :   unsigned(20 downto 0) :=(others=>'0');
    signal int_target : unsigned(20 downto 0) :=(others=>'0');
begin 

process(resetn, clk)
begin
    if resetn = '0' then 
        count <= (others =>'0');
        pwm_op <= '0';
        int_target <= to_unsigned(150_000,21);
    elsif rising_edge(clk) then
        if count < int_target then 
            pwm_op <= '1'; 
        else
            pwm_op <= '0';
        end if; 
        if count = max_count then 
            count <= (others=>'0');
            int_target <= unsigned(pwm_reg);
        else
            count <= count + 1;
        end if;
    end if;
end process;


end architecture; 