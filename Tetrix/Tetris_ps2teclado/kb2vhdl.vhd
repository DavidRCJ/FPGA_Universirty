----------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
------------------------------------------------------------------------
-- The component is used to read the scan code sent by the keyboard. 
-- It can make device-to-host communication and will check if the start 
-- bit and the stop bit is in order.
--
-- I am using a register("shiftCounter") which is counting the clocks
-- sent by the keyboard, when this counter measured 11 clocks I will
-- know that the scan code was read. After a scan code was read the
-- "an" output will change his value: from '0' to '1' or from '1' to
-- '0'. The next component which is connected to this will know that
-- a scan code was read. The "an" signal is like a "write enable",
-- an "interrupt" or an "alarm" signal.
--
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk           Input      Main clock input
-- kc            Input      Keyboard clock
-- kd            Input      Keyboard data
-- rst           Input      Asynchronous reset
-- sseg(7:0)     Output   ScanCode
-- an            Output   Alarm

------------------------------------------------------------------------
entity keyboardVhdl is
   Port (   CLK, RST, KD, KC: in std_logic;
            an: out std_logic;
            sseg: out std_logic_vector (7 downto 0));


end keyboardVhdl;


architecture Behavioral of keyboardVhdl is

------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------

signal pclk : std_logic;
signal KDI, KCI : std_logic;
signal DFF1, DFF2 : std_logic;
signal ant : std_logic:='0';
signal shiftReg: std_logic_vector(10 downto 0):="00000000000";
signal shiftCounter: std_logic_vector(4 downto 0):="00001";
signal WaitReg: std_logic_vector (7 downto 0);

------------------------------------------------------------------------
-- Module Implementation
------------------------------------------------------------------------

begin
--generating 25MHz
CLKDivider: Process (CLK)
begin
   if (CLK = '1' and CLK'Event) then 
      pclk <= not pclk; 
   end if;   
end Process;



--Flip Flops used to condition siglans coming from PS2--
Process (pclk, RST, KC, KD)
begin
      if(RST = '1') then
      DFF1 <= '0'; DFF2 <= '0'; KDI <= '0'; KCI <= '0';
   else                                    
      if (pclk = '1' and pclk'Event) then
         DFF1 <= KD; KDI <= DFF1; DFF2 <= KC; KCI <= DFF2;
      end if;
   end if;
end process;



Process(KDI, KCI, RST) --DFF2 carries KD and DFF4, and DFF4 carries KC
begin                                                                 
   if (RST = '1') then
      ShiftReg <= "00000000000";
      
   else
      -- incrementing the shiftCounter and reading the data from PS2
      if (KCI = '0' and KCI'Event) then
         if (shiftCounter(4)='0') then 
            shiftCounter <= "10001";
         else
            if (shiftCounter="11010") then
               shiftCounter <=  "00000";
            else
               shiftCounter <= shiftCounter + 1;
            end if;
         end if;
         -- reading the data from PS2
         ShiftReg(10 downto 0) <= KDI & ShiftReg(10 downto 1);
         
      end if;
   end if;
end process;

--Wait Register
process( ShiftReg, RST, KCI)
begin
   if(RST = '1')then
      WaitReg <= "00000000";
   else
      if(KCI'event and KCI = '1' and shiftCounter = "00000" and 
               ShiftReg(0)='0' and ShiftReg(10)='1') then 
         -- waitreg will get the scancode 
         WaitReg <= ShiftReg(8 downto 1);
         -- we send an ALARM signal to the next component
         ant<=not ant;
         
      end if;         
   end if;
end Process;


sseg <=WaitReg(7 downto 0) when RST = '0' else    "00000000";

an<=ant;
            
end Behavioral;