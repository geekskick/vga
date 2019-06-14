library ieee;
use ieee.std_logic_1164.all;

entity all_tb is
end all_tb;

architecture structural of all_tb is
    
begin

    driver_tb   : entity work.driver_tb;
    mem_tb      : entity work.mem_tb;
    top_tb      : entity work.top_vga_tb;
end architecture;
