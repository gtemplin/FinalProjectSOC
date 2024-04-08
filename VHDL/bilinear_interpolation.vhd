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
            line_width: IN STD_LOGIC_VECTOR(10 DOWNTO 0); -- up to 2048 pixels per line, more than sufficient for 1080p
            loading: IN STD_LOGIC; -- filter needs two full lines before it can perform calculations 
            reset: IN STD_LOGIC;
            );
END bilinear_interpolation;
----------------------------------------------------------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF bilinear_interpolation IS
-- type declarations
    TYPE single_line IS ARRAY (0 to 4095) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    TYPE line_buffer IS ARRAY (0 TO 1) OF single_line;
-- signal declarations 
    SIGNAL red_buffer : line_buffer;
    SIGNAL green_buffer : line_buffer;
    SIGNAL blue_buffer: line_buffer;
    SIGNAL counter : INTEGER;
BEGIN
    PROCESS(clk, rst)
    BEGIN
        IF reset = '1' THEN
            counter := 0; 
            FOR i IN line_buffer'range
                FOR j IN single_line'range
                    red_buffer(i)(j) <= (OTHERS => '0')
                    green_buffer(i)(j) <= (OTHERS => '0');
                    blue_buffer(i)(j) <= (OTHERS => '0');
                END LOOP;
            END LOOP;
        ELSIF rising_edge(clk) THEN
            IF loading = '1' THEN
                -- don't yet have full buffers
            ELSE
                -- full buffers ready for filtering 
            END IF; 
        END IF;
    END PROCESS
--combinational
END Behavioral
----------------------------------------------------------------------------------------------------------------------------------











































