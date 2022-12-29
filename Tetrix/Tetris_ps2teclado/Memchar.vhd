------------------------------------------------------------------------
--  memchar.vhd -- contain's the character's form
------------------------------------------------------------------------
--  Author : Fazakas Szabolcs
--           
------------------------------------------------------------------------
-- Software version: Xilinx ISE 7.1.04i
--                   WebPack
------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memchar is
    Port ( CH : in std_logic_vector(7 downto 0);
           L : in std_logic_vector(2 downto 0);
           Q : out std_logic_vector(7 downto 0));
end Memchar;

architecture Behavioral of Memchar is
  type ROM_Array is array (0 to 7) of std_logic_vector(7 downto 0);
  constant space: ROM_Array := (
      "00000000",--space
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "00000000");
   constant A: ROM_Array := (
      "00111000",--A
      "01000100",
      "01000100",
      "01000100",
      "01111100",
      "01000100",
      "01000100",
      "00000000");
   constant B: ROM_Array := (
      "01111000",--B
      "01000100",
      "01000100",
      "01111000",
      "01000100",
      "01000100",
      "01111000",
      "00000000");
   constant C: ROM_Array := (
      "00111000",--C
      "01000100",
      "01000000",
      "01000000",
      "01000000",
      "01000100",
      "00111000",
      "00000000");
   constant D: ROM_Array := (
      "01110000",--D
      "01001000",
      "01000100",
      "01000100",
      "01000100",
      "01001000",
      "01110000",
      "00000000");
   constant E: ROM_Array := (
      "01111100",--E
      "01000000",
      "01000000",
      "01111000",
      "01000000",
      "01000000",
      "01111100",
      "00000000");
   constant F: ROM_Array := (
      "01111100",--F
      "01000000",
      "01000000",
      "01111000",
      "01000000",
      "01000000",
      "01000000",
      "00000000");
   constant G: ROM_Array := (
      "00111000",--G
      "01000100",
      "01000000",
      "01011100",
      "01000100",
      "01000100",
      "00111000",
      "00000000");
   constant H: ROM_Array := (
      "01000100",--H
      "01000100",
      "01000100",
      "01111100",
      "01000100",
      "01000100",
      "01000100",
      "00000000");
   constant I: ROM_Array := (
      "00111000",--I
      "00010000",
      "00010000",
      "00010000",
      "00010000",
      "00010000",
      "00111000",
      "00000000");
   constant J: ROM_Array := (
      "00011100",--J
      "00001000",
      "00001000",
      "00001000",
      "00001000",
      "00101000",
      "00110000",
      "00000000");
   constant K: ROM_Array := (
      "01000100",--K
      "01001000",
      "01010000",
      "01100000",
      "01010000",
      "01001000",
      "01000100",
      "00000000");
   constant Lo: ROM_Array := (
      "01000000",--L
      "01000000",
      "01000000",
      "01000000",
      "01000000",
      "01000000",
      "01111100",
      "00000000");
   constant M: ROM_Array := (
      "01000100",--M
      "01101100",
      "01010100",
      "01010100",
      "01000100",
      "01000100",
      "00000000",
      "00000000");
   constant N: ROM_Array := (
      "01000100",--N
      "01000100",
      "01100100",
      "01010100",
      "01001100",
      "01000100",
      "00000000",
      "00000000");
   constant O: ROM_Array := (
      "00111000",--O
      "01000100",
      "01000100",
      "01000100",
      "01000100",
      "01000100",
      "00111000",
      "00000000");
   constant P: ROM_Array := (
      "01111000",--P
      "01000100",
      "01000100",
      "01111000",
      "01000000",
      "01000000",
      "01000000",
      "00000000");
   constant Qo: ROM_Array := (
      "00111000",--Q
      "01000100",
      "01000100",
      "01000100",
      "01010100",
      "01001000",
      "00110100",
      "00000000");
   constant R: ROM_Array := (
      "01111000",--R
      "01000100",
      "01000100",
      "01111000",
      "01010000",
      "01001000",
      "01000100",
      "00000000");
   constant S: ROM_Array := (
      "00111100",--S
      "01000000",
      "01000000",
      "00111000",
      "00000100",
      "00000100",
      "01111000",
      "00000000");
   constant T: ROM_Array := (
      "01111100",--T
      "00010000",
      "00010000",
      "00010000",
      "00010000",
      "00010000",
      "00010000",
      "00000000");
   constant U: ROM_Array := (
      "01000100",--U
      "01000100",
      "01000100",
      "01000100",
      "01000100",
      "01000100",
      "00111000",
      "00000000");
   constant V: ROM_Array := (
      "01000100",--V
      "01000100",
      "01000100",
      "01000100",
      "01000100",
      "00101000",
      "00010000",
      "00000000");
   constant W: ROM_Array := (
      "01000100",--W
      "01000100",
      "01000100",
      "01010100",
      "01010100",
      "01010100",
      "00101000",
      "00000000");
   constant X: ROM_Array := (
      "01000100",--X
      "01000100",
      "00101000",
      "00010000",
      "00101000",
      "01000100",
      "01000100",
      "00000000");
   constant Y: ROM_Array := (
      "01000100",--Y
      "01000100",
      "01000100",
      "00101000",
      "00010000",
      "00010000",
      "00010000",
      "00000000");
   constant Z: ROM_Array := (
      "01111100",--Z
      "00000100",
      "00001000",
      "00010000",
      "00100000",
      "01000000",
      "01111100",
      "00000000");
   constant zero: ROM_Array := (
      "00111000",--0
      "01000100",
      "01001100",
      "01010100",
      "01100100",
      "01000100",
      "00111000",
      "00000000");
   constant one: ROM_Array := (
      "00010000",--1
      "00110000",
      "00010000",
      "00010000",
      "00010000",
      "00010000",
      "00111000",
      "00000000");
   constant two: ROM_Array := (
      "00111000",--2
      "01000100",
      "00000100",
      "00001000",
      "00010000",
      "00100000",
      "01111100",
      "00000000");
   constant three: ROM_Array := (
      "01111100",--3
      "00001000",
      "00010000",
      "00001000",
      "00000100",
      "01000100",
      "00111000",
      "00000000");
   constant four: ROM_Array := (
      "00001000",--4
      "00011000",
      "00101000",
      "01001000",
      "01111100",
      "00001000",
      "00001000",
      "00000000");
   constant five: ROM_Array := (
      "01111100",--5
      "01000000",
      "01111000",
      "00000100",
      "00000100",
      "01000100",
      "00111000",
      "00000000");
   constant six: ROM_Array := (
      "00011000",--6
      "00100000",
      "01000000",
      "01111000",
      "01000100",
      "01000100",
      "00111000",
      "00000000");
   constant seven: ROM_Array := (
      "01111100",--7
      "00000100",
      "00001000",
      "00010000",
      "00100000",
      "00100000",
      "00100000",
      "00000000");
   constant eight: ROM_Array := (
      "00111000",--8
      "01000100",
      "01000100",
      "00111000",
      "01000100",
      "01000100",
      "00111000",
      "00000000");
   constant nine: ROM_Array := (
      "00111000",--9
      "01000100",
      "01000100",
      "00111000",
      "00000100",
      "00001000",
      "00110000",
      "00000000");
   constant twopoint: ROM_Array := (
      "00000000",--:
      "00110000",
      "00110000",
      "00000000",
      "00110000",
      "00110000",
      "00000000",
      "00000000");
   constant minus: ROM_Array := (
      "00000000",--:
      "00000000",
      "00000000",
      "01111100",
      "00000000",
      "00000000",
      "00000000",
      "00000000");
   constant s_up: ROM_Array := (
      "11111111",    
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "00000000");
   constant s_dw: ROM_Array := (
      "00000000",    
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "00000000",
      "11111111");
   constant s_lf: ROM_Array := (
      "10000000",    
      "10000000",
      "10000000",
      "10000000",
      "10000000",
      "10000000",
      "10000000",
      "10000000");
   constant s_rg: ROM_Array := (
      "00000001",    
      "00000001",
      "00000001",
      "00000001",
      "00000001",
      "00000001",
      "00000001",
      "00000001");
   constant c_uplf: ROM_Array := (
      "11111111",    
      "10000000",
      "10000000",
      "10000000",
      "10000000",
      "10000000",
      "10000000",
      "10000000");
   constant c_uprg: ROM_Array := (
      "11111111",    
      "00000001",
      "00000001",
      "00000001",
      "00000001",
      "00000001",
      "00000001",
      "00000001");
   constant c_dwlf: ROM_Array := (
      "10000000",    
      "10000000",
      "10000000",
      "10000000",
      "10000000",
      "10000000",
      "10000000",
      "11111111");
   constant c_dwrg: ROM_Array := (
      "00000001",    
      "00000001",
      "00000001",
      "00000001",
      "00000001",
      "00000001",
      "00000001",
      "11111111");

