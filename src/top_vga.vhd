library ieee;
use ieee.std_logic_1164.all;

entity top_vga is
generic(
    colour_width : integer := 16 
    );
port(
    clk     : in std_logic;
    en      : in std_logic;
    r       : out std_logic_vector(colour_width-1 downto 0);
    g       : out std_logic_vector(colour_width-1 downto 0);
    b       : out std_logic_vector(colour_width-1 downto 0);
    hsync   :out std_logic;
    vsync   :out std_logic
);
end entity;

architecture s of top_vga is
    constant addr_width : integer := 10;
    signal active : std_logic;
    signal addr_v : std_logic_vector(addr_width-1 downto 0);
    signal addr_h : std_logic_vector(addr_width-1 downto 0);
    signal r_i    : std_logic_vector(colour_width-1 downto 0);
    signal b_i    : std_logic_vector(colour_width-1 downto 0);
    signal g_i    : std_logic_vector(colour_width-1 downto 0);
begin

    dr: entity work.vga_driver
    generic map(
        addr_width => 10
    ) port map(
        clk_25_2_mhz => clk,
        en => en,
        is_active => active,
        addr_v => addr_v,
        addr_h => addr_h, 
        hsync => hsync,
        vsync => vsync
    );

    m: entity work.video_mem 
    generic map(
        addr_width => addr_width,
        colour_width => colour_width
    ) port map(
        addr_v => addr_v,
        addr_h => addr_h,
        r => r_i,
        g => g_i,
        b => b_i
    );

    r <= r_i when active = '1' else (others=>'0');
    g <= g_i when active = '1' else (others=>'0');
    b <= b_i when active = '1' else (others=>'0');
end architecture;        
