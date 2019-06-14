library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_driver is
    generic(
        addr_width  : integer := 10
    );
    port(
        clk_25_2_mhz: in std_logic;
        en          : in std_logic;
        is_active   : out std_logic;
        addr_v      : out std_logic_vector(addr_width-1 downto 0);
        addr_h      : out std_logic_vector(addr_width-1 downto 0);
        hsync       : out std_logic;
        vsync       : out std_logic
    );
end entity vga_driver;

architecture b of vga_driver is
    signal pixel_clock              : std_logic;
    signal horizontal_pixel_number  : integer := 0; -- The pixel number horizontally
    signal line_number              : integer := 0; -- The line number
    
    constant disp_width : integer := 640;
    constant disp_height: integer := 480;   

    -- The VGA spec at 60Hz
    -- http://tinyvga.com/vga-timing/640x480@60Hz
    type dimension is record
        front_porch : integer;
        sync        : integer;
        back_porch  : integer;
        visible     : integer;
        total       : integer;
    end record;

    -- Horizontal Timing:
    --  Visible Area    = 640   (25.422us)
    --  Front Porch     = 16    (0.64us)
    --  Sync Pulse      = 96    (3.813us)
    --  Back Porch      = 48    (1.91us)
    --  Total           = 800   (31.777us) 
    -- The visible area comes before the sync pulses
    constant h_dimensions : dimension := (disp_width+16, disp_width+16+96, disp_width+16+96+48, disp_width, 800);

    -- Vertical Timing:
    --  Visible Area    = 480   (15.24ms)
    --  Front Porch     = 10    (0.3178ms)
    --  Sync Pulse      = 2     (0.0635ms)
    --  Back Porch      = 33    (1.05ms)
    --  Total           = 525   (16.683ms)
    -- The visible area comes before the sync pulses
    constant v_dimensions : dimension := (disp_height+10, disp_height+10+2, disp_height+10+2+33, disp_height, 525);
begin
    pixel_clock <= clk_25_2_mhz;

    process(horizontal_pixel_number, line_number)
    begin

        vsync <= '0';
        hsync <= '0';
        addr_h <= (others => '0');
        addr_v <= (others => '0');
        is_active <= '0';
        
        if line_number < v_dimensions.visible then
            -- In the visible part of the vertical display
            -- so I care about the horizontal part of the display
            
            if horizontal_pixel_number < h_dimensions.visible then
                is_active <= '1';
                addr_v <= std_logic_vector(to_unsigned(line_number, addr_v'length));
                addr_h <= std_logic_vector(to_unsigned(horizontal_pixel_number, addr_h'length));
                
            elsif horizontal_pixel_number < h_dimensions.front_porch then
                -- Not in active display but 
            
            elsif horizontal_pixel_number < h_dimensions.sync then
                -- In the hsync area
                hsync <= '1';
                
            elsif horizontal_pixel_number < h_dimensions.back_porch then
                -- hsync stays low
                
            elsif horizontal_pixel_number < h_dimensions.visible then
                is_active <= '1';
                addr_v <= std_logic_vector(to_unsigned(line_number,addr_v'length));
                addr_h <= std_logic_vector(to_unsigned(horizontal_pixel_number - h_dimensions.back_porch, addr_h'length));
            end if;

        elsif line_number < v_dimensions.front_porch then
        elsif line_number < v_dimensions.sync then
            vsync <= '1';
        elsif line_number < v_dimensions.back_porch then
        end if;
    end process;

    -- Line/H counter
    process(pixel_clock)
    begin
        if rising_edge(pixel_clock) and en = '1' then
            if horizontal_pixel_number = h_dimensions.total - 1 then
                -- At the end of the line
                horizontal_pixel_number <= 0;
        
                if line_number = v_dimensions.total - 1 then
                    -- At the end of the frame too
                    line_number <= 0;
                else
                    -- Not at the end of the frame so just so go down a line
                    line_number <= line_number + 1;
                end if;
            else 
                -- Not at the end of the line so just go across one pixel
                horizontal_pixel_number <= horizontal_pixel_number + 1;
            end if;
        end if;
    end process;

end architecture b;
