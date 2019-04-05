-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.0.0 Build 156 04/24/2013 SJ Web Edition"

-- DATE "03/30/2018 13:42:08"

-- 
-- Device: Altera EPM240T100C5 Package TQFP100
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY IEEE;
LIBRARY MAXII;
USE IEEE.STD_LOGIC_1164.ALL;
USE MAXII.MAXII_COMPONENTS.ALL;

ENTITY 	lighten IS
    PORT (
	display : OUT std_logic_vector(6 DOWNTO 0);
	display_4 : OUT std_logic_vector(3 DOWNTO 0);
	display_4_2 : OUT std_logic_vector(3 DOWNTO 0);
	clk : IN std_logic
	);
END lighten;

-- Design Ports Information
-- clk	=>  Location: PIN_14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- display[0]	=>  Location: PIN_15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display[1]	=>  Location: PIN_16,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display[2]	=>  Location: PIN_17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display[3]	=>  Location: PIN_18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display[4]	=>  Location: PIN_19,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display[5]	=>  Location: PIN_20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display[6]	=>  Location: PIN_21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display_4[0]	=>  Location: PIN_5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display_4[1]	=>  Location: PIN_6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display_4[2]	=>  Location: PIN_7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display_4[3]	=>  Location: PIN_8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display_4_2[0]	=>  Location: PIN_1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display_4_2[1]	=>  Location: PIN_2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display_4_2[2]	=>  Location: PIN_3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- display_4_2[3]	=>  Location: PIN_4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA


ARCHITECTURE structure OF lighten IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_display : std_logic_vector(6 DOWNTO 0);
SIGNAL ww_display_4 : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_display_4_2 : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_clk : std_logic;
SIGNAL \cnt[0]~63\ : std_logic;
SIGNAL \cnt[1]~61\ : std_logic;
SIGNAL \cnt[1]~61COUT1_90\ : std_logic;
SIGNAL \cnt[2]~59\ : std_logic;
SIGNAL \cnt[2]~59COUT1_92\ : std_logic;
SIGNAL \cnt[3]~57\ : std_logic;
SIGNAL \cnt[3]~57COUT1_94\ : std_logic;
SIGNAL \cnt[4]~55\ : std_logic;
SIGNAL \cnt[4]~55COUT1_96\ : std_logic;
SIGNAL \cnt[5]~53\ : std_logic;
SIGNAL \cnt[6]~11\ : std_logic;
SIGNAL \cnt[6]~11COUT1_98\ : std_logic;
SIGNAL \cnt[7]~13\ : std_logic;
SIGNAL \cnt[7]~13COUT1_100\ : std_logic;
SIGNAL \cnt[8]~15\ : std_logic;
SIGNAL \cnt[8]~15COUT1_102\ : std_logic;
SIGNAL \cnt[9]~17\ : std_logic;
SIGNAL \cnt[9]~17COUT1_104\ : std_logic;
SIGNAL \cnt[10]~3\ : std_logic;
SIGNAL \cnt[11]~5\ : std_logic;
SIGNAL \cnt[11]~5COUT1_106\ : std_logic;
SIGNAL \cnt[12]~7\ : std_logic;
SIGNAL \cnt[12]~7COUT1_108\ : std_logic;
SIGNAL \cnt[13]~9\ : std_logic;
SIGNAL \cnt[13]~9COUT1_110\ : std_logic;
SIGNAL \cnt[14]~21\ : std_logic;
SIGNAL \cnt[14]~21COUT1_112\ : std_logic;
SIGNAL \cnt[15]~19\ : std_logic;
SIGNAL \cnt[16]~23\ : std_logic;
SIGNAL \cnt[16]~23COUT1_114\ : std_logic;
SIGNAL \cnt[17]~25\ : std_logic;
SIGNAL \cnt[17]~25COUT1_116\ : std_logic;
SIGNAL \cnt[18]~27\ : std_logic;
SIGNAL \cnt[18]~27COUT1_118\ : std_logic;
SIGNAL \cnt[19]~29\ : std_logic;
SIGNAL \cnt[19]~29COUT1_120\ : std_logic;
SIGNAL \cnt[20]~31\ : std_logic;
SIGNAL \cnt[21]~33\ : std_logic;
SIGNAL \cnt[21]~33COUT1_122\ : std_logic;
SIGNAL \cnt[22]~35\ : std_logic;
SIGNAL \cnt[22]~35COUT1_124\ : std_logic;
SIGNAL \LessThan0~5_combout\ : std_logic;
SIGNAL \cnt[23]~37\ : std_logic;
SIGNAL \cnt[23]~37COUT1_126\ : std_logic;
SIGNAL \cnt[24]~39\ : std_logic;
SIGNAL \cnt[24]~39COUT1_128\ : std_logic;
SIGNAL \cnt[25]~41\ : std_logic;
SIGNAL \cnt[26]~43\ : std_logic;
SIGNAL \cnt[26]~43COUT1_130\ : std_logic;
SIGNAL \cnt[27]~45\ : std_logic;
SIGNAL \cnt[27]~45COUT1_132\ : std_logic;
SIGNAL \cnt[28]~47\ : std_logic;
SIGNAL \cnt[28]~47COUT1_134\ : std_logic;
SIGNAL \cnt[29]~49\ : std_logic;
SIGNAL \cnt[29]~49COUT1_136\ : std_logic;
SIGNAL \cnt[30]~51\ : std_logic;
SIGNAL \LessThan0~6_combout\ : std_logic;
SIGNAL \LessThan0~7_combout\ : std_logic;
SIGNAL \LessThan0~3_combout\ : std_logic;
SIGNAL \LessThan0~0_combout\ : std_logic;
SIGNAL \LessThan0~1_combout\ : std_logic;
SIGNAL \LessThan0~2_combout\ : std_logic;
SIGNAL \LessThan0~4_combout\ : std_logic;
SIGNAL \LessThan0~8_combout\ : std_logic;
SIGNAL \Mux6~0_combout\ : std_logic;
SIGNAL \Mux5~0_combout\ : std_logic;
SIGNAL \Mux4~0_combout\ : std_logic;
SIGNAL \Mux3~0_combout\ : std_logic;
SIGNAL \Mux2~0_combout\ : std_logic;
SIGNAL \Mux1~0_combout\ : std_logic;
SIGNAL \Mux0~0_combout\ : std_logic;
SIGNAL \clk~combout\ : std_logic;
SIGNAL \display_4[1]~reg0_regout\ : std_logic;
SIGNAL \display_4[2]~reg0_regout\ : std_logic;
SIGNAL \display_4[3]~reg0_regout\ : std_logic;
SIGNAL \display_4_2[1]~reg0_regout\ : std_logic;
SIGNAL \display_4_2[2]~reg0_regout\ : std_logic;
SIGNAL \display_4_2[3]~reg0_regout\ : std_logic;
SIGNAL display_4_buf_even : std_logic_vector(3 DOWNTO 0);
SIGNAL display_4_buf : std_logic_vector(3 DOWNTO 0);
SIGNAL cnt : std_logic_vector(31 DOWNTO 0);
SIGNAL \ALT_INV_Mux0~0_combout\ : std_logic;
SIGNAL \ALT_INV_Mux1~0_combout\ : std_logic;
SIGNAL \ALT_INV_Mux2~0_combout\ : std_logic;
SIGNAL \ALT_INV_Mux3~0_combout\ : std_logic;
SIGNAL \ALT_INV_Mux4~0_combout\ : std_logic;
SIGNAL \ALT_INV_Mux5~0_combout\ : std_logic;

