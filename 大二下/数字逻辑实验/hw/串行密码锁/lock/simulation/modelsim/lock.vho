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

-- DATE "05/18/2018 08:23:42"

-- 
-- Device: Altera EPM240T100C5 Package TQFP100
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY IEEE, maxii;
USE IEEE.std_logic_1164.all;
USE maxii.maxii_components.all;

ENTITY 	lock IS
    PORT (
	code : IN std_logic_vector(3 DOWNTO 0);
	mode : IN std_logic_vector(1 DOWNTO 0);
	clk : IN std_logic;
	rst : IN std_logic;
	unlock : OUT std_logic;
	alarm : OUT std_logic;
	err : OUT std_logic
	);
END lock;

ARCHITECTURE structure OF lock IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_code : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_mode : std_logic_vector(1 DOWNTO 0);
SIGNAL ww_clk : std_logic;
SIGNAL ww_rst : std_logic;
SIGNAL ww_unlock : std_logic;
SIGNAL ww_alarm : std_logic;
SIGNAL ww_err : std_logic;
SIGNAL \pwd[3][3]~regout\ : std_logic;
SIGNAL \pwd[3][2]~regout\ : std_logic;
SIGNAL \pwd[0][1]~regout\ : std_logic;
SIGNAL \pwd[0][2]~regout\ : std_logic;
SIGNAL \pwd[2][1]~regout\ : std_logic;
SIGNAL \pwd[2][2]~regout\ : std_logic;
SIGNAL \pwd[1][1]~regout\ : std_logic;
SIGNAL \pwd[1][2]~regout\ : std_logic;
SIGNAL \clk~combout\ : std_logic;
SIGNAL \cnt~454_combout\ : std_logic;
SIGNAL \rst~combout\ : std_logic;
SIGNAL \cnt~417_combout\ : std_logic;
SIGNAL \Selector2~0_combout\ : std_logic;
SIGNAL \Equal5~0_combout\ : std_logic;
SIGNAL \Equal10~0_combout\ : std_logic;
SIGNAL \Equal10~1_combout\ : std_logic;
SIGNAL \pwd[3][31]~384_combout\ : std_logic;
SIGNAL \pwd[3][31]~regout\ : std_logic;
SIGNAL \pwd[3][1]~regout\ : std_logic;
SIGNAL \Equal9~0\ : std_logic;
SIGNAL \pwd[3][0]~regout\ : std_logic;
SIGNAL \Equal9~1\ : std_logic;
SIGNAL \Selector32~0_combout\ : std_logic;
SIGNAL \Selector36~2_combout\ : std_logic;
SIGNAL \pwd[0][31]~386_combout\ : std_logic;
SIGNAL \pwd[1][31]~388_combout\ : std_logic;
SIGNAL \pwd[1][31]~regout\ : std_logic;
SIGNAL \pwd[1][0]~regout\ : std_logic;
SIGNAL \Equal7~1\ : std_logic;
SIGNAL \pwd[1][3]~regout\ : std_logic;
SIGNAL \Equal7~0\ : std_logic;
SIGNAL \Selector32~2_combout\ : std_logic;
SIGNAL \Selector34~0_combout\ : std_logic;
SIGNAL \state~221_combout\ : std_logic;
SIGNAL \state~222_combout\ : std_logic;
SIGNAL \err~5_combout\ : std_logic;
SIGNAL \err~6_combout\ : std_logic;
SIGNAL \Selector36~0_combout\ : std_logic;
SIGNAL \pwd[2][31]~387_combout\ : std_logic;
SIGNAL \pwd[2][31]~regout\ : std_logic;
SIGNAL \pwd[2][0]~regout\ : std_logic;
SIGNAL \Equal8~1\ : std_logic;
SIGNAL \pwd[2][3]~regout\ : std_logic;
SIGNAL \Equal8~0\ : std_logic;
SIGNAL \Equal8~2_combout\ : std_logic;
SIGNAL \Selector36~1_combout\ : std_logic;
SIGNAL \pwd[0][31]~385_combout\ : std_logic;
SIGNAL \pwd[0][31]~regout\ : std_logic;
SIGNAL \pwd[0][0]~regout\ : std_logic;
SIGNAL \Equal6~1\ : std_logic;
SIGNAL \pwd[0][3]~regout\ : std_logic;
SIGNAL \Equal6~0\ : std_logic;
SIGNAL \Equal6~2_combout\ : std_logic;
SIGNAL \alarm~10_combout\ : std_logic;
SIGNAL \Equal9~2_combout\ : std_logic;
SIGNAL \Equal7~2_combout\ : std_logic;
SIGNAL \alarm~11_combout\ : std_logic;
SIGNAL \alarm~12_combout\ : std_logic;
SIGNAL \err~reg0_regout\ : std_logic;
SIGNAL \process_0~1_combout\ : std_logic;
SIGNAL \Selector1~0_combout\ : std_logic;
SIGNAL \Selector32~1_combout\ : std_logic;
SIGNAL \Selector33~2_combout\ : std_logic;
SIGNAL \Selector0~0_combout\ : std_logic;
SIGNAL \Selector32~3_combout\ : std_logic;
SIGNAL \Selector32~4_combout\ : std_logic;
SIGNAL \WideNor1~0_combout\ : std_logic;
SIGNAL \cnt[16]~422_combout\ : std_logic;
SIGNAL \cnt[16]~421_combout\ : std_logic;
SIGNAL \cnt[16]~423_combout\ : std_logic;
SIGNAL \cnt[0]~415\ : std_logic;
SIGNAL \cnt[16]~419_combout\ : std_logic;
SIGNAL \cnt~452_combout\ : std_logic;
SIGNAL \cnt~447_combout\ : std_logic;
SIGNAL \cnt~442_combout\ : std_logic;
SIGNAL \cnt~437_combout\ : std_logic;
SIGNAL \cnt~432_combout\ : std_logic;
SIGNAL \cnt~427_combout\ : std_logic;
SIGNAL \cnt~426_combout\ : std_logic;
SIGNAL \cnt~425_combout\ : std_logic;
SIGNAL \cnt~424_combout\ : std_logic;
SIGNAL \cnt[1]~353\ : std_logic;
SIGNAL \cnt[1]~353COUT1_481\ : std_logic;
SIGNAL \cnt[2]~355\ : std_logic;
SIGNAL \cnt[2]~355COUT1_483\ : std_logic;
SIGNAL \cnt[3]~357\ : std_logic;
SIGNAL \cnt[3]~357COUT1_485\ : std_logic;
SIGNAL \cnt[4]~359\ : std_logic;
SIGNAL \cnt[4]~359COUT1_487\ : std_logic;
SIGNAL \cnt[5]~361\ : std_logic;
SIGNAL \cnt~431_combout\ : std_logic;
SIGNAL \cnt~430_combout\ : std_logic;
SIGNAL \cnt~429_combout\ : std_logic;
SIGNAL \cnt~428_combout\ : std_logic;
SIGNAL \cnt[6]~363\ : std_logic;
SIGNAL \cnt[6]~363COUT1_489\ : std_logic;
SIGNAL \cnt[7]~365\ : std_logic;
SIGNAL \cnt[7]~365COUT1_491\ : std_logic;
SIGNAL \cnt[8]~367\ : std_logic;
SIGNAL \cnt[8]~367COUT1_493\ : std_logic;
SIGNAL \cnt[9]~369\ : std_logic;
SIGNAL \cnt[9]~369COUT1_495\ : std_logic;
SIGNAL \cnt[10]~371\ : std_logic;
SIGNAL \cnt~436_combout\ : std_logic;
SIGNAL \cnt~435_combout\ : std_logic;
SIGNAL \cnt~434_combout\ : std_logic;
SIGNAL \cnt~433_combout\ : std_logic;
SIGNAL \cnt[11]~373\ : std_logic;
SIGNAL \cnt[11]~373COUT1_497\ : std_logic;
SIGNAL \cnt[12]~375\ : std_logic;
SIGNAL \cnt[12]~375COUT1_499\ : std_logic;
SIGNAL \cnt[13]~377\ : std_logic;
SIGNAL \cnt[13]~377COUT1_501\ : std_logic;
SIGNAL \cnt[14]~379\ : std_logic;
SIGNAL \cnt[14]~379COUT1_503\ : std_logic;
SIGNAL \cnt[15]~381\ : std_logic;
SIGNAL \cnt~441_combout\ : std_logic;
SIGNAL \cnt~440_combout\ : std_logic;
SIGNAL \cnt~439_combout\ : std_logic;
SIGNAL \cnt~438_combout\ : std_logic;
SIGNAL \cnt[16]~383\ : std_logic;
SIGNAL \cnt[16]~383COUT1_505\ : std_logic;
SIGNAL \cnt[17]~385\ : std_logic;
SIGNAL \cnt[17]~385COUT1_507\ : std_logic;
SIGNAL \cnt[18]~387\ : std_logic;
SIGNAL \cnt[18]~387COUT1_509\ : std_logic;
SIGNAL \cnt[19]~389\ : std_logic;
SIGNAL \cnt[19]~389COUT1_511\ : std_logic;
SIGNAL \cnt[20]~391\ : std_logic;
SIGNAL \cnt~446_combout\ : std_logic;
SIGNAL \cnt~445_combout\ : std_logic;
SIGNAL \cnt~444_combout\ : std_logic;
SIGNAL \cnt~443_combout\ : std_logic;
SIGNAL \cnt[21]~393\ : std_logic;
SIGNAL \cnt[21]~393COUT1_513\ : std_logic;
SIGNAL \cnt[22]~395\ : std_logic;
SIGNAL \cnt[22]~395COUT1_515\ : std_logic;
SIGNAL \cnt[23]~397\ : std_logic;
SIGNAL \cnt[23]~397COUT1_517\ : std_logic;
SIGNAL \cnt[24]~399\ : std_logic;
SIGNAL \cnt[24]~399COUT1_519\ : std_logic;
SIGNAL \cnt[25]~401\ : std_logic;
SIGNAL \cnt~451_combout\ : std_logic;
SIGNAL \cnt~449_combout\ : std_logic;
SIGNAL \cnt~448_combout\ : std_logic;
SIGNAL \cnt[26]~403\ : std_logic;
SIGNAL \cnt[26]~403COUT1_521\ : std_logic;
SIGNAL \cnt[27]~405\ : std_logic;
SIGNAL \cnt[27]~405COUT1_523\ : std_logic;
SIGNAL \cnt[28]~409\ : std_logic;
SIGNAL \cnt[28]~409COUT1_525\ : std_logic;
SIGNAL \cnt~450_combout\ : std_logic;
SIGNAL \cnt[29]~411\ : std_logic;
SIGNAL \cnt[29]~411COUT1_527\ : std_logic;
SIGNAL \LessThan0~7_combout\ : std_logic;
SIGNAL \LessThan0~8_combout\ : std_logic;
SIGNAL \LessThan0~5_combout\ : std_logic;
SIGNAL \LessThan0~6_combout\ : std_logic;
SIGNAL \LessThan0~0_combout\ : std_logic;
SIGNAL \LessThan0~3_combout\ : std_logic;
SIGNAL \LessThan0~2_combout\ : std_logic;
SIGNAL \LessThan0~1_combout\ : std_logic;
SIGNAL \LessThan0~4_combout\ : std_logic;
SIGNAL \LessThan0~9_combout\ : std_logic;
SIGNAL \cnt~453_combout\ : std_logic;
SIGNAL \cnt[30]~407\ : std_logic;
SIGNAL \cnt[16]~416_combout\ : std_logic;
SIGNAL \cnt[16]~418_combout\ : std_logic;
SIGNAL \cnt[16]~420_combout\ : std_logic;
SIGNAL \LessThan0~10_combout\ : std_logic;
SIGNAL \alarm~14_combout\ : std_logic;
SIGNAL \alarm~13_combout\ : std_logic;
SIGNAL \alarm~reg0_regout\ : std_logic;
SIGNAL \unlock~5_combout\ : std_logic;
SIGNAL \unlock~reg0_regout\ : std_logic;
SIGNAL cnt : std_logic_vector(31 DOWNTO 0);
SIGNAL \code~combout\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \mode~combout\ : std_logic_vector(1 DOWNTO 0);
SIGNAL state : std_logic_vector(31 DOWNTO 0);
SIGNAL \ALT_INV_clk~combout\ : std_logic;
SIGNAL \ALT_INV_rst~combout\ : std_logic;

