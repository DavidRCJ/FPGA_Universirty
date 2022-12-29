------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
------------------------------------------------------------------------
-- Reading the tetrix's BlockRAM and generating the pixels which will
-- be displayed. 
--
-- I am using 2 counter(cx 0 -> 9 and cy 0 -> 19 ) which are connected
-- to the "crx" and "cry" outputs. Using these counters I will read the 
-- dates from the BlockRAM about the tetrix. Each address will return a 
-- 4 bit data(rect(3:0)) about that block: - the first bit is telling 
-- if there is something or not and the other 3 is keeping the block's 
-- color. Each block from the tetrix needs 16x16 pixels to be drawn on
-- the screen. To know which pixel to send I am using 2 counters:
-- "nrpix" (0-> 15) is the column number, "line" (0-> 15) is the line 
-- number.
--
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clkdiv      Input      Main clock input
-- rect(3:0)   Input      BlockRAM's data output
-- mclk        Input      Clock - 50MHz, is used to draw more colors
-- vid         Input      Enable input - enables the component
-- pixel(2:0)   Output   Pixel's color
-- crx(4:0)     Output   BlockRAM's address input
-- cry(4:0)     Output   BlockRAM's address input

------------------------------------------------------------------------
entity display is
Port(    mclk       : in std_logic;   
         clkdiv    : in std_logic;
         vidon       : in std_logic;
         rect       : in std_logic_vector(3 downto 0);
        
        pixel        :out std_logic_vector(2 downto 0);
        crx          :out std_logic_vector(4 downto 0);
        cry         :out std_logic_vector(4 downto 0)
        );

end display;

architecture Behavioral of display is

------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------


------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
 signal nrpix      : std_logic_vector(3 downto 0):="0000";
 signal line      : std_logic_vector(3 downto 0):="0000";
 signal cx        : std_logic_vector(4 downto 0):="00000";
 signal cy          : std_logic_vector(4 downto 0):="00000";
 
------------------------------------------------------------------------
-- Module Implementation - 
------------------------------------------------------------------------

begin
  counters: process(clkdiv,vidon)
   begin
      if vidon='1' and clkdiv = '1' and clkdiv'EVENT then
           -- increment the column
           nrpix<= nrpix + 1;
          if nrpix="1111" then
                  if cx="01001" then            --"01001"
                            if line="1111"   then
                              if cy="10011"   then
                                 cy<="00000"; 
                              else
                                 -- increment the block y coordinate 
                                 cy<= cy + 1;
                              end if;
                           end if;
                           -- increment the line
                           line<= line +1;
                           cx<= "00000";
                   else
                   -- increment the block x coordinate
                   cx<=cx + 1;
                   end if; 
                   
                     
           end if;

      end if;
   end process;

    
-- sending the pixel's color
pixel(0)<= '0' when nrpix="0000" or nrpix="1111" or line="0000" or
                line="1111" else
           '1' when nrpix>"0011" and nrpix<"1100" and line>"0011" and 
                line<"1100" and rect(0)='1' else
           mclk when rect(0)='1' else
           '0';
pixel(1)<= '0' when nrpix="0000" or nrpix="1111" or line="0000" or
                line="1111" else
           '1' when nrpix>"0011" and nrpix<"1100" and line>"0011" and
                line<"1100" and rect(1)='1' else
           mclk when rect(1)='1' else
           '0';
pixel(2)<= '0' when nrpix="0000" or nrpix="1111" or line="0000" or
                line="1111" else
           '1' when nrpix>"0011" and nrpix<"1100" and line>"0011" and
                line<"1100" and rect(2)='1' else
           mclk when rect(2)='1' else
           '0';

crx<=cx;
cry<=cy;
 
end Behavioral;
