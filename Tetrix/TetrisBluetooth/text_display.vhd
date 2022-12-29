library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

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
--
-- This component uses 512x8 bit BlockRAMs to memorize the character's
-- form. In one BlockRAM we can memorize 64 different characters and
-- the resource utilization is not dependent by the character's
-- number. I am using 2 BlockRAMs in this design and for that I need
-- only 7 bits( car(6 downto 0) ) from the 8 bit input
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
entity text_display is
   port(    clkd    : in std_logic;
            texton      : in std_logic;
            car           :in std_logic_vector(7 downto 0);

        crx           :out std_logic_vector(4 downto 0);
        cry            :out std_logic_vector(3 downto 0);
        pix            :out std_logic_vector(2 downto 0));
end text_display;

architecture Behavioral of text_display is
------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------
component counters is
      Port(    
            clkd    : in std_logic;
            texton      : in std_logic;
            

        crx           :out std_logic_vector(4 downto 0);
        cry            :out std_logic_vector(3 downto 0);
        lin            :out std_logic_vector(2 downto 0);
        col            :out std_logic_vector(2 downto 0));
      end component;
		
------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
 signal nrpix      : std_logic_vector(2 downto 0):="000";
 signal blselect   : std_logic:='0'; 
 
 signal cp1  : std_logic_vector(7 downto 0):="00000000";
 signal cp0  : std_logic_vector(7 downto 0):="00000000";
 signal ADDR  : std_logic_vector(8 downto 0):="000000000";

------------------------------------------------------------------------
-- Module Implementation - 
------------------------------------------------------------------------
begin
    -- counters can be found in this component
    count: counters Port map( clkd=>clkd,
                     texton=>texton,
                   crx=>crx,
                   cry=>cry,
                   lin=>ADDR(2 downto 0),
                   col=>nrpix);

   process(clkd,nrpix)
   begin
      if nrpix="111" and clkd = '1' and clkd'EVENT then
           blselect<= car(6);
          
      end if;
   end process;

  ADDR(8 downto 3)<=car(5 downto 0);

   -- first BlockRAM
   RAMB4_S8_inst2 : RAMB4_S8
generic map (  
           --      03       0      02       0       01      0      00       0                  
INIT_00 => X"FF80808080808080FF0101010101010180808080808080FF0000000000000000",
           --      07       0      06       0       05      0      04       0    
INIT_01 => X"80808080808080800101010101010101FF0000000000000000000000000000FF",
           --      0B       0      0A       0       09      0      08       0 
INIT_02 => X"00000000000000000000000000000000000000000000000001010101010101FF",
           --      0F       0      0E       0       0D      0      0C       0 
INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      13       0      12       0       11      0      10       0 
INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      17       0      16       0       15      0      14       0
INIT_05 => X"0000000000000000003810101010301000344854444444380000000000000000",
           --      1B       0      1A       0       19      0      18       0
INIT_06 => X"007804043840403C007C40201008047C00000000000000000000000000000000",
           --      1F       0      1E       0       1D      0      1C       0
INIT_07 => X"0000000000000000003C20100804443800285454544444440044447C44444438",
           --      23       0      22       0       21      0      20       0
INIT_08 => X"0070484444444870004444281028444400384440404044380000000000000000",
           --      27       0      26       0       25      0      24       0
INIT_09 => X"0000000000000000003844040810083C0008087C48281808007C40407840407C",
           --      2B       0      2A       0       29      0      28       0
INIT_0A => X"004040407840407C001028444444444400000000000000000000000000000000",
           --      2F       0      2E       0       2D      0      2C       0
INIT_0B => X"0000000000000000003844040478407C0044485078444478001010101010107C",
           --      33       0      32       0       31      0      30       0
INIT_0C => X"004444447C44444400784444784444780000444C546444440000000000000000",
           --      37       0      36       0       35      0      34       0
INIT_0D => X"000000000000000000384444784020180010101028444444003844445C404438",
           --      3B       0      3A       0       39      0      38       0
INIT_0E => X"003028080808081C0044444444546C4400000000000000000000000000000000",
           --      3F       0      3E       0       3D      0      3C       0
INIT_0F => X"00000000000000000038444438444438002020201008047C0038444444444444")
   port map (     
      DO => cp0,     -- 8-bit data output
      ADDR => ADDR, -- 9-bit address input
      CLK => clkd,   -- Clock input
      DI => "00000000",     -- 8-bit data input
      EN =>'1',     -- RAM enable input
      RST => '0',   -- Synchronous reset input
      WE => '0'      -- RAM write enable input
   );

  -- second BlockRAM
  RAMB4_S8_inst1 : RAMB4_S8
generic map ( 
           --      43       0      42       0       41      0      40       0                  
INIT_00 => X"0038101010101038004448506050484400000000000000000000000000000000",
           --      47       0      46       0       45      0      44       0
INIT_01 => X"0000000000000000003008043844443800384464544C44380038444444444438",
           --      4B       0      4A       0       49      0      48       0
INIT_02 => X"007C404040404040000000000000000000000000000000000000000000000000",
           --      4F       0      4E       0       4D      0      4C       0
INIT_03 => X"0000000000000000000000007C00000000404040784444780000000000000000",
           --      53       0      52       0       51      0      50       0
INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      57       0      56       0       55      0      54       0
INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      5B       0      5A       0       59      0      58       0
INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      5F       0      5E       0       5D      0      5C       0
INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      63       0      62       0       61      0      60       0
INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      67       0      66       0       65      0      64       0
INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      6B       0      6A       0       69      0      68       0
INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      6F       0      6E       0       6D      0      6C       0
INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      73       0      72       0       71      0      70       0
INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      77       0      76       0       75      0      74       0
INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      7B       0      7A       0       79      0      78       0
INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      7F       0      7E       0       7D      0      7C       0
INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000")

   port map (    
      DO => cp1,     -- 8-bit data output
      ADDR => ADDR, -- 9-bit address input
      CLK => clkd,   -- Clock input
      DI => "00000000",     -- 8-bit data input
      EN =>'1',     -- RAM enable input
      RST => '0',   -- Synchronous reset input
      WE => '0'      -- RAM write enable input
   );

pix <="111" when  nrpix="000" and ((cp1(7)='1' and blselect='1') or
                                  (cp0(7)='1' and blselect='0')) else
      "111" when  nrpix="001" and ((cp1(6)='1' and blselect='1') or 
                                  (cp0(6)='1' and blselect='0')) else
      "111" when  nrpix="010" and ((cp1(5)='1' and blselect='1') or
                                  (cp0(5)='1' and blselect='0')) else
      "111" when  nrpix="011" and ((cp1(4)='1' and blselect='1') or
                                  (cp0(4)='1' and blselect='0')) else
      "111" when  nrpix="100" and ((cp1(3)='1' and blselect='1') or
                                  (cp0(3)='1' and blselect='0')) else
      "111" when  nrpix="101" and ((cp1(2)='1' and blselect='1') or
                                  (cp0(2)='1' and blselect='0')) else
      "111" when  nrpix="110" and ((cp1(1)='1' and blselect='1') or
                                  (cp0(1)='1' and blselect='0')) else
      "111" when  nrpix="111" and ((cp1(0)='1' and blselect='1') or
                                  (cp0(0)='1' and blselect='0')) else
      "000";
end Behavioral;