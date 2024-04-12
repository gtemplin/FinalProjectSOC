library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --package needed for signed

-- Import my functions/types 
library work; use work.bilinear_functions.all;



----------------------------------------------------------------------------------------------------------------------------------
entity bilinear_interpolation is
    port (clk, rst: in std_logic;
            -- The input pixels
            red_in: in std_logic_vector(7 downto 0);
            green_in: in std_logic_vector(7 downto 0);
            blue_in: in std_logic_vector(7 downto 0);
            -- The output pixels 
            red_out: out std_logic_vector(7 downto 0);
            green_out: out std_logic_vector(7 downto 0);
            blue_out: out std_logic_vector(7 downto 0);
            -- Control signals
            input_width: in std_logic_vector(10 downto 0); -- up to 2048 pixels per line, more than sufficient for 1080p
            input_height: in std_logic_vector(10 downto 0);
            output_width: in std_logic_vector(10 downto 0);
            output_height:  in std_logic_vector(10 downto 0);
            reset: in std_logic;
            valid_input: in std_logic); -- when tvalid is high, that means that axi has received valid data that is ready to be filtered 
end bilinear_interpolation;
----------------------------------------------------------------------------------------------------------------------------------
architecture behavioral of bilinear_interpolation is
    constant max_line_length : integer := 2048;
    type state is (idle, initial_load, process_load_next, final_processing);
-- signal declarations 
    signal red_buffer : line_buffers;
    signal green_buffer : line_buffers;
    signal blue_buffer: line_buffers;
    signal buffer_matrix : RGB_Buffer_Matrix;
    signal next_line_ready : std_logic; -- can calculations take place yet (true or false) 
    signal red_int, green_int, blue_int : unsigned(7 downto 0); -- internal signals for pixels 
    signal height : unsigned(10 downto 0);
    signal width : unsigned(10 downto 0);
    signal line_complete: std_logic; -- boolean to determine if the new line has been generated 
-- state machine signals
    signal current_state, next_state : state;

begin
    process(clk, rst)
        -- variable declarations 
        variable pixel_counter : integer; -- where you are in the line
        variable line_counter : integer; -- the line you are on itself 
        variable loading_buffer_index : integer;
    begin
    -- Obtain the internal signals 
        red_int <= unsigned(red_in);
        green_int <= unsigned(green_in);
        blue_int <= unsigned(blue_in);
        height <= unsigned(input_height); 
        width <= unsigned(input_width); 
    -- Go to initial state w/ everything cleared 
        if reset = '1' then
            pixel_counter := 0; 
            line_counter := 0; 
            current_state <= idle; next_state <= initial_load;
            -- clear out RGB buffers 
            buffer_matrix(1) <= clear_line_buffers; buffer_matrix(2) <= clear_line_buffers; buffer_matrix(3) <= clear_line_buffers;
        elsif rising_edge(clk) then
        
        end if; 
    end process;
--combinational
end behavioral;
----------------------------------------------------------------------------------------------------------------------------------
