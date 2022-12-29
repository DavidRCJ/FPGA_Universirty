-- Módulo de recepción serial UART
--Recibe 8 bits de manera serial, un bit de inicio, un bit de parada y no posee análisis de paridad
--Cuando termina la recepción "o_rx_dv" se pone en "alto" durante un ciclo de reloj para indicar que se recibió un nuevo dato. 
--*******************************************************************************
--El "Generic -> g_CLKS_PER_BIT" se define de la siguente forma:
--EJEMPLO1: 50 MHz (señal de reloj), a una velocidad de transmisión de 115200 baudios
--(50E6)/(115200)=434.02 entonces aprox. g_CLKS_PER_BIT : integer := 434 
--EJEMPLO2: 10 MHz (señal de reloj), a una velocidad de transmisión de 115200 baudios
--(10E6)/(115200)=86.8.02 entonces aprox. g_CLKS_PER_BIT : integer := 87 
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity UART_RX is
  generic (
    g_CLKS_PER_BIT : integer := 5208     			-- Colocar el valor guiado de los ejemplos
    );
  port (
    i_Clk       : in  std_logic;					--Señal de reloj de la tarjeta
    i_RX_Serial : in  std_logic;					--Linea donde ingresará el dato serial
    o_RX_DV     : out std_logic; 					--Se debe poner en "alto" durante un ciclo de reloj al finalizar la recepción
    o_RX_Byte   : out std_logic_vector(7 downto 0)  --Será el dato obtenido de la recepción serial
    );
end UART_RX;

architecture rtl of UART_RX is
  type t_SM_Main is (s_Idle, s_RX_Start_Bit, s_RX_Data_Bits,s_RX_Stop_Bit, s_Cleanup);
  signal r_SM_Main : t_SM_Main := s_Idle;
  signal r_RX_Data_R : std_logic := '0';
  signal r_RX_Data   : std_logic := '0';
  signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal r_Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal r_RX_Byte   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_RX_DV     : std_logic := '0';
begin
  --Respaldo del valor de entrada serial, se realiza dos veces el respaldo 
  --para evitar problemas de metaestabilidad
  p_SAMPLE : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      r_RX_Data_R <= i_RX_Serial;
      r_RX_Data   <= r_RX_Data_R;
    end if;
  end process p_SAMPLE;
 
  --Máquina de control para la UART 
  p_UART_RX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      case r_SM_Main is
        when s_Idle =>
          r_RX_DV     <= '0';
          r_Clk_Count <= 0;
          r_Bit_Index <= 0;
          if r_RX_Data = '0' then       -- Detección del bit de inicio
            r_SM_Main <= s_RX_Start_Bit;
          else
            r_SM_Main <= s_Idle;
          end if;
		--Checa a la mitad del bit si el bit de inicio permanece en "bajo".
        when s_RX_Start_Bit =>
          if r_Clk_Count = (g_CLKS_PER_BIT-1)/2 then
            if r_RX_Data = '0' then
              r_Clk_Count <= 0;  -- reset counter since we found the middle
              r_SM_Main   <= s_RX_Data_Bits;
            else
              r_SM_Main   <= s_Idle;
            end if;
          else
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Start_Bit;
          end if;
        -- Wait g_CLKS_PER_BIT-1 clock cycles to sample serial data
        when s_RX_Data_Bits =>
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Data_Bits;
          else
            r_Clk_Count            <= 0;
            r_RX_Byte(r_Bit_Index) <= r_RX_Data;
            -- Check if we have sent out all bits
            if r_Bit_Index < 7 then
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= s_RX_Data_Bits;
            else
              r_Bit_Index <= 0;
              r_SM_Main   <= s_RX_Stop_Bit;
            end if;
          end if;
        -- Receive Stop bit.  Stop bit = 1
        when s_RX_Stop_Bit =>
          -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Stop_Bit;
          else
            r_RX_DV     <= '1';
            r_Clk_Count <= 0;
            r_SM_Main   <= s_Cleanup;
          end if;
        -- Stay here 1 clock
        when s_Cleanup =>
          r_SM_Main <= s_Idle;
          r_RX_DV   <= '0';
        when others =>
          r_SM_Main <= s_Idle;
      end case;
    end if;
  end process p_UART_RX;
  o_RX_DV   <= r_RX_DV;
  o_RX_Byte <= r_RX_Byte;
end rtl;