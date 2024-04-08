----------------------------------------------------------------------------------
-- Company: IUPUI
-- Engineer: Dr. Lauren Christopher
-- 
-- Create Date: 02/14/2022 06:59:10 PM
-- Design Name: 
-- Module Name: ColorBars - Behavioral
-- Project Name: LABProject3
-- Target Devices: PYNQ
-- Tool Versions: VIVADO 2018.3
-- Description: This module creates color bars to the SMPTE Standard SVGA 60Hz, and a Red/White Flag 
-- to be paired with the Video Timing IP set to 800x600 60p
-- 
-- Dependencies: 
-- 
-- Revision: 1
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;  

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;   -- we will use this library to make integer / std_logic_vector conversion easier

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity ColorBars is
    Port ( clk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           Xposblock : in UNSIGNED(31 downto 0);
           Yposblock : in UNSIGNED(31 downto 0);
           switch : in UNSIGNED(31 downto 0);
           i_data_ready : in STD_LOGIC;
           o_data_valid : out STD_LOGIC := '0';
           o_video_user : out STD_LOGIC_VECTOR (0 downto 0) := (OTHERS => '0');  -- sof; start of frame (one clock pulse)
           o_last : out STD_LOGIC_VECTOR (0 downto 0) := (OTHERS => '0');  -- eol; end of horizontal line 
           vid_out : out STD_LOGIC_VECTOR (23 downto 0) := (OTHERS => '0'));
end ColorBars;

architecture Behavioral of ColorBars is
SIGNAL line_counter         : UNSIGNED(9 DOWNTO 0) := (OTHERS => '0');
SIGNAL pixel_counter        : UNSIGNED(9 DOWNTO 0) := (OTHERS => '0');
--SIGNAL hsync, vsync         : STD_LOGIC := '0';

type    state is (IDLE, SENDSTREAM, ENDLINE);
SIGNAL  SMstate : state := IDLE;

SIGNAL R, G, B     : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL Red, Green, Blue : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');


begin

-- Type cast the R, G, B signals to STD_LOGIC_VECTOR here:
Red    <= STD_LOGIC_VECTOR (R);
Green  <= STD_LOGIC_VECTOR (G);   
Blue   <= STD_LOGIC_VECTOR (B);

-- CONCATENATE the Red, Blue, Green (in that order)to vid_out
vid_out <= Red & Blue & Green;


-- Process for State Machine interface to AXI Video Out block
-- Three States (not including reset): IDLE, SENDSTREAM, ENDLINE
PROCESS(clk, resetn)
BEGIN

-- when resetn is zero (not clocked, asynchronous)write zero to:
-- o_data_valid, o_video_user, o_last, pixel_counter, line_counter
-- NOTE o_video_user and o_last are STD_LOGIC_VECTORs so use
-- the (OTHERS => '?') notation.
-- set SMstate to IDLE 
IF (resetn='0') THEN
    o_data_valid <= '0';
    o_video_user <= (OTHERS => '0');
    o_last <= (OTHERS => '0');
    pixel_counter <= (OTHERS => '0');
    line_counter <= (OTHERS => '0');
    SMstate <= IDLE;


-- next test for the rising edge of the clock (use ELSIF)
ELSIF rising_edge(clk) THEN
-- next make CASE statement, with 3 WHEN blocks
    CASE (SMstate)IS
        WHEN IDLE =>
            o_data_valid <= '1';
            o_video_user <= (OTHERS => '1');
            SMstate <= SENDSTREAM;
          
-- for IDLE state, this will be the state where we set:
-- o_data_valid to 1, and o_video_user to 1.
-- and set SMstate to SENDSTREAM
        WHEN SENDSTREAM =>
            IF (i_data_ready = '1') THEN
                o_video_user <= (OTHERS => '0');
                pixel_counter <= pixel_counter + 1 ;
                IF (pixel_counter = 798) THEN
                    o_last <= (OTHERS => '1');
                    SMstate <= ENDLINE;
                END IF;
             END IF;
    
-- for SENDSTREAM case, test whether the block is ready
-- by IF (i_data_ready = '1').
-- if that is true, then set:
-- o_video_user to 0, increment the pixel_counter.
-- Test whether pixel_counter is 798, and if it is, then set:
-- o_last to 1, and SMstate to ENDLINE.
        WHEN ENDLINE =>
            IF (i_data_ready = '1') THEN
                o_last <= (OTHERS => '0');
                pixel_counter <= (OTHERS => '0');
                line_counter <= line_counter + 1;
                IF ((line_counter = 599) AND (pixel_counter = 799)) THEN
                    SMstate <= IDLE;
                    o_data_valid <= '0';
                    line_counter <= (OTHERS => '0');
                ELSE SMstate <= SENDSTREAM;
                END IF;
            END IF;
