
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
-- This component is controlling all the steps of the game.
-- With the "sseg" and "an" input is connected to the kbfilter, which
-- is sending the scan codes. Using the "cl" and "ng" output and the 
-- "speed" input is communicating with the score component and the
-- other signals are used to communicate with the tetrix's BlockRAM. 
-- This component is a big state machine and almost each state has
-- sub states.

--
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- mclk             Input      Main clock input 
-- an               Input      Alarm
-- sseg(7:0)        Input      Scan code
-- speed(1:0)       Input      Game speed
-- rectin(3:0)      Input      BlockRAM's data output
-- crx(4:0)         Output   BlockRAM's address input
-- cry(3:0)         Output   BlockRAM's address input
-- rectout (3:0)    Output   BlockRAM's data input
-- cl               Output   Count line
-- ng               Output   New game
-- wen              Output   BlockRAM's write enable
--
------------------------------------------------------------------------
entity gamecontrol is
Port(    mclk       : in std_logic;
         an          : in std_logic;
         sseg       : in std_logic_vector (7 downto 0);
         rectin    : in std_logic_vector(3 downto 0);
        speed          :in std_logic_vector(1 downto 0);
        ng           :out std_logic;
        cl           :out std_logic;
        wen           :out std_logic;
        rectout     :out std_logic_vector(3 downto 0);
        crx          :out std_logic_vector(4 downto 0);
        cry         :out std_logic_vector(4 downto 0)
        );
end gamecontrol;

architecture Behavioral of gamecontrol is
------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------


------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
signal cntClk:std_logic_vector(24 downto 0):="0000000000000000000000000";
 signal random         : std_logic_vector(2 downto 0):="000";
 signal color         : std_logic_vector(2 downto 0):="001";
    
 signal cx             : std_logic_vector(4 downto 0):="00000";
 signal cy                 : std_logic_vector(4 downto 0):="00000";

 signal pix            : std_logic_vector(3 downto 0):="0000";

 signal newgame      : std_logic:='0';   
 signal countline      : std_logic:='0';
 signal we            : std_logic:='0';   
 signal ann            : std_logic:='0';
 
 --piece x coordinate
 signal p1x             : std_logic_vector(4 downto 0):="00000";
 signal p2x             : std_logic_vector(4 downto 0):="00000";
 signal p3x             : std_logic_vector(4 downto 0):="00000";
 signal p4x             : std_logic_vector(4 downto 0):="00000";

 --piece y coordinate
 signal p1y             : std_logic_vector(4 downto 0):="00000";
 signal p2y             : std_logic_vector(4 downto 0):="00000";
 signal p3y             : std_logic_vector(4 downto 0):="00000";
 signal p4y             : std_logic_vector(4 downto 0):="00000";

 --piece codification
 signal p              : std_logic_vector(4 downto 0):="00000";
 --piece color
 signal pcolor           : std_logic_vector(2 downto 0):="000";

 signal testx          : std_logic_vector(4 downto 0):="00000";
 signal testy          : std_logic_vector(4 downto 0):="00000";
 signal makex            : std_logic_vector(4 downto 0):="00000";
 signal makey            : std_logic_vector(4 downto 0):="00000";

 signal make         : std_logic_vector(3 downto 0):="0000";
 signal test         : std_logic_vector(3 downto 0):="0000";
 --state
 signal state         : std_logic_vector(3 downto 0):="0000";
 --speed
 signal spd         : std_logic_vector(1 downto 0):="00";







------------------------------------------------------------------------
-- Module Implementation - 
------------------------------------------------------------------------
begin
    -- generating the random piece and the random color
    process (mclk)                       
        begin
          if mclk = '1' and mclk'Event then 
                cntClk <= cntClk + 1;
                if random="100" then
                   random<="000";
                else
                   random<=random + 1;
                end if;
                if color="111" then
                   color<="001";
                else
                   color<=color + 1;
                end if;
          end if;
    end process;



 
