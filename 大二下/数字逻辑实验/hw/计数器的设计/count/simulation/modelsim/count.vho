-- Copyright (C) 1991-2009 Altera Corporation
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
-- PROGRAM "Quartus II"
-- VERSION "Version 9.0 Build 132 02/25/2009 SJ Full Version"

-- DATE "05/11/2018 14:16:23"

-- 
-- Device: Altera EPM240T100C5 Package TQFP100
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY IEEE, maxii;
USE IEEE.std_logic_1164.all;
USE maxii.maxii_components.all;

ENTITY 	count IS
    PORT (
	clk : IN std_logic;
	rst : IN std_logic;
	mode : IN std_logic;
	pause : IN std_logic;
	n0 : OUT std_logic_vector(3 DOWNTO 0);
	n1 : OUT std_logic_vector(3 DOWNTO 0);
	ll : OUT std_logic_vector(6 DOWNTO 0);
	hh : OUT std_logic_vector(6 DOWNTO 0)
	);
END count;

ARCHITECTURE structure OF count IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_rst : std_logic;
SIGNAL ww_mode : std_logic;
SIGNAL ww_pause : std_logic;
SIGNAL ww_n0 : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_n1 : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_ll : std_logic_vector(6 DOWNTO 0);
SIGNAL ww_hh : std_logic_vector(6 DOWNTO 0);
SIGNAL \clk~combout\ : std_logic;
SIGNAL \rst~combout\ : std_logic;
SIGNAL \pause~combout\ : std_logic;
SIGNAL \mode~combout\ : std_logic;
SIGNAL \tmp0|cnt[0]~128_combout\ : std_logic;
SIGNAL \tmp0|cnt[0]~89\ : std_logic;
SIGNAL \tmp0|cnt[1]~99\ : std_logic;
SIGNAL \tmp0|cnt[1]~99COUT1_155\ : std_logic;
SIGNAL \tmp0|cnt[2]~101\ : std_logic;
SIGNAL \tmp0|cnt[2]~101COUT1_157\ : std_logic;
SIGNAL \tmp0|cnt[3]~103\ : std_logic;
SIGNAL \tmp0|cnt[3]~103COUT1_159\ : std_logic;
SIGNAL \tmp0|cnt[4]~105\ : std_logic;
SIGNAL \tmp0|cnt[4]~105COUT1_161\ : std_logic;
SIGNAL \tmp0|cnt[5]~107\ : std_logic;
SIGNAL \tmp0|cnt[6]~109\ : std_logic;
SIGNAL \tmp0|cnt[6]~109COUT1_163\ : std_logic;
SIGNAL \tmp0|cnt[7]~111\ : std_logic;
SIGNAL \tmp0|cnt[7]~111COUT1_165\ : std_logic;
SIGNAL \tmp0|cnt[8]~83\ : std_logic;
SIGNAL \tmp0|cnt[8]~83COUT1_167\ : std_logic;
SIGNAL \tmp0|cnt[9]~85\ : std_logic;
SIGNAL \tmp0|cnt[9]~85COUT1_169\ : std_logic;
SIGNAL \tmp0|cnt[10]~87\ : std_logic;
SIGNAL \tmp0|cnt[11]~113\ : std_logic;
SIGNAL \tmp0|cnt[11]~113COUT1_171\ : std_logic;
SIGNAL \tmp0|cnt[12]~91\ : std_logic;
SIGNAL \tmp0|cnt[12]~91COUT1_173\ : std_logic;
SIGNAL \tmp0|cnt[13]~93\ : std_logic;
SIGNAL \tmp0|cnt[13]~93COUT1_175\ : std_logic;
SIGNAL \tmp0|cnt[14]~95\ : std_logic;
SIGNAL \tmp0|cnt[14]~95COUT1_177\ : std_logic;
SIGNAL \tmp0|cnt[15]~97\ : std_logic;
SIGNAL \tmp0|cnt[16]~117\ : std_logic;
SIGNAL \tmp0|cnt[16]~117COUT1_179\ : std_logic;
SIGNAL \tmp0|cnt[17]~115\ : std_logic;
SIGNAL \tmp0|cnt[17]~115COUT1_181\ : std_logic;
SIGNAL \tmp0|cnt[18]~119\ : std_logic;
SIGNAL \tmp0|cnt[18]~119COUT1_183\ : std_logic;
SIGNAL \tmp0|cnt[19]~121\ : std_logic;
SIGNAL \tmp0|cnt[19]~121COUT1_185\ : std_logic;
SIGNAL \tmp0|cnt[20]~123\ : std_logic;
SIGNAL \tmp0|cnt[21]~125\ : std_logic;
SIGNAL \tmp0|cnt[21]~125COUT1_187\ : std_logic;
SIGNAL \tmp0|cnt[22]~65\ : std_logic;
SIGNAL \tmp0|cnt[22]~65COUT1_189\ : std_logic;
SIGNAL \tmp0|cnt[23]~67\ : std_logic;
SIGNAL \tmp0|cnt[23]~67COUT1_191\ : std_logic;
SIGNAL \tmp0|cnt[24]~69\ : std_logic;
SIGNAL \tmp0|cnt[24]~69COUT1_193\ : std_logic;
SIGNAL \tmp0|cnt[25]~71\ : std_logic;
SIGNAL \tmp0|cnt[26]~73\ : std_logic;
SIGNAL \tmp0|cnt[26]~73COUT1_195\ : std_logic;
SIGNAL \tmp0|cnt[27]~75\ : std_logic;
SIGNAL \tmp0|cnt[27]~75COUT1_197\ : std_logic;
SIGNAL \tmp0|cnt[28]~77\ : std_logic;
SIGNAL \tmp0|cnt[28]~77COUT1_199\ : std_logic;
SIGNAL \tmp0|cnt[29]~79\ : std_logic;
SIGNAL \tmp0|cnt[29]~79COUT1_201\ : std_logic;
SIGNAL \tmp0|cnt[30]~81\ : std_logic;
SIGNAL \tmp0|LessThan0~1_combout\ : std_logic;
SIGNAL \tmp0|Equal0~5_combout\ : std_logic;
SIGNAL \tmp0|Equal0~3_combout\ : std_logic;
SIGNAL \tmp0|LessThan0~0_combout\ : std_logic;
SIGNAL \tmp0|LessThan0~2_combout\ : std_logic;
SIGNAL \tmp0|Equal0~1_combout\ : std_logic;
SIGNAL \tmp0|Equal0~0_combout\ : std_logic;
SIGNAL \tmp0|Equal0~2_combout\ : std_logic;
SIGNAL \tmp0|LessThan0~3_combout\ : std_logic;
SIGNAL \tmp0|Equal0~9_combout\ : std_logic;
SIGNAL \tmp0|Equal0~6_combout\ : std_logic;
SIGNAL \tmp0|Equal0~7_combout\ : std_logic;
SIGNAL \tmp0|Equal0~8_combout\ : std_logic;
SIGNAL \tmp0|Equal0~10_combout\ : std_logic;
SIGNAL \tmp0|Equal0~4_combout\ : std_logic;
SIGNAL \tmp0|n0[0]~8_combout\ : std_logic;
SIGNAL \tmp0|Equal1~0_combout\ : std_logic;
SIGNAL \tmp0|n1[0]~12_combout\ : std_logic;
SIGNAL \tmp0|n1[3]~15_combout\ : std_logic;
SIGNAL \tmp1|Mux6~0_combout\ : std_logic;
SIGNAL \tmp1|Mux5~0_combout\ : std_logic;
SIGNAL \tmp1|Mux4~0_combout\ : std_logic;
SIGNAL \tmp1|Mux3~0_combout\ : std_logic;
SIGNAL \tmp1|Mux2~0_combout\ : std_logic;
SIGNAL \tmp1|Mux1~0_combout\ : std_logic;
SIGNAL \tmp1|Mux0~0_combout\ : std_logic;
SIGNAL \tmp2|Mux6~0_combout\ : std_logic;
SIGNAL \tmp2|Mux5~0_combout\ : std_logic;
SIGNAL \tmp2|Mux4~0_combout\ : std_logic;
SIGNAL \tmp2|Mux3~0_combout\ : std_logic;
SIGNAL \tmp2|Mux2~0_combout\ : std_logic;
SIGNAL \tmp2|Mux1~0_combout\ : std_logic;
SIGNAL \tmp2|Mux0~0_combout\ : std_logic;
SIGNAL \tmp0|cnt\ : std_logic_vector(31 DOWNTO 0);
SIGNAL \tmp0|n0\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \tmp0|n1\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \tmp1|ALT_INV_Mux5~0_combout\ : std_logic;
SIGNAL \tmp1|ALT_INV_Mux4~0_combout\ : std_logic;
SIGNAL \tmp1|ALT_INV_Mux3~0_combout\ : std_logic;
SIGNAL \tmp1|ALT_INV_Mux2~0_combout\ : std_logic;
SIGNAL \tmp1|ALT_INV_Mux1~0_combout\ : std_logic;
SIGNAL \tmp1|ALT_INV_Mux0~0_combout\ : std_logic;
SIGNAL \tmp2|ALT_INV_Mux5~0_combout\ : std_logic;
SIGNAL \tmp2|ALT_INV_Mux4~0_combout\ : std_logic;
SIGNAL \tmp2|ALT_INV_Mux3~0_combout\ : std_logic;
SIGNAL \tmp2|ALT_INV_Mux2~0_combout\ : std_logic;
SIGNAL \tmp2|ALT_INV_Mux1~0_combout\ : std_logic;
SIGNAL \tmp2|ALT_INV_Mux0~0_combout\ : std_logic;
SIGNAL \ALT_INV_rst~combout\ : std_logic;

