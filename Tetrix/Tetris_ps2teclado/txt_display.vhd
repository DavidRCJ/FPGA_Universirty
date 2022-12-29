------------------------------------------------------------------------
--  txt_display.vhd -- 
------------------------------------------------------------------------
--  Author : Fazakas Szabolcs
--           
------------------------------------------------------------------------
-- Software version: Xilinx ISE 7.1.04i
--                   WebPack
------------------------------------------------------------------------
-- This component generates the necessary pixel's to draw the 
-- characters of the textbox. The component is activated by 
-- the "text" input signal and the main clock of this component 
-- is the "clkd"(25MHz). The "crx" and "cry" outputs are connected 
-- to the BlockRAM as address input and the "car" input is 
-- connected to the BlockRAM's data output. The textbox's BlockRAM
-- contains 512x8 bit data and this is displayed on the screen as
-- a 32x16(=512) character matrix. 
--
-- To draw a character I need 8x8 pixels. With the "nrpix" and the 
-- "line" counters we are accessing the right memory address. If at 
-- that address we find '1' then we are sending the white color
-- (pix<="111") to the VGA component, otherwise the black 
-- color(pix<="000").

------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clkd          Input      Main clock input (25MHz)
-- car(7:0)      Input      BlockRAM's data output
-- texton        Input      Enable input - enables the component
-- pix(2:0)      Output   Pixel's color
-- crx(4:0)      Output   BlockRAM's address input
-- cry(3:0)      Output   BlockRAM's address input


------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity txt_display is
   Port(    
            clkd    : in std_logic;
            texton      : in std_logic;
            car           :in std_logic_vector(7 downto 0);

        crx           :out std_logic_vector(4 downto 0);
        cry            :out std_logic_vector(3 downto 0);
        pix            :out std_logic_vector(2 downto 0));
end txt_display;

architecture Behavioral of txt_display is
------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------
-- contains the character's form
   component Memchar is
   Port ( CH : in std_logic_vector(7 downto 0);
           L : in std_logic_vector(2 downto 0);
           Q : out std_logic_vector(7 downto 0));
      end component;
------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
signal nrpix      : std_logic_vector(2 downto 0):="000";
 signal line      : std_logic_vector(2 downto 0):="000";
 signal cx          : std_logic_vector(4 downto 0):="00000";
 signal cy         : std_logic_vector(3 downto 0):="0000";
 signal carpart  : std_logic_vector(7 downto 0):="00000000";


------------------------------------------------------------------------
-- Module Implementation - 
------------------------------------------------------------------------

begin

   caracter: Memchar Port map( CH=>car,
                     L=>line,
                   Q=>carpart);


  process(clkd,texton)
   begin
      if texton='1' and clkd = '1' and clkd'EVENT then
            -- increment the line
           nrpix<= nrpix + 1;
          if nrpix="110" then
                  if cx="11111" then
                            if line="111"   then
                               -- increment the block y coordinate
                               cy<=cy + 1; 
                           end if;
                           -- increment the line
                           line<= line +1;
                   end if;
                   -- increment the block x coordinate 
                   cx<=cx + 1;
                     
           end if;

      end if;
   end process;


crx<=cx;
cry<=cy;


pix <=        "111" when  nrpix="000" and carpart(7)='1' else
              "111" when  nrpix="001" and carpart(6)='1' else
               "111" when  nrpix="010" and carpart(5)='1' else
                "111" when  nrpix="011" and carpart(4)='1' else
              "111" when  nrpix="100" and carpart(3)='1' else
             "111" when  nrpix="101" and carpart(2)='1' else
               "111" when  nrpix="110" and carpart(1)='1' else
               "111" when  nrpix="111" and carpart(0)='1' else
             "000";



end Behavioral;
