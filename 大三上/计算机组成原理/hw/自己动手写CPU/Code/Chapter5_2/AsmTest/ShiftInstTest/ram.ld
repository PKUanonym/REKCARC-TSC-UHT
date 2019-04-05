/* default.ld. Default linker script for Or1ksim test programs

   Copyright (C) 1999-2006 OpenCores
   Copyright (C) 2010 Embecosm Limited

   Contributors various OpenCores participants
   Contributor Jeremy Bennett <jeremy.bennett@embecosm.com>

   This file is part of OpenRISC 1000 Architectural Simulator.

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the Free
   Software Foundation; either version 3 of the License, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful, but WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
   more details.

   You should have received a copy of the GNU General Public License along
   with this program.  If not, see <http:  www.gnu.org/licenses/>.  */

/* ----------------------------------------------------------------------------
   This code is commented throughout for use with Doxygen.
   --------------------------------------------------------------------------*/

MEMORY
        {
       
        ram    : ORIGIN = 0x00000000, LENGTH = 0x00001000
        }

SECTIONS
{
	  /*
	  For some reason the linker script can't see the _reset_vector symbol 
	  (even if we declare it global), so we explicitly set it. */

	

	.text :
        {
        *(.text)
        } > ram

        .data :
        {
        *(.data)
        } > ram

        .bss :
        {
        *(.bss)
        } > ram

        .stack  ALIGN(0x10) (NOLOAD):
        {
        *(.stack)
        _ram_end = .;
        } > ram
}

ENTRY (_start)
