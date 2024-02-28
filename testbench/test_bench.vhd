library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package prot_uart_bfm_pkg is new work.uart_bfm_pkg generic map(
    G_BIT_PERIOD => 8.68 us
    ); 


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_bench is

end test_bench;

architecture Behavioral of test_bench is

    constant c_clk_period   : time := 10ns;
    signal s_clk            : std_logic := '0';
    
    signal s_rx             : std_logic;
    signal s_tx             : std_logic;
    signal s_locked         : std_logic;
    
    signal s_pwm_op_0       :  STD_LOGIC;
    signal s_pwm_op_1       :  STD_LOGIC;
    signal s_pwm_op_2       :  STD_LOGIC;
    signal s_pwm_op_3       :  STD_LOGIC;
    signal s_pwm_op_4       :  STD_LOGIC;
    signal s_pwm_op_5       :  STD_LOGIC;
    signal s_pwm_op_6       :  STD_LOGIC;
    signal s_pwm_op_7       :  STD_LOGIC;

begin

clk_gen: s_clk <= not s_clk after (c_clk_period/2);

uut: entity work.design_1_wrapper 
  port map (
    locked_0    => s_locked,
    pwm_op_0    => s_pwm_op_0,
    pwm_op_1    => s_pwm_op_1,
    pwm_op_2    => s_pwm_op_2,
    pwm_op_3    => s_pwm_op_3,
    pwm_op_4    => s_pwm_op_4,
    pwm_op_5    => s_pwm_op_5,
    pwm_op_6    => s_pwm_op_6,
    pwm_op_7    => s_pwm_op_7,
    rx          => s_rx,
    sys_clock   => s_clk,
    tx          => s_tx
  );



end Behavioral;
