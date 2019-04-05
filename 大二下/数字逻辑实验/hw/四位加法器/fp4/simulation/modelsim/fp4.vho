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

-- DATE "04/28/2018 13:04:01"

-- 
-- Device: Altera EPM240T100C5 Package TQFP100
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY IEEE, maxii;
USE IEEE.std_logic_1164.all;
USE maxii.maxii_components.all;

ENTITY 	fp4 IS
    PORT (
	a : IN std_logic_vector(3 DOWNTO 0);
	b : IN std_logic_vector(3 DOWNTO 0);
	cin : IN std_logic;
	s : OUT std_logic_vector(3 DOWNTO 0);
	cout : OUT std_logic
	);
END fp4;

ARCHITECTURE structure OF fp4 IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_a : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_b : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_cin : std_logic;
SIGNAL ww_s : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_cout : std_logic;
SIGNAL \cin~combout\ : std_logic;
SIGNAL \fa0|s~combout\ : std_logic;
SIGNAL \fa1|p~combout\ : std_logic;
SIGNAL \fa1|s~combout\ : std_logic;
SIGNAL \fa2|p~combout\ : std_logic;
SIGNAL \c~14_combout\ : std_logic;
SIGNAL \c~13_combout\ : std_logic;
SIGNAL \fa2|s~combout\ : std_logic;
SIGNAL \c~15_combout\ : std_logic;
SIGNAL \cout~11_combout\ : std_logic;
SIGNAL \cout~12_combout\ : std_logic;
SIGNAL \fa3|s~combout\ : std_logic;
SIGNAL \fa3|p~combout\ : std_logic;
SIGNAL \cout~13_combout\ : std_logic;
SIGNAL \cout~14_combout\ : std_logic;
SIGNAL \cout~15_combout\ : std_logic;
SIGNAL \a~combout\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \b~combout\ : std_logic_vector(3 DOWNTO 0);

BEGIN

ww_a <= a;
ww_b <= b;
ww_cin <= cin;
s <= ww_s;
cout <= ww_cout;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\a[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_a(0),
	combout => \a~combout\(0));

\b[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_b(0),
	combout => \b~combout\(0));

\cin~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_cin,
	combout => \cin~combout\);

\fa0|s\ : maxii_lcell
-- Equation(s):
-- \fa0|s~combout\ = \a~combout\(0) $ (\b~combout\(0) $ \cin~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "a55a",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \a~combout\(0),
	datac => \b~combout\(0),
	datad => \cin~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \fa0|s~combout\);

\b[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_b(1),
	combout => \b~combout\(1));

\a[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_a(1),
	combout => \a~combout\(1));