BEGIN

ww_code <= code;
ww_mode <= mode;
ww_clk <= clk;
ww_rst <= rst;
unlock <= ww_unlock;
alarm <= ww_alarm;
err <= ww_err;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_clk~combout\ <= NOT \clk~combout\;
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

\cnt~454\ : maxii_lcell
-- Equation(s):
-- \cnt~454_combout\ = !\alarm~reg0_regout\ & (cnt(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3300",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datad => cnt(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~454_combout\);

\rst~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_rst,
	combout => \rst~combout\);

\cnt~417\ : maxii_lcell
-- Equation(s):
-- \cnt~417_combout\ = !\alarm~reg0_regout\ & (cnt(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5500",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \alarm~reg0_regout\,
	datad => cnt(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~417_combout\);

\mode[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_mode(0),
	combout => \mode~combout\(0));

\mode[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_mode(1),
	combout => \mode~combout\(1));

\Selector2~0\ : maxii_lcell
-- Equation(s):
-- \Selector2~0_combout\ = state(0) & (state(1) # state(2)) # !state(0) & (!state(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f0af",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => state(1),
	datac => state(0),
	datad => state(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector2~0_combout\);

\Equal5~0\ : maxii_lcell
-- Equation(s):
-- \Equal5~0_combout\ = \mode~combout\(0) & !\mode~combout\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "2222",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \mode~combout\(0),
	datab => \mode~combout\(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal5~0_combout\);

\Equal10~0\ : maxii_lcell
-- Equation(s):
-- \Equal10~0_combout\ = !state(0) & state(2) & state(1)

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
	datab => state(0),
	datac => state(2),
	datad => state(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal10~0_combout\);

\Equal10~1\ : maxii_lcell
-- Equation(s):
-- \Equal10~1_combout\ = state(0) & state(1) & (!state(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0088",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => state(0),
	datab => state(1),
	datad => state(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal10~1_combout\);

\pwd[3][31]~384\ : maxii_lcell
-- Equation(s):
-- \pwd[3][31]~384_combout\ = !\process_0~1_combout\ & \Equal10~1_combout\ & !\alarm~reg0_regout\ & \rst~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0400",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \process_0~1_combout\,
	datab => \Equal10~1_combout\,
	datac => \alarm~reg0_regout\,
	datad => \rst~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \pwd[3][31]~384_combout\);

\pwd[3][31]\ : maxii_lcell
-- Equation(s):
-- \pwd[3][31]~regout\ = DFFEAS(VCC, !GLOBAL(\clk~combout\), VCC, , \pwd[3][31]~384_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	aclr => GND,
	ena => \pwd[3][31]~384_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[3][31]~regout\);

\code[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_code(1),
	combout => \code~combout\(1));

\pwd[3][1]\ : maxii_lcell
-- Equation(s):
-- \pwd[3][1]~regout\ = DFFEAS(\code~combout\(1), !GLOBAL(\clk~combout\), VCC, , \pwd[3][31]~384_combout\, , , , )

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
	clk => \ALT_INV_clk~combout\,
	datad => \code~combout\(1),
	aclr => GND,
	ena => \pwd[3][31]~384_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[3][1]~regout\);

\code[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_code(3),
	combout => \code~combout\(3));

\pwd[3][3]\ : maxii_lcell
-- Equation(s):
-- \Equal9~0\ = \code~combout\(1) & \pwd[3][1]~regout\ & (pwd[3][3] $ !\code~combout\(3)) # !\code~combout\(1) & !\pwd[3][1]~regout\ & (pwd[3][3] $ !\code~combout\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "9009",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \code~combout\(1),
	datab => \pwd[3][1]~regout\,
	datac => \code~combout\(3),
	datad => \code~combout\(3),
	aclr => GND,
	sload => VCC,
	ena => \pwd[3][31]~384_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal9~0\,
	regout => \pwd[3][3]~regout\);

\code[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_code(0),
	combout => \code~combout\(0));

\pwd[3][0]\ : maxii_lcell
-- Equation(s):
-- \pwd[3][0]~regout\ = DFFEAS(!\code~combout\(0), !GLOBAL(\clk~combout\), VCC, , \pwd[3][31]~384_combout\, , , , )

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
	clk => \ALT_INV_clk~combout\,
	datac => \code~combout\(0),
	aclr => GND,
	ena => \pwd[3][31]~384_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[3][0]~regout\);

\code[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_code(2),
	combout => \code~combout\(2));

\pwd[3][2]\ : maxii_lcell
-- Equation(s):
-- \Equal9~1\ = \pwd[3][0]~regout\ & !\code~combout\(0) & (\code~combout\(2) $ !pwd[3][2]) # !\pwd[3][0]~regout\ & \code~combout\(0) & (\code~combout\(2) $ !pwd[3][2])

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4182",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \pwd[3][0]~regout\,
	datab => \code~combout\(2),
	datac => \code~combout\(2),
	datad => \code~combout\(0),
	aclr => GND,
	sload => VCC,
	ena => \pwd[3][31]~384_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal9~1\,
	regout => \pwd[3][2]~regout\);

\Selector32~0\ : maxii_lcell
-- Equation(s):
-- \Selector32~0_combout\ = \Equal10~0_combout\ & \pwd[3][31]~regout\ & \Equal9~0\ & \Equal9~1\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \Equal10~0_combout\,
	datab => \pwd[3][31]~regout\,
	datac => \Equal9~0\,
	datad => \Equal9~1\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector32~0_combout\);

\Selector36~2\ : maxii_lcell
-- Equation(s):
-- \Selector36~2_combout\ = !state(1) & state(2) & !state(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0030",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => state(1),
	datac => state(2),
	datad => state(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector36~2_combout\);

\pwd[0][31]~386\ : maxii_lcell
-- Equation(s):
-- \pwd[0][31]~386_combout\ = !\process_0~1_combout\ & \rst~combout\ & !\alarm~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0404",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \process_0~1_combout\,
	datab => \rst~combout\,
	datac => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \pwd[0][31]~386_combout\);

