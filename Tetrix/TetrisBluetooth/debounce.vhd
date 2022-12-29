library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- This component selects which scan code will be sent forwardly.
--
-- It contains 3 different type of filters:
--    -   reading only the break key
--    -   reading only the first make key and 
--       not reading anything before releasing that button
--    -   reading the make keys of the pushed button and 
--       not reading anything before releasing that button
-- In the design the first filter is activated. We have an internal 
-- signal which is compared with the "an" input, when this signal is
-- different as the input then we know that a scan code was read and we
-- change the internal signals value to be the same with input.
-- If the scan code can be sent forwardly then the "ssegout" will get
-- the "ssegin" value and the "send" output will change his value:
-- from '0' to '1' or from '1' to '0'.
--
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- mclk             Input      Main clock input
-- an               Input      Alarm
-- ssegin(7:0)      Input      ScanCode
-- ssegout(7:0)    Output   ScanCode - filtered
-- send            Output   Alarm       
------------------------------------------------------------------------

entity kbfilter is
Port(    mclk       : in std_logic;
         an          : in std_logic;
         ssegin    : in std_logic_vector (7 downto 0);

         send          : out std_logic;
         ssegout    : out std_logic_vector (7 downto 0)
         );
end kbfilter;

architecture Behavioral of kbfilter is
------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------


------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
 signal key      : std_logic_vector(7 downto 0):="00000000";
 signal ack      : std_logic:='0';
 signal ann      : std_logic:='0';
 signal temp   : std_logic_vector(1 downto 0):="00";
 



------------------------------------------------------------------------
-- Module Implementation - 
------------------------------------------------------------------------
begin

process (mclk,an)
begin
   
if (mclk'event and mclk = '1') then
   
   if (an /= ann) then
      ann <= not ann;
      -------------------------------------------------
      --reading only the break key
      if (temp="00" and ssegin = "11110000") then
         temp <= "10";
      elsif (temp="10") then
         key <= ssegin;
         ack<= not ack;
         temp<="00";
      else   
               temp<="00";
      end if;
      -------------------------------------------------

--      -------------------------------------------------
--      --reading only the first make key and 
--      --not reading anything before releasing that
--   if (temp="00" and ssegin /= "11100000" and ssegin /= "11110000") then
--         key <= ssegin;
--         ack<= not ack;
--         temp <= "10";
--      elsif (temp="10" and ssegin="11110000") then
--               temp<="11";         
--      elsif temp="11" then
--             if (ssegin=key) then
--               temp<="00";
--            else
--               temp<="10";
--            end if;
--      end if;
--      -------------------------------------------------
--
--      -------------------------------------------------
--      --reading the make keys and 
--      --not reading anything before releasing that
--      if (temp="00" and ssegin /= "11100000") then
--         key <= ssegin;
--         ack<= not ack;
--         temp <= "10";
--      elsif (temp="10") then
--         if (ssegin="11110000")   then
--               temp<="11";         
--         elsif (ssegin = key) then
--               ack<= not ack;
--         end if;
--      elsif (temp="11") then
--             if (ssegin=key) then
--               temp<="00";
--            else
--               temp<="10";
--            end if;
--      end if;
--      -------------------------------------------------

      end if;         
   end if;
 end process;

 send <= ack;
 ssegout <= key;

end Behavioral;