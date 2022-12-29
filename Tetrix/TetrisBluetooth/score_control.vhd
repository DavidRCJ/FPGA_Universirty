
------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
------------------------------------------------------------------------
-- This component has 8 registers in which he is keeping the 
-- top score and the current player's score. The "cl" signal indicates
-- that we need to add a point to the player's score. The "ng" signal
-- indicates that a new game has begun, in this case it will test if
-- the players score is bigger then the topscore. If the players score
-- is bigger, then the topscore will get that value and the player's 
-- score will be reseated. This component writes in the textbox's 
-- BlockRAM.
--
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- mclk          Input      Main clock input 
-- cl            Input      Count line
-- ng            Input      New game
-- car(7:0)      Output   BlockRAM's data input
-- crx(4:0)      Output   BlockRAM's address input
-- cry(3:0)      Output   BlockRAM's address input
-- speed(1:0)    Output   Game speed
-- wen           Output   BlockRAM's write enable
--

------------------------------------------------------------------------
entity score is
   Port(    
			mclk			:in std_logic;
         ng				:in std_logic;
         cl				:in std_logic;
			speed			:out std_logic_vector(1 downto 0);
			wen			:out std_logic;
			car			:out std_logic_vector(7 downto 0);
			crx			:out std_logic_vector(4 downto 0);
			cry			:out std_logic_vector(3 downto 0)
        );
end score;

architecture Behavioral of score is
------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
   signal cx                	: std_logic_vector(4 downto 0):="00000";
   signal cy                 	: std_logic_vector(3 downto 0):="0000";
   -- the current player's score
   signal you1                : std_logic_vector(3 downto 0):="0000";
   signal you2                : std_logic_vector(3 downto 0):="0000";
   signal you3                : std_logic_vector(3 downto 0):="0000";
   signal you4                : std_logic_vector(3 downto 0):="0000";
   -- the topscore
   signal top1                : std_logic_vector(3 downto 0):="0000";
   signal top2                : std_logic_vector(3 downto 0):="0000";
   signal top3                : std_logic_vector(3 downto 0):="0000";
   signal top4                : std_logic_vector(3 downto 0):="0000";
   signal number            	: std_logic_vector(3 downto 0):="0000";
   signal newgame         		: std_logic:='0';   
   signal countline      		: std_logic:='0';
   signal we            		: std_logic:='0';   

------------------------------------------------------------------------
-- Module Implementation - 
------------------------------------------------------------------------
begin
counters: process(mclk,cl)
begin
   if mclk = '1' and mclk'EVENT then
      -- increment the player's score
      if countline/=cl then
          countline<= not countline;
             cx<="01100";
            cy<="1000";
          if you1="1001" then
                you1<="0000";
               if you2="1001" then
                   you2<="0000";
                  if you3="1001" then
                      you3<="0000";
                     if you4="1001" then
                         you4<="0000";
                     else
                         you4<=you4 + 1;
                      end if; 
                   else
                      you3<=you3 + 1;
                   end if;    
               else
                   you2<=you2 + 1;
               end if;    
          else
             you1<=you1 + 1;
          end if; 
      else
         if newgame/=ng then
            -- new game
             newgame<= not newgame;
             cx<="01100";
               
             if (top4 < you4) or (top3 < you3 and top4=you4) or 
            (top2 < you2 and top4=you4 and top3=you3) or 
            (top1 < you1 and top4=you4 and top3=you3 and top2=you2) then         
                --change topscore
               cy<="0111";
             else
                               -- reset the player's score
                               you1<="0000";
                               you2<="0000";
                               you3<="0000";
                               you4<="0000";
                               cy<="1000";
             end if;
         else
             -- writting in the BlockRAM
             if cx="01100" then
                     we<='1';
                     number<=you4;
                     cx<="01101";
            elsif    cx="01101" then
                     number<=you3;
                     cx<="01110";
            elsif    cx="01110" then
                     number<=you2;
                     cx<="01111";
            elsif cx="01111" then
                     number<=you1;
                     cx<="10000";
                     if cy="0111" then
                         top1<=you1;
                         top2<=you2;
                         top3<=you3;
                         top4<=you4;
                     end if;
            else
               if cy="0111" then
                   -- reset the player's score
                   you1<="0000";
                   you2<="0000";
                   you3<="0000";
                   you4<="0000";
                   cy<="1000";
                   cx<="01100";
               end if;
               we<='0';
            end if;
         end if;                    
      end if;
   end if;
end process;

-- sending the number's scancode
car<= X"45" when number="0000" else  --0
      X"16" when number="0001" else  --1
      X"1E" when number="0010" else  --2
      X"26" when number="0011" else  --3
      X"25" when number="0100" else  --4
      X"2E" when number="0101" else  --5
      X"36" when number="0110" else  --6
      X"3D" when number="0111" else  --7
      X"3E" when number="1000" else  --8
      X"46" when number="1001" else  --9
      X"00";
crx<=cx;
cry<=cy;
wen<=we;
speed<=  "00" when you3="0000" else
         "01" when you3="0001" else
         "10" when you3="0010" else
         "11";
end Behavioral;