\pwd[1][31]~388\ : maxii_lcell
-- Equation(s):
-- \pwd[1][31]~388_combout\ = !state(1) & \pwd[0][31]~386_combout\ & state(0) & !state(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0040",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => state(1),
	datab => \pwd[0][31]~386_combout\,
	datac => state(0),
	datad => state(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \pwd[1][31]~388_combout\);

\pwd[1][31]\ : maxii_lcell
-- Equation(s):
-- \pwd[1][31]~regout\ = DFFEAS(VCC, !GLOBAL(\clk~combout\), VCC, , \pwd[1][31]~388_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	aclr => GND,
	ena => \pwd[1][31]~388_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[1][31]~regout\);

\pwd[1][0]\ : maxii_lcell
-- Equation(s):
-- \pwd[1][0]~regout\ = DFFEAS(!\code~combout\(0), !GLOBAL(\clk~combout\), VCC, , \pwd[1][31]~388_combout\, , , , )

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
	clk => \ALT_INV_clk~combout\,
	datad => \code~combout\(0),
	aclr => GND,
	ena => \pwd[1][31]~388_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[1][0]~regout\);

\pwd[1][2]\ : maxii_lcell
-- Equation(s):
-- \Equal7~1\ = \code~combout\(2) & pwd[1][2] & (\code~combout\(0) $ \pwd[1][0]~regout\) # !\code~combout\(2) & !pwd[1][2] & (\code~combout\(0) $ \pwd[1][0]~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "2184",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \code~combout\(2),
	datab => \code~combout\(0),
	datac => \code~combout\(2),
	datad => \pwd[1][0]~regout\,
	aclr => GND,
	sload => VCC,
	ena => \pwd[1][31]~388_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal7~1\,
	regout => \pwd[1][2]~regout\);

\pwd[1][3]\ : maxii_lcell
-- Equation(s):
-- \pwd[1][3]~regout\ = DFFEAS(\code~combout\(3), !GLOBAL(\clk~combout\), VCC, , \pwd[1][31]~388_combout\, , , , )

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
	clk => \ALT_INV_clk~combout\,
	datad => \code~combout\(3),
	aclr => GND,
	ena => \pwd[1][31]~388_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[1][3]~regout\);

\pwd[1][1]\ : maxii_lcell
-- Equation(s):
-- \Equal7~0\ = \code~combout\(3) & \pwd[1][3]~regout\ & (\code~combout\(1) $ !pwd[1][1]) # !\code~combout\(3) & !\pwd[1][3]~regout\ & (\code~combout\(1) $ !pwd[1][1])

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8241",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \code~combout\(3),
	datab => \code~combout\(1),
	datac => \code~combout\(1),
	datad => \pwd[1][3]~regout\,
	aclr => GND,
	sload => VCC,
	ena => \pwd[1][31]~388_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal7~0\,
	regout => \pwd[1][1]~regout\);

\Selector32~2\ : maxii_lcell
-- Equation(s):
-- \Selector32~2_combout\ = \Selector36~2_combout\ & \pwd[1][31]~regout\ & \Equal7~1\ & \Equal7~0\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \Selector36~2_combout\,
	datab => \pwd[1][31]~regout\,
	datac => \Equal7~1\,
	datad => \Equal7~0\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector32~2_combout\);

\Selector34~0\ : maxii_lcell
-- Equation(s):
-- \Selector34~0_combout\ = \Selector32~0_combout\ # \Selector32~2_combout\ # state(0) & \WideNor1~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fff8",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => state(0),
	datab => \WideNor1~0_combout\,
	datac => \Selector32~0_combout\,
	datad => \Selector32~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector34~0_combout\);

\state~221\ : maxii_lcell
-- Equation(s):
-- \state~221_combout\ = \mode~combout\(0) # !\err~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff0f",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \err~reg0_regout\,
	datad => \mode~combout\(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \state~221_combout\);

\state~222\ : maxii_lcell
-- Equation(s):
-- \state~222_combout\ = \alarm~reg0_regout\ & (!\alarm~14_combout\) # !\alarm~reg0_regout\ & \state~221_combout\ & !\mode~combout\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "04ae",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \alarm~reg0_regout\,
	datab => \state~221_combout\,
	datac => \mode~combout\(1),
	datad => \alarm~14_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \state~222_combout\);

\state[0]\ : maxii_lcell
-- Equation(s):
-- state(0) = DFFEAS(\process_0~1_combout\ & (\Equal5~0_combout\ & (\Selector34~0_combout\) # !\Equal5~0_combout\ & \Selector2~0_combout\) # !\process_0~1_combout\ & \Selector2~0_combout\, !GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \state~222_combout\, 
-- , , \alarm~reg0_regout\, )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ea2a",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \Selector2~0_combout\,
	datab => \process_0~1_combout\,
	datac => \Equal5~0_combout\,
	datad => \Selector34~0_combout\,
	aclr => \ALT_INV_rst~combout\,
	sclr => \alarm~reg0_regout\,
	ena => \state~222_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => state(0));

\err~5\ : maxii_lcell
-- Equation(s):
-- \err~5_combout\ = state(1) # state(0) # state(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fffa",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => state(1),
	datac => state(0),
	datad => state(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \err~5_combout\);

\err~6\ : maxii_lcell
-- Equation(s):
-- \err~6_combout\ = \mode~combout\(0) & !\mode~combout\(1) & !\alarm~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0202",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \mode~combout\(0),
	datab => \mode~combout\(1),
	datac => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \err~6_combout\);

\Selector36~0\ : maxii_lcell
-- Equation(s):
-- \Selector36~0_combout\ = !state(1) & !state(2) & !state(0)

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
	datab => state(1),
	datac => state(2),
	datad => state(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector36~0_combout\);

\pwd[2][31]~387\ : maxii_lcell
-- Equation(s):
-- \pwd[2][31]~387_combout\ = state(1) & \pwd[0][31]~386_combout\ & !state(0) & !state(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0008",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => state(1),
	datab => \pwd[0][31]~386_combout\,
	datac => state(0),
	datad => state(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \pwd[2][31]~387_combout\);

\pwd[2][31]\ : maxii_lcell
-- Equation(s):
-- \pwd[2][31]~regout\ = DFFEAS(VCC, !GLOBAL(\clk~combout\), VCC, , \pwd[2][31]~387_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	aclr => GND,
	ena => \pwd[2][31]~387_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[2][31]~regout\);

\pwd[2][0]\ : maxii_lcell
-- Equation(s):
-- \pwd[2][0]~regout\ = DFFEAS(!\code~combout\(0), !GLOBAL(\clk~combout\), VCC, , \pwd[2][31]~387_combout\, , , , )

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
	clk => \ALT_INV_clk~combout\,
	datac => \code~combout\(0),
	aclr => GND,
	ena => \pwd[2][31]~387_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[2][0]~regout\);

\pwd[2][2]\ : maxii_lcell
-- Equation(s):
-- \Equal8~1\ = \pwd[2][0]~regout\ & !\code~combout\(0) & (\code~combout\(2) $ !pwd[2][2]) # !\pwd[2][0]~regout\ & \code~combout\(0) & (\code~combout\(2) $ !pwd[2][2])

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4182",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \pwd[2][0]~regout\,
	datab => \code~combout\(2),
	datac => \code~combout\(2),
	datad => \code~combout\(0),
	aclr => GND,
	sload => VCC,
	ena => \pwd[2][31]~387_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal8~1\,
	regout => \pwd[2][2]~regout\);

\pwd[2][3]\ : maxii_lcell
-- Equation(s):
-- \pwd[2][3]~regout\ = DFFEAS(\code~combout\(3), !GLOBAL(\clk~combout\), VCC, , \pwd[2][31]~387_combout\, , , , )

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
	clk => \ALT_INV_clk~combout\,
	datad => \code~combout\(3),
	aclr => GND,
	ena => \pwd[2][31]~387_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[2][3]~regout\);

\pwd[2][1]\ : maxii_lcell
-- Equation(s):
-- \Equal8~0\ = \code~combout\(1) & pwd[2][1] & (\pwd[2][3]~regout\ $ !\code~combout\(3)) # !\code~combout\(1) & !pwd[2][1] & (\pwd[2][3]~regout\ $ !\code~combout\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8421",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \code~combout\(1),
	datab => \pwd[2][3]~regout\,
	datac => \code~combout\(1),
	datad => \code~combout\(3),
	aclr => GND,
	sload => VCC,
	ena => \pwd[2][31]~387_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal8~0\,
	regout => \pwd[2][1]~regout\);

\Equal8~2\ : maxii_lcell
-- Equation(s):
-- \Equal8~2_combout\ = \pwd[2][31]~regout\ & \Equal8~1\ & \Equal8~0\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \pwd[2][31]~regout\,
	datac => \Equal8~1\,
	datad => \Equal8~0\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal8~2_combout\);

\Selector36~1\ : maxii_lcell
-- Equation(s):
-- \Selector36~1_combout\ = state(2) & state(0) & !state(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00c0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => state(2),
	datac => state(0),
	datad => state(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector36~1_combout\);

\pwd[0][31]~385\ : maxii_lcell
-- Equation(s):
-- \pwd[0][31]~385_combout\ = !\alarm~reg0_regout\ & \rst~combout\ & \Selector36~0_combout\ & !\process_0~1_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0040",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \alarm~reg0_regout\,
	datab => \rst~combout\,
	datac => \Selector36~0_combout\,
	datad => \process_0~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \pwd[0][31]~385_combout\);

