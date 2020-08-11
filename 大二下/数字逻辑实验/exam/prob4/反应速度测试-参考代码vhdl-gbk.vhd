
library IEEE, BASIC;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY problem4_reaction IS
    PORT (
        clk1M                   : IN std_logic;   -- 1MHz ʱ��
        clkBtn                  : IN std_logic;   -- CLK ��ť
        rstBtn                  : IN std_logic;   -- RST ��ť
        led1                    : OUT std_logic;   -- ����LED1
        led2                    : OUT std_logic;   -- ����LED2
        led3                    : OUT std_logic);   -- ����LED3
END problem4_reaction;

ARCHITECTURE problem4_reaction OF problem4_reaction IS


    SIGNAL btnSync                  :  std_logic;   
    SIGNAL btnLast                  :  std_logic;   
    SIGNAL counter                  :  std_logic_vector(21 DOWNTO 0);   
    SIGNAL led1_xhdl1               :  std_logic;   
    SIGNAL led2_xhdl2               :  std_logic;   
    SIGNAL led3_xhdl3               :  std_logic;   

BEGIN
    led1 <= led1_xhdl1;
    led2 <= led2_xhdl2;
    led3 <= led3_xhdl3;

    PROCESS
    BEGIN
        WAIT UNTIL (clk1M'EVENT AND clk1M = '1');
        IF (rstBtn = '1') THEN
            counter <= "0000000000000000000000";    
            led1_xhdl1 <= '0';    
        ELSE
            IF (NOT counter /= "0000000000000000000000") THEN
                counter <= counter + "0000000000000000000001";    
            END IF;
            IF (NOT led1_xhdl1 = '1') THEN
            -- �ж�counter��ʱ��2s��4s��ĳ��ֵʱ������led1�������¿�ʼ��ʱ
            -- === YOUR CODE HERE ===
            END IF;
        END IF;
    END PROCESS;

    PROCESS
    BEGIN
        WAIT UNTIL (clk1M'EVENT AND clk1M = '1');
        btnLast <= btnSync;    
        btnSync <= clkBtn;    
        IF (rstBtn = '1') THEN
            led2_xhdl2 <= '0';    
            led3_xhdl3 <= '0';    
        ELSE
            IF ((btnSync AND NOT btnLast) = '1') THEN
            -- ��⵽CLK��ť����˲�䣬������ĿҪ��Ƚ�counter��ֵ��������led2��led3
            -- === YOUR CODE HERE ===
            END IF;
        END IF;
    END PROCESS;


END problem4_reaction;