begin





Q <= space(conv_integer(unsigned(L))) when CH = X"29" else  
   A(conv_integer(unsigned(L)))       when CH = X"1C" else
   B(conv_integer(unsigned(L)))       when CH = X"32" else
   C(conv_integer(unsigned(L)))       when CH = X"21" else
   D(conv_integer(unsigned(L)))       when CH = X"23" else
   E(conv_integer(unsigned(L)))       when CH = X"24" else
   F(conv_integer(unsigned(L)))       when CH = X"2B" else
   G(conv_integer(unsigned(L)))       when CH = X"34" else
   H(conv_integer(unsigned(L)))       when CH = X"33" else
   I(conv_integer(unsigned(L)))       when CH = X"43" else
   J(conv_integer(unsigned(L)))       when CH = X"3B" else
   K(conv_integer(unsigned(L)))       when CH = X"42" else
   Lo(conv_integer(unsigned(L)))       when CH = X"4B" else
   M(conv_integer(unsigned(L)))       when CH = X"3A" else
   N(conv_integer(unsigned(L)))       when CH = X"31" else
   O(conv_integer(unsigned(L)))       when CH = X"44" else
   P(conv_integer(unsigned(L)))       when CH = X"4D" else
   Qo(conv_integer(unsigned(L)))       when CH = X"15" else
   R(conv_integer(unsigned(L)))       when CH = X"2D" else
   S(conv_integer(unsigned(L)))       when CH = X"1B" else
   T(conv_integer(unsigned(L)))       when CH = X"2C" else
   U(conv_integer(unsigned(L)))       when CH = X"3C" else
   V(conv_integer(unsigned(L)))       when CH = X"2A" else
   W(conv_integer(unsigned(L)))       when CH = X"1D" else
   X(conv_integer(unsigned(L)))       when CH = X"22" else
   Y(conv_integer(unsigned(L)))       when CH = X"35" else
   Z(conv_integer(unsigned(L)))       when CH = X"1A" else

   zero(conv_integer(unsigned(L)))       when CH = X"45" else
   one(conv_integer(unsigned(L)))       when CH = X"16" else
   two(conv_integer(unsigned(L)))       when CH = X"1E" else
   three(conv_integer(unsigned(L)))       when CH = X"26" else
   four(conv_integer(unsigned(L)))       when CH = X"25" else
   five(conv_integer(unsigned(L)))       when CH = X"2E" else
   six(conv_integer(unsigned(L)))       when CH = X"36" else
   seven(conv_integer(unsigned(L)))       when CH = X"3D" else
   eight(conv_integer(unsigned(L)))       when CH = X"3E" else
   nine(conv_integer(unsigned(L)))       when CH = X"46" else
   twopoint(conv_integer(unsigned(L)))    when CH = X"4C" else
   minus(conv_integer(unsigned(L)))    when CH = X"4E" else

   s_up(conv_integer(unsigned(L)))       when CH = X"04" else
   s_dw(conv_integer(unsigned(L)))       when CH = X"05" else
   s_lf(conv_integer(unsigned(L)))       when CH = X"07" else
   s_rg(conv_integer(unsigned(L)))       when CH = X"06" else
   c_uplf(conv_integer(unsigned(L)))    when CH = X"01" else
   c_uprg(conv_integer(unsigned(L)))    when CH = X"08" else
   c_dwlf(conv_integer(unsigned(L)))    when CH = X"03" else
   c_dwrg(conv_integer(unsigned(L)))    when CH = X"02" else

   "00000000";


end Behavioral;
   