library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package bilinear_functions is
-- define types to be used in buffers 
    constant max_line_length : INTEGER := 2048;
    type single_line is array (0 to max_line_length-1) of std_logic_vector(7 downto 0);
    type line_buffers is array (1 to 3) of single_line;
    type RGB_Buffer_Matrix is array (1 to 3) of line_buffers;
-- Function to clear out a line buffer
    function clear_line_buffers return line_buffers;
end bilinear_functions;



package body bilinear_functions is
-- implement the clear function
    function clear_line_buffers return line_buffers is
        variable result : line_buffers;
    begin
        for i in result'range loop 
            for j in result(i)'range loop
                result(i)(j) := (others => '0');
            end loop;
        end loop;
        return result;
    end function;

 
end bilinear_functions;
