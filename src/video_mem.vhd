library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity video_mem is
    generic(
        addr_width      : integer := 10;
        colour_width    : integer := 16
    );
    port(
        addr_v  : in std_logic_vector(addr_width-1 downto 0);
        addr_h  : in std_logic_vector(addr_width-1 downto 0);
        r       : out std_logic_vector(colour_width-1 downto 0);
        b       : out std_logic_vector(colour_width-1 downto 0);
        g       : out std_logic_vector(colour_width-1 downto 0)
    );
end video_mem;

architecture behavioral of video_mem is
    signal addr_v_i : integer;
    signal addr_h_i : integer;
    signal code : std_logic_vector(2 downto 0);
begin
    addr_v_i <= to_integer(unsigned(addr_v));
    addr_h_i <= to_integer(unsigned(addr_h));
    
    -- Just a bunch of different squares
    process(addr_v_i, addr_h_i)
        constant section_1_right : integer := 160;
        constant section_2_right : integer := 320;
        constant section_3_right : integer := 480;
        constant section_4_right : integer := 600;
        constant top_row_bottom  : integer := 200;
        constant bottom_row_bottom:integer := 400;

    begin
        code <= "000";
        
        if addr_v_i < top_row_bottom then
        
            if addr_h_i < section_1_right then
            elsif addr_h_i < section_2_right then
                code <= "001";
            elsif addr_h_i < section_3_right then
                code <= "010";
            elsif addr_h_i < section_4_right then
                code <= "011";
            end if;
            
        else
        
            if addr_h_i < section_1_right then
                code <= "100";
            elsif addr_h_i < section_2_right then
                code <= "101";
            elsif addr_h_i < section_3_right then
                code <= "110";
            elsif addr_h_i < section_4_right then
                code <= "111";
            end if;
            
        end if;
     
    end process;
    
    r <= (others => '1') when code(0) = '1' else (others => '0');
    g <= (others => '1') when code(1) = '1' else (others => '0');
    b <= (others => '1') when code(2) = '1' else (others => '0');
    
end behavioral;