\pwd[0][31]\ : maxii_lcell
-- Equation(s):
-- \pwd[0][31]~regout\ = DFFEAS(VCC, !GLOBAL(\clk~combout\), VCC, , \pwd[0][31]~385_combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffff",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	aclr => GND,
	ena => \pwd[0][31]~385_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[0][31]~regout\);

\pwd[0][0]\ : maxii_lcell
-- Equation(s):
-- \pwd[0][0]~regout\ = DFFEAS(!\code~combout\(0), !GLOBAL(\clk~combout\), VCC, , \pwd[0][31]~385_combout\, , , , )

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
	clk => \ALT_INV_clk~combout\,
	datad => \code~combout\(0),
	aclr => GND,
	ena => \pwd[0][31]~385_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[0][0]~regout\);

\pwd[0][2]\ : maxii_lcell
-- Equation(s):
-- \Equal6~1\ = \code~combout\(2) & pwd[0][2] & (\code~combout\(0) $ \pwd[0][0]~regout\) # !\code~combout\(2) & !pwd[0][2] & (\code~combout\(0) $ \pwd[0][0]~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "2184",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \code~combout\(2),
	datab => \code~combout\(0),
	datac => \code~combout\(2),
	datad => \pwd[0][0]~regout\,
	aclr => GND,
	sload => VCC,
	ena => \pwd[0][31]~385_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal6~1\,
	regout => \pwd[0][2]~regout\);

\pwd[0][3]\ : maxii_lcell
-- Equation(s):
-- \pwd[0][3]~regout\ = DFFEAS(\code~combout\(3), !GLOBAL(\clk~combout\), VCC, , \pwd[0][31]~385_combout\, , , , )

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
	clk => \ALT_INV_clk~combout\,
	datad => \code~combout\(3),
	aclr => GND,
	ena => \pwd[0][31]~385_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \pwd[0][3]~regout\);

\pwd[0][1]\ : maxii_lcell
-- Equation(s):
-- \Equal6~0\ = \code~combout\(3) & \pwd[0][3]~regout\ & (\code~combout\(1) $ !pwd[0][1]) # !\code~combout\(3) & !\pwd[0][3]~regout\ & (\code~combout\(1) $ !pwd[0][1])

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8241",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "qfbk",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \code~combout\(3),
	datab => \code~combout\(1),
	datac => \code~combout\(1),
	datad => \pwd[0][3]~regout\,
	aclr => GND,
	sload => VCC,
	ena => \pwd[0][31]~385_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal6~0\,
	regout => \pwd[0][1]~regout\);

\Equal6~2\ : maxii_lcell
-- Equation(s):
-- \Equal6~2_combout\ = \pwd[0][31]~regout\ & (\Equal6~1\ & \Equal6~0\)

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
	dataa => \pwd[0][31]~regout\,
	datac => \Equal6~1\,
	datad => \Equal6~0\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal6~2_combout\);

\alarm~10\ : maxii_lcell
-- Equation(s):
-- \alarm~10_combout\ = \Selector36~0_combout\ & (!\Equal8~2_combout\ & \Selector36~1_combout\ # !\Equal6~2_combout\) # !\Selector36~0_combout\ & !\Equal8~2_combout\ & \Selector36~1_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "30ba",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \Selector36~0_combout\,
	datab => \Equal8~2_combout\,
	datac => \Selector36~1_combout\,
	datad => \Equal6~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \alarm~10_combout\);

\Equal9~2\ : maxii_lcell
-- Equation(s):
-- \Equal9~2_combout\ = \pwd[3][31]~regout\ & \Equal9~0\ & \Equal9~1\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \pwd[3][31]~regout\,
	datac => \Equal9~0\,
	datad => \Equal9~1\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal9~2_combout\);

\Equal7~2\ : maxii_lcell
-- Equation(s):
-- \Equal7~2_combout\ = \pwd[1][31]~regout\ & (\Equal7~1\ & \Equal7~0\)

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
	dataa => \pwd[1][31]~regout\,
	datac => \Equal7~1\,
	datad => \Equal7~0\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Equal7~2_combout\);

\alarm~11\ : maxii_lcell
-- Equation(s):
-- \alarm~11_combout\ = \Selector36~2_combout\ & (\Equal10~0_combout\ & !\Equal9~2_combout\ # !\Equal7~2_combout\) # !\Selector36~2_combout\ & \Equal10~0_combout\ & !\Equal9~2_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0cae",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \Selector36~2_combout\,
	datab => \Equal10~0_combout\,
	datac => \Equal9~2_combout\,
	datad => \Equal7~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \alarm~11_combout\);

\alarm~12\ : maxii_lcell
-- Equation(s):
-- \alarm~12_combout\ = !\alarm~reg0_regout\ & \Equal5~0_combout\ & (\alarm~10_combout\ # \alarm~11_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "4440",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \alarm~reg0_regout\,
	datab => \Equal5~0_combout\,
	datac => \alarm~10_combout\,
	datad => \alarm~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \alarm~12_combout\);

\err~reg0\ : maxii_lcell
-- Equation(s):
-- \err~reg0_regout\ = DFFEAS(\alarm~12_combout\ # \err~reg0_regout\ & (\err~5_combout\ # !\err~6_combout\), !GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff8a",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \err~reg0_regout\,
	datab => \err~5_combout\,
	datac => \err~6_combout\,
	datad => \alarm~12_combout\,
	aclr => \ALT_INV_rst~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \err~reg0_regout\);

\process_0~1\ : maxii_lcell
-- Equation(s):
-- \process_0~1_combout\ = \mode~combout\(0) # \mode~combout\(1) # \err~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffee",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \mode~combout\(0),
	datab => \mode~combout\(1),
	datad => \err~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \process_0~1_combout\);

\Selector1~0\ : maxii_lcell
-- Equation(s):
-- \Selector1~0_combout\ = state(1) # state(0) & !state(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "aafa",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => state(1),
	datac => state(0),
	datad => state(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector1~0_combout\);

\Selector32~1\ : maxii_lcell
-- Equation(s):
-- \Selector32~1_combout\ = !\Selector32~0_combout\ & (!\Selector36~1_combout\ # !\Equal8~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "030f",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \Equal8~2_combout\,
	datac => \Selector32~0_combout\,
	datad => \Selector36~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector32~1_combout\);

\Selector33~2\ : maxii_lcell
-- Equation(s):
-- \Selector33~2_combout\ = state(1) & (state(0) # !state(2)) # !\Selector32~1_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "a2ff",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => state(1),
	datab => state(2),
	datac => state(0),
	datad => \Selector32~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector33~2_combout\);

\state[1]\ : maxii_lcell
-- Equation(s):
-- state(1) = DFFEAS(\process_0~1_combout\ & (\Equal5~0_combout\ & (\Selector33~2_combout\) # !\Equal5~0_combout\ & \Selector1~0_combout\) # !\process_0~1_combout\ & \Selector1~0_combout\, !GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \state~222_combout\, 
-- , , \alarm~reg0_regout\, )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ec4c",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \process_0~1_combout\,
	datab => \Selector1~0_combout\,
	datac => \Equal5~0_combout\,
	datad => \Selector33~2_combout\,
	aclr => \ALT_INV_rst~combout\,
	sclr => \alarm~reg0_regout\,
	ena => \state~222_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => state(1));

\Selector0~0\ : maxii_lcell
-- Equation(s):
-- \Selector0~0_combout\ = state(2) # state(1) & state(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffa0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => state(1),
	datac => state(0),
	datad => state(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector0~0_combout\);

\Selector32~3\ : maxii_lcell
-- Equation(s):
-- \Selector32~3_combout\ = \Selector32~2_combout\ # \Selector36~0_combout\ & \Equal6~2_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ffc0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \Selector36~0_combout\,
	datac => \Equal6~2_combout\,
	datad => \Selector32~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector32~3_combout\);

\Selector32~4\ : maxii_lcell
-- Equation(s):
-- \Selector32~4_combout\ = \Selector32~3_combout\ # state(2) & \WideNor1~0_combout\ # !\Selector32~1_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ff8f",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => state(2),
	datab => \WideNor1~0_combout\,
	datac => \Selector32~1_combout\,
	datad => \Selector32~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \Selector32~4_combout\);

\state[2]\ : maxii_lcell
-- Equation(s):
-- state(2) = DFFEAS(\process_0~1_combout\ & (\Equal5~0_combout\ & (\Selector32~4_combout\) # !\Equal5~0_combout\ & \Selector0~0_combout\) # !\process_0~1_combout\ & \Selector0~0_combout\, !GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , \state~222_combout\, 
-- , , \alarm~reg0_regout\, )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ea2a",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "on")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \Selector0~0_combout\,
	datab => \process_0~1_combout\,
	datac => \Equal5~0_combout\,
	datad => \Selector32~4_combout\,
	aclr => \ALT_INV_rst~combout\,
	sclr => \alarm~reg0_regout\,
	ena => \state~222_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => state(2));