game:process (cntCLk(0),an,make,rectin,test,state)
begin
if (cntCLk(0)'event and cntCLk(0) = '1') then
   
   if (an /= ann) then
      -- reading the scancode
      ann <= not ann;
      -- F2: new game
      if (sseg="00000110" and state="0000") then
         state <= "0011";
         makex<="00000";
         makey<="00000";
      -- F1: stop game
      elsif (sseg="00000101")   then
      state <= "0000";
      -- A: left
      elsif (sseg="00011100" and state="0111")   then
            state <= "1110";
            test<="1000";
   
      -- D: right
      elsif (sseg="00100011" and state="0111")   then
            state <= "1101";
            test<="1000";
      
      -- Space: rotate
      elsif (sseg="00101001" and state="0111" and
      not(p1y="00001" or p2y="00001" or p3y="00001" or p4y="00001"))then
            state <= "1011";
            test<="1000";
      -- speed   
      elsif (sseg="00011011")   then
         spd<="11";
      end if;

   else
          
      ------------------------------------------------------------------
      --stop: end of game, stop the game
      if (state="0000") then
         

      ------------------------------------------------------------------
      --reset: reseting the table   
      elsif (state="0011") then
           --makex will count from 0 to 9          
           if makex<"01010" then
            we<='1';
            pix<="0000";
            cx<=makex;
            makex<=makex + 1;
            cy<=makey;
         else
            -- makey will count from 0 to 19
            if makey<"10100" then
               makey<=makey + 1;
               makex<="00000";
            else
               --starting the game
               newgame<=not newgame;
               state<="0010";
               we<='0';
            end if;
         end if;
       
      ------------------------------------------------------------------
      -- test_stop: test game stop   
      elsif (state="0001") then
        if p1y="00001" or p2y="00001" or p3y="00001" or p4y="00001" then
            state<="0000";
         else
            state<="1111";
            test<="0000";
            testx<="00000";
            testy<="00001";
         end if; 
         spd<=speed;
      ------------------------------------------------------------------
      -- initate:- generating the form's
      elsif (state="0010") then
         pcolor<=color;
         
         --            p3 p4
         --         p1 p2  
         if random="000"  then
            p<="00000";
            p1x<= "00011";
            p2x<= "00100";
            p3x<= "00100";
            p4x<= "00101";
            p1y<= "00001";
            p2y<= "00001";
            p3y<= "00000";
            p4y<= "00000";
         --            p3 
         --         p1 p2 p4 
         elsif random="001"  then
            p<="00100";
            p1x<= "00011";
            p2x<= "00100";
            p3x<= "00100";
            p4x<= "00101";
            p1y<= "00001";
            p2y<= "00001";
            p3y<= "00000";
            p4y<= "00001";
         --               p4
         --         p1 p2 p3 
         elsif random="010"  then
            p<="01000";
            p1x<= "00011";
            p2x<= "00100";
            p3x<= "00101";
            p4x<= "00101";
            p1y<= "00001";
            p2y<= "00001";
            p3y<= "00001";
            p4y<= "00000";
         --         p3 p4
         --         p1 p2  
         elsif random="011"  then
            p<="01100";
            p1x<= "00011";
            p2x<= "00100";
            p3x<= "00011";
            p4x<= "00100";
            p1y<= "00001";
            p2y<= "00001";
            p3y<= "00000";
            p4y<= "00000";
         --              
         --         p1 p2 p3 p4 
         elsif random="100"  then
            p<="10000";
            p1x<= "00011";
            p2x<= "00100";
            p3x<= "00101";
            p4x<= "00110";
            p1y<= "00001";
            p2y<= "00001";
            p3y<= "00001";
            p4y<= "00001";
         end if;
            
      state<="0111";

      ------------------------------------------------------------------
      -- wait: standing, waiting
      elsif   (state="0111") then
       if (spd="00" and cntClk(24 downto 0)="0000000000000000000000000")
        or (spd="01" and cntClk(23 downto 0)="000000000000000000000000")
         or (spd="10" and cntClk(22 downto 0)="00000000000000000000000")
          or (spd="11" and cntClk(21 downto 0)="0000000000000000000000")
           then   
               state<="0110";
               test<="1000";
         end if;
            
      ------------------------------------------------------------------
      -- step_down,step_left,step_right: stepping state
      elsif  (state="1000" or state="1010" or state="1001") then
         
         if (make = "1000") then
             cx<=p1x;
             cy<=p1y;
             pix<="0000";
             we<='1';   
             make <= "1001";
         elsif make="1001" then
             cx<=p2x;
             cy<=p2y;
             if state="1000" then
                 p1y<=p1y + 1;
             elsif state="1001" then
                 p1x<=p1x + 1;
             elsif state="1010" then
                 p1x<=p1x - 1;
             end if;
             make <= "1010";
         elsif make="1010" then
             cx<=p3x;
             cy<=p3y;
             if state="1000" then
                 p2y<=p2y + 1;
             elsif state="1001" then
                 p2x<=p2x + 1;
             elsif state="1010" then
                 p2x<=p2x - 1;
             end if;
             make <= "1011";
         elsif make="1011" then
             cx<=p4x;
             cy<=p4y;
             if state="1000" then
                 p3y<=p3y + 1;
             elsif state="1001" then
                 p3x<=p3x + 1;
             elsif state="1010" then
                 p3x<=p3x - 1;
             end if;
             make <= "1100";
         elsif make="1100" then
             cx<=p1x;
             cy<=p1y;
             if state="1000" then
                 p4y<=p4y + 1;
             elsif state="1001" then
                 p4x<=p4x + 1;
             elsif state="1010" then
                 p4x<=p4x - 1;
             end if;
             pix<='1' & pcolor;
             make <= "1101";
          elsif make="1101" then
             cx<=p2x;
             cy<=p2y;
             make <= "1110";
          elsif make="1110" then
             cx<=p3x;
             cy<=p3y;
             make <= "1111";
          elsif make="1111" then
             cx<=p4x;
             cy<=p4y;
             make <= "0001";
          elsif make="0001" then
              we<='0';
         
                state<="0111";
                
             
         end if;
      ------------------------------------------------------------------
      -- test_down, test_right, test_left: testing state
      elsif state="0110" or state="1101" or state="1110" then
          
       if (test = "1000") then
            if state="0110" then   
               if (p1y<"10011")  then
                  cx<=p1x;
                  cy<=p1y + 1;         
                  test <= "1001";
               else
                  state<="0001";
               end if;
            elsif  state="1101" then
               if p1x<"01001" then
                  cx<=p1x + 1;
                  cy<=p1y;         
                  test <= "1001";
               else
                  state<="0111";
               end if;
            elsif  state="1110" then
               if p1x>"00000"   then
                  cx<=p1x - 1;
                  cy<=p1y;         
                  test <= "1001";
               else
                  state<="0111";
               end if;
            end if;
         elsif   (test = "1001") then
             if ((cy=p2y and cx=p2x) or (cy=p3y and cx=p3x) or
                            (cy=p4y and cx=p4x)) then
                test<="1010";
             else
                if (rectin(3)='1') then
                  if state="0110" then   
                      state<="0001";
                  else
                     state<="0111";
                  end if;
               else
                  test<="1010";
               end if;
             end if;
         elsif   (test = "1010") then

            if state="0110" then   
               if (p2y<"10011")  then
                  cx<=p2x;
                  cy<=p2y + 1;         
                  test <= "1011";
               else
                  state<="0001";
               end if;
            elsif  state="1101" then
               if p2x<"01001" then
                  cx<=p2x + 1;
                  cy<=p2y;         
                  test <= "1011";
               else
                  state<="0111";
               end if;
            elsif  state="1110" then
               if p2x>"00000"   then
                  cx<=p2x - 1;
                  cy<=p2y;         
                  test <= "1011";
               else
                  state<="0111";
               end if;
            end if;
         elsif   (test = "1011") then
            if ((cy=p1y and cx=p1x) or (cy=p3y and cx=p3x) or 
                        (cy=p4y and cx=p4x)) then
                test<="1100";
             else
                if (rectin(3)='1') then
                   if state="0110" then   
                      state<="0001";
                  else
                     state<="0111";
                  end if;
               else
                  test<="1100";
               end if;
             end if;
         elsif   (test = "1100") then

            if state="0110" then   
               if (p3y<"10011")  then
                  cx<=p3x;
                  cy<=p3y + 1;         
                  test <= "1101";
               else
                  state<="0001";
               end if;
            elsif  state="1101" then
               if p3x<"01001" then
                  cx<=p3x + 1;
                  cy<=p3y;         
                  test <= "1101";
               else
                  state<="0111";
               end if;
            elsif  state="1110" then
               if p3x>"00000"   then
                  cx<=p3x - 1;
                  cy<=p3y;         
                  test <= "1101";
               else
                  state<="0111";
               end if;
            end if;
         elsif   (test = "1101") then
            if ((cy=p1y and cx=p1x) or (cy=p2y and cx=p2x) or 
                        (cy=p4y and cx=p4x)) then
                test<="1110";
             else
                if (rectin(3)='1') then
                   if state="0110" then   
                      state<="0001";
                  else
                     state<="0111";
                  end if;
               else
                  test<="1110";
               end if;
             end if;
           elsif   (test = "1110") then
            if state="0110" then   
               if (p4y<"10011")  then
                  cx<=p4x;
                  cy<=p4y + 1;         
                  test <= "1111";
               else
                  state<="0001";
               end if;
            elsif  state="1101" then
               if p4x<"01001" then
                  cx<=p4x + 1;
                  cy<=p4y;         
                  test <= "1111";
               else
                  state<="0111";
               end if;
            elsif  state="1110" then
               if p4x>"00000"   then
                  cx<=p4x - 1;
                  cy<=p4y;         
                  test <= "1111";
               else
                  state<="0111";
               end if;
            end if;
         elsif   (test = "1111") then
            if ((cy=p1y and cx=p1x) or (cy=p2y and cx=p2x) or 
                        (cy=p3y and cx=p3x)) then
                test<="0000";
               if state="0110" then   
                      state<="1000";
                     make<="1000";
                  elsif  state="1110" then
                     state<="1010";
                     make<="1000";
                  elsif  state="1101" then
                     state<="1001";
                     make<="1000";
                  end if;
             else
                if (rectin(3)='1') then
                   if state="0110" then   
                      state<="0001";
                  else
                     state<="0111";
                  end if;
               else
               -- we can make the step
                  test<="0000";
                  if state="0110" then   
                      state<="1000";
                     make<="1000";
                  elsif  state="1110" then
                     state<="1010";
                     make<="1000";
                  elsif  state="1101" then
                     state<="1001";
                     make<="1000";
                  end if;
                  
                  
               end if;
             end if;

         end if;
      ------------------------------------------------------------------
      -- del_rows: deleting row
      elsif state="1111" then
          
         if test="0000" then
                  if testx<"01010" then
                     cx<=testx;
                     cy<=testy;
                     testx<=testx + 1;
                     test<="0001";
                  else
                     --copy
                     make<="0000";
                     makex<="00000";
                     makey<=testy - 1;
                     test<="1111";
                     countline<=not countline;
                  end if;
         elsif test="0001" then
                  if rectin(3)='0' then
                     if testy>"10100" then
                     --out
                        state<="0010";
                     else
                        testx<="00000";
                        testy<=testy + 1;
                        test<="0000";
                     end if;
                   else
                      test<="0000";
                   end if;   
         else
                if make="0000" then
                  if makex<"01010" then
                     cx<=makex;
                     makex<=makex + 1;
                     cy<=makey;
                     make<="0001";
                  else
                     if makey>"00001" then
                        makey<=makey - 1;
                        makex<="00000";
                     else
                        --back
                        
                        test<="0000";
                        testx<="00000";
                        testy<=testy + 1;   
                     end if;
                   end if;
                elsif make="0001" then
                     pix<=rectin;
                    cy<=makey + 1;
                    we<='1';
                    make<="0010";
                elsif make="0010" then
                    we<='0';
                    make<="0000";
                end if;
          end if;
      ------------------------------------------------------------------
      --test_rotate: test if we can rotate the piece
      elsif state="1011" then
          if (test = "1000") then
                  if p="00000" then   
                        cx<=p1x + 1;
                        cy<=p1y - 2;         
                        test <= "1001";
                  elsif  p="00001" then
                        if p2x<"01001" then
                           cx<=p2x + 1;
                           cy<=p2y;
                           test <= "1001";
                        else
                           state<="0111";
                        end if;      
                  elsif  p="00100" then
                         cx<=p4x;
                         cy<=p4y - 1;
                         test <= "1001";                                  
                  elsif  p="00101" then
                         if p2x<"01001" then
                           cx<=p2x + 1;
                           cy<=p2y;
                           test <= "1001";
                        else
                           state<="0111";
                        end if;
                  elsif  p="00110" then
                         cx<=p2x;
                         cy<=p2y - 1;
                         test <= "1001";
                  elsif  p="00111" then
                         if p3x<"01001" then
                           cx<=p4x + 1;
                           cy<=p4y;
                           test <= "1001";
                        else
                           state<="0111";
                        end if;
                  elsif  p="01000" then
                         cx<=p4x;
                         cy<=p4y - 1;
                         test <= "1001";
                  elsif  p="01001" then
                         if p2x<"01001" then
                           cx<=p2x + 1;
                           cy<=p2y;
                           test <= "1001";
                        else
                           state<="0111";
                        end if;
                  elsif  p="01010" then
                         cx<=p4x + 1;
                         cy<=p4y;
                         test <= "1001";
                  elsif  p="01011" then
                         if p4x<"01001" then
                           cx<=p4x + 1;
                           cy<=p4y;
                           test <= "1001";
                        else
                           state<="0111";
                        end if;
                  elsif  p="01100" then
                          state<="0111";
                  elsif  p="10000" then
                        if p4y<"10011" then
                           cx<=p1x + 1;
                           cy<=p1y + 1;
                           test <= "1001";
                        else
                           state<="0111";
                        end if;
                  elsif  p="10001" then
                        if p4x<"01000" and p4x>"00000" then
                           cx<=p2x - 1;
                           cy<=p2y;
                           test <= "1001";
                        else
                           state<="0111";
                        end if;
                  end if;
         elsif   (test = "1001") then
                    if (rectin(3)='1') then
                        state<="0111";
                  else
                     test<="1010";
                  end if;
         elsif   (test = "1010") then
               if p="00000" then   
                      cx<=p1x;
                     cy<=p1y - 2;         
                     test <= "1011";
               elsif  p="00001" then
                     cx<=p1x - 1;
                     cy<=p1y;
                     test <= "1011";
               elsif  p="00100" then
                      cx<=p4x;
                      cy<=p4y - 2;
                      test <= "1011";                                  
               elsif  p="00111" then
                      cx<=p4x + 2;
                      cy<=p4y;
                      test <= "1011";
               elsif  p="01000" then
                         cx<=p4x - 1;
                         cy<=p4y - 1;
                         test <= "1011";
               elsif  p="01001" then                               
                        cx<=p2x - 1;
                        cy<=p2y;
                        test <= "1011";         
               elsif  p="01010" then
                      cx<=p3x;
                      cy<=p3y - 1;
                      test <= "1011";
               elsif  p="01011" then
                        cx<=p4x + 1;
                        cy<=p4y - 1;
                        test <= "1011";
               elsif  p="10000" then                           
                        cx<=p2x;
                        cy<=p2y - 1;
                        test <= "1011";
               elsif  p="10001" then                              
                        cx<=p2x + 1;
                        cy<=p2y;
                        test <= "1011";
               else
                      state<="1100";
                      make<="1000";                              
               end if;
         elsif   (test = "1011") then
                   if (rectin(3)='1') then
                        state<="0111";
                  else
                     test<="1100";
                  end if;
         elsif   (test = "1100") then
                  if  p="01001" then                               
                        cx<=p1x - 1;
                        cy<=p1y;
                        test <= "1101";
                  elsif  p="10000" then                           
                        cx<=p2x;
                        cy<=p2y - 2;
                        test <= "1101";
                  elsif  p="10001" then                              
                        cx<=p2x + 2;
                        cy<=p2y;
                        test <= "1101";
                  else 
                        state<="1100";
                        make<="1000";
                  end if;
         elsif   (test = "1101") then
                  if (rectin(3)='1') then
                        state<="0111";
                  else
                  -- we can make the step
                     state<="1100";
                     make<="1000";
                  end if;
                 
         end if;

      ------------------------------------------------------------------
      -- rotate: rotating state
      elsif  state="1100" then
         
         if (make = "1000") then
             cx<=p1x;
             cy<=p1y;
             pix<="0000";
             we<='1';   
             make <= "1001";
         elsif make="1001" then
             cx<=p2x;
             cy<=p2y;
             if p="00000" then   
                         p1x<=p1x + 1;
             elsif  p="00001" then
                        p1x<=p1x - 1;
             elsif  p="00100" then
                        p1x<=p1x + 2;
             elsif  p="00101" then
                        p1x<=p1x + 1;
                        p1y<=p1y - 1;
             elsif  p="00110" then
                        p1x<=p1x - 1;
                        p1y<=p1y - 1;
             elsif  p="00111" then
                        p1y<=p1y + 2;
             elsif  p="01000" then
                        p1x<=p1x + 2;                                 
             elsif  p="01001" then
                        p1x<=p1x + 1;
                        p1y<=p1y - 1;
             elsif  p="01010" then
                        p1x<=p1x - 2;
                        p1y<=p1y - 1;
             elsif  p="01011" then
                        p1y<=p1y + 2;
             elsif  p="10000" then
                        p1x<=p1x + 1;
                        p1y<=p1y + 2;
             elsif  p="10001" then
                        p1x<=p1x - 1;
                        p1y<=p1y - 1;
             end if;
             make <= "1010";
         elsif make="1010" then
             cx<=p3x;
             cy<=p3y;
             if p="00000" then   
                         p2y<=p2y - 1;
             elsif  p="00001" then
                        p2y<=p2y + 1;
             elsif  p="00100" then
                        p2x<=p2x + 1;
                        p2y<=p2y - 1;
             elsif  p="00111" then
                        p2x<=p2x + 1;
                        p2y<=p2y + 1;
             elsif  p="01000" then
                        p2x<=p2x + 1;
                        p2y<=p2y - 1;                   
             elsif  p="01010" then
                         p2x<=p2x - 1;
             elsif  p="01011" then
                        p2x<=p2x + 1;
                        p2y<=p2y + 1;
             end if;
             make <= "1011";
         elsif make="1011" then
             cx<=p4x;
             cy<=p4y;
              if p="00000" then   
                         p3x<=p3x - 1;
             elsif  p="00001" then
                        p3x<=p3x + 1;
             elsif  p="00101" then
                        p3x<=p3x + 1;
                        p3y<=p3y + 1;
             elsif  p="00110" then
                        p3x<=p3x + 1;
                        p3y<=p3y - 1;
             elsif  p="01000" then
                        p3y<=p3y - 2;                                 
             elsif  p="01001" then
                        p3x<=p3x - 1;
                        p3y<=p3y + 1;
             elsif  p="01010" then
                         p3y<=p3y + 1;
             elsif  p="01011" then
                        p3x<=p3x + 2;
             elsif  p="10000" then
                        p3x<=p3x - 1;
                        p3y<=p3y - 1;
             elsif  p="10001" then
                        p3x<=p3x + 1;
                        p3y<=p3y + 1;                                 
             end if;
             make <= "1100";
         elsif make="1100" then
             cx<=p1x;
             cy<=p1y;
              if p="00000" then   
                         p4x<=p4x - 2;
                        p4y<=p4y - 1;
             elsif  p="00001" then
                        p4x<=p4x + 2;
                        p4y<=p4y + 1;
             elsif  p="00100" then
                        p4y<=p4y - 2;
             elsif  p="00101" then
                         p4x<=p4x - 1;
                        p4y<=p4y + 1;                                 
             elsif  p="00110" then
                        p4x<=p4x + 1;
                        p4y<=p4y + 1;
             elsif  p="00111" then
                        p4x<=p4x + 2;
             elsif  p="01000" then
                        p4x<=p4x - 1;
                        p4y<=p4y - 1;                                 
             elsif  p="01001" then
                        p4y<=p4y + 2;
             elsif  p="01010" then
                         p4x<=p4x + 1;
             elsif  p="01011" then
                        p4x<=p4x + 1;
                        p4y<=p4y - 1;
             elsif  p="10000" then
                        p4x<=p4x - 2;
                        p4y<=p4y - 2;
             elsif  p="10001" then
                        p4x<=p4x + 2;
                        p4y<=p4y + 2;
             end if;
             pix<='1' & pcolor;
             make <= "1101";
          elsif make="1101" then
             cx<=p2x;
             cy<=p2y;
             make <= "1110";
          elsif make="1110" then
             cx<=p3x;
             cy<=p3y;
             make <= "1111";
          elsif make="1111" then
             cx<=p4x;
             cy<=p4y;
             make <= "0001";
          elsif make="0001" then
              we<='0';
             if p="00000" then   
                         p<="00001";
             elsif  p="00001" then
                        p<="00000";
             elsif  p="00100" then
                        p<="00101";
             elsif  p="00101" then
                         p<="00110";                                 
             elsif  p="00110" then
                        p<="00111";
             elsif  p="00111" then
                        p<="00100";
             elsif  p="01000" then
                        p<="01001";
             elsif  p="01001" then
                        p<="01010";
             elsif  p="01010" then
                         p<="01011";                                 
             elsif  p="01011" then
                        p<="01000";
             elsif  p="10000" then
                        p<="10001";
             elsif  p="10001" then
                        p<="10000";
             end if;
             state<="0111";
             
             
         end if;
      ------------------------------------------------------------------


      end if;
   end if;
 end if;
 end process;


        ng<=newgame;
        cl<=countline;
         wen   <= we;
        rectout <=pix;
        crx <=cx ;
        cry <=cy;     

end Behavioral;
