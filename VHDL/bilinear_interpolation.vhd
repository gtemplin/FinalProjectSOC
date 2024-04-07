LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL; --package needed for SIGNED
-----------------------------------------------------------------
ENTITY bilinear_interpolation IS
    PORT (clk, rst: IN STD_LOGIC;
        load: IN STD_LOGIC; --to enter new coefficient values
        run: IN STD_LOGIC; --to compute the output
    );
END bilinear_interpolation;
-----------------------------------------------------------------
ARCHITECTURE Behavioral OF bilinear_interpolation IS
-- signal declarations
BEGIN
PROCESS(clk, rst)
-- sequential 
END PROCESS
--combinational
END Behavioral
-----------------------------------------------------------------











































