#ifndef __KERN_DRIVER_KBDREG_H__
#define __KERN_DRIVER_KBDREG_H__

// Special keycodes
#define KEY_HOME            0xE0
#define KEY_END             0xE1
#define KEY_UP              0xE2
#define KEY_DN              0xE3
#define KEY_LF              0xE4
#define KEY_RT              0xE5
#define KEY_PGUP            0xE6
#define KEY_PGDN            0xE7
#define KEY_INS             0xE8
#define KEY_DEL             0xE9


/* This is i8042reg.h + kbdreg.h from NetBSD. */

#define KBSTATP             0x64    // kbd controller status port(I)
#define KBS_DIB             0x01    // kbd data in buffer
#define KBS_IBF             0x02    // kbd input buffer low
#define KBS_WARM            0x04    // kbd input buffer low
#define BS_OCMD             0x08    // kbd output buffer has command
#define KBS_NOSEC           0x10    // kbd security lock not engaged
#define KBS_TERR            0x20    // kbd transmission error
#define KBS_RERR            0x40    // kbd receive error
#define KBS_PERR            0x80    // kbd parity error

#define KBCMDP              0x64    // kbd controller port(O)
#define KBC_RAMREAD         0x20    // read from RAM
#define KBC_RAMWRITE        0x60    // write to RAM
#define KBC_AUXDISABLE      0xa7    // disable auxiliary port
#define KBC_AUXENABLE       0xa8    // enable auxiliary port
#define KBC_AUXTEST         0xa9    // test auxiliary port
#define KBC_KBDECHO         0xd2    // echo to keyboard port
#define KBC_AUXECHO         0xd3    // echo to auxiliary port
#define KBC_AUXWRITE        0xd4    // write to auxiliary port
#define KBC_SELFTEST        0xaa    // start self-test
#define KBC_KBDTEST         0xab    // test keyboard port
#define KBC_KBDDISABLE      0xad    // disable keyboard port
#define KBC_KBDENABLE       0xae    // enable keyboard port
#define KBC_PULSE0          0xfe    // pulse output bit 0
#define KBC_PULSE1          0xfd    // pulse output bit 1
#define KBC_PULSE2          0xfb    // pulse output bit 2
#define KBC_PULSE3          0xf7    // pulse output bit 3

#define KBDATAP             0x60    // kbd data port(I)
#define KBOUTP              0x60    // kbd data port(O)

#define K_RDCMDBYTE         0x20
#define K_LDCMDBYTE         0x60

#define KC8_TRANS           0x40    // convert to old scan codes
#define KC8_MDISABLE        0x20    // disable mouse
#define KC8_KDISABLE        0x10    // disable keyboard
#define KC8_IGNSEC          0x08    // ignore security lock
#define KC8_CPU             0x04    // exit from protected mode reset
#define KC8_MENABLE         0x02    // enable mouse interrupt
#define KC8_KENABLE         0x01    // enable keyboard interrupt
#define CMDBYTE             (KC8_TRANS|KC8_CPU|KC8_MENABLE|KC8_KENABLE)

/* keyboard commands */
#define KBC_RESET           0xFF    // reset the keyboard
#define KBC_RESEND          0xFE    // request the keyboard resend the last byte
#define KBC_SETDEFAULT      0xF6    // resets keyboard to its power-on defaults
#define KBC_DISABLE         0xF5    // as per KBC_SETDEFAULT, but also disable key scanning
#define KBC_ENABLE          0xF4    // enable key scanning
#define KBC_TYPEMATIC       0xF3    // set typematic rate and delay
#define KBC_SETTABLE        0xF0    // set scancode translation table
#define KBC_MODEIND         0xED    // set mode indicators(i.e. LEDs)
#define KBC_ECHO            0xEE    // request an echo from the keyboard

/* keyboard responses */
#define KBR_EXTENDED        0xE0    // extended key sequence
#define KBR_RESEND          0xFE    // needs resend of command
#define KBR_ACK             0xFA    // received a valid command
#define KBR_OVERRUN         0x00    // flooded
#define KBR_FAILURE         0xFD    // diagnosic failure
#define KBR_BREAK           0xF0    // break code prefix - sent on key release
#define KBR_RSTDONE         0xAA    // reset complete
#define KBR_ECHO            0xEE    // echo response

#endif /* !__KERN_DRIVER_KBDREG_H__ */