BEGIN

ww_clk <= clk;
ww_rst <= rst;
ww_mode <= mode;
ww_pause <= pause;
n0 <= ww_n0;
n1 <= ww_n1;
ll <= ww_ll;
hh <= ww_hh;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\tmp1|ALT_INV_Mux5~0_combout\ <= NOT \tmp1|Mux5~0_combout\;
\tmp1|ALT_INV_Mux4~0_combout\ <= NOT \tmp1|Mux4~0_combout\;
\tmp1|ALT_INV_Mux3~0_combout\ <= NOT \tmp1|Mux3~0_combout\;
\tmp1|ALT_INV_Mux2~0_combout\ <= NOT \tmp1|Mux2~0_combout\;
\tmp1|ALT_INV_Mux1~0_combout\ <= NOT \tmp1|Mux1~0_combout\;
\tmp1|ALT_INV_Mux0~0_combout\ <= NOT \tmp1|Mux0~0_combout\;
\tmp2|ALT_INV_Mux5~0_combout\ <= NOT \tmp2|Mux5~0_combout\;
\tmp2|ALT_INV_Mux4~0_combout\ <= NOT \tmp2|Mux4~0_combout\;
\tmp2|ALT_INV_Mux3~0_combout\ <= NOT \tmp2|Mux3~0_combout\;
\tmp2|ALT_INV_Mux2~0_combout\ <= NOT \tmp2|Mux2~0_combout\;
\tmp2|ALT_INV_Mux1~0_combout\ <= NOT \tmp2|Mux1~0_combout\;
\tmp2|ALT_INV_Mux0~0_combout\ <= NOT \tmp2|Mux0~0_combout\;
\ALT_INV_rst~combout\ <= NOT \rst~combout\;

\clk~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_clk,
	combout => \clk~combout\);

\rst~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_rst,
	combout => \rst~combout\);

\pause~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_pause,
	combout => \pause~combout\);

\mode~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_mode,
	combout => \mode~combout\);

\tmp0|cnt[0]~128\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt[0]~128_combout\ = \mode~combout\ & (!\pause~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00aa",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \mode~combout\,
	datad => \pause~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|cnt[0]~128_combout\);

