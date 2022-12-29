library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- mclk       Input      Main clock input
-- kc         Input      Keyboard clock
-- kd         Input      Keyboard data
-- blu        Output   VGA Blue signal
-- grn        Output   VGA Green signal
-- hs         Output   VGA Horizontal Sync
-- red        Output   VGA Red signal
-- vs         Output   VGA Vertical Sync
------------------------------------------------------------------------
entity tetris is
Port (
			mclk        : in std_logic;
			rx				: in std_logic;
         --kd         : in std_logic;
         --kc          : in std_logic;
         hs         : out std_logic;
         vs          : out std_logic;
         red, grn, blu : out std_logic);
end tetris;

architecture Behavioral of tetris is
------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------
      component vga is
      Port(      mclk       : in std_logic;
                 pix        : in std_logic_vector(2 downto 0);
                 hs              : out std_logic;
                 vs              : out std_logic;
                 red, grn, blu   : out std_logic;
                 text,vid,clkd   : out std_logic);
      end component;

--      COMPONENT KEYBOARDVHDL IS
--      PORT (   CLK, RST, KD, KC   : IN STD_LOGIC;
--               AN            : OUT STD_LOGIC;
--               SSEG          : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
--      END COMPONENT;

		component uart_rx is 
		port (
				i_Clk       : in  std_logic;					--Señal de reloj de la tarjeta
				i_RX_Serial : in  std_logic;					--Linea donde ingresará el dato serial
				o_RX_DV     : out std_logic; 					--Se debe poner en "alto" durante un ciclo de reloj al finalizar la recepción
				o_RX_Byte   : out std_logic_vector(7 downto 0)  --Será el dato obtenido de la recepción serial
		);
		end component;

--      component kbfilter is
--      Port( mclk     : in std_logic;
--            an       : in std_logic;
--            ssegin   : in std_logic_vector (7 downto 0);
--            send       : out std_logic;
--            ssegout    : out std_logic_vector (7 downto 0)
--            );
--      end component;

      component text_display is
      Port( clkd           : in std_logic;
            texton         : in std_logic;
            car            :in std_logic_vector(7 downto 0);
				crx            :out std_logic_vector(4 downto 0);
				cry            :out std_logic_vector(3 downto 0);
				pix            :out std_logic_vector(2 downto 0));
      end component;   
      
      component score is
      Port(   	mclk        :in std_logic;
					ng          :in std_logic;
					cl          :in std_logic;
					speed         :out std_logic_vector(1 downto 0);
					wen           :out std_logic;
					car           :out std_logic_vector(7 downto 0);
					crx           :out std_logic_vector(4 downto 0);
					cry           :out std_logic_vector(3 downto 0)
        );
      end component;      

      component display is
      Port(     mclk             : in std_logic;   
                clkdiv           : in std_logic;
                vidon            : in std_logic;
                rect             : in std_logic_vector(3 downto 0);
                  pixel              :out std_logic_vector(2 downto 0);
                  crx                :out std_logic_vector(4 downto 0);
                  cry                :out std_logic_vector(4 downto 0)
        );
      end component;

      component gamecontrol is
      Port(    mclk       : in std_logic;
               an         : in std_logic;
               sseg       : in std_logic_vector (7 downto 0);
               rectin     : in std_logic_vector(3 downto 0);
               speed      : in std_logic_vector(1 downto 0);
              ng           :out std_logic;
              cl           :out std_logic;
              wen          :out std_logic;
              rectout      :out std_logic_vector(3 downto 0);
              crx          :out std_logic_vector(4 downto 0);
              cry          :out std_logic_vector(4 downto 0)
        );
      end component;

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
    signal pix            : std_logic_vector(2 downto 0):="000";
    signal pixtetrix      : std_logic_vector(2 downto 0):="000";
    signal pixtext        : std_logic_vector(2 downto 0):="000";
    signal spd            : std_logic_vector(1 downto 0):="00";
    signal texton         : std_logic:='0';
    signal clkdiv         : std_logic:='0';
    signal vidon          : std_logic:='0';
    signal newgame        : std_logic:='0';
    signal countline      : std_logic:='0';

   --memori signals
    signal DOB            : std_logic_vector(3 downto 0):="0000";
    signal DOA            : std_logic_vector(3 downto 0):="0000";
    signal DIA            : std_logic_vector(3 downto 0):="0000";
    signal ADDRB          : std_logic_vector(9 downto 0):="0000000000";
    signal ADDRA          : std_logic_vector(9 downto 0):="0000000000";
    signal WEA            : std_logic:='0';

    signal DOBt            : std_logic_vector(7 downto 0):="00000000";
    signal DOAt            : std_logic_vector(7 downto 0):="00000000";
    signal DIAt            : std_logic_vector(7 downto 0):="00000000";
    signal ADDRBt          : std_logic_vector(8 downto 0):="000000000";
    signal ADDRAt          : std_logic_vector(8 downto 0):="000000000";
    signal WEAt            : std_logic:='0';

    --keyboard signals
    signal ssegkb          : std_logic_vector(7 downto 0):="00000000";
    signal ankb            : std_logic:='0';
    signal ssegkbnext      : std_logic_vector(7 downto 0):="00000000";
    signal send            : std_logic:='0';

    
------------------------------------------------------------------------
-- Module Implementation - 
------------------------------------------------------------------------
begin
    monitor: vga Port map( mclk=>mclk,
                     pix=>pix,
                   hs=>hs,
                   vs=>vs,
                   red=>red,
                   grn=>grn,
                   blu=>blu,
                    text=>texton,
                   vid=>vidon,
                   clkd=>clkdiv);

--   keyboard:    keyboardVhdl port map(   CLK => mclk,
--                        RST => '0',
--                        KD => kd,
--                        KC => kc,
--                        an => ankb,
--                        sseg => ssegkb);
--
--   kbf:    kbfilter port map(   mclk => mclk,
--                              an => ankb,
--                              ssegin => ssegkb,
--                              send => send,
--                              ssegout => ssegkbnext   );
--	
	uart_rx_mod:	uart_rx port map(
							i_Clk       	=> mclk,
							i_RX_Serial		=> rx,
							o_RX_DV			=> send,
							o_RX_Byte		=> ssegkbnext
						);
	
   tetrix_display:    display port map(   mclk => mclk,
                        clkdiv => clkdiv,
                        vidon => vidon,
                        rect => DOB,
                        crx => ADDRB(4 downto 0),
                        cry => ADDRB(9 downto 5),
                        pixel => pixtetrix);

   textdisplay:    text_display port map( clkd => clkdiv,
                        texton => texton,
                        car => DOBt,
                        crx => ADDRBt(4 downto 0),
                        cry => ADDRBt(8 downto 5),
                        pix => pixtext);

   score_controll:    score port map(   mclk => clkdiv,
                        ng => newgame,
                        cl => countline,
                        speed => spd,
                        wen => WEAt,
                        car => DIAt,
                        crx => ADDRAt(4 downto 0),
                        cry => ADDRAt(8 downto 5));

   tetrix_gamecontrol:    gamecontrol port map(   mclk => mclk,
                        an => send,
                        sseg => ssegkbnext,
                        rectin => DOA,
                        speed => spd,
                        ng => newgame,
                        cl => countline,
                        wen => WEA,
                        rectout => DIA,
                        crx => ADDRA(4 downto 0),
                        cry => ADDRA(9 downto 5)
                     );

   -- tetrix's BlockRAM
   RAMB4_S4_S4_inst : RAMB4_S4_S4
	generic map (
				 --                                1                               0
	INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
				 --                                3                               2
	INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
				 --                                5                               4
	INIT_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
				 --                                7                               6
	INIT_03 => X"00000000000000000000000000EEEC00000000000000000000000000000CCCCC",
				 --                                9                               8
	INIT_04 => X"0000000000000000000000000AEEEC0000000000000000000000000AAAAAEC00",
				 --                               11                              10
	INIT_05 => X"0000000000000000000000000AEEE0DD0000000000000000000000000A00EC00",
				 --                               13                              12
	INIT_06 => X"0000000000000000000000F0000F00DD0000000000000000000000000A000D0D",
				 --                               15                              14
	INIT_07 => X"00000000000000000000000F0F09D00D0000000000000000000000F000F90D0D",
				 --                               17                              16
	INIT_08 => X"00000000000000000000000F0F090000000000000000000000000000F0090000",
				 --                               19                              18
	INIT_09 => X"0000000000000000000000F0000F00000000000000000000000000F000F90000",

	INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
   port map (
      DOA => DOA,     -- Port A 4-bit data output
      DOB => DOB,     -- Port B 4-bit data output
      ADDRA => ADDRA, -- Port A 10-bit address input
      ADDRB => ADDRB, -- Port B 10-bit address input
      CLKA => mclk,   -- Port A clock input
      CLKB => mclk,   -- Port B clock input
      DIA => DIA,  -- Port A 4-bit data input
      DIB => "0000",     -- Port B 4-bit data input
      ENA => '1',     -- Port A RAM enable input
      ENB => '1',     -- Port B RAM enable input
      RSTA => '0',   -- Port A Synchronous reset input
      RSTB => '0',   -- Port B Synchronous reset input
      WEA => WEA,     -- Port A RAM write enable input
      WEB => '0'      -- Port B RAM write enable input
   );

    --------------------------------------------------------------------
    --textbox's BlockRAM
    RAMB4_S8_S8_inst : RAMB4_S8_S8
	generic map (
	INIT_00 => X"0007040404040404040404040404040404040404040404040404040404040401",
	--   F1 - STOP PARA REINICIAR
	INIT_01 => X"00070000000000002D1C4321433143242D001C2D1C4D004D442C1B004E162B07",
	-- F2 - INTENTALO DE NUEVO   
	INIT_02 => X"000700000000000000442A243C3100242300444B1C2C31242C3143004E1E2B07",   
	-- D - MUEVE A LA DERECHA
	INIT_03 => X"0007000000000000001C3321242D2423001C4B001C00242A243C3A004E002307",   
	-- A - MUEVE AL OTRO LADO
	INIT_04 => X"00070000000000000044231C4B00442D2C44004B1C00242A243C3A004E001C07",   
	-- ESPACIO - ROTACION
	INIT_05 => X"00070000000000000000000000314443211C2C442D004E004443211C4D1B2407",
	--  S - PARA MAS RAPIDO 
	INIT_06 => X"0007000000000000000000004423434D1C2D001B1C3A001C2D1C4D004E001B07",
	-- RECORD
	INIT_07 => X"00070000000000000000000000000000000000000000000000232D4421242D07",
	-- PUNTUACION   
	INIT_08 => X"000700000000000000000000000000000000000000314443211C3C2C313C4D07",   
	INIT_09 => X"0007000000000000000000000000000000000000000000000000000000000007",
	INIT_0A => X"0007000000000000000000000000000000000000000000000000000000000007",
	INIT_0B => X"00070000000000000000000000001B433C4B000000000000000000002D232107",
	INIT_0C => X"0007000000000000000000001C2D24231C3A00000016004E00444D433C152407",
	INIT_0D => X"0007000000000000000000000023432A1C230000000044432D1C3143232D4407",
	INIT_0E => X"000700000000000000001C3124211C3A1C210000000000000000000000000007",
	INIT_0F => X"0007050505050505050505050505050505050505050505050505050505050503")
   port map (
      DOA => DOAt,     -- Port A 8-bit data output
      DOB => DOBt,     -- Port B 8-bit data output
      ADDRA => ADDRAt, -- Port A 9-bit address input
      ADDRB => ADDRBt, -- Port B 9-bit address input
      CLKA => mclk,   -- Port A clock input
      CLKB => clkdiv,   -- Port B clock input
      DIA => DIAt, -- Port A 8-bit data input
      DIB => "00000000",     -- Port B 8-bit data input
      ENA => '1',     -- Port A RAM enable input
      ENB => '1',     -- Port B RAM enable input
      RSTA => '0',   -- Port A Synchronous reset input
      RSTB => '0',   -- Port B Synchronous reset input
      WEA => WEAt,     -- Port A RAM write enable input
      WEB => '0'      -- Port B RAM write enable input
   );
    
   -- Selecting from which component to read the pixel:
   -- tetrix or text display
   pix<= pixtetrix when vidon='1' else pixtext;
end Behavioral;