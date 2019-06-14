library ieee;
use ieee.std_logic_1164.all;

entity mem_tb is
end mem_tb;

architecture Behavioral of mem_tb is
    constant period : time := 100ns;
    signal clk : std_logic := '0';
    
    signal stop : boolean := false;
    
    constant address_width  : integer := 4;
    constant colour_width   : integer := 4;
    
    signal addr_v   : std_logic_vector(address_width-1 downto 0);
    signal addr_h   : std_logic_vector(address_width-1 downto 0);
    signal r        : std_logic_vector(colour_width-1 downto 0);
    signal g        : std_logic_vector(colour_width-1 downto 0);
    signal b        : std_logic_vector(colour_width-1 downto 0);

begin

    uut: entity work.video_mem
    generic map(
        addr_width      => address_width,
        colour_width    => colour_width
    )
    port map(
        addr_v => addr_v,
        addr_h => addr_h,
        r => r,
        g => g,
        b => b 
    );

    stim: process
    begin
        -- The video memory just squirts out a bunch of squares. for now I don't care about the actual stuff in there
        -- so this is more of a placeholder testbench
    

        wait;
    end process;
    
end architecture;