\fa1|p\ : maxii_lcell
-- Equation(s):
-- \fa1|p~combout\ = \b~combout\(1) $ (\a~combout\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "33cc",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \b~combout\(1),
	datad => \a~combout\(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \fa1|p~combout\);

\fa1|s\ : maxii_lcell
-- Equation(s):
-- \fa1|s~combout\ = \fa1|p~combout\ $ (\a~combout\(0) & (\cin~combout\ # \b~combout\(0)) # !\a~combout\(0) & \cin~combout\ & \b~combout\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "17e8",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \a~combout\(0),
	datab => \cin~combout\,
	datac => \b~combout\(0),
	datad => \fa1|p~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \fa1|s~combout\);

\b[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_b(2),
	combout => \b~combout\(2));

\a[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_a(2),
	combout => \a~combout\(2));

\fa2|p\ : maxii_lcell
-- Equation(s):
-- \fa2|p~combout\ = \b~combout\(2) $ \a~combout\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0ff0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \b~combout\(2),
	datad => \a~combout\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \fa2|p~combout\);

\c~14\ : maxii_lcell
-- Equation(s):
-- \c~14_combout\ = \a~combout\(1) & (\b~combout\(1) # \a~combout\(0) & \b~combout\(0)) # !\a~combout\(1) & \a~combout\(0) & \b~combout\(0) & \b~combout\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ea80",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \a~combout\(1),
	datab => \a~combout\(0),
	datac => \b~combout\(0),
	datad => \b~combout\(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \c~14_combout\);

\c~13\ : maxii_lcell
-- Equation(s):
-- \c~13_combout\ = \cin~combout\ & (\a~combout\(0) $ \b~combout\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "3c00",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datab => \a~combout\(0),
	datac => \b~combout\(0),
	datad => \cin~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \c~13_combout\);

\fa2|s\ : maxii_lcell
-- Equation(s):
-- \fa2|s~combout\ = \fa2|p~combout\ $ (\c~14_combout\ # \fa1|p~combout\ & \c~13_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "565a",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \fa2|p~combout\,
	datab => \fa1|p~combout\,
	datac => \c~14_combout\,
	datad => \c~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \fa2|s~combout\);

\b[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_b(3),
	combout => \b~combout\(3));

\a[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "input")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_a(3),
	combout => \a~combout\(3));

\c~15\ : maxii_lcell
-- Equation(s):
-- \c~15_combout\ = \b~combout\(2) & (\a~combout\(2) # \a~combout\(1) & \b~combout\(1)) # !\b~combout\(2) & \a~combout\(1) & \b~combout\(1) & \a~combout\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "ea80",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \b~combout\(2),
	datab => \a~combout\(1),
	datac => \b~combout\(1),
	datad => \a~combout\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \c~15_combout\);

\cout~11\ : maxii_lcell
-- Equation(s):
-- \cout~11_combout\ = \a~combout\(0) & (\b~combout\(0) # \cin~combout\) # !\a~combout\(0) & (\b~combout\(0) & \cin~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "faa0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \a~combout\(0),
	datac => \b~combout\(0),
	datad => \cin~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cout~11_combout\);

\cout~12\ : maxii_lcell
-- Equation(s):
-- \cout~12_combout\ = \fa2|p~combout\ & \cout~11_combout\ & (\b~combout\(1) $ \a~combout\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "6000",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \b~combout\(1),
	datab => \a~combout\(1),
	datac => \fa2|p~combout\,
	datad => \cout~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cout~12_combout\);

\fa3|s\ : maxii_lcell
-- Equation(s):
-- \fa3|s~combout\ = \b~combout\(3) $ \a~combout\(3) $ (\c~15_combout\ # \cout~12_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "9996",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \b~combout\(3),
	datab => \a~combout\(3),
	datac => \c~15_combout\,
	datad => \cout~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \fa3|s~combout\);

\fa3|p\ : maxii_lcell
-- Equation(s):
-- \fa3|p~combout\ = \b~combout\(3) $ \a~combout\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0ff0",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	datac => \b~combout\(3),
	datad => \a~combout\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \fa3|p~combout\);

\cout~13\ : maxii_lcell
-- Equation(s):
-- \cout~13_combout\ = \b~combout\(3) & (\a~combout\(3) # \b~combout\(2) & \a~combout\(2)) # !\b~combout\(3) & \b~combout\(2) & \a~combout\(2) & \a~combout\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "f880",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \b~combout\(2),
	datab => \a~combout\(2),
	datac => \b~combout\(3),
	datad => \a~combout\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cout~13_combout\);

\cout~14\ : maxii_lcell
-- Equation(s):
-- \cout~14_combout\ = \b~combout\(1) & \a~combout\(1) & \fa2|p~combout\ & \fa3|p~combout\

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
	dataa => \b~combout\(1),
	datab => \a~combout\(1),
	datac => \fa2|p~combout\,
	datad => \fa3|p~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cout~14_combout\);

\cout~15\ : maxii_lcell
-- Equation(s):
-- \cout~15_combout\ = \cout~13_combout\ # \cout~14_combout\ # \fa3|p~combout\ & \cout~12_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "fefc",
	operation_mode => "normal",
	output_mode => "comb_only",
	register_cascade_mode => "off",
	sum_lutc_input => "datac",
	synch_mode => "off")
-- pragma translate_on
PORT MAP (
	dataa => \fa3|p~combout\,
	datab => \cout~13_combout\,
	datac => \cout~14_combout\,
	datad => \cout~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	combout => \cout~15_combout\);

\s[0]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \fa0|s~combout\,
	oe => VCC,
	padio => ww_s(0));

\s[1]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \fa1|s~combout\,
	oe => VCC,
	padio => ww_s(1));

\s[2]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \fa2|s~combout\,
	oe => VCC,
	padio => ww_s(2));

\s[3]~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \fa3|s~combout\,
	oe => VCC,
	padio => ww_s(3));

\cout~I\ : maxii_io
-- pragma translate_off
GENERIC MAP (
	operation_mode => "output")
-- pragma translate_on
PORT MAP (
	datain => \cout~15_combout\,
	oe => VCC,
	padio => ww_cout);
END structure;