\tmp0|cnt[0]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(0) = DFFEAS(!\tmp0|cnt\(0), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[0]~89\ = CARRY(\tmp0|cnt\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "55aa",
	operation_mode => "arithmetic",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => \tmp0|cnt\(0),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(0),
	cout => \tmp0|cnt[0]~89\);

\tmp0|cnt[1]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(1) = DFFEAS(\tmp0|cnt\(1) $ (\tmp0|cnt[0]~89\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[1]~99\ = CARRY(!\tmp0|cnt[0]~89\ # !\tmp0|cnt\(1))
-- \tmp0|cnt[1]~99COUT1_155\ = CARRY(!\tmp0|cnt[0]~89\ # !\tmp0|cnt\(1))

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
	dataa => \tmp0|cnt\(1),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[0]~89\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(1),
	cout0 => \tmp0|cnt[1]~99\,
	cout1 => \tmp0|cnt[1]~99COUT1_155\);

\tmp0|cnt[2]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(2) = DFFEAS(\tmp0|cnt\(2) $ (!(!\tmp0|cnt[0]~89\ & \tmp0|cnt[1]~99\) # (\tmp0|cnt[0]~89\ & \tmp0|cnt[1]~99COUT1_155\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[2]~101\ = CARRY(\tmp0|cnt\(2) & (!\tmp0|cnt[1]~99\))
-- \tmp0|cnt[2]~101COUT1_157\ = CARRY(\tmp0|cnt\(2) & (!\tmp0|cnt[1]~99COUT1_155\))

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
	dataa => \tmp0|cnt\(2),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[0]~89\,
	cin0 => \tmp0|cnt[1]~99\,
	cin1 => \tmp0|cnt[1]~99COUT1_155\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(2),
	cout0 => \tmp0|cnt[2]~101\,
	cout1 => \tmp0|cnt[2]~101COUT1_157\);

\tmp0|cnt[3]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(3) = DFFEAS(\tmp0|cnt\(3) $ (!\tmp0|cnt[0]~89\ & \tmp0|cnt[2]~101\) # (\tmp0|cnt[0]~89\ & \tmp0|cnt[2]~101COUT1_157\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[3]~103\ = CARRY(!\tmp0|cnt[2]~101\ # !\tmp0|cnt\(3))
-- \tmp0|cnt[3]~103COUT1_159\ = CARRY(!\tmp0|cnt[2]~101COUT1_157\ # !\tmp0|cnt\(3))

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
	datab => \tmp0|cnt\(3),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[0]~89\,
	cin0 => \tmp0|cnt[2]~101\,
	cin1 => \tmp0|cnt[2]~101COUT1_157\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(3),
	cout0 => \tmp0|cnt[3]~103\,
	cout1 => \tmp0|cnt[3]~103COUT1_159\);

\tmp0|cnt[4]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(4) = DFFEAS(\tmp0|cnt\(4) $ (!(!\tmp0|cnt[0]~89\ & \tmp0|cnt[3]~103\) # (\tmp0|cnt[0]~89\ & \tmp0|cnt[3]~103COUT1_159\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[4]~105\ = CARRY(\tmp0|cnt\(4) & (!\tmp0|cnt[3]~103\))
-- \tmp0|cnt[4]~105COUT1_161\ = CARRY(\tmp0|cnt\(4) & (!\tmp0|cnt[3]~103COUT1_159\))

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
	dataa => \tmp0|cnt\(4),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[0]~89\,
	cin0 => \tmp0|cnt[3]~103\,
	cin1 => \tmp0|cnt[3]~103COUT1_159\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(4),
	cout0 => \tmp0|cnt[4]~105\,
	cout1 => \tmp0|cnt[4]~105COUT1_161\);

\tmp0|cnt[5]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(5) = DFFEAS(\tmp0|cnt\(5) $ (!\tmp0|cnt[0]~89\ & \tmp0|cnt[4]~105\) # (\tmp0|cnt[0]~89\ & \tmp0|cnt[4]~105COUT1_161\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[5]~107\ = CARRY(!\tmp0|cnt[4]~105COUT1_161\ # !\tmp0|cnt\(5))

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
	datab => \tmp0|cnt\(5),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[0]~89\,
	cin0 => \tmp0|cnt[4]~105\,
	cin1 => \tmp0|cnt[4]~105COUT1_161\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(5),
	cout => \tmp0|cnt[5]~107\);

\tmp0|cnt[6]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(6) = DFFEAS(\tmp0|cnt\(6) $ !\tmp0|cnt[5]~107\, GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[6]~109\ = CARRY(\tmp0|cnt\(6) & !\tmp0|cnt[5]~107\)
-- \tmp0|cnt[6]~109COUT1_163\ = CARRY(\tmp0|cnt\(6) & !\tmp0|cnt[5]~107\)

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
	datab => \tmp0|cnt\(6),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[5]~107\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(6),
	cout0 => \tmp0|cnt[6]~109\,
	cout1 => \tmp0|cnt[6]~109COUT1_163\);

\tmp0|cnt[7]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(7) = DFFEAS(\tmp0|cnt\(7) $ (!\tmp0|cnt[5]~107\ & \tmp0|cnt[6]~109\) # (\tmp0|cnt[5]~107\ & \tmp0|cnt[6]~109COUT1_163\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[7]~111\ = CARRY(!\tmp0|cnt[6]~109\ # !\tmp0|cnt\(7))
-- \tmp0|cnt[7]~111COUT1_165\ = CARRY(!\tmp0|cnt[6]~109COUT1_163\ # !\tmp0|cnt\(7))

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
	datab => \tmp0|cnt\(7),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[5]~107\,
	cin0 => \tmp0|cnt[6]~109\,
	cin1 => \tmp0|cnt[6]~109COUT1_163\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(7),
	cout0 => \tmp0|cnt[7]~111\,
	cout1 => \tmp0|cnt[7]~111COUT1_165\);

\tmp0|cnt[8]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(8) = DFFEAS(\tmp0|cnt\(8) $ !(!\tmp0|cnt[5]~107\ & \tmp0|cnt[7]~111\) # (\tmp0|cnt[5]~107\ & \tmp0|cnt[7]~111COUT1_165\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[8]~83\ = CARRY(\tmp0|cnt\(8) & !\tmp0|cnt[7]~111\)
-- \tmp0|cnt[8]~83COUT1_167\ = CARRY(\tmp0|cnt\(8) & !\tmp0|cnt[7]~111COUT1_165\)

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
	datab => \tmp0|cnt\(8),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[5]~107\,
	cin0 => \tmp0|cnt[7]~111\,
	cin1 => \tmp0|cnt[7]~111COUT1_165\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(8),
	cout0 => \tmp0|cnt[8]~83\,
	cout1 => \tmp0|cnt[8]~83COUT1_167\);

\tmp0|cnt[9]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(9) = DFFEAS(\tmp0|cnt\(9) $ ((!\tmp0|cnt[5]~107\ & \tmp0|cnt[8]~83\) # (\tmp0|cnt[5]~107\ & \tmp0|cnt[8]~83COUT1_167\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[9]~85\ = CARRY(!\tmp0|cnt[8]~83\ # !\tmp0|cnt\(9))
-- \tmp0|cnt[9]~85COUT1_169\ = CARRY(!\tmp0|cnt[8]~83COUT1_167\ # !\tmp0|cnt\(9))

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
	dataa => \tmp0|cnt\(9),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[5]~107\,
	cin0 => \tmp0|cnt[8]~83\,
	cin1 => \tmp0|cnt[8]~83COUT1_167\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(9),
	cout0 => \tmp0|cnt[9]~85\,
	cout1 => \tmp0|cnt[9]~85COUT1_169\);

\tmp0|cnt[10]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(10) = DFFEAS(\tmp0|cnt\(10) $ (!(!\tmp0|cnt[5]~107\ & \tmp0|cnt[9]~85\) # (\tmp0|cnt[5]~107\ & \tmp0|cnt[9]~85COUT1_169\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[10]~87\ = CARRY(\tmp0|cnt\(10) & (!\tmp0|cnt[9]~85COUT1_169\))

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
	dataa => \tmp0|cnt\(10),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[5]~107\,
	cin0 => \tmp0|cnt[9]~85\,
	cin1 => \tmp0|cnt[9]~85COUT1_169\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(10),
	cout => \tmp0|cnt[10]~87\);

\tmp0|cnt[11]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(11) = DFFEAS(\tmp0|cnt\(11) $ (\tmp0|cnt[10]~87\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[11]~113\ = CARRY(!\tmp0|cnt[10]~87\ # !\tmp0|cnt\(11))
-- \tmp0|cnt[11]~113COUT1_171\ = CARRY(!\tmp0|cnt[10]~87\ # !\tmp0|cnt\(11))

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
	dataa => \tmp0|cnt\(11),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[10]~87\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(11),
	cout0 => \tmp0|cnt[11]~113\,
	cout1 => \tmp0|cnt[11]~113COUT1_171\);

\tmp0|cnt[12]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(12) = DFFEAS(\tmp0|cnt\(12) $ (!(!\tmp0|cnt[10]~87\ & \tmp0|cnt[11]~113\) # (\tmp0|cnt[10]~87\ & \tmp0|cnt[11]~113COUT1_171\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[12]~91\ = CARRY(\tmp0|cnt\(12) & (!\tmp0|cnt[11]~113\))
-- \tmp0|cnt[12]~91COUT1_173\ = CARRY(\tmp0|cnt\(12) & (!\tmp0|cnt[11]~113COUT1_171\))

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
	dataa => \tmp0|cnt\(12),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[10]~87\,
	cin0 => \tmp0|cnt[11]~113\,
	cin1 => \tmp0|cnt[11]~113COUT1_171\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(12),
	cout0 => \tmp0|cnt[12]~91\,
	cout1 => \tmp0|cnt[12]~91COUT1_173\);

\tmp0|cnt[13]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(13) = DFFEAS(\tmp0|cnt\(13) $ (!\tmp0|cnt[10]~87\ & \tmp0|cnt[12]~91\) # (\tmp0|cnt[10]~87\ & \tmp0|cnt[12]~91COUT1_173\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[13]~93\ = CARRY(!\tmp0|cnt[12]~91\ # !\tmp0|cnt\(13))
-- \tmp0|cnt[13]~93COUT1_175\ = CARRY(!\tmp0|cnt[12]~91COUT1_173\ # !\tmp0|cnt\(13))

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
	datab => \tmp0|cnt\(13),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[10]~87\,
	cin0 => \tmp0|cnt[12]~91\,
	cin1 => \tmp0|cnt[12]~91COUT1_173\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(13),
	cout0 => \tmp0|cnt[13]~93\,
	cout1 => \tmp0|cnt[13]~93COUT1_175\);

\tmp0|cnt[14]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(14) = DFFEAS(\tmp0|cnt\(14) $ (!(!\tmp0|cnt[10]~87\ & \tmp0|cnt[13]~93\) # (\tmp0|cnt[10]~87\ & \tmp0|cnt[13]~93COUT1_175\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[14]~95\ = CARRY(\tmp0|cnt\(14) & (!\tmp0|cnt[13]~93\))
-- \tmp0|cnt[14]~95COUT1_177\ = CARRY(\tmp0|cnt\(14) & (!\tmp0|cnt[13]~93COUT1_175\))

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
	dataa => \tmp0|cnt\(14),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[10]~87\,
	cin0 => \tmp0|cnt[13]~93\,
	cin1 => \tmp0|cnt[13]~93COUT1_175\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(14),
	cout0 => \tmp0|cnt[14]~95\,
	cout1 => \tmp0|cnt[14]~95COUT1_177\);

\tmp0|cnt[15]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(15) = DFFEAS(\tmp0|cnt\(15) $ (!\tmp0|cnt[10]~87\ & \tmp0|cnt[14]~95\) # (\tmp0|cnt[10]~87\ & \tmp0|cnt[14]~95COUT1_177\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[15]~97\ = CARRY(!\tmp0|cnt[14]~95COUT1_177\ # !\tmp0|cnt\(15))

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
	datab => \tmp0|cnt\(15),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[10]~87\,
	cin0 => \tmp0|cnt[14]~95\,
	cin1 => \tmp0|cnt[14]~95COUT1_177\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(15),
	cout => \tmp0|cnt[15]~97\);

\tmp0|cnt[16]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(16) = DFFEAS(\tmp0|cnt\(16) $ !\tmp0|cnt[15]~97\, GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[16]~117\ = CARRY(\tmp0|cnt\(16) & !\tmp0|cnt[15]~97\)
-- \tmp0|cnt[16]~117COUT1_179\ = CARRY(\tmp0|cnt\(16) & !\tmp0|cnt[15]~97\)

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
	datab => \tmp0|cnt\(16),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[15]~97\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(16),
	cout0 => \tmp0|cnt[16]~117\,
	cout1 => \tmp0|cnt[16]~117COUT1_179\);

\tmp0|cnt[17]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(17) = DFFEAS(\tmp0|cnt\(17) $ (!\tmp0|cnt[15]~97\ & \tmp0|cnt[16]~117\) # (\tmp0|cnt[15]~97\ & \tmp0|cnt[16]~117COUT1_179\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[17]~115\ = CARRY(!\tmp0|cnt[16]~117\ # !\tmp0|cnt\(17))
-- \tmp0|cnt[17]~115COUT1_181\ = CARRY(!\tmp0|cnt[16]~117COUT1_179\ # !\tmp0|cnt\(17))

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
	datab => \tmp0|cnt\(17),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[15]~97\,
	cin0 => \tmp0|cnt[16]~117\,
	cin1 => \tmp0|cnt[16]~117COUT1_179\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(17),
	cout0 => \tmp0|cnt[17]~115\,
	cout1 => \tmp0|cnt[17]~115COUT1_181\);

\tmp0|cnt[18]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(18) = DFFEAS(\tmp0|cnt\(18) $ !(!\tmp0|cnt[15]~97\ & \tmp0|cnt[17]~115\) # (\tmp0|cnt[15]~97\ & \tmp0|cnt[17]~115COUT1_181\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[18]~119\ = CARRY(\tmp0|cnt\(18) & !\tmp0|cnt[17]~115\)
-- \tmp0|cnt[18]~119COUT1_183\ = CARRY(\tmp0|cnt\(18) & !\tmp0|cnt[17]~115COUT1_181\)

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
	datab => \tmp0|cnt\(18),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[15]~97\,
	cin0 => \tmp0|cnt[17]~115\,
	cin1 => \tmp0|cnt[17]~115COUT1_181\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(18),
	cout0 => \tmp0|cnt[18]~119\,
	cout1 => \tmp0|cnt[18]~119COUT1_183\);

\tmp0|cnt[19]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(19) = DFFEAS(\tmp0|cnt\(19) $ ((!\tmp0|cnt[15]~97\ & \tmp0|cnt[18]~119\) # (\tmp0|cnt[15]~97\ & \tmp0|cnt[18]~119COUT1_183\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[19]~121\ = CARRY(!\tmp0|cnt[18]~119\ # !\tmp0|cnt\(19))
-- \tmp0|cnt[19]~121COUT1_185\ = CARRY(!\tmp0|cnt[18]~119COUT1_183\ # !\tmp0|cnt\(19))

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
	dataa => \tmp0|cnt\(19),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[15]~97\,
	cin0 => \tmp0|cnt[18]~119\,
	cin1 => \tmp0|cnt[18]~119COUT1_183\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(19),
	cout0 => \tmp0|cnt[19]~121\,
	cout1 => \tmp0|cnt[19]~121COUT1_185\);

\tmp0|cnt[20]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(20) = DFFEAS(\tmp0|cnt\(20) $ (!(!\tmp0|cnt[15]~97\ & \tmp0|cnt[19]~121\) # (\tmp0|cnt[15]~97\ & \tmp0|cnt[19]~121COUT1_185\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[20]~123\ = CARRY(\tmp0|cnt\(20) & (!\tmp0|cnt[19]~121COUT1_185\))

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
	dataa => \tmp0|cnt\(20),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[15]~97\,
	cin0 => \tmp0|cnt[19]~121\,
	cin1 => \tmp0|cnt[19]~121COUT1_185\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(20),
	cout => \tmp0|cnt[20]~123\);

\tmp0|cnt[21]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(21) = DFFEAS(\tmp0|cnt\(21) $ (\tmp0|cnt[20]~123\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[21]~125\ = CARRY(!\tmp0|cnt[20]~123\ # !\tmp0|cnt\(21))
-- \tmp0|cnt[21]~125COUT1_187\ = CARRY(!\tmp0|cnt[20]~123\ # !\tmp0|cnt\(21))

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
	dataa => \tmp0|cnt\(21),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[20]~123\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(21),
	cout0 => \tmp0|cnt[21]~125\,
	cout1 => \tmp0|cnt[21]~125COUT1_187\);

\tmp0|cnt[22]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(22) = DFFEAS(\tmp0|cnt\(22) $ (!(!\tmp0|cnt[20]~123\ & \tmp0|cnt[21]~125\) # (\tmp0|cnt[20]~123\ & \tmp0|cnt[21]~125COUT1_187\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[22]~65\ = CARRY(\tmp0|cnt\(22) & (!\tmp0|cnt[21]~125\))
-- \tmp0|cnt[22]~65COUT1_189\ = CARRY(\tmp0|cnt\(22) & (!\tmp0|cnt[21]~125COUT1_187\))

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
	dataa => \tmp0|cnt\(22),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[20]~123\,
	cin0 => \tmp0|cnt[21]~125\,
	cin1 => \tmp0|cnt[21]~125COUT1_187\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(22),
	cout0 => \tmp0|cnt[22]~65\,
	cout1 => \tmp0|cnt[22]~65COUT1_189\);

\tmp0|cnt[23]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(23) = DFFEAS(\tmp0|cnt\(23) $ (!\tmp0|cnt[20]~123\ & \tmp0|cnt[22]~65\) # (\tmp0|cnt[20]~123\ & \tmp0|cnt[22]~65COUT1_189\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[23]~67\ = CARRY(!\tmp0|cnt[22]~65\ # !\tmp0|cnt\(23))
-- \tmp0|cnt[23]~67COUT1_191\ = CARRY(!\tmp0|cnt[22]~65COUT1_189\ # !\tmp0|cnt\(23))

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
	datab => \tmp0|cnt\(23),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[20]~123\,
	cin0 => \tmp0|cnt[22]~65\,
	cin1 => \tmp0|cnt[22]~65COUT1_189\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(23),
	cout0 => \tmp0|cnt[23]~67\,
	cout1 => \tmp0|cnt[23]~67COUT1_191\);

\tmp0|cnt[24]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(24) = DFFEAS(\tmp0|cnt\(24) $ (!(!\tmp0|cnt[20]~123\ & \tmp0|cnt[23]~67\) # (\tmp0|cnt[20]~123\ & \tmp0|cnt[23]~67COUT1_191\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[24]~69\ = CARRY(\tmp0|cnt\(24) & (!\tmp0|cnt[23]~67\))
-- \tmp0|cnt[24]~69COUT1_193\ = CARRY(\tmp0|cnt\(24) & (!\tmp0|cnt[23]~67COUT1_191\))

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
	dataa => \tmp0|cnt\(24),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[20]~123\,
	cin0 => \tmp0|cnt[23]~67\,
	cin1 => \tmp0|cnt[23]~67COUT1_191\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(24),
	cout0 => \tmp0|cnt[24]~69\,
	cout1 => \tmp0|cnt[24]~69COUT1_193\);

\tmp0|cnt[25]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(25) = DFFEAS(\tmp0|cnt\(25) $ (!\tmp0|cnt[20]~123\ & \tmp0|cnt[24]~69\) # (\tmp0|cnt[20]~123\ & \tmp0|cnt[24]~69COUT1_193\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[25]~71\ = CARRY(!\tmp0|cnt[24]~69COUT1_193\ # !\tmp0|cnt\(25))

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
	datab => \tmp0|cnt\(25),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[20]~123\,
	cin0 => \tmp0|cnt[24]~69\,
	cin1 => \tmp0|cnt[24]~69COUT1_193\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(25),
	cout => \tmp0|cnt[25]~71\);

\tmp0|cnt[26]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(26) = DFFEAS(\tmp0|cnt\(26) $ !\tmp0|cnt[25]~71\, GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[26]~73\ = CARRY(\tmp0|cnt\(26) & !\tmp0|cnt[25]~71\)
-- \tmp0|cnt[26]~73COUT1_195\ = CARRY(\tmp0|cnt\(26) & !\tmp0|cnt[25]~71\)

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
	datab => \tmp0|cnt\(26),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[25]~71\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(26),
	cout0 => \tmp0|cnt[26]~73\,
	cout1 => \tmp0|cnt[26]~73COUT1_195\);

\tmp0|cnt[27]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(27) = DFFEAS(\tmp0|cnt\(27) $ (!\tmp0|cnt[25]~71\ & \tmp0|cnt[26]~73\) # (\tmp0|cnt[25]~71\ & \tmp0|cnt[26]~73COUT1_195\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[27]~75\ = CARRY(!\tmp0|cnt[26]~73\ # !\tmp0|cnt\(27))
-- \tmp0|cnt[27]~75COUT1_197\ = CARRY(!\tmp0|cnt[26]~73COUT1_195\ # !\tmp0|cnt\(27))

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
	datab => \tmp0|cnt\(27),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[25]~71\,
	cin0 => \tmp0|cnt[26]~73\,
	cin1 => \tmp0|cnt[26]~73COUT1_195\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(27),
	cout0 => \tmp0|cnt[27]~75\,
	cout1 => \tmp0|cnt[27]~75COUT1_197\);

\tmp0|cnt[28]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(28) = DFFEAS(\tmp0|cnt\(28) $ !(!\tmp0|cnt[25]~71\ & \tmp0|cnt[27]~75\) # (\tmp0|cnt[25]~71\ & \tmp0|cnt[27]~75COUT1_197\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[28]~77\ = CARRY(\tmp0|cnt\(28) & !\tmp0|cnt[27]~75\)
-- \tmp0|cnt[28]~77COUT1_199\ = CARRY(\tmp0|cnt\(28) & !\tmp0|cnt[27]~75COUT1_197\)

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
	datab => \tmp0|cnt\(28),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[25]~71\,
	cin0 => \tmp0|cnt[27]~75\,
	cin1 => \tmp0|cnt[27]~75COUT1_197\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(28),
	cout0 => \tmp0|cnt[28]~77\,
	cout1 => \tmp0|cnt[28]~77COUT1_199\);

\tmp0|cnt[29]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(29) = DFFEAS(\tmp0|cnt\(29) $ ((!\tmp0|cnt[25]~71\ & \tmp0|cnt[28]~77\) # (\tmp0|cnt[25]~71\ & \tmp0|cnt[28]~77COUT1_199\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[29]~79\ = CARRY(!\tmp0|cnt[28]~77\ # !\tmp0|cnt\(29))
-- \tmp0|cnt[29]~79COUT1_201\ = CARRY(!\tmp0|cnt[28]~77COUT1_199\ # !\tmp0|cnt\(29))

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
	dataa => \tmp0|cnt\(29),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[25]~71\,
	cin0 => \tmp0|cnt[28]~77\,
	cin1 => \tmp0|cnt[28]~77COUT1_199\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(29),
	cout0 => \tmp0|cnt[29]~79\,
	cout1 => \tmp0|cnt[29]~79COUT1_201\);

\tmp0|cnt[30]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(30) = DFFEAS(\tmp0|cnt\(30) $ (!(!\tmp0|cnt[25]~71\ & \tmp0|cnt[29]~79\) # (\tmp0|cnt[25]~71\ & \tmp0|cnt[29]~79COUT1_201\)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )
-- \tmp0|cnt[30]~81\ = CARRY(\tmp0|cnt\(30) & (!\tmp0|cnt[29]~79COUT1_201\))

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
	dataa => \tmp0|cnt\(30),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[25]~71\,
	cin0 => \tmp0|cnt[29]~79\,
	cin1 => \tmp0|cnt[29]~79COUT1_201\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(30),
	cout => \tmp0|cnt[30]~81\);

\tmp0|cnt[31]\ : maxii_lcell
-- Equation(s):
-- \tmp0|cnt\(31) = DFFEAS(\tmp0|cnt\(31) $ (\tmp0|cnt[30]~81\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|cnt[0]~128_combout\, , , \tmp0|LessThan0~3_combout\, )

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
	dataa => \tmp0|cnt\(31),
	aclr => \ALT_INV_rst~combout\,
	sclr => \tmp0|LessThan0~3_combout\,
	ena => \tmp0|cnt[0]~128_combout\,
	cin => \tmp0|cnt[30]~81\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|cnt\(31));

\tmp0|LessThan0~1\ : maxii_lcell
-- Equation(s):
-- \tmp0|LessThan0~1_combout\ = !\tmp0|cnt\(17) & !\tmp0|cnt\(16) # !\tmp0|cnt\(19) # !\tmp0|cnt\(18)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "37ff",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|cnt\(17),
	datab => \tmp0|cnt\(18),
	datac => \tmp0|cnt\(16),
	datad => \tmp0|cnt\(19),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|LessThan0~1_combout\);

\tmp0|Equal0~5\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~5_combout\ = !\tmp0|cnt\(14) & !\tmp0|cnt\(13) & !\tmp0|cnt\(12) & !\tmp0|cnt\(15)

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
	dataa => \tmp0|cnt\(14),
	datab => \tmp0|cnt\(13),
	datac => \tmp0|cnt\(12),
	datad => \tmp0|cnt\(15),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~5_combout\);

\tmp0|Equal0~3\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~3_combout\ = !\tmp0|cnt\(9) & !\tmp0|cnt\(8) & !\tmp0|cnt\(10)

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
	datab => \tmp0|cnt\(9),
	datac => \tmp0|cnt\(8),
	datad => \tmp0|cnt\(10),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~3_combout\);

\tmp0|LessThan0~0\ : maxii_lcell
-- Equation(s):
-- \tmp0|LessThan0~0_combout\ = \tmp0|Equal0~5_combout\ & !\tmp0|cnt\(17) & (\tmp0|Equal0~3_combout\ # !\tmp0|cnt\(11))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0c04",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|cnt\(11),
	datab => \tmp0|Equal0~5_combout\,
	datac => \tmp0|cnt\(17),
	datad => \tmp0|Equal0~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|LessThan0~0_combout\);

\tmp0|LessThan0~2\ : maxii_lcell
-- Equation(s):
-- \tmp0|LessThan0~2_combout\ = \tmp0|LessThan0~1_combout\ # \tmp0|LessThan0~0_combout\ # !\tmp0|cnt\(21) # !\tmp0|cnt\(20)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fff7",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|cnt\(20),
	datab => \tmp0|cnt\(21),
	datac => \tmp0|LessThan0~1_combout\,
	datad => \tmp0|LessThan0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|LessThan0~2_combout\);

\tmp0|Equal0~1\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~1_combout\ = !\tmp0|cnt\(29) & !\tmp0|cnt\(28) & !\tmp0|cnt\(26) & !\tmp0|cnt\(27)

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
	dataa => \tmp0|cnt\(29),
	datab => \tmp0|cnt\(28),
	datac => \tmp0|cnt\(26),
	datad => \tmp0|cnt\(27),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~1_combout\);

\tmp0|Equal0~0\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~0_combout\ = !\tmp0|cnt\(24) & !\tmp0|cnt\(23) & !\tmp0|cnt\(22) & !\tmp0|cnt\(25)

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
	dataa => \tmp0|cnt\(24),
	datab => \tmp0|cnt\(23),
	datac => \tmp0|cnt\(22),
	datad => \tmp0|cnt\(25),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~0_combout\);

\tmp0|Equal0~2\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~2_combout\ = !\tmp0|cnt\(30) & (\tmp0|Equal0~1_combout\ & \tmp0|Equal0~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|cnt\(30),
	datac => \tmp0|Equal0~1_combout\,
	datad => \tmp0|Equal0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~2_combout\);

\tmp0|LessThan0~3\ : maxii_lcell
-- Equation(s):
-- \tmp0|LessThan0~3_combout\ = !\tmp0|cnt\(31) & (!\tmp0|Equal0~2_combout\ # !\tmp0|LessThan0~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0333",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \tmp0|cnt\(31),
	datac => \tmp0|LessThan0~2_combout\,
	datad => \tmp0|Equal0~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|LessThan0~3_combout\);

\tmp0|Equal0~9\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~9_combout\ = !\tmp0|cnt\(16) & !\tmp0|cnt\(19) & !\tmp0|cnt\(18) & !\tmp0|cnt\(20)

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
	dataa => \tmp0|cnt\(16),
	datab => \tmp0|cnt\(19),
	datac => \tmp0|cnt\(18),
	datad => \tmp0|cnt\(20),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~9_combout\);

\tmp0|Equal0~6\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~6_combout\ = !\tmp0|cnt\(2) & !\tmp0|cnt\(3) & !\tmp0|cnt\(1) & !\tmp0|cnt\(4)

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
	dataa => \tmp0|cnt\(2),
	datab => \tmp0|cnt\(3),
	datac => \tmp0|cnt\(1),
	datad => \tmp0|cnt\(4),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~6_combout\);

\tmp0|Equal0~7\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~7_combout\ = !\tmp0|cnt\(6) & !\tmp0|cnt\(7) & !\tmp0|cnt\(11) & !\tmp0|cnt\(5)

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
	dataa => \tmp0|cnt\(6),
	datab => \tmp0|cnt\(7),
	datac => \tmp0|cnt\(11),
	datad => \tmp0|cnt\(5),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~7_combout\);

\tmp0|Equal0~8\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~8_combout\ = !\tmp0|cnt\(17) & \tmp0|Equal0~6_combout\ & \tmp0|Equal0~7_combout\ & \tmp0|Equal0~5_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|cnt\(17),
	datab => \tmp0|Equal0~6_combout\,
	datac => \tmp0|Equal0~7_combout\,
	datad => \tmp0|Equal0~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~8_combout\);

\tmp0|Equal0~10\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~10_combout\ = !\tmp0|cnt\(21) & !\tmp0|cnt\(31) & \tmp0|Equal0~9_combout\ & \tmp0|Equal0~8_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|cnt\(21),
	datab => \tmp0|cnt\(31),
	datac => \tmp0|Equal0~9_combout\,
	datad => \tmp0|Equal0~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~10_combout\);

\tmp0|Equal0~4\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal0~4_combout\ = !\tmp0|cnt\(0) & \tmp0|Equal0~2_combout\ & \tmp0|Equal0~3_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \tmp0|cnt\(0),
	datac => \tmp0|Equal0~2_combout\,
	datad => \tmp0|Equal0~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal0~4_combout\);

\tmp0|n0[0]~8\ : maxii_lcell
-- Equation(s):
-- \tmp0|n0[0]~8_combout\ = !\pause~combout\ & (\tmp0|Equal0~10_combout\ & \tmp0|Equal0~4_combout\ # !\mode~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5111",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \pause~combout\,
	datab => \mode~combout\,
	datac => \tmp0|Equal0~10_combout\,
	datad => \tmp0|Equal0~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|n0[0]~8_combout\);

\tmp0|n0[0]\ : maxii_lcell
-- Equation(s):
-- \tmp0|n0\(0) = DFFEAS(!\tmp0|n0\(0), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|n0[0]~8_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0f0f",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	datac => \tmp0|n0\(0),
	aclr => \ALT_INV_rst~combout\,
	ena => \tmp0|n0[0]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|n0\(0));

\tmp0|n0[2]\ : maxii_lcell
-- Equation(s):
-- \tmp0|n0\(2) = DFFEAS(\tmp0|n0\(2) $ (\tmp0|n0\(1) & \tmp0|n0\(0) & \tmp0|n0[0]~8_combout\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , , , , , )

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
	dataa => \tmp0|n0\(1),
	datab => \tmp0|n0\(0),
	datac => \tmp0|n0[0]~8_combout\,
	datad => \tmp0|n0\(2),
	aclr => \ALT_INV_rst~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|n0\(2));

\tmp0|n0[3]\ : maxii_lcell
-- Equation(s):
-- \tmp0|n0\(3) = DFFEAS(\tmp0|n0\(2) & (\tmp0|n0\(3) $ (\tmp0|n0\(0) & \tmp0|n0\(1))) # !\tmp0|n0\(2) & \tmp0|n0\(3) & (\tmp0|n0\(1) # !\tmp0|n0\(0)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|n0[0]~8_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "7b80",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => \tmp0|n0\(2),
	datab => \tmp0|n0\(0),
	datac => \tmp0|n0\(1),
	datad => \tmp0|n0\(3),
	aclr => \ALT_INV_rst~combout\,
	ena => \tmp0|n0[0]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|n0\(3));

\tmp0|n0[1]\ : maxii_lcell
-- Equation(s):
-- \tmp0|n0\(1) = DFFEAS(\tmp0|n0\(0) & !\tmp0|n0\(1) & (\tmp0|n0\(2) # !\tmp0|n0\(3)) # !\tmp0|n0\(0) & (\tmp0|n0\(1)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|n0[0]~8_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "383c",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => \tmp0|n0\(2),
	datab => \tmp0|n0\(0),
	datac => \tmp0|n0\(1),
	datad => \tmp0|n0\(3),
	aclr => \ALT_INV_rst~combout\,
	ena => \tmp0|n0[0]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|n0\(1));

\tmp0|Equal1~0\ : maxii_lcell
-- Equation(s):
-- \tmp0|Equal1~0_combout\ = !\tmp0|n0\(1) & !\tmp0|n0\(2) & \tmp0|n0\(0) & \tmp0|n0\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n0\(1),
	datab => \tmp0|n0\(2),
	datac => \tmp0|n0\(0),
	datad => \tmp0|n0\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|Equal1~0_combout\);

\tmp0|n1[0]~12\ : maxii_lcell
-- Equation(s):
-- \tmp0|n1[0]~12_combout\ = \tmp0|Equal1~0_combout\ & \tmp0|n0[0]~8_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \tmp0|Equal1~0_combout\,
	datad => \tmp0|n0[0]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|n1[0]~12_combout\);

\tmp0|n1[0]\ : maxii_lcell
-- Equation(s):
-- \tmp0|n1\(0) = DFFEAS(!\tmp0|n1\(0), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|n1[0]~12_combout\, , , , )

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
	datad => \tmp0|n1\(0),
	aclr => \ALT_INV_rst~combout\,
	ena => \tmp0|n1[0]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|n1\(0));

\tmp0|n1[2]\ : maxii_lcell
-- Equation(s):
-- \tmp0|n1\(2) = DFFEAS(\tmp0|n1\(1) & (\tmp0|n1\(0) $ \tmp0|n1\(2)) # !\tmp0|n1\(1) & \tmp0|n1\(2) & (\tmp0|n1\(3) # !\tmp0|n1\(0)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|n1[0]~12_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4fa0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => \tmp0|n1\(1),
	datab => \tmp0|n1\(3),
	datac => \tmp0|n1\(0),
	datad => \tmp0|n1\(2),
	aclr => \ALT_INV_rst~combout\,
	ena => \tmp0|n1[0]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|n1\(2));

\tmp0|n1[3]~15\ : maxii_lcell
-- Equation(s):
-- \tmp0|n1[3]~15_combout\ = \tmp0|n1\(2) & (\tmp0|n1\(0) & \tmp0|n1\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "a000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n1\(2),
	datac => \tmp0|n1\(0),
	datad => \tmp0|n1\(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp0|n1[3]~15_combout\);

\tmp0|n1[3]\ : maxii_lcell
-- Equation(s):
-- \tmp0|n1\(3) = DFFEAS(\tmp0|n1\(3) $ (\tmp0|n1[3]~15_combout\ & \tmp0|n0[0]~8_combout\ & \tmp0|Equal1~0_combout\), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "6aaa",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => \tmp0|n1\(3),
	datab => \tmp0|n1[3]~15_combout\,
	datac => \tmp0|n0[0]~8_combout\,
	datad => \tmp0|Equal1~0_combout\,
	aclr => \ALT_INV_rst~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|n1\(3));

\tmp0|n1[1]\ : maxii_lcell
-- Equation(s):
-- \tmp0|n1\(1) = DFFEAS(\tmp0|n1\(1) & (!\tmp0|n1\(0)) # !\tmp0|n1\(1) & \tmp0|n1\(0) & (\tmp0|n1\(3) # !\tmp0|n1\(2)), GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \tmp0|n1[0]~12_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4a5a",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \clk~combout\,
	dataa => \tmp0|n1\(1),
	datab => \tmp0|n1\(3),
	datac => \tmp0|n1\(0),
	datad => \tmp0|n1\(2),
	aclr => \ALT_INV_rst~combout\,
	ena => \tmp0|n1[0]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \tmp0|n1\(1));

\tmp1|Mux6~0\ : maxii_lcell
-- Equation(s):
-- \tmp1|Mux6~0_combout\ = \tmp0|n0\(0) & (\tmp0|n0\(3) # \tmp0|n0\(2) $ \tmp0|n0\(1)) # !\tmp0|n0\(0) & (\tmp0|n0\(1) # \tmp0|n0\(2) $ \tmp0|n0\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fd6e",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n0\(2),
	datab => \tmp0|n0\(1),
	datac => \tmp0|n0\(0),
	datad => \tmp0|n0\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp1|Mux6~0_combout\);

\tmp1|Mux5~0\ : maxii_lcell
-- Equation(s):
-- \tmp1|Mux5~0_combout\ = \tmp0|n0\(2) & \tmp0|n0\(0) & (\tmp0|n0\(1) $ \tmp0|n0\(3)) # !\tmp0|n0\(2) & !\tmp0|n0\(3) & (\tmp0|n0\(1) # \tmp0|n0\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "20d4",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n0\(2),
	datab => \tmp0|n0\(1),
	datac => \tmp0|n0\(0),
	datad => \tmp0|n0\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp1|Mux5~0_combout\);

\tmp1|Mux4~0\ : maxii_lcell
-- Equation(s):
-- \tmp1|Mux4~0_combout\ = \tmp0|n0\(1) & (\tmp0|n0\(0) & !\tmp0|n0\(3)) # !\tmp0|n0\(1) & (\tmp0|n0\(2) & (!\tmp0|n0\(3)) # !\tmp0|n0\(2) & \tmp0|n0\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "10f2",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n0\(2),
	datab => \tmp0|n0\(1),
	datac => \tmp0|n0\(0),
	datad => \tmp0|n0\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp1|Mux4~0_combout\);

\tmp1|Mux3~0\ : maxii_lcell
-- Equation(s):
-- \tmp1|Mux3~0_combout\ = \tmp0|n0\(0) & (\tmp0|n0\(2) $ !\tmp0|n0\(1)) # !\tmp0|n0\(0) & (\tmp0|n0\(2) & !\tmp0|n0\(1) & !\tmp0|n0\(3) # !\tmp0|n0\(2) & \tmp0|n0\(1) & \tmp0|n0\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "9492",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n0\(2),
	datab => \tmp0|n0\(1),
	datac => \tmp0|n0\(0),
	datad => \tmp0|n0\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp1|Mux3~0_combout\);

\tmp1|Mux2~0\ : maxii_lcell
-- Equation(s):
-- \tmp1|Mux2~0_combout\ = \tmp0|n0\(2) & \tmp0|n0\(3) & (\tmp0|n0\(1) # !\tmp0|n0\(0)) # !\tmp0|n0\(2) & \tmp0|n0\(1) & !\tmp0|n0\(0) & !\tmp0|n0\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8a04",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n0\(2),
	datab => \tmp0|n0\(1),
	datac => \tmp0|n0\(0),
	datad => \tmp0|n0\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp1|Mux2~0_combout\);

\tmp1|Mux1~0\ : maxii_lcell
-- Equation(s):
-- \tmp1|Mux1~0_combout\ = \tmp0|n0\(1) & (\tmp0|n0\(0) & (\tmp0|n0\(3)) # !\tmp0|n0\(0) & \tmp0|n0\(2)) # !\tmp0|n0\(1) & \tmp0|n0\(2) & (\tmp0|n0\(0) $ \tmp0|n0\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "e228",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n0\(2),
	datab => \tmp0|n0\(0),
	datac => \tmp0|n0\(1),
	datad => \tmp0|n0\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp1|Mux1~0_combout\);

\tmp1|Mux0~0\ : maxii_lcell
-- Equation(s):
-- \tmp1|Mux0~0_combout\ = \tmp0|n0\(2) & (\tmp0|n0\(0) & !\tmp0|n0\(1) & \tmp0|n0\(3) # !\tmp0|n0\(0) & (!\tmp0|n0\(3))) # !\tmp0|n0\(2) & \tmp0|n0\(0) & (\tmp0|n0\(1) $ !\tmp0|n0\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "601c",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n0\(1),
	datab => \tmp0|n0\(2),
	datac => \tmp0|n0\(0),
	datad => \tmp0|n0\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp1|Mux0~0_combout\);

\tmp2|Mux6~0\ : maxii_lcell
-- Equation(s):
-- \tmp2|Mux6~0_combout\ = \tmp0|n1\(0) & (\tmp0|n1\(3) # \tmp0|n1\(2) $ \tmp0|n1\(1)) # !\tmp0|n1\(0) & (\tmp0|n1\(1) # \tmp0|n1\(2) $ \tmp0|n1\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fd7a",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n1\(2),
	datab => \tmp0|n1\(0),
	datac => \tmp0|n1\(1),
	datad => \tmp0|n1\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp2|Mux6~0_combout\);

\tmp2|Mux5~0\ : maxii_lcell
-- Equation(s):
-- \tmp2|Mux5~0_combout\ = \tmp0|n1\(2) & \tmp0|n1\(0) & (\tmp0|n1\(1) $ \tmp0|n1\(3)) # !\tmp0|n1\(2) & !\tmp0|n1\(3) & (\tmp0|n1\(0) # \tmp0|n1\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "08d4",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n1\(2),
	datab => \tmp0|n1\(0),
	datac => \tmp0|n1\(1),
	datad => \tmp0|n1\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp2|Mux5~0_combout\);

\tmp2|Mux4~0\ : maxii_lcell
-- Equation(s):
-- \tmp2|Mux4~0_combout\ = \tmp0|n1\(1) & (\tmp0|n1\(0) & !\tmp0|n1\(3)) # !\tmp0|n1\(1) & (\tmp0|n1\(2) & (!\tmp0|n1\(3)) # !\tmp0|n1\(2) & \tmp0|n1\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "10f2",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n1\(2),
	datab => \tmp0|n1\(1),
	datac => \tmp0|n1\(0),
	datad => \tmp0|n1\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp2|Mux4~0_combout\);

\tmp2|Mux3~0\ : maxii_lcell
-- Equation(s):
-- \tmp2|Mux3~0_combout\ = \tmp0|n1\(0) & (\tmp0|n1\(2) $ !\tmp0|n1\(1)) # !\tmp0|n1\(0) & (\tmp0|n1\(2) & !\tmp0|n1\(1) & !\tmp0|n1\(3) # !\tmp0|n1\(2) & \tmp0|n1\(1) & \tmp0|n1\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "9492",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n1\(2),
	datab => \tmp0|n1\(1),
	datac => \tmp0|n1\(0),
	datad => \tmp0|n1\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp2|Mux3~0_combout\);

\tmp2|Mux2~0\ : maxii_lcell
-- Equation(s):
-- \tmp2|Mux2~0_combout\ = \tmp0|n1\(3) & \tmp0|n1\(2) & (\tmp0|n1\(1) # !\tmp0|n1\(0)) # !\tmp0|n1\(3) & !\tmp0|n1\(0) & \tmp0|n1\(1) & !\tmp0|n1\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c410",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n1\(0),
	datab => \tmp0|n1\(3),
	datac => \tmp0|n1\(1),
	datad => \tmp0|n1\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp2|Mux2~0_combout\);

\tmp2|Mux1~0\ : maxii_lcell
-- Equation(s):
-- \tmp2|Mux1~0_combout\ = \tmp0|n1\(3) & (\tmp0|n1\(0) & \tmp0|n1\(1) # !\tmp0|n1\(0) & (\tmp0|n1\(2))) # !\tmp0|n1\(3) & \tmp0|n1\(2) & (\tmp0|n1\(0) $ \tmp0|n1\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "d680",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n1\(0),
	datab => \tmp0|n1\(3),
	datac => \tmp0|n1\(1),
	datad => \tmp0|n1\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp2|Mux1~0_combout\);

\tmp2|Mux0~0\ : maxii_lcell
-- Equation(s):
-- \tmp2|Mux0~0_combout\ = \tmp0|n1\(0) & (\tmp0|n1\(3) & (\tmp0|n1\(1) $ \tmp0|n1\(2)) # !\tmp0|n1\(3) & !\tmp0|n1\(1) & !\tmp0|n1\(2)) # !\tmp0|n1\(0) & !\tmp0|n1\(3) & (\tmp0|n1\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1982",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \tmp0|n1\(0),
	datab => \tmp0|n1\(3),
	datac => \tmp0|n1\(1),
	datad => \tmp0|n1\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \tmp2|Mux0~0_combout\);

\n0[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp0|n0\(0),
	oe => VCC,
	padio => ww_n0(0));

\n0[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp0|n0\(1),
	oe => VCC,
	padio => ww_n0(1));

\n0[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp0|n0\(2),
	oe => VCC,
	padio => ww_n0(2));

\n0[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp0|n0\(3),
	oe => VCC,
	padio => ww_n0(3));

\n1[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp0|n1\(0),
	oe => VCC,
	padio => ww_n1(0));

\n1[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp0|n1\(1),
	oe => VCC,
	padio => ww_n1(1));

\n1[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp0|n1\(2),
	oe => VCC,
	padio => ww_n1(2));

\n1[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp0|n1\(3),
	oe => VCC,
	padio => ww_n1(3));

\ll[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp1|Mux6~0_combout\,
	oe => VCC,
	padio => ww_ll(0));

\ll[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp1|ALT_INV_Mux5~0_combout\,
	oe => VCC,
	padio => ww_ll(1));

\ll[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp1|ALT_INV_Mux4~0_combout\,
	oe => VCC,
	padio => ww_ll(2));

\ll[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp1|ALT_INV_Mux3~0_combout\,
	oe => VCC,
	padio => ww_ll(3));

\ll[4]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp1|ALT_INV_Mux2~0_combout\,
	oe => VCC,
	padio => ww_ll(4));

\ll[5]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp1|ALT_INV_Mux1~0_combout\,
	oe => VCC,
	padio => ww_ll(5));

\ll[6]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp1|ALT_INV_Mux0~0_combout\,
	oe => VCC,
	padio => ww_ll(6));

\hh[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp2|Mux6~0_combout\,
	oe => VCC,
	padio => ww_hh(0));

\hh[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp2|ALT_INV_Mux5~0_combout\,
	oe => VCC,
	padio => ww_hh(1));

\hh[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp2|ALT_INV_Mux4~0_combout\,
	oe => VCC,
	padio => ww_hh(2));

\hh[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp2|ALT_INV_Mux3~0_combout\,
	oe => VCC,
	padio => ww_hh(3));

\hh[4]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp2|ALT_INV_Mux2~0_combout\,
	oe => VCC,
	padio => ww_hh(4));

\hh[5]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp2|ALT_INV_Mux1~0_combout\,
	oe => VCC,
	padio => ww_hh(5));

\hh[6]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \tmp2|ALT_INV_Mux0~0_combout\,
	oe => VCC,
	padio => ww_hh(6));
END structure;


