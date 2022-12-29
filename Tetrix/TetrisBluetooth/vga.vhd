library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- mclk       Input      Main clock input
-- pix(2:0)   Input      Pixel's color
-- clkd      Output   Clock - 25MHz
-- blu       Output   VGA Blue signal
-- grn       Output   VGA Green signal
-- hs        Output   VGA Horizontal Sync
-- red       Output   VGA Red signal
-- vs        Output   VGA Vertical Sync
-- vid       Output   Activates the tetrix_display component
-- text      Output   Activates the text_display component
--
------------------------------------------------------------------------

entity vga is
Port (
		mclk    			: in std_logic;
      pix				: in std_logic_vector(2 downto 0);
		hs       		: out std_logic;
		vs       		: out std_logic;
		red, grn, blu	: out std_logic;
		text,vid,clkd	: out std_logic);
end vga;

architecture Behavioral of vga is
------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
   --800Value of pixels in a horizontal line
   constant hpixels      : std_logic_vector(9 downto 0) := "1100100000"; 
   --521Number of horizontal lines in the display   
   constant vlines      : std_logic_vector(9 downto 0) := "1000001001";    
   
   --199 Horizontal back porch
   constant hbp         : std_logic_vector(9 downto 0) := "0011000111";    
   --360 Horizontal front porch
   constant hfp         : std_logic_vector(9 downto 0) := "0101101000";    
   --99 Vertical back porch
   constant vbp         : std_logic_vector(9 downto 0) := "0001100011";    
   --420 Vertical front porch
   constant vfp         : std_logic_vector(9 downto 0) := "0110100100";    

   --399 Horizontal back porch
   constant hbptext     : std_logic_vector(9 downto 0) := "0110001111";    
   --656 Horizontal front porch
   constant hfptext     : std_logic_vector(9 downto 0) := "1010010000";    
   --99 Vertical back porch
   constant vbptext     : std_logic_vector(9 downto 0) := "0001100011";    
   --228 Vertical front porch
   constant vfptext     : std_logic_vector(9 downto 0) := "0011100100";    
   
   --These are the Horizontal and Vertical counters
   signal hc         : std_logic_vector(9 downto 0):="0000000000";          
   signal vc         : std_logic_vector(9 downto 0):="0000000000";
   --Clock divider
   signal clkdiv         : std_logic :='0';   
                                  
   signal vidon         : std_logic;
   signal texton         : std_logic;
   signal border         : std_logic;        
   signal vsenable      : std_logic;
  
------------------------------------------------------------------------
-- Module Implementation - 
------------------------------------------------------------------------
begin
   -- we divide the clock to obtain 25mhz
   process(mclk)
      begin
         if(mclk = '1' and mclk'EVENT) then
            clkdiv <= not clkdiv;
         end if;
   end process;                                                         

   --Runs the horizontal counter
   process(clkdiv)
      begin
         if(clkdiv = '1' and clkdiv'EVENT) then
            if hc = hpixels then                                           
               hc <= "0000000000";                                        
               vsenable <= '1';                                           
            else
               hc <= hc + 1;
                                                                          
               vsenable <= '0';                                           
            end if;
         
      end if;
   end process;

   -- runs the vertical counter
   process(clkdiv)
   begin
      if(clkdiv = '1' and clkdiv'EVENT and vsenable = '1') then          
       
         if vc = vlines then                                              
            vc <= "0000000000";
            
         else vc <= vc + 1;                                               
         end if;
       
      end if;
   end process;

	process(clkdiv)
	begin
	if(clkdiv = '1' and clkdiv'EVENT ) then                 
		if ((hc="0011000110" or hc="0011000100") and ((vc < "0110100111") 
		and (vc > "0001100000"))) then
			 border<='1';
		elsif ((hc="0101101001" or hc="0101101011") and ((vc < "0110100111") 
		and (vc > "0001100000"))) then
			 border<='1';
		elsif ((vc="0001100010" or vc="0001100000") and ((hc < "0101101011") 
		and (hc > "0011000100"))) then
			 border<='1';
		elsif ((vc="0110100101" or vc="0110100111") and ((hc < "0101101011") 
		and (hc > "0011000100"))) then                                                 
			 border<='1';
		else 
			border<='0';                                             
		end if;
	 
	end if;
	end process;

	--Horizontal Sync Pulse
	hs <= '1' when hc(9 downto 3) = "0000000" else '0';     -- 7
	--Vertical Sync Pulse                         
	vs <= '1' when vc(9 downto 1) = "000000000" else '0';                 
	--red color
	red <= '1' when (pix(0)='1' and vidon ='1') or
	 (pix(0)='1' and texton='1') else '0';
	--blue color
	blu <= '1' when (pix(1)='1' and vidon ='1') or
	 (pix(0)='1' and texton='1') or border='1' else '0';
	--green color
	grn <= '1' when (pix(2)='1' and vidon ='1') or
	 (pix(0)='1' and texton='1') else '0';

	vidon <= '1' when (((hc < hfp) and (hc > hbp)) and
	 ((vc < vfp) and (vc > vbp))) else '0';
	texton<= '1' when (((hc < hfptext) and (hc > hbptext)) and
	 ((vc < vfptext) and (vc > vbptext))) else '0';

	text<= texton;
	clkd<=clkdiv;
	vid<=vidon;
	
end Behavioral;