\WideNor1~0\ : maxii_lcell
-- Equation(s):
-- \WideNor1~0_combout\ = state(2) & state(0) & state(1) # !state(2) & (state(0) # state(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f330",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => state(2),
	datac => state(0),
	datad => state(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \WideNor1~0_combout\);

\cnt[16]~422\ : maxii_lcell
-- Equation(s):
-- \cnt[16]~422_combout\ = \WideNor1~0_combout\ # \Selector36~0_combout\ & \Equal6~2_combout\ # !\Equal5~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "efaf",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \WideNor1~0_combout\,
	datab => \Selector36~0_combout\,
	datac => \Equal5~0_combout\,
	datad => \Equal6~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt[16]~422_combout\);

\cnt[16]~421\ : maxii_lcell
-- Equation(s):
-- \cnt[16]~421_combout\ = !\Selector36~0_combout\ & (\Selector36~1_combout\ & (\Equal8~2_combout\) # !\Selector36~1_combout\ & \Selector32~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3210",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \Selector36~1_combout\,
	datab => \Selector36~0_combout\,
	datac => \Selector32~2_combout\,
	datad => \Equal8~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt[16]~421_combout\);

\cnt[16]~423\ : maxii_lcell
-- Equation(s):
-- \cnt[16]~423_combout\ = \alarm~reg0_regout\ # !\cnt[16]~422_combout\ & !\cnt[16]~421_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "cccf",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datac => \cnt[16]~422_combout\,
	datad => \cnt[16]~421_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt[16]~423_combout\);

\cnt[0]\ : maxii_lcell
-- Equation(s):
-- cnt(0) = DFFEAS(!cnt(0), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~454_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[0]~415\ = CARRY(cnt(0))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(0),
	datac => \cnt~454_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(0),
	cout => \cnt[0]~415\);

\cnt[1]\ : maxii_lcell
-- Equation(s):
-- cnt(1) = DFFEAS(cnt(1) $ (\cnt[0]~415\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~417_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[1]~353\ = CARRY(!\cnt[0]~415\ # !cnt(1))
-- \cnt[1]~353COUT1_481\ = CARRY(!\cnt[0]~415\ # !cnt(1))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(1),
	datac => \cnt~417_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[0]~415\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(1),
	cout0 => \cnt[1]~353\,
	cout1 => \cnt[1]~353COUT1_481\);

\cnt[16]~419\ : maxii_lcell
-- Equation(s):
-- \cnt[16]~419_combout\ = cnt(1) & (cnt(0) # !\alarm~reg0_regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "a0f0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => cnt(0),
	datac => cnt(1),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt[16]~419_combout\);

\cnt~452\ : maxii_lcell
-- Equation(s):
-- \cnt~452_combout\ = !\alarm~reg0_regout\ & (cnt(29))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3300",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datad => cnt(29),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~452_combout\);

\cnt~447\ : maxii_lcell
-- Equation(s):
-- \cnt~447_combout\ = !\alarm~reg0_regout\ & (cnt(25))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3300",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datad => cnt(25),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~447_combout\);

\cnt~442\ : maxii_lcell
-- Equation(s):
-- \cnt~442_combout\ = cnt(20) & !\alarm~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00f0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => cnt(20),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~442_combout\);

\cnt~437\ : maxii_lcell
-- Equation(s):
-- \cnt~437_combout\ = !\alarm~reg0_regout\ & cnt(15)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0f00",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \alarm~reg0_regout\,
	datad => cnt(15),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~437_combout\);

\cnt~432\ : maxii_lcell
-- Equation(s):
-- \cnt~432_combout\ = !\alarm~reg0_regout\ & (cnt(10))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3300",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datad => cnt(10),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~432_combout\);

\cnt~427\ : maxii_lcell
-- Equation(s):
-- \cnt~427_combout\ = !\alarm~reg0_regout\ & (cnt(5))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3300",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datad => cnt(5),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~427_combout\);

\cnt~426\ : maxii_lcell
-- Equation(s):
-- \cnt~426_combout\ = cnt(4) & (!\alarm~reg0_regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0a0a",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => cnt(4),
	datac => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~426_combout\);

\cnt~425\ : maxii_lcell
-- Equation(s):
-- \cnt~425_combout\ = cnt(3) & !\alarm~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00f0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => cnt(3),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~425_combout\);

\cnt~424\ : maxii_lcell
-- Equation(s):
-- \cnt~424_combout\ = !\alarm~reg0_regout\ & cnt(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3030",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datac => cnt(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~424_combout\);

\cnt[2]\ : maxii_lcell
-- Equation(s):
-- cnt(2) = DFFEAS(cnt(2) $ (!(!\cnt[0]~415\ & \cnt[1]~353\) # (\cnt[0]~415\ & \cnt[1]~353COUT1_481\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~424_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[2]~355\ = CARRY(cnt(2) & (!\cnt[1]~353\))
-- \cnt[2]~355COUT1_483\ = CARRY(cnt(2) & (!\cnt[1]~353COUT1_481\))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(2),
	datac => \cnt~424_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[0]~415\,
	cin0 => \cnt[1]~353\,
	cin1 => \cnt[1]~353COUT1_481\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(2),
	cout0 => \cnt[2]~355\,
	cout1 => \cnt[2]~355COUT1_483\);

\cnt[3]\ : maxii_lcell
-- Equation(s):
-- cnt(3) = DFFEAS(cnt(3) $ (!\cnt[0]~415\ & \cnt[2]~355\) # (\cnt[0]~415\ & \cnt[2]~355COUT1_483\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~425_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[3]~357\ = CARRY(!\cnt[2]~355\ # !cnt(3))
-- \cnt[3]~357COUT1_485\ = CARRY(!\cnt[2]~355COUT1_483\ # !cnt(3))

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(3),
	datac => \cnt~425_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[0]~415\,
	cin0 => \cnt[2]~355\,
	cin1 => \cnt[2]~355COUT1_483\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(3),
	cout0 => \cnt[3]~357\,
	cout1 => \cnt[3]~357COUT1_485\);

\cnt[4]\ : maxii_lcell
-- Equation(s):
-- cnt(4) = DFFEAS(cnt(4) $ (!(!\cnt[0]~415\ & \cnt[3]~357\) # (\cnt[0]~415\ & \cnt[3]~357COUT1_485\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~426_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[4]~359\ = CARRY(cnt(4) & (!\cnt[3]~357\))
-- \cnt[4]~359COUT1_487\ = CARRY(cnt(4) & (!\cnt[3]~357COUT1_485\))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(4),
	datac => \cnt~426_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[0]~415\,
	cin0 => \cnt[3]~357\,
	cin1 => \cnt[3]~357COUT1_485\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(4),
	cout0 => \cnt[4]~359\,
	cout1 => \cnt[4]~359COUT1_487\);

\cnt[5]\ : maxii_lcell
-- Equation(s):
-- cnt(5) = DFFEAS(cnt(5) $ (!\cnt[0]~415\ & \cnt[4]~359\) # (\cnt[0]~415\ & \cnt[4]~359COUT1_487\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~427_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[5]~361\ = CARRY(!\cnt[4]~359COUT1_487\ # !cnt(5))

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(5),
	datac => \cnt~427_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[0]~415\,
	cin0 => \cnt[4]~359\,
	cin1 => \cnt[4]~359COUT1_487\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(5),
	cout => \cnt[5]~361\);

\cnt~431\ : maxii_lcell
-- Equation(s):
-- \cnt~431_combout\ = cnt(9) & (!\alarm~reg0_regout\)

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
	dataa => cnt(9),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~431_combout\);

\cnt~430\ : maxii_lcell
-- Equation(s):
-- \cnt~430_combout\ = !\alarm~reg0_regout\ & (cnt(8))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "5500",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \alarm~reg0_regout\,
	datad => cnt(8),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~430_combout\);

\cnt~429\ : maxii_lcell
-- Equation(s):
-- \cnt~429_combout\ = cnt(7) & !\alarm~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00f0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => cnt(7),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~429_combout\);

\cnt~428\ : maxii_lcell
-- Equation(s):
-- \cnt~428_combout\ = cnt(6) & !\alarm~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00f0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => cnt(6),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~428_combout\);

\cnt[6]\ : maxii_lcell
-- Equation(s):
-- cnt(6) = DFFEAS(cnt(6) $ !\cnt[5]~361\, !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~428_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[6]~363\ = CARRY(cnt(6) & !\cnt[5]~361\)
-- \cnt[6]~363COUT1_489\ = CARRY(cnt(6) & !\cnt[5]~361\)

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(6),
	datac => \cnt~428_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[5]~361\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(6),
	cout0 => \cnt[6]~363\,
	cout1 => \cnt[6]~363COUT1_489\);

