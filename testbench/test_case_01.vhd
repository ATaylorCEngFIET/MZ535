

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity test_case_01 is

end test_case_01;

architecture Behavioral of test_case_01 is

alias rs232_tx  is << signal .test_case_01.tb.s_rx  : std_logic  >>;

begin

tb : entity work.test_bench;

stim : process 
   begin
    work.prot_uart_bfm_pkg.reset_bus (rs232_tx);
    wait for 1 us; 
    
    --set register 0 
    --command
    for i in 0 to 7 loop 
        work.prot_uart_bfm_pkg.send_tx(x"09",rs232_tx);
        --address
        work.prot_uart_bfm_pkg.send_tx(x"00",rs232_tx);
        work.prot_uart_bfm_pkg.send_tx(x"00",rs232_tx);
        work.prot_uart_bfm_pkg.send_tx(x"00",rs232_tx);
        work.prot_uart_bfm_pkg.send_tx(std_logic_vector(to_unsigned(i,8)),rs232_tx);
        --length
        work.prot_uart_bfm_pkg.send_tx(x"01",rs232_tx);
        --data 
        --1ms pulse
        work.prot_uart_bfm_pkg.send_tx(x"00",rs232_tx);
        work.prot_uart_bfm_pkg.send_tx(x"01",rs232_tx);
        work.prot_uart_bfm_pkg.send_tx(x"86",rs232_tx);
        work.prot_uart_bfm_pkg.send_tx(x"a0",rs232_tx);
    end loop;  

    wait for 50 ms;
    report "simulation complete!" severity failure;
end process;
    

end Behavioral;
