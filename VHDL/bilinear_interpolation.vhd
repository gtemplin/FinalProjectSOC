-- -------- INPUT INFO: ----------------
-- Reset should be done before each new image is created
-- First inputs need to be original image dimensions, then new image dimensions 
-- Stream in RGB pixels in raster fashion, a two-line buffer will be used to hold pixels




LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL; --package needed for SIGNED
----------------------------------------------------------------------------------------------------------------------------------
ENTITY bilinear_interpolation IS
    PORT (clk, rst: IN STD_LOGIC;
            -- The input pixels
            red_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            green_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            blue_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            -- The output pixels 
            red_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            green_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            blue_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            -- Control signals
            input_width: IN STD_LOGIC_VECTOR(10 DOWNTO 0); -- up to 2048 pixels per line, more than sufficient for 1080p
            input_height: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            output_width: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            output_height:  IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            reset: IN STD_LOGIC;
            );
END bilinear_interpolation;
----------------------------------------------------------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF bilinear_interpolation IS
    constant max_line_length : INTEGER := 2048;
-- type declarations
    TYPE single_line IS ARRAY (0 TO max_line_length*3-1) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    TYPE line_buffer IS ARRAY (0 TO 2) OF single_line;
    TYPE state IS (waiting, initial_load, process_load_next, final_processing);
-- signal declarations 
    SIGNAL red_buffer : line_buffer;
    SIGNAL green_buffer : line_buffer;
    SIGNAL blue_buffer: line_buffer;
    SIGNAL next_line_ready : STD_LOGIC; -- can calculations take place yet (true or false) 
    SIGNAL red_int, green_int, blue_int : unsigned(7 downto 0); -- internal signals for pixels 
    SIGNAL height : STD_LOGIC_VECTOR(10 DOWNTO 0);
    SIGNAL width : STD_LOGIC_VECTOR(10 DOWNTO 0);
    SIGNAL current_state : state;
-- variable declarations 
    VARIABLE pixel_counter : INTEGER; -- where you are in the line
    VARIABLE line_counter : INTEGER; -- the line you are on itself 
BEGIN
    PROCESS(clk, rst)
    BEGIN
    -- Obtain the internal signals 
        red_int <= unsigned(red_in);
        green_int <= unsigned(green_in);
        blue_int <= unsigned(blue_in);
        height <= unsigned(input_height); 
        width <= unsigned(input_width); 
    -- Process the inputs 
        IF reset = '1' THEN
            pixel_counter := 0; 
            line_counter := 0; 
            loading <= '1' -- will need to load in new pixel values upon a reset 
            current_state := waiting; -- waiting for pixels to be loaded in  
            FOR i IN line_buffer'range
                FOR j IN single_line'range
                    red_buffer(i)(j) <= (OTHERS => '0')
                    green_buffer(i)(j) <= (OTHERS => '0');
                    blue_buffer(i)(j) <= (OTHERS => '0');
                END LOOP;
            END LOOP;
        ELSIF rising_edge(clk) THEN
            CASE(current_state) IS 
            END CASE;
        END IF; -- end of rising edge process 
    END PROCESS
--combinational
END Behavioral
----------------------------------------------------------------------------------------------------------------------------------











