-- lastly, for ENDLINE
-- also test whether the block is ready with the i_data_ready IF
-- then set:
-- o_last to 0, pixel_counter to zero, increment line_counter
-- test simultaneously for line_counter = 599 and pixel_counter = 799
--if true, then set:
-- SMstate to IDLE, o_data_valid to zero, line_counter to zero.
-- ELSE set SMstate to SENDSTREAM.
    END CASE;
END IF;
END PROCESS;

-- Copy paste your solution to the ColorBar Process from LABProject1 here:  
 

PROCESS(clk)
    VARIABLE xsquared : integer;
    VARIABLE ysquared : integer;  
BEGIN
  IF (pixel_counter>Xposblock-10)AND(pixel_counter<Xposblock+10)AND(line_counter>Yposblock-5)AND(line_counter<Yposblock+5) THEN
    R   <= TO_UNSIGNED(150, 8);  --Brown / almost maroon 
    G   <= TO_UNSIGNED(75, 8);
    B   <= TO_UNSIGNED(50, 8);
    ELSE
    IF switch=0 THEN
        IF (pixel_counter < 100) then    --White
            R   <= TO_UNSIGNED(191, 8);
            G   <= TO_UNSIGNED(191, 8);
            B   <= TO_UNSIGNED(191, 8);
        ELSIF (pixel_counter < 200) then --Yellow
            R   <= TO_UNSIGNED(191, 8);
            G   <= TO_UNSIGNED(191, 8);
            B   <= TO_UNSIGNED(0, 8);
        ELSIF (pixel_counter < 300) then --cyan
            R   <= TO_UNSIGNED(0, 8);
            G   <= TO_UNSIGNED(191, 8);
            B   <= TO_UNSIGNED(190, 8);
        ELSIF (pixel_counter < 400) then --green
            R   <= TO_UNSIGNED(0, 8);
            G   <= TO_UNSIGNED(191, 8);
            B   <= TO_UNSIGNED(0, 8);
        ELSIF (pixel_counter < 500) then --magenta
            R   <= TO_UNSIGNED(191, 8);
            G   <= TO_UNSIGNED(0, 8);
            B   <= TO_UNSIGNED(192, 8);
        ELSIF (pixel_counter < 600) then --red
            R   <= TO_UNSIGNED(191, 8);
            G   <= TO_UNSIGNED(0, 8);
            B   <= TO_UNSIGNED(1, 8);
        ELSIF (pixel_counter < 700) then --blue
            R   <= TO_UNSIGNED(0, 8);
            G   <= TO_UNSIGNED(0, 8);
            B   <= TO_UNSIGNED(191, 8);
        ELSE                            --black
            R   <= TO_UNSIGNED(0, 8);
            G   <= TO_UNSIGNED(0, 8);
            B   <= TO_UNSIGNED(0, 8);        
        END IF; -- color bars
    ELSIF switch=1 then
        IF ((pixel_counter > line_counter) AND (pixel_counter < line_counter + 200)) THEN
            R   <= TO_UNSIGNED(191, 8);  -- WHITE
            G   <= TO_UNSIGNED(191, 8);
            B   <= TO_UNSIGNED(191, 8);
        ELSE                            
            R   <= TO_UNSIGNED(191, 8);    --RED
            G   <= TO_UNSIGNED(0, 8); 
            B   <= TO_UNSIGNED(1, 8);
        END IF; -- Flag  
    ELSIF switch=2 then
        --make the circle centered at (400,300) with radius of 100
        -- x=pixel_counter & y=line_counter
        -- (pixel_counter - 400)^2 + (line_counter - 300)^2 = 1000
        xsquared := (to_integer(pixel_counter) - 400) ** 2;
		ysquared := (to_integer(line_counter) - 300) ** 2;
		IF (xsquared + ysquared) <= 1000 then
			R   <= TO_UNSIGNED(191, 8);    --RED
            G   <= TO_UNSIGNED(0, 8); 
            B   <= TO_UNSIGNED(1, 8);
		ELSE
			R   <= TO_UNSIGNED(0, 8);    --GREEN
            G   <= TO_UNSIGNED(191, 8); 
            B   <= TO_UNSIGNED(1, 8);
        END IF; --end setting a circle 
        
    ELSE --everything goes white if something went wrong 
        R   <= TO_UNSIGNED(191, 8);  -- WHITE
        G   <= TO_UNSIGNED(191, 8);
        B   <= TO_UNSIGNED(191, 8);        
    END IF;  -- switch IF
  END IF; --xposblock,yposblock IF
END PROCESS;


end Behavioral;
