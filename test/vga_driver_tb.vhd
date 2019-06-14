library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity driver_tb is
end driver_tb;

architecture Behavioral of driver_tb is
    constant period : time := 39680 ps; -- 25.2MHz is 39.68ns
    signal clk : std_logic := '0';

    signal stop : boolean := false;
    
    constant address_width : integer := 10;
    signal en           : std_logic;
    signal is_active    : std_logic;
    signal addr_v       : std_logic_vector(address_width-1 downto 0);
    signal addr_h       : std_logic_vector(address_width-1 downto 0);
    signal hsync        : std_logic;
    signal vsync        : std_logic;

begin
    tick: process
    begin
        while stop = false loop
            clk <= '1';
            wait for period/2;
            clk <= '0';
            wait for period/2;
        end loop;
        wait;
    end process;
    
    uut: entity work.vga_driver 
    generic map(
        addr_width      => address_width
    )
    port map(
        clk_25_2_mhz    => clk,
        en              => en,
        is_active       => is_active,
        addr_v          => addr_v,
        addr_h          => addr_h,
        hsync           => hsync,
        vsync           => vsync
    );

    stim: process
        variable previous_addr_v : std_logic_vector(address_width-1 downto 0);
        variable previous_addr_h : std_logic_vector(address_width-1 downto 0);
        variable i: integer;
        variable l: integer;
    begin
        en <= '0';
        -- Check that it doesn't count when not enabled
        previous_addr_v := (others => '0');
        previous_addr_h := (others => '0');
        wait for period * 5;
        assert previous_addr_h = addr_h report "When not enabled the count is still happening" severity failure;
        assert previous_addr_v = addr_v report "When not enabled the count is still happening" severity failure;
        
        -- While it's a 0,0 this should be visible space
        assert is_active = '1' report "When at 0,0 this is visible screen space" severity failure;
        assert hsync = '0' report "Hsync in active screen space" severity failure;
        assert vsync = '0' report "Vsync in active screen space" severity failure;
        
        -- I want to enable it before the rising edge
        wait for period/2;
        en <= '1';
        
        l := 0;
        while l < 480 loop

            i := 0;
            while i < 640 loop
                assert to_integer(unsigned(addr_v)) = l report "Line number increased early" severity failure;
                assert to_integer(unsigned(addr_h)) = i report "Pixel addrss isn't increasing" severity failure;
                assert is_active = '1' report "This is visible screen space" severity failure;
                assert hsync = '0' report "Hsync in active screen space" severity failure;
                assert vsync = '0' report "Vsync in active screen space" severity failure;
                wait for period;
                i := i + 1;
            end loop;
            
           
            i := 0;
            while i < 16 loop
                assert to_integer(unsigned(addr_v)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert to_integer(unsigned(addr_h)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert is_active <= '0' report "Off the end of the horizontal visible bit" severity error;
                assert hsync = '0' report "Hsync in h front porch" severity failure;
                assert vsync = '0' report "Vsync in h front porch" severity failure;
                wait for period;
                i := i + 1;
            end loop;
            
            i := 0;
            while i < 96 loop
                assert to_integer(unsigned(addr_v)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert to_integer(unsigned(addr_h)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert is_active <= '0' report "Off the end of the horizontal visible bit" severity error;
                assert hsync = '1' report "Hsync not on" severity failure;
                assert vsync = '0' report "Vsync in hsync" severity failure;
                wait for period;
                i := i + 1; 
            end loop;
            
            i := 0;
            while i < 48 loop
                assert to_integer(unsigned(addr_v)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert to_integer(unsigned(addr_h)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert is_active <= '0' report "Off the end of the horizontal visible bit" severity error;
                assert hsync = '0' report "Hsync in h back porch" severity failure;
                assert vsync = '0' report "Vsync in h back porch" severity failure;
                wait for period;
                i := i + 1; 
            end loop;
            
            
            l := l + 1;
        end loop;
        
        l := 0;
        while l < 10 loop         
            i := 0;
            while i < 800 loop
                assert to_integer(unsigned(addr_v)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert to_integer(unsigned(addr_h)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert is_active <= '0' report "Off the bottom of the vertical visible bit" severity error;
                assert hsync = '0' report "Hsync in v front porch" severity failure;
                assert vsync = '0' report "vsync in the v front porch" severity failure;
                wait for period;
                i := i + 1;
            end loop;
            l := l + 1;
        end loop;
        
        l := 0;
        while l < 2 loop
            i := 0;
            while i < 800 loop
                assert to_integer(unsigned(addr_v)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert to_integer(unsigned(addr_h)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert is_active <= '0' report "Off the bottom of the vertical visible bit" severity error;
                assert hsync = '0' report "Hsync in vsync" severity failure;
                assert vsync = '1' report "vsync is supposed to be high" severity failure;      
                wait for period;
                i := i + 1;
            end loop;
            l := l + 1;
        end loop;
        
        l := 0;
        while l < 33 loop
            i := 0;
            while i < 800 loop
                assert to_integer(unsigned(addr_v)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert to_integer(unsigned(addr_h)) = 0 report "Line number is expected to be 0'd in non active space" severity failure;
                assert is_active <= '0' report "Off the bottom of the vertical visible bit" severity error;
                assert hsync = '0' report "Hsync in v back porch" severity failure;
                assert vsync = '0' report "vsync in v back_porch" severity failure;      
                wait for period;
                i := i + 1;
            end loop;
            l := l + 1;
        end loop;
        
        assert to_integer(unsigned(addr_v)) = 0 report "Line number is expected to be 0" severity failure;
        assert to_integer(unsigned(addr_h)) = 0 report "Line number is expected to be 0" severity failure;
        assert is_active <= '1' report "New frame" severity error;
        assert hsync = '0' report "Hsync in visible" severity failure;
        assert vsync = '0' report "vsync in visible" severity failure;      

        stop <= true;
        report "======== driver testbench done= =========";
        wait;
    end process;

end architecture;

