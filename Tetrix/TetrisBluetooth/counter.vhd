library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counters is
Port(    
        clkd    : in std_logic;
        texton      : in std_logic;
        crx           :out std_logic_vector(4 downto 0);
        cry            :out std_logic_vector(3 downto 0);
        lin            :out std_logic_vector(2 downto 0);
        col            :out std_logic_vector(2 downto 0));
end counters;

architecture Behavioral of counters is
 signal nrpix      : std_logic_vector(2 downto 0):="000";
 signal line      : std_logic_vector(2 downto 0):="000";
 signal cx        : std_logic_vector(4 downto 0):="00000";
 signal cy          : std_logic_vector(3 downto 0):="0000";

begin
   process(clkd,texton)
   begin
      if texton='1' and clkd = '1' and clkd'EVENT then
           -- increment the column
           nrpix<= nrpix + 1;
          if nrpix="101" then
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
   lin<=line;
   col<=nrpix;

end Behavioral;