BEGIN

display <= ww_display;
display_4 <= ww_display_4;
display_4_2 <= ww_display_4_2;
ww_clk <= clk;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_Mux0~0_combout\ <= NOT \Mux0~0_combout\;
\ALT_INV_Mux1~0_combout\ <= NOT \Mux1~0_combout\;
\ALT_INV_Mux2~0_combout\ <= NOT \Mux2~0_combout\;
\ALT_INV_Mux3~0_combout\ <= NOT \Mux3~0_combout\;
\ALT_INV_Mux4~0_combout\ <= NOT \Mux4~0_combout\;
\ALT_INV_Mux5~0_combout\ <= NOT \Mux5~0_combout\;

-- Location: LC_X3_Y2_N4
\cnt[0]\ : maxii_lcell
-- Equation(s):
-- cnt(0) = DFFEAS(((!cnt(0))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[0]~63\ = CARRY(((cnt(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "33cc",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(0),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(0),
	cout => \cnt[0]~63\);

-- Location: LC_X3_Y2_N5
\cnt[1]\ : maxii_lcell
-- Equation(s):
-- cnt(1) = DFFEAS(cnt(1) $ ((((\cnt[0]~63\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[1]~61\ = CARRY(((!\cnt[0]~63\)) # (!cnt(1)))
-- \cnt[1]~61COUT1_90\ = CARRY(((!\cnt[0]~63\)) # (!cnt(1)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(1),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[0]~63\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(1),
	cout0 => \cnt[1]~61\,
	cout1 => \cnt[1]~61COUT1_90\);

-- Location: LC_X3_Y2_N6
\cnt[2]\ : maxii_lcell
-- Equation(s):
-- cnt(2) = DFFEAS(cnt(2) $ ((((!(!\cnt[0]~63\ & \cnt[1]~61\) # (\cnt[0]~63\ & \cnt[1]~61COUT1_90\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[2]~59\ = CARRY((cnt(2) & ((!\cnt[1]~61\))))
-- \cnt[2]~59COUT1_92\ = CARRY((cnt(2) & ((!\cnt[1]~61COUT1_90\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(2),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[0]~63\,
	cin0 => \cnt[1]~61\,
	cin1 => \cnt[1]~61COUT1_90\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(2),
	cout0 => \cnt[2]~59\,
	cout1 => \cnt[2]~59COUT1_92\);

-- Location: LC_X3_Y2_N7
\cnt[3]\ : maxii_lcell
-- Equation(s):
-- cnt(3) = DFFEAS((cnt(3) $ (((!\cnt[0]~63\ & \cnt[2]~59\) # (\cnt[0]~63\ & \cnt[2]~59COUT1_92\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[3]~57\ = CARRY(((!\cnt[2]~59\) # (!cnt(3))))
-- \cnt[3]~57COUT1_94\ = CARRY(((!\cnt[2]~59COUT1_92\) # (!cnt(3))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(3),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[0]~63\,
	cin0 => \cnt[2]~59\,
	cin1 => \cnt[2]~59COUT1_92\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(3),
	cout0 => \cnt[3]~57\,
	cout1 => \cnt[3]~57COUT1_94\);

-- Location: LC_X3_Y2_N8
\cnt[4]\ : maxii_lcell
-- Equation(s):
-- cnt(4) = DFFEAS(cnt(4) $ ((((!(!\cnt[0]~63\ & \cnt[3]~57\) # (\cnt[0]~63\ & \cnt[3]~57COUT1_94\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[4]~55\ = CARRY((cnt(4) & ((!\cnt[3]~57\))))
-- \cnt[4]~55COUT1_96\ = CARRY((cnt(4) & ((!\cnt[3]~57COUT1_94\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(4),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[0]~63\,
	cin0 => \cnt[3]~57\,
	cin1 => \cnt[3]~57COUT1_94\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(4),
	cout0 => \cnt[4]~55\,
	cout1 => \cnt[4]~55COUT1_96\);

-- Location: LC_X3_Y2_N9
\cnt[5]\ : maxii_lcell
-- Equation(s):
-- cnt(5) = DFFEAS((cnt(5) $ (((!\cnt[0]~63\ & \cnt[4]~55\) # (\cnt[0]~63\ & \cnt[4]~55COUT1_96\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[5]~53\ = CARRY(((!\cnt[4]~55COUT1_96\) # (!cnt(5))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(5),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[0]~63\,
	cin0 => \cnt[4]~55\,
	cin1 => \cnt[4]~55COUT1_96\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(5),
	cout => \cnt[5]~53\);

-- Location: LC_X4_Y2_N0
\cnt[6]\ : maxii_lcell
-- Equation(s):
-- cnt(6) = DFFEAS((cnt(6) $ ((!\cnt[5]~53\))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[6]~11\ = CARRY(((cnt(6) & !\cnt[5]~53\)))
-- \cnt[6]~11COUT1_98\ = CARRY(((cnt(6) & !\cnt[5]~53\)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "c30c",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(6),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[5]~53\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(6),
	cout0 => \cnt[6]~11\,
	cout1 => \cnt[6]~11COUT1_98\);

-- Location: LC_X4_Y2_N1
\cnt[7]\ : maxii_lcell
-- Equation(s):
-- cnt(7) = DFFEAS((cnt(7) $ (((!\cnt[5]~53\ & \cnt[6]~11\) # (\cnt[5]~53\ & \cnt[6]~11COUT1_98\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[7]~13\ = CARRY(((!\cnt[6]~11\) # (!cnt(7))))
-- \cnt[7]~13COUT1_100\ = CARRY(((!\cnt[6]~11COUT1_98\) # (!cnt(7))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(7),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[5]~53\,
	cin0 => \cnt[6]~11\,
	cin1 => \cnt[6]~11COUT1_98\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(7),
	cout0 => \cnt[7]~13\,
	cout1 => \cnt[7]~13COUT1_100\);

-- Location: LC_X4_Y2_N2
\cnt[8]\ : maxii_lcell
-- Equation(s):
-- cnt(8) = DFFEAS((cnt(8) $ ((!(!\cnt[5]~53\ & \cnt[7]~13\) # (\cnt[5]~53\ & \cnt[7]~13COUT1_100\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[8]~15\ = CARRY(((cnt(8) & !\cnt[7]~13\)))
-- \cnt[8]~15COUT1_102\ = CARRY(((cnt(8) & !\cnt[7]~13COUT1_100\)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "c30c",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(8),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[5]~53\,
	cin0 => \cnt[7]~13\,
	cin1 => \cnt[7]~13COUT1_100\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(8),
	cout0 => \cnt[8]~15\,
	cout1 => \cnt[8]~15COUT1_102\);

-- Location: LC_X4_Y2_N3
\cnt[9]\ : maxii_lcell
-- Equation(s):
-- cnt(9) = DFFEAS(cnt(9) $ (((((!\cnt[5]~53\ & \cnt[8]~15\) # (\cnt[5]~53\ & \cnt[8]~15COUT1_102\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[9]~17\ = CARRY(((!\cnt[8]~15\)) # (!cnt(9)))
-- \cnt[9]~17COUT1_104\ = CARRY(((!\cnt[8]~15COUT1_102\)) # (!cnt(9)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(9),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[5]~53\,
	cin0 => \cnt[8]~15\,
	cin1 => \cnt[8]~15COUT1_102\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(9),
	cout0 => \cnt[9]~17\,
	cout1 => \cnt[9]~17COUT1_104\);

-- Location: LC_X4_Y2_N4
\cnt[10]\ : maxii_lcell
-- Equation(s):
-- cnt(10) = DFFEAS(cnt(10) $ ((((!(!\cnt[5]~53\ & \cnt[9]~17\) # (\cnt[5]~53\ & \cnt[9]~17COUT1_104\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[10]~3\ = CARRY((cnt(10) & ((!\cnt[9]~17COUT1_104\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(10),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[5]~53\,
	cin0 => \cnt[9]~17\,
	cin1 => \cnt[9]~17COUT1_104\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(10),
	cout => \cnt[10]~3\);

-- Location: LC_X4_Y2_N5
\cnt[11]\ : maxii_lcell
-- Equation(s):
-- cnt(11) = DFFEAS(cnt(11) $ ((((\cnt[10]~3\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[11]~5\ = CARRY(((!\cnt[10]~3\)) # (!cnt(11)))
-- \cnt[11]~5COUT1_106\ = CARRY(((!\cnt[10]~3\)) # (!cnt(11)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(11),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[10]~3\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(11),
	cout0 => \cnt[11]~5\,
	cout1 => \cnt[11]~5COUT1_106\);

-- Location: LC_X4_Y2_N6
\cnt[12]\ : maxii_lcell
-- Equation(s):
-- cnt(12) = DFFEAS(cnt(12) $ ((((!(!\cnt[10]~3\ & \cnt[11]~5\) # (\cnt[10]~3\ & \cnt[11]~5COUT1_106\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[12]~7\ = CARRY((cnt(12) & ((!\cnt[11]~5\))))
-- \cnt[12]~7COUT1_108\ = CARRY((cnt(12) & ((!\cnt[11]~5COUT1_106\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(12),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[10]~3\,
	cin0 => \cnt[11]~5\,
	cin1 => \cnt[11]~5COUT1_106\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(12),
	cout0 => \cnt[12]~7\,
	cout1 => \cnt[12]~7COUT1_108\);

-- Location: LC_X4_Y2_N7
\cnt[13]\ : maxii_lcell
-- Equation(s):
-- cnt(13) = DFFEAS((cnt(13) $ (((!\cnt[10]~3\ & \cnt[12]~7\) # (\cnt[10]~3\ & \cnt[12]~7COUT1_108\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[13]~9\ = CARRY(((!\cnt[12]~7\) # (!cnt(13))))
-- \cnt[13]~9COUT1_110\ = CARRY(((!\cnt[12]~7COUT1_108\) # (!cnt(13))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(13),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[10]~3\,
	cin0 => \cnt[12]~7\,
	cin1 => \cnt[12]~7COUT1_108\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(13),
	cout0 => \cnt[13]~9\,
	cout1 => \cnt[13]~9COUT1_110\);

-- Location: LC_X4_Y2_N8
\cnt[14]\ : maxii_lcell
-- Equation(s):
-- cnt(14) = DFFEAS(cnt(14) $ ((((!(!\cnt[10]~3\ & \cnt[13]~9\) # (\cnt[10]~3\ & \cnt[13]~9COUT1_110\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[14]~21\ = CARRY((cnt(14) & ((!\cnt[13]~9\))))
-- \cnt[14]~21COUT1_112\ = CARRY((cnt(14) & ((!\cnt[13]~9COUT1_110\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(14),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[10]~3\,
	cin0 => \cnt[13]~9\,
	cin1 => \cnt[13]~9COUT1_110\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(14),
	cout0 => \cnt[14]~21\,
	cout1 => \cnt[14]~21COUT1_112\);

-- Location: LC_X4_Y2_N9
\cnt[15]\ : maxii_lcell
-- Equation(s):
-- cnt(15) = DFFEAS((cnt(15) $ (((!\cnt[10]~3\ & \cnt[14]~21\) # (\cnt[10]~3\ & \cnt[14]~21COUT1_112\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[15]~19\ = CARRY(((!\cnt[14]~21COUT1_112\) # (!cnt(15))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(15),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[10]~3\,
	cin0 => \cnt[14]~21\,
	cin1 => \cnt[14]~21COUT1_112\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(15),
	cout => \cnt[15]~19\);

-- Location: LC_X5_Y2_N0
\cnt[16]\ : maxii_lcell
-- Equation(s):
-- cnt(16) = DFFEAS((cnt(16) $ ((!\cnt[15]~19\))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[16]~23\ = CARRY(((cnt(16) & !\cnt[15]~19\)))
-- \cnt[16]~23COUT1_114\ = CARRY(((cnt(16) & !\cnt[15]~19\)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "c30c",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(16),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[15]~19\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(16),
	cout0 => \cnt[16]~23\,
	cout1 => \cnt[16]~23COUT1_114\);

-- Location: LC_X5_Y2_N1
\cnt[17]\ : maxii_lcell
-- Equation(s):
-- cnt(17) = DFFEAS((cnt(17) $ (((!\cnt[15]~19\ & \cnt[16]~23\) # (\cnt[15]~19\ & \cnt[16]~23COUT1_114\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[17]~25\ = CARRY(((!\cnt[16]~23\) # (!cnt(17))))
-- \cnt[17]~25COUT1_116\ = CARRY(((!\cnt[16]~23COUT1_114\) # (!cnt(17))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(17),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[15]~19\,
	cin0 => \cnt[16]~23\,
	cin1 => \cnt[16]~23COUT1_114\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(17),
	cout0 => \cnt[17]~25\,
	cout1 => \cnt[17]~25COUT1_116\);

-- Location: LC_X5_Y2_N2
\cnt[18]\ : maxii_lcell
-- Equation(s):
-- cnt(18) = DFFEAS((cnt(18) $ ((!(!\cnt[15]~19\ & \cnt[17]~25\) # (\cnt[15]~19\ & \cnt[17]~25COUT1_116\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[18]~27\ = CARRY(((cnt(18) & !\cnt[17]~25\)))
-- \cnt[18]~27COUT1_118\ = CARRY(((cnt(18) & !\cnt[17]~25COUT1_116\)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "c30c",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(18),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[15]~19\,
	cin0 => \cnt[17]~25\,
	cin1 => \cnt[17]~25COUT1_116\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(18),
	cout0 => \cnt[18]~27\,
	cout1 => \cnt[18]~27COUT1_118\);

-- Location: LC_X5_Y2_N3
\cnt[19]\ : maxii_lcell
-- Equation(s):
-- cnt(19) = DFFEAS(cnt(19) $ (((((!\cnt[15]~19\ & \cnt[18]~27\) # (\cnt[15]~19\ & \cnt[18]~27COUT1_118\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[19]~29\ = CARRY(((!\cnt[18]~27\)) # (!cnt(19)))
-- \cnt[19]~29COUT1_120\ = CARRY(((!\cnt[18]~27COUT1_118\)) # (!cnt(19)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(19),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[15]~19\,
	cin0 => \cnt[18]~27\,
	cin1 => \cnt[18]~27COUT1_118\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(19),
	cout0 => \cnt[19]~29\,
	cout1 => \cnt[19]~29COUT1_120\);

-- Location: LC_X5_Y2_N4
\cnt[20]\ : maxii_lcell
-- Equation(s):
-- cnt(20) = DFFEAS(cnt(20) $ ((((!(!\cnt[15]~19\ & \cnt[19]~29\) # (\cnt[15]~19\ & \cnt[19]~29COUT1_120\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[20]~31\ = CARRY((cnt(20) & ((!\cnt[19]~29COUT1_120\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(20),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[15]~19\,
	cin0 => \cnt[19]~29\,
	cin1 => \cnt[19]~29COUT1_120\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(20),
	cout => \cnt[20]~31\);

-- Location: LC_X5_Y2_N5
\cnt[21]\ : maxii_lcell
-- Equation(s):
-- cnt(21) = DFFEAS(cnt(21) $ ((((\cnt[20]~31\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[21]~33\ = CARRY(((!\cnt[20]~31\)) # (!cnt(21)))
-- \cnt[21]~33COUT1_122\ = CARRY(((!\cnt[20]~31\)) # (!cnt(21)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(21),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[20]~31\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(21),
	cout0 => \cnt[21]~33\,
	cout1 => \cnt[21]~33COUT1_122\);

-- Location: LC_X5_Y2_N6
\cnt[22]\ : maxii_lcell
-- Equation(s):
-- cnt(22) = DFFEAS(cnt(22) $ ((((!(!\cnt[20]~31\ & \cnt[21]~33\) # (\cnt[20]~31\ & \cnt[21]~33COUT1_122\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[22]~35\ = CARRY((cnt(22) & ((!\cnt[21]~33\))))
-- \cnt[22]~35COUT1_124\ = CARRY((cnt(22) & ((!\cnt[21]~33COUT1_122\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(22),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[20]~31\,
	cin0 => \cnt[21]~33\,
	cin1 => \cnt[21]~33COUT1_122\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(22),
	cout0 => \cnt[22]~35\,
	cout1 => \cnt[22]~35COUT1_124\);

-- Location: LC_X5_Y2_N7
\cnt[23]\ : maxii_lcell
-- Equation(s):
-- cnt(23) = DFFEAS((cnt(23) $ (((!\cnt[20]~31\ & \cnt[22]~35\) # (\cnt[20]~31\ & \cnt[22]~35COUT1_124\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[23]~37\ = CARRY(((!\cnt[22]~35\) # (!cnt(23))))
-- \cnt[23]~37COUT1_126\ = CARRY(((!\cnt[22]~35COUT1_124\) # (!cnt(23))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(23),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[20]~31\,
	cin0 => \cnt[22]~35\,
	cin1 => \cnt[22]~35COUT1_124\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(23),
	cout0 => \cnt[23]~37\,
	cout1 => \cnt[23]~37COUT1_126\);

-- Location: LC_X2_Y2_N9
\LessThan0~5\ : maxii_lcell
-- Equation(s):
-- \LessThan0~5_combout\ = (!cnt(23) & (!cnt(20) & (!cnt(21) & !cnt(22))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => cnt(23),
	datab => cnt(20),
	datac => cnt(21),
	datad => cnt(22),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~5_combout\);

-- Location: LC_X5_Y2_N8
\cnt[24]\ : maxii_lcell
-- Equation(s):
-- cnt(24) = DFFEAS(cnt(24) $ ((((!(!\cnt[20]~31\ & \cnt[23]~37\) # (\cnt[20]~31\ & \cnt[23]~37COUT1_126\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[24]~39\ = CARRY((cnt(24) & ((!\cnt[23]~37\))))
-- \cnt[24]~39COUT1_128\ = CARRY((cnt(24) & ((!\cnt[23]~37COUT1_126\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(24),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[20]~31\,
	cin0 => \cnt[23]~37\,
	cin1 => \cnt[23]~37COUT1_126\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(24),
	cout0 => \cnt[24]~39\,
	cout1 => \cnt[24]~39COUT1_128\);

-- Location: LC_X5_Y2_N9
\cnt[25]\ : maxii_lcell
-- Equation(s):
-- cnt(25) = DFFEAS((cnt(25) $ (((!\cnt[20]~31\ & \cnt[24]~39\) # (\cnt[20]~31\ & \cnt[24]~39COUT1_128\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[25]~41\ = CARRY(((!\cnt[24]~39COUT1_128\) # (!cnt(25))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(25),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[20]~31\,
	cin0 => \cnt[24]~39\,
	cin1 => \cnt[24]~39COUT1_128\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(25),
	cout => \cnt[25]~41\);

-- Location: LC_X6_Y2_N0
\cnt[26]\ : maxii_lcell
-- Equation(s):
-- cnt(26) = DFFEAS((cnt(26) $ ((!\cnt[25]~41\))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[26]~43\ = CARRY(((cnt(26) & !\cnt[25]~41\)))
-- \cnt[26]~43COUT1_130\ = CARRY(((cnt(26) & !\cnt[25]~41\)))

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "c30c",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(26),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[25]~41\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(26),
	cout0 => \cnt[26]~43\,
	cout1 => \cnt[26]~43COUT1_130\);

-- Location: LC_X6_Y2_N1
\cnt[27]\ : maxii_lcell
-- Equation(s):
-- cnt(27) = DFFEAS((cnt(27) $ (((!\cnt[25]~41\ & \cnt[26]~43\) # (\cnt[25]~41\ & \cnt[26]~43COUT1_130\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[27]~45\ = CARRY(((!\cnt[26]~43\) # (!cnt(27))))
-- \cnt[27]~45COUT1_132\ = CARRY(((!\cnt[26]~43COUT1_130\) # (!cnt(27))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "3c3f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(27),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[25]~41\,
	cin0 => \cnt[26]~43\,
	cin1 => \cnt[26]~43COUT1_130\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(27),
	cout0 => \cnt[27]~45\,
	cout1 => \cnt[27]~45COUT1_132\);

-- Location: LC_X6_Y2_N2
\cnt[28]\ : maxii_lcell
-- Equation(s):
-- cnt(28) = DFFEAS((cnt(28) $ ((!(!\cnt[25]~41\ & \cnt[27]~45\) # (\cnt[25]~41\ & \cnt[27]~45COUT1_132\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[28]~47\ = CARRY(((cnt(28) & !\cnt[27]~45\)))
-- \cnt[28]~47COUT1_134\ = CARRY(((cnt(28) & !\cnt[27]~45COUT1_132\)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "c30c",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datab => cnt(28),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[25]~41\,
	cin0 => \cnt[27]~45\,
	cin1 => \cnt[27]~45COUT1_132\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(28),
	cout0 => \cnt[28]~47\,
	cout1 => \cnt[28]~47COUT1_134\);

-- Location: LC_X6_Y2_N3
\cnt[29]\ : maxii_lcell
-- Equation(s):
-- cnt(29) = DFFEAS(cnt(29) $ (((((!\cnt[25]~41\ & \cnt[28]~47\) # (\cnt[25]~41\ & \cnt[28]~47COUT1_134\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[29]~49\ = CARRY(((!\cnt[28]~47\)) # (!cnt(29)))
-- \cnt[29]~49COUT1_136\ = CARRY(((!\cnt[28]~47COUT1_134\)) # (!cnt(29)))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "5a5f",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(29),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[25]~41\,
	cin0 => \cnt[28]~47\,
	cin1 => \cnt[28]~47COUT1_134\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(29),
	cout0 => \cnt[29]~49\,
	cout1 => \cnt[29]~49COUT1_136\);

-- Location: LC_X6_Y2_N4
\cnt[30]\ : maxii_lcell
-- Equation(s):
-- cnt(30) = DFFEAS(cnt(30) $ ((((!(!\cnt[25]~41\ & \cnt[29]~49\) # (\cnt[25]~41\ & \cnt[29]~49COUT1_136\))))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )
-- \cnt[30]~51\ = CARRY((cnt(30) & ((!\cnt[29]~49COUT1_136\))))

-- pragma translate_off
GENERIC MAP (
	cin0_used => "true",
	cin1_used => "true",
	cin_used => "true",
	lut_mask => "a50a",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(30),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[25]~41\,
	cin0 => \cnt[29]~49\,
	cin1 => \cnt[29]~49COUT1_136\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(30),
	cout => \cnt[30]~51\);

-- Location: LC_X6_Y2_N5
\cnt[31]\ : maxii_lcell
-- Equation(s):
-- cnt(31) = DFFEAS(cnt(31) $ ((((\cnt[30]~51\)))), GLOBAL(\clk~combout\), VCC, , , , , \LessThan0~8_combout\, )

-- pragma translate_off
GENERIC MAP (
	cin_used => "true",
	lut_mask => "5a5a",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "cin",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => cnt(31),
	aclr => GND,
	sclr => \LessThan0~8_combout\,
	cin => \cnt[30]~51\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(31));

-- Location: LC_X6_Y2_N9
\LessThan0~6\ : maxii_lcell
-- Equation(s):
-- \LessThan0~6_combout\ = (!cnt(24) & (!cnt(27) & (!cnt(26) & !cnt(25))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => cnt(24),
	datab => cnt(27),
	datac => cnt(26),
	datad => cnt(25),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~6_combout\);

-- Location: LC_X3_Y2_N0
\LessThan0~7\ : maxii_lcell
-- Equation(s):
-- \LessThan0~7_combout\ = (!cnt(28) & (!cnt(29) & (!cnt(30) & \LessThan0~6_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => cnt(28),
	datab => cnt(29),
	datac => cnt(30),
	datad => \LessThan0~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~7_combout\);

-- Location: LC_X3_Y2_N1
\LessThan0~3\ : maxii_lcell
-- Equation(s):
-- \LessThan0~3_combout\ = (((!cnt(15) & !cnt(14))) # (!cnt(16))) # (!cnt(17))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1fff",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => cnt(15),
	datab => cnt(14),
	datac => cnt(17),
	datad => cnt(16),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~3_combout\);

-- Location: LC_X2_Y2_N6
\LessThan0~0\ : maxii_lcell
-- Equation(s):
-- \LessThan0~0_combout\ = (!cnt(13) & (!cnt(10) & (!cnt(12) & !cnt(11))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => cnt(13),
	datab => cnt(10),
	datac => cnt(12),
	datad => cnt(11),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~0_combout\);

-- Location: LC_X2_Y2_N4
\LessThan0~1\ : maxii_lcell
-- Equation(s):
-- \LessThan0~1_combout\ = ((!cnt(7) & (!cnt(8) & !cnt(6))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0003",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => cnt(7),
	datac => cnt(8),
	datad => cnt(6),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~1_combout\);

-- Location: LC_X2_Y2_N5
\LessThan0~2\ : maxii_lcell
-- Equation(s):
-- \LessThan0~2_combout\ = (!cnt(15) & (\LessThan0~0_combout\ & ((\LessThan0~1_combout\) # (!cnt(9)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5010",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => cnt(15),
	datab => cnt(9),
	datac => \LessThan0~0_combout\,
	datad => \LessThan0~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~2_combout\);

-- Location: LC_X3_Y2_N2
\LessThan0~4\ : maxii_lcell
-- Equation(s):
-- \LessThan0~4_combout\ = ((\LessThan0~3_combout\) # ((\LessThan0~2_combout\) # (!cnt(19)))) # (!cnt(18))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffdf",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => cnt(18),
	datab => \LessThan0~3_combout\,
	datac => cnt(19),
	datad => \LessThan0~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~4_combout\);

-- Location: LC_X3_Y2_N3
\LessThan0~8\ : maxii_lcell
-- Equation(s):
-- \LessThan0~8_combout\ = (!cnt(31) & (((!\LessThan0~4_combout\) # (!\LessThan0~7_combout\)) # (!\LessThan0~5_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1333",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~5_combout\,
	datab => cnt(31),
	datac => \LessThan0~7_combout\,
	datad => \LessThan0~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~8_combout\);

-- Location: LC_X2_Y2_N3
\display_4_buf[0]\ : maxii_lcell
-- Equation(s):
-- display_4_buf(0) = DFFEAS((((!display_4_buf(0)))), GLOBAL(\clk~combout\), VCC, , \LessThan0~8_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00ff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datad => display_4_buf(0),
	aclr => GND,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => display_4_buf(0));

-- Location: LC_X2_Y2_N1
\display_4_buf[2]\ : maxii_lcell
-- Equation(s):
-- display_4_buf(2) = DFFEAS(display_4_buf(2) $ (((display_4_buf(0) & (display_4_buf(1) & \LessThan0~8_combout\)))), GLOBAL(\clk~combout\), VCC, , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "7f80",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => display_4_buf(0),
	datab => display_4_buf(1),
	datac => \LessThan0~8_combout\,
	datad => display_4_buf(2),
	aclr => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => display_4_buf(2));

-- Location: LC_X2_Y2_N8
\display_4_buf[3]\ : maxii_lcell
-- Equation(s):
-- display_4_buf(3) = DFFEAS((display_4_buf(0) & ((display_4_buf(2) & (display_4_buf(1) $ (display_4_buf(3)))) # (!display_4_buf(2) & (display_4_buf(1) & display_4_buf(3))))) # (!display_4_buf(0) & (((display_4_buf(3))))), GLOBAL(\clk~combout\), VCC, , 
-- \LessThan0~8_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "7d80",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => display_4_buf(0),
	datab => display_4_buf(2),
	datac => display_4_buf(1),
	datad => display_4_buf(3),
	aclr => GND,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => display_4_buf(3));

-- Location: LC_X2_Y2_N0
\display_4_buf[1]\ : maxii_lcell
-- Equation(s):
-- display_4_buf(1) = DFFEAS((display_4_buf(0) & (!display_4_buf(1) & ((display_4_buf(2)) # (!display_4_buf(3))))) # (!display_4_buf(0) & (((display_4_buf(1))))), GLOBAL(\clk~combout\), VCC, , \LessThan0~8_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "585a",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => display_4_buf(0),
	datab => display_4_buf(2),
	datac => display_4_buf(1),
	datad => display_4_buf(3),
	aclr => GND,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => display_4_buf(1));

-- Location: LC_X2_Y1_N8
\Mux6~0\ : maxii_lcell
-- Equation(s):
-- \Mux6~0_combout\ = (display_4_buf(0) & ((display_4_buf(3)) # (display_4_buf(1) $ (display_4_buf(2))))) # (!display_4_buf(0) & ((display_4_buf(1)) # (display_4_buf(2) $ (display_4_buf(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f6be",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => display_4_buf(1),
	datab => display_4_buf(2),
	datac => display_4_buf(3),
	datad => display_4_buf(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Mux6~0_combout\);

-- Location: LC_X2_Y1_N5
\Mux5~0\ : maxii_lcell
-- Equation(s):
-- \Mux5~0_combout\ = (display_4_buf(1) & (!display_4_buf(3) & ((display_4_buf(0)) # (!display_4_buf(2))))) # (!display_4_buf(1) & (display_4_buf(0) & (display_4_buf(2) $ (!display_4_buf(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4b02",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => display_4_buf(1),
	datab => display_4_buf(2),
	datac => display_4_buf(3),
	datad => display_4_buf(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Mux5~0_combout\);

-- Location: LC_X2_Y1_N7
\Mux4~0\ : maxii_lcell
-- Equation(s):
-- \Mux4~0_combout\ = (display_4_buf(1) & (((!display_4_buf(3) & display_4_buf(0))))) # (!display_4_buf(1) & ((display_4_buf(2) & (!display_4_buf(3))) # (!display_4_buf(2) & ((display_4_buf(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1f04",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => display_4_buf(1),
	datab => display_4_buf(2),
	datac => display_4_buf(3),
	datad => display_4_buf(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Mux4~0_combout\);

-- Location: LC_X2_Y1_N2
\Mux3~0\ : maxii_lcell
-- Equation(s):
-- \Mux3~0_combout\ = (display_4_buf(0) & (display_4_buf(1) $ ((!display_4_buf(2))))) # (!display_4_buf(0) & ((display_4_buf(1) & (!display_4_buf(2) & display_4_buf(3))) # (!display_4_buf(1) & (display_4_buf(2) & !display_4_buf(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "9924",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => display_4_buf(1),
	datab => display_4_buf(2),
	datac => display_4_buf(3),
	datad => display_4_buf(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Mux3~0_combout\);

-- Location: LC_X2_Y1_N3
\Mux2~0\ : maxii_lcell
-- Equation(s):
-- \Mux2~0_combout\ = (display_4_buf(2) & (display_4_buf(3) & ((display_4_buf(1)) # (!display_4_buf(0))))) # (!display_4_buf(2) & (display_4_buf(1) & (!display_4_buf(3) & !display_4_buf(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "80c2",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => display_4_buf(1),
	datab => display_4_buf(2),
	datac => display_4_buf(3),
	datad => display_4_buf(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Mux2~0_combout\);

-- Location: LC_X2_Y1_N4
\Mux1~0\ : maxii_lcell
-- Equation(s):
-- \Mux1~0_combout\ = (display_4_buf(1) & ((display_4_buf(0) & ((display_4_buf(3)))) # (!display_4_buf(0) & (display_4_buf(2))))) # (!display_4_buf(1) & (display_4_buf(2) & (display_4_buf(3) $ (display_4_buf(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "a4c8",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => display_4_buf(1),
	datab => display_4_buf(2),
	datac => display_4_buf(3),
	datad => display_4_buf(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Mux1~0_combout\);

-- Location: LC_X2_Y1_N9
\Mux0~0\ : maxii_lcell
-- Equation(s):
-- \Mux0~0_combout\ = (display_4_buf(2) & ((display_4_buf(3) & (!display_4_buf(1) & display_4_buf(0))) # (!display_4_buf(3) & ((!display_4_buf(0)))))) # (!display_4_buf(2) & (display_4_buf(0) & (display_4_buf(1) $ (!display_4_buf(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "610c",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => display_4_buf(1),
	datab => display_4_buf(2),
	datac => display_4_buf(3),
	datad => display_4_buf(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Mux0~0_combout\);

-- Location: PIN_14,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
\clk~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_clk,
	combout => \clk~combout\);

-- Location: LC_X2_Y3_N6
\display_4_buf_even[2]\ : maxii_lcell
-- Equation(s):
-- display_4_buf_even(2) = DFFEAS((display_4_buf_even(2) $ (((display_4_buf_even(1) & \LessThan0~8_combout\)))), GLOBAL(\clk~combout\), VCC, , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5af0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => display_4_buf_even(1),
	datac => display_4_buf_even(2),
	datad => \LessThan0~8_combout\,
	aclr => GND,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => display_4_buf_even(2));

-- Location: LC_X2_Y3_N8
\display_4_buf_even[3]\ : maxii_lcell
-- Equation(s):
-- display_4_buf_even(3) = DFFEAS((display_4_buf_even(1) & ((display_4_buf_even(2) $ (display_4_buf_even(3))))) # (!display_4_buf_even(1) & (((display_4_buf_even(2) & display_4_buf_even(3))))), GLOBAL(\clk~combout\), VCC, , \LessThan0~8_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5aa0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => display_4_buf_even(1),
	datac => display_4_buf_even(2),
	datad => display_4_buf_even(3),
	aclr => GND,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => display_4_buf_even(3));

-- Location: LC_X2_Y3_N5
\display_4_buf_even[1]\ : maxii_lcell
-- Equation(s):
-- display_4_buf_even(1) = DFFEAS((!display_4_buf_even(1) & (((display_4_buf_even(2)) # (!display_4_buf_even(3))))), GLOBAL(\clk~combout\), VCC, , \LessThan0~8_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5055",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => display_4_buf_even(1),
	datac => display_4_buf_even(2),
	datad => display_4_buf_even(3),
	aclr => GND,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => display_4_buf_even(1));

-- Location: LC_X2_Y3_N2
\display_4[1]~reg0\ : maxii_lcell
-- Equation(s):
-- \display_4[1]~reg0_regout\ = DFFEAS(GND, GLOBAL(\clk~combout\), VCC, , \LessThan0~8_combout\, display_4_buf_even(1), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datac => display_4_buf_even(1),
	aclr => GND,
	sload => VCC,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \display_4[1]~reg0_regout\);

-- Location: LC_X2_Y3_N3
\display_4[2]~reg0\ : maxii_lcell
-- Equation(s):
-- \display_4[2]~reg0_regout\ = DFFEAS(GND, GLOBAL(\clk~combout\), VCC, , \LessThan0~8_combout\, display_4_buf_even(2), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datac => display_4_buf_even(2),
	aclr => GND,
	sload => VCC,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \display_4[2]~reg0_regout\);

-- Location: LC_X2_Y3_N4
\display_4[3]~reg0\ : maxii_lcell
-- Equation(s):
-- \display_4[3]~reg0_regout\ = DFFEAS((((display_4_buf_even(3)))), GLOBAL(\clk~combout\), VCC, , \LessThan0~8_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff00",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datad => display_4_buf_even(3),
	aclr => GND,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \display_4[3]~reg0_regout\);

-- Location: LC_X2_Y2_N2
\display_4_2[1]~reg0\ : maxii_lcell
-- Equation(s):
-- \display_4_2[1]~reg0_regout\ = DFFEAS(GND, GLOBAL(\clk~combout\), VCC, , \LessThan0~8_combout\, display_4_buf_even(1), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datac => display_4_buf_even(1),
	aclr => GND,
	sload => VCC,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \display_4_2[1]~reg0_regout\);

-- Location: LC_X2_Y3_N7
\display_4_2[2]~reg0\ : maxii_lcell
-- Equation(s):
-- \display_4_2[2]~reg0_regout\ = DFFEAS(GND, GLOBAL(\clk~combout\), VCC, , \LessThan0~8_combout\, display_4_buf_even(2), , , VCC)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datac => display_4_buf_even(2),
	aclr => GND,
	sload => VCC,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \display_4_2[2]~reg0_regout\);

-- Location: LC_X2_Y2_N7
\display_4_2[3]~reg0\ : maxii_lcell
-- Equation(s):
-- \display_4_2[3]~reg0_regout\ = DFFEAS((((display_4_buf_even(3)))), GLOBAL(\clk~combout\), VCC, , \LessThan0~8_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff00",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datad => display_4_buf_even(3),
	aclr => GND,
	ena => \LessThan0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \display_4_2[3]~reg0_regout\);

-- Location: PIN_15,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \Mux6~0_combout\,
	oe => VCC,
	padio => ww_display(0));

-- Location: PIN_16,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_Mux5~0_combout\,
	oe => VCC,
	padio => ww_display(1));

-- Location: PIN_17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_Mux4~0_combout\,
	oe => VCC,
	padio => ww_display(2));

-- Location: PIN_18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_Mux3~0_combout\,
	oe => VCC,
	padio => ww_display(3));

-- Location: PIN_19,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display[4]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_Mux2~0_combout\,
	oe => VCC,
	padio => ww_display(4));

-- Location: PIN_20,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display[5]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_Mux1~0_combout\,
	oe => VCC,
	padio => ww_display(5));

-- Location: PIN_21,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display[6]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \ALT_INV_Mux0~0_combout\,
	oe => VCC,
	padio => ww_display(6));

-- Location: PIN_5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display_4[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => GND,
	oe => VCC,
	padio => ww_display_4(0));

-- Location: PIN_6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display_4[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \display_4[1]~reg0_regout\,
	oe => VCC,
	padio => ww_display_4(1));

-- Location: PIN_7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display_4[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \display_4[2]~reg0_regout\,
	oe => VCC,
	padio => ww_display_4(2));

-- Location: PIN_8,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display_4[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \display_4[3]~reg0_regout\,
	oe => VCC,
	padio => ww_display_4(3));

-- Location: PIN_1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display_4_2[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => VCC,
	oe => VCC,
	padio => ww_display_4_2(0));

-- Location: PIN_2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display_4_2[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \display_4_2[1]~reg0_regout\,
	oe => VCC,
	padio => ww_display_4_2(1));

-- Location: PIN_3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display_4_2[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \display_4_2[2]~reg0_regout\,
	oe => VCC,
	padio => ww_display_4_2(2));

-- Location: PIN_4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
\display_4_2[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \display_4_2[3]~reg0_regout\,
	oe => VCC,
	padio => ww_display_4_2(3));
END structure;