\cnt[7]\ : maxii_lcell
-- Equation(s):
-- cnt(7) = DFFEAS(cnt(7) $ (!\cnt[5]~361\ & \cnt[6]~363\) # (\cnt[5]~361\ & \cnt[6]~363COUT1_489\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~429_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[7]~365\ = CARRY(!\cnt[6]~363\ # !cnt(7))
-- \cnt[7]~365COUT1_491\ = CARRY(!\cnt[6]~363COUT1_489\ # !cnt(7))

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(7),
	datac => \cnt~429_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[5]~361\,
	cin0 => \cnt[6]~363\,
	cin1 => \cnt[6]~363COUT1_489\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(7),
	cout0 => \cnt[7]~365\,
	cout1 => \cnt[7]~365COUT1_491\);

\cnt[8]\ : maxii_lcell
-- Equation(s):
-- cnt(8) = DFFEAS(cnt(8) $ !(!\cnt[5]~361\ & \cnt[7]~365\) # (\cnt[5]~361\ & \cnt[7]~365COUT1_491\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~430_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[8]~367\ = CARRY(cnt(8) & !\cnt[7]~365\)
-- \cnt[8]~367COUT1_493\ = CARRY(cnt(8) & !\cnt[7]~365COUT1_491\)

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(8),
	datac => \cnt~430_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[5]~361\,
	cin0 => \cnt[7]~365\,
	cin1 => \cnt[7]~365COUT1_491\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(8),
	cout0 => \cnt[8]~367\,
	cout1 => \cnt[8]~367COUT1_493\);

\cnt[9]\ : maxii_lcell
-- Equation(s):
-- cnt(9) = DFFEAS(cnt(9) $ ((!\cnt[5]~361\ & \cnt[8]~367\) # (\cnt[5]~361\ & \cnt[8]~367COUT1_493\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~431_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[9]~369\ = CARRY(!\cnt[8]~367\ # !cnt(9))
-- \cnt[9]~369COUT1_495\ = CARRY(!\cnt[8]~367COUT1_493\ # !cnt(9))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(9),
	datac => \cnt~431_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[5]~361\,
	cin0 => \cnt[8]~367\,
	cin1 => \cnt[8]~367COUT1_493\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(9),
	cout0 => \cnt[9]~369\,
	cout1 => \cnt[9]~369COUT1_495\);

\cnt[10]\ : maxii_lcell
-- Equation(s):
-- cnt(10) = DFFEAS(cnt(10) $ (!(!\cnt[5]~361\ & \cnt[9]~369\) # (\cnt[5]~361\ & \cnt[9]~369COUT1_495\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~432_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[10]~371\ = CARRY(cnt(10) & (!\cnt[9]~369COUT1_495\))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(10),
	datac => \cnt~432_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[5]~361\,
	cin0 => \cnt[9]~369\,
	cin1 => \cnt[9]~369COUT1_495\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(10),
	cout => \cnt[10]~371\);

\cnt~436\ : maxii_lcell
-- Equation(s):
-- \cnt~436_combout\ = !\alarm~reg0_regout\ & cnt(14)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0f00",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \alarm~reg0_regout\,
	datad => cnt(14),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~436_combout\);

\cnt~435\ : maxii_lcell
-- Equation(s):
-- \cnt~435_combout\ = !\alarm~reg0_regout\ & cnt(13)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3030",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datac => cnt(13),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~435_combout\);

\cnt~434\ : maxii_lcell
-- Equation(s):
-- \cnt~434_combout\ = cnt(12) & (!\alarm~reg0_regout\)

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
	dataa => cnt(12),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~434_combout\);

\cnt~433\ : maxii_lcell
-- Equation(s):
-- \cnt~433_combout\ = !\alarm~reg0_regout\ & (cnt(11))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3300",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datad => cnt(11),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~433_combout\);

\cnt[11]\ : maxii_lcell
-- Equation(s):
-- cnt(11) = DFFEAS(cnt(11) $ (\cnt[10]~371\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~433_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[11]~373\ = CARRY(!\cnt[10]~371\ # !cnt(11))
-- \cnt[11]~373COUT1_497\ = CARRY(!\cnt[10]~371\ # !cnt(11))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(11),
	datac => \cnt~433_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[10]~371\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(11),
	cout0 => \cnt[11]~373\,
	cout1 => \cnt[11]~373COUT1_497\);

\cnt[12]\ : maxii_lcell
-- Equation(s):
-- cnt(12) = DFFEAS(cnt(12) $ (!(!\cnt[10]~371\ & \cnt[11]~373\) # (\cnt[10]~371\ & \cnt[11]~373COUT1_497\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~434_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[12]~375\ = CARRY(cnt(12) & (!\cnt[11]~373\))
-- \cnt[12]~375COUT1_499\ = CARRY(cnt(12) & (!\cnt[11]~373COUT1_497\))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(12),
	datac => \cnt~434_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[10]~371\,
	cin0 => \cnt[11]~373\,
	cin1 => \cnt[11]~373COUT1_497\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(12),
	cout0 => \cnt[12]~375\,
	cout1 => \cnt[12]~375COUT1_499\);

\cnt[13]\ : maxii_lcell
-- Equation(s):
-- cnt(13) = DFFEAS(cnt(13) $ (!\cnt[10]~371\ & \cnt[12]~375\) # (\cnt[10]~371\ & \cnt[12]~375COUT1_499\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~435_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[13]~377\ = CARRY(!\cnt[12]~375\ # !cnt(13))
-- \cnt[13]~377COUT1_501\ = CARRY(!\cnt[12]~375COUT1_499\ # !cnt(13))

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(13),
	datac => \cnt~435_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[10]~371\,
	cin0 => \cnt[12]~375\,
	cin1 => \cnt[12]~375COUT1_499\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(13),
	cout0 => \cnt[13]~377\,
	cout1 => \cnt[13]~377COUT1_501\);

\cnt[14]\ : maxii_lcell
-- Equation(s):
-- cnt(14) = DFFEAS(cnt(14) $ (!(!\cnt[10]~371\ & \cnt[13]~377\) # (\cnt[10]~371\ & \cnt[13]~377COUT1_501\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~436_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[14]~379\ = CARRY(cnt(14) & (!\cnt[13]~377\))
-- \cnt[14]~379COUT1_503\ = CARRY(cnt(14) & (!\cnt[13]~377COUT1_501\))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(14),
	datac => \cnt~436_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[10]~371\,
	cin0 => \cnt[13]~377\,
	cin1 => \cnt[13]~377COUT1_501\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(14),
	cout0 => \cnt[14]~379\,
	cout1 => \cnt[14]~379COUT1_503\);

\cnt[15]\ : maxii_lcell
-- Equation(s):
-- cnt(15) = DFFEAS(cnt(15) $ (!\cnt[10]~371\ & \cnt[14]~379\) # (\cnt[10]~371\ & \cnt[14]~379COUT1_503\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~437_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[15]~381\ = CARRY(!\cnt[14]~379COUT1_503\ # !cnt(15))

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(15),
	datac => \cnt~437_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[10]~371\,
	cin0 => \cnt[14]~379\,
	cin1 => \cnt[14]~379COUT1_503\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(15),
	cout => \cnt[15]~381\);

\cnt~441\ : maxii_lcell
-- Equation(s):
-- \cnt~441_combout\ = cnt(19) & !\alarm~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00f0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => cnt(19),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~441_combout\);

\cnt~440\ : maxii_lcell
-- Equation(s):
-- \cnt~440_combout\ = cnt(18) & (!\alarm~reg0_regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00cc",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => cnt(18),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~440_combout\);

\cnt~439\ : maxii_lcell
-- Equation(s):
-- \cnt~439_combout\ = cnt(17) & (!\alarm~reg0_regout\)

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
	dataa => cnt(17),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~439_combout\);

\cnt~438\ : maxii_lcell
-- Equation(s):
-- \cnt~438_combout\ = cnt(16) & (!\alarm~reg0_regout\)

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
	dataa => cnt(16),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~438_combout\);

\cnt[16]\ : maxii_lcell
-- Equation(s):
-- cnt(16) = DFFEAS(cnt(16) $ !\cnt[15]~381\, !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~438_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[16]~383\ = CARRY(cnt(16) & !\cnt[15]~381\)
-- \cnt[16]~383COUT1_505\ = CARRY(cnt(16) & !\cnt[15]~381\)

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(16),
	datac => \cnt~438_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[15]~381\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(16),
	cout0 => \cnt[16]~383\,
	cout1 => \cnt[16]~383COUT1_505\);

\cnt[17]\ : maxii_lcell
-- Equation(s):
-- cnt(17) = DFFEAS(cnt(17) $ (!\cnt[15]~381\ & \cnt[16]~383\) # (\cnt[15]~381\ & \cnt[16]~383COUT1_505\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~439_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[17]~385\ = CARRY(!\cnt[16]~383\ # !cnt(17))
-- \cnt[17]~385COUT1_507\ = CARRY(!\cnt[16]~383COUT1_505\ # !cnt(17))

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(17),
	datac => \cnt~439_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[15]~381\,
	cin0 => \cnt[16]~383\,
	cin1 => \cnt[16]~383COUT1_505\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(17),
	cout0 => \cnt[17]~385\,
	cout1 => \cnt[17]~385COUT1_507\);

\cnt[18]\ : maxii_lcell
-- Equation(s):
-- cnt(18) = DFFEAS(cnt(18) $ !(!\cnt[15]~381\ & \cnt[17]~385\) # (\cnt[15]~381\ & \cnt[17]~385COUT1_507\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~440_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[18]~387\ = CARRY(cnt(18) & !\cnt[17]~385\)
-- \cnt[18]~387COUT1_509\ = CARRY(cnt(18) & !\cnt[17]~385COUT1_507\)

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(18),
	datac => \cnt~440_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[15]~381\,
	cin0 => \cnt[17]~385\,
	cin1 => \cnt[17]~385COUT1_507\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(18),
	cout0 => \cnt[18]~387\,
	cout1 => \cnt[18]~387COUT1_509\);

\cnt[19]\ : maxii_lcell
-- Equation(s):
-- cnt(19) = DFFEAS(cnt(19) $ ((!\cnt[15]~381\ & \cnt[18]~387\) # (\cnt[15]~381\ & \cnt[18]~387COUT1_509\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~441_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[19]~389\ = CARRY(!\cnt[18]~387\ # !cnt(19))
-- \cnt[19]~389COUT1_511\ = CARRY(!\cnt[18]~387COUT1_509\ # !cnt(19))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(19),
	datac => \cnt~441_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[15]~381\,
	cin0 => \cnt[18]~387\,
	cin1 => \cnt[18]~387COUT1_509\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(19),
	cout0 => \cnt[19]~389\,
	cout1 => \cnt[19]~389COUT1_511\);

\cnt[20]\ : maxii_lcell
-- Equation(s):
-- cnt(20) = DFFEAS(cnt(20) $ (!(!\cnt[15]~381\ & \cnt[19]~389\) # (\cnt[15]~381\ & \cnt[19]~389COUT1_511\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~442_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[20]~391\ = CARRY(cnt(20) & (!\cnt[19]~389COUT1_511\))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(20),
	datac => \cnt~442_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[15]~381\,
	cin0 => \cnt[19]~389\,
	cin1 => \cnt[19]~389COUT1_511\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(20),
	cout => \cnt[20]~391\);

\cnt~446\ : maxii_lcell
-- Equation(s):
-- \cnt~446_combout\ = !\alarm~reg0_regout\ & cnt(24)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3030",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datac => cnt(24),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~446_combout\);

\cnt~445\ : maxii_lcell
-- Equation(s):
-- \cnt~445_combout\ = !\alarm~reg0_regout\ & cnt(23)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3030",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datac => cnt(23),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~445_combout\);

\cnt~444\ : maxii_lcell
-- Equation(s):
-- \cnt~444_combout\ = cnt(22) & !\alarm~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00f0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => cnt(22),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~444_combout\);

\cnt~443\ : maxii_lcell
-- Equation(s):
-- \cnt~443_combout\ = cnt(21) & !\alarm~reg0_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "00f0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => cnt(21),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~443_combout\);

\cnt[21]\ : maxii_lcell
-- Equation(s):
-- cnt(21) = DFFEAS(cnt(21) $ (\cnt[20]~391\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~443_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[21]~393\ = CARRY(!\cnt[20]~391\ # !cnt(21))
-- \cnt[21]~393COUT1_513\ = CARRY(!\cnt[20]~391\ # !cnt(21))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(21),
	datac => \cnt~443_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[20]~391\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(21),
	cout0 => \cnt[21]~393\,
	cout1 => \cnt[21]~393COUT1_513\);

\cnt[22]\ : maxii_lcell
-- Equation(s):
-- cnt(22) = DFFEAS(cnt(22) $ (!(!\cnt[20]~391\ & \cnt[21]~393\) # (\cnt[20]~391\ & \cnt[21]~393COUT1_513\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~444_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[22]~395\ = CARRY(cnt(22) & (!\cnt[21]~393\))
-- \cnt[22]~395COUT1_515\ = CARRY(cnt(22) & (!\cnt[21]~393COUT1_513\))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(22),
	datac => \cnt~444_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[20]~391\,
	cin0 => \cnt[21]~393\,
	cin1 => \cnt[21]~393COUT1_513\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(22),
	cout0 => \cnt[22]~395\,
	cout1 => \cnt[22]~395COUT1_515\);

\cnt[23]\ : maxii_lcell
-- Equation(s):
-- cnt(23) = DFFEAS(cnt(23) $ (!\cnt[20]~391\ & \cnt[22]~395\) # (\cnt[20]~391\ & \cnt[22]~395COUT1_515\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~445_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[23]~397\ = CARRY(!\cnt[22]~395\ # !cnt(23))
-- \cnt[23]~397COUT1_517\ = CARRY(!\cnt[22]~395COUT1_515\ # !cnt(23))

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(23),
	datac => \cnt~445_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[20]~391\,
	cin0 => \cnt[22]~395\,
	cin1 => \cnt[22]~395COUT1_515\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(23),
	cout0 => \cnt[23]~397\,
	cout1 => \cnt[23]~397COUT1_517\);

\cnt[24]\ : maxii_lcell
-- Equation(s):
-- cnt(24) = DFFEAS(cnt(24) $ (!(!\cnt[20]~391\ & \cnt[23]~397\) # (\cnt[20]~391\ & \cnt[23]~397COUT1_517\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~446_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[24]~399\ = CARRY(cnt(24) & (!\cnt[23]~397\))
-- \cnt[24]~399COUT1_519\ = CARRY(cnt(24) & (!\cnt[23]~397COUT1_517\))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(24),
	datac => \cnt~446_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[20]~391\,
	cin0 => \cnt[23]~397\,
	cin1 => \cnt[23]~397COUT1_517\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(24),
	cout0 => \cnt[24]~399\,
	cout1 => \cnt[24]~399COUT1_519\);

\cnt[25]\ : maxii_lcell
-- Equation(s):
-- cnt(25) = DFFEAS(cnt(25) $ (!\cnt[20]~391\ & \cnt[24]~399\) # (\cnt[20]~391\ & \cnt[24]~399COUT1_519\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~447_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[25]~401\ = CARRY(!\cnt[24]~399COUT1_519\ # !cnt(25))

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(25),
	datac => \cnt~447_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[20]~391\,
	cin0 => \cnt[24]~399\,
	cin1 => \cnt[24]~399COUT1_519\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(25),
	cout => \cnt[25]~401\);

\cnt~451\ : maxii_lcell
-- Equation(s):
-- \cnt~451_combout\ = !\alarm~reg0_regout\ & (cnt(28))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3300",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datad => cnt(28),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~451_combout\);

\cnt~449\ : maxii_lcell
-- Equation(s):
-- \cnt~449_combout\ = !\alarm~reg0_regout\ & cnt(27)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0f00",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \alarm~reg0_regout\,
	datad => cnt(27),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~449_combout\);

\cnt~448\ : maxii_lcell
-- Equation(s):
-- \cnt~448_combout\ = !\alarm~reg0_regout\ & (cnt(26))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3300",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datad => cnt(26),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~448_combout\);

\cnt[26]\ : maxii_lcell
-- Equation(s):
-- cnt(26) = DFFEAS(cnt(26) $ !\cnt[25]~401\, !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~448_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[26]~403\ = CARRY(cnt(26) & !\cnt[25]~401\)
-- \cnt[26]~403COUT1_521\ = CARRY(cnt(26) & !\cnt[25]~401\)

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(26),
	datac => \cnt~448_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[25]~401\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(26),
	cout0 => \cnt[26]~403\,
	cout1 => \cnt[26]~403COUT1_521\);

\cnt[27]\ : maxii_lcell
-- Equation(s):
-- cnt(27) = DFFEAS(cnt(27) $ (!\cnt[25]~401\ & \cnt[26]~403\) # (\cnt[25]~401\ & \cnt[26]~403COUT1_521\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~449_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[27]~405\ = CARRY(!\cnt[26]~403\ # !cnt(27))
-- \cnt[27]~405COUT1_523\ = CARRY(!\cnt[26]~403COUT1_521\ # !cnt(27))

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(27),
	datac => \cnt~449_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[25]~401\,
	cin0 => \cnt[26]~403\,
	cin1 => \cnt[26]~403COUT1_521\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(27),
	cout0 => \cnt[27]~405\,
	cout1 => \cnt[27]~405COUT1_523\);

\cnt[28]\ : maxii_lcell
-- Equation(s):
-- cnt(28) = DFFEAS(cnt(28) $ !(!\cnt[25]~401\ & \cnt[27]~405\) # (\cnt[25]~401\ & \cnt[27]~405COUT1_523\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~451_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[28]~409\ = CARRY(cnt(28) & !\cnt[27]~405\)
-- \cnt[28]~409COUT1_525\ = CARRY(cnt(28) & !\cnt[27]~405COUT1_523\)

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
	clk => \ALT_INV_clk~combout\,
	datab => cnt(28),
	datac => \cnt~451_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[25]~401\,
	cin0 => \cnt[27]~405\,
	cin1 => \cnt[27]~405COUT1_523\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(28),
	cout0 => \cnt[28]~409\,
	cout1 => \cnt[28]~409COUT1_525\);

\cnt[29]\ : maxii_lcell
-- Equation(s):
-- cnt(29) = DFFEAS(cnt(29) $ ((!\cnt[25]~401\ & \cnt[28]~409\) # (\cnt[25]~401\ & \cnt[28]~409COUT1_525\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~452_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[29]~411\ = CARRY(!\cnt[28]~409\ # !cnt(29))
-- \cnt[29]~411COUT1_527\ = CARRY(!\cnt[28]~409COUT1_525\ # !cnt(29))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(29),
	datac => \cnt~452_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[25]~401\,
	cin0 => \cnt[28]~409\,
	cin1 => \cnt[28]~409COUT1_525\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(29),
	cout0 => \cnt[29]~411\,
	cout1 => \cnt[29]~411COUT1_527\);

\cnt~450\ : maxii_lcell
-- Equation(s):
-- \cnt~450_combout\ = cnt(30) & (!\alarm~reg0_regout\)

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
	dataa => cnt(30),
	datad => \alarm~reg0_regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~450_combout\);

\cnt[30]\ : maxii_lcell
-- Equation(s):
-- cnt(30) = DFFEAS(cnt(30) $ (!(!\cnt[25]~401\ & \cnt[29]~411\) # (\cnt[25]~401\ & \cnt[29]~411COUT1_527\)), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~450_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )
-- \cnt[30]~407\ = CARRY(cnt(30) & (!\cnt[29]~411COUT1_527\))

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(30),
	datac => \cnt~450_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[25]~401\,
	cin0 => \cnt[29]~411\,
	cin1 => \cnt[29]~411COUT1_527\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(30),
	cout => \cnt[30]~407\);

\LessThan0~7\ : maxii_lcell
-- Equation(s):
-- \LessThan0~7_combout\ = !cnt(26) & !cnt(27)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "000f",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => cnt(26),
	datad => cnt(27),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~7_combout\);

\LessThan0~8\ : maxii_lcell
-- Equation(s):
-- \LessThan0~8_combout\ = !cnt(29) & !cnt(28) & !cnt(30) & \LessThan0~7_combout\

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
	dataa => cnt(29),
	datab => cnt(28),
	datac => cnt(30),
	datad => \LessThan0~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~8_combout\);

\LessThan0~5\ : maxii_lcell
-- Equation(s):
-- \LessThan0~5_combout\ = !cnt(19) & !cnt(20) & !cnt(18) & !cnt(21)

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
	dataa => cnt(19),
	datab => cnt(20),
	datac => cnt(18),
	datad => cnt(21),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~5_combout\);

\LessThan0~6\ : maxii_lcell
-- Equation(s):
-- \LessThan0~6_combout\ = !cnt(22) & !cnt(23) & !cnt(24) & !cnt(25)

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
	dataa => cnt(22),
	datab => cnt(23),
	datac => cnt(24),
	datad => cnt(25),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~6_combout\);

\LessThan0~0\ : maxii_lcell
-- Equation(s):
-- \LessThan0~0_combout\ = !cnt(4) & !cnt(3) & !cnt(2) & !cnt(5)

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
	dataa => cnt(4),
	datab => cnt(3),
	datac => cnt(2),
	datad => cnt(5),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~0_combout\);

\LessThan0~3\ : maxii_lcell
-- Equation(s):
-- \LessThan0~3_combout\ = !cnt(15) & !cnt(14) & !cnt(16) & !cnt(17)

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
	dataa => cnt(15),
	datab => cnt(14),
	datac => cnt(16),
	datad => cnt(17),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~3_combout\);

\LessThan0~2\ : maxii_lcell
-- Equation(s):
-- \LessThan0~2_combout\ = !cnt(13) & !cnt(11) & !cnt(10) & !cnt(12)

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
	datab => cnt(11),
	datac => cnt(10),
	datad => cnt(12),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~2_combout\);

\LessThan0~1\ : maxii_lcell
-- Equation(s):
-- \LessThan0~1_combout\ = !cnt(8) & !cnt(7) & !cnt(6) & !cnt(9)

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
	dataa => cnt(8),
	datab => cnt(7),
	datac => cnt(6),
	datad => cnt(9),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~1_combout\);

\LessThan0~4\ : maxii_lcell
-- Equation(s):
-- \LessThan0~4_combout\ = \LessThan0~0_combout\ & \LessThan0~3_combout\ & \LessThan0~2_combout\ & \LessThan0~1_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~0_combout\,
	datab => \LessThan0~3_combout\,
	datac => \LessThan0~2_combout\,
	datad => \LessThan0~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~4_combout\);

\LessThan0~9\ : maxii_lcell
-- Equation(s):
-- \LessThan0~9_combout\ = \LessThan0~8_combout\ & \LessThan0~5_combout\ & \LessThan0~6_combout\ & \LessThan0~4_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "8000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~8_combout\,
	datab => \LessThan0~5_combout\,
	datac => \LessThan0~6_combout\,
	datad => \LessThan0~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~9_combout\);

\cnt~453\ : maxii_lcell
-- Equation(s):
-- \cnt~453_combout\ = !\alarm~reg0_regout\ & (cnt(31))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3300",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datad => cnt(31),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt~453_combout\);

\cnt[31]\ : maxii_lcell
-- Equation(s):
-- cnt(31) = DFFEAS(cnt(31) $ (\cnt[30]~407\), !GLOBAL(\clk~combout\), VCC, , \cnt[16]~423_combout\, \cnt~453_combout\, !GLOBAL(\rst~combout\), \cnt[16]~420_combout\, )

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
	clk => \ALT_INV_clk~combout\,
	dataa => cnt(31),
	datac => \cnt~453_combout\,
	aclr => GND,
	aload => \ALT_INV_rst~combout\,
	sclr => \cnt[16]~420_combout\,
	ena => \cnt[16]~423_combout\,
	cin => \cnt[30]~407\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => cnt(31));

\cnt[16]~416\ : maxii_lcell
-- Equation(s):
-- \cnt[16]~416_combout\ = !\code~combout\(2) & \code~combout\(3) & !\code~combout\(1) & !\code~combout\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0004",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \code~combout\(2),
	datab => \code~combout\(3),
	datac => \code~combout\(1),
	datad => \code~combout\(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt[16]~416_combout\);

\cnt[16]~418\ : maxii_lcell
-- Equation(s):
-- \cnt[16]~418_combout\ = \alarm~reg0_regout\ & \cnt[16]~416_combout\ # !\alarm~reg0_regout\ & (!\Selector32~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "c0f3",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \alarm~reg0_regout\,
	datac => \cnt[16]~416_combout\,
	datad => \Selector32~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt[16]~418_combout\);

\cnt[16]~420\ : maxii_lcell
-- Equation(s):
-- \cnt[16]~420_combout\ = !cnt(31) & (\cnt[16]~419_combout\ # !\LessThan0~9_combout\) # !\cnt[16]~418_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0bff",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \cnt[16]~419_combout\,
	datab => \LessThan0~9_combout\,
	datac => cnt(31),
	datad => \cnt[16]~418_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cnt[16]~420_combout\);

\LessThan0~10\ : maxii_lcell
-- Equation(s):
-- \LessThan0~10_combout\ = cnt(0) & cnt(1)

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
	datac => cnt(0),
	datad => cnt(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \LessThan0~10_combout\);

\alarm~14\ : maxii_lcell
-- Equation(s):
-- \alarm~14_combout\ = cnt(31) # !\LessThan0~10_combout\ & \LessThan0~9_combout\ # !\cnt[16]~416_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "dfcf",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \LessThan0~10_combout\,
	datab => cnt(31),
	datac => \cnt[16]~416_combout\,
	datad => \LessThan0~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \alarm~14_combout\);

\alarm~13\ : maxii_lcell
-- Equation(s):
-- \alarm~13_combout\ = !cnt(31) & (cnt(1) # !\LessThan0~9_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0c0f",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => cnt(1),
	datac => cnt(31),
	datad => \LessThan0~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \alarm~13_combout\);

\alarm~reg0\ : maxii_lcell
-- Equation(s):
-- \alarm~reg0_regout\ = DFFEAS(\alarm~reg0_regout\ & (\alarm~14_combout\ # \alarm~13_combout\ & \alarm~12_combout\) # !\alarm~reg0_regout\ & (\alarm~13_combout\ & \alarm~12_combout\), !GLOBAL(\clk~combout\), VCC, , \rst~combout\, , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f888",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \alarm~reg0_regout\,
	datab => \alarm~14_combout\,
	datac => \alarm~13_combout\,
	datad => \alarm~12_combout\,
	aclr => GND,
	ena => \rst~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \alarm~reg0_regout\);

\unlock~5\ : maxii_lcell
-- Equation(s):
-- \unlock~5_combout\ = \Equal5~0_combout\ & (\Selector32~0_combout\ # \Equal10~1_combout\ & !\process_0~1_combout\) # !\Equal5~0_combout\ & \Equal10~1_combout\ & (!\process_0~1_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "a0ec",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \Equal5~0_combout\,
	datab => \Equal10~1_combout\,
	datac => \Selector32~0_combout\,
	datad => \process_0~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \unlock~5_combout\);

\unlock~reg0\ : maxii_lcell
-- Equation(s):
-- \unlock~reg0_regout\ = DFFEAS(\unlock~reg0_regout\ # !\alarm~reg0_regout\ & \unlock~5_combout\, !GLOBAL(\clk~combout\), GLOBAL(\rst~combout\), , , , , , )

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f5f0",
	operation_mode => "normal",
	output_mode => "reg_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~combout\,
	dataa => \alarm~reg0_regout\,
	datac => \unlock~reg0_regout\,
	datad => \unlock~5_combout\,
	aclr => \ALT_INV_rst~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \unlock~reg0_regout\);

\unlock~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \unlock~reg0_regout\,
	oe => VCC,
	padio => ww_unlock);

\alarm~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \alarm~reg0_regout\,
	oe => VCC,
	padio => ww_alarm);

\err~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \err~reg0_regout\,
	oe => VCC,
	padio => ww_err);
END structure;


