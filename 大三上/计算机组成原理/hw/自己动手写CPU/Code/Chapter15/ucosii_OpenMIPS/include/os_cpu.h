/*
*********************************************************************************************************
*                                               uC/OS-II
*                                        The Real-Time Kernel
*
*                            (c) Copyright 2010, Micrium, Inc., Weston, FL
*                                         All Rights Reserved
*
*                                              MIPS14K 
*							                  MicroMips
* File    : os_cpu.h
* Version : v2.90
* By      : NB
*********************************************************************************************************
*/

#ifdef  OS_CPU_GLOBALS
#define OS_CPU_EXT
#else
#define OS_CPU_EXT  extern
#endif

#include "cpu.h"

/*
*********************************************************************************************************
*                                              DATA TYPES
*                                         (Compiler Specific)
*********************************************************************************************************
*/

typedef unsigned  char              BOOLEAN;
typedef unsigned  char              INT8U;        /* Unsigned  8-bit quantity                          */
typedef signed    char              INT8S;        /* Signed    8-bit quantity                          */
typedef unsigned  short             INT16U;       /* Unsigned 16-bit quantity                          */
typedef signed    short             INT16S;       /* Signed   16-bit quantity                          */
typedef unsigned  int               INT32U;       /* Unsigned 32-bit quantity                          */
typedef signed    int               INT32S;       /* Signed   32-bit quantity                          */
typedef float                       FP32;
typedef double                      FP64;

typedef unsigned  int               OS_STK;       /* Each stack entry is 32 bits wide                  */
typedef unsigned  int  volatile     OS_CPU_SR;    /* The CPU Status Word is 32-bits wide. This variable*/
                                                  /* MUST be volatile for proper operation.  Refer to  */
                                                  /* os_cpu_a.s for more details.                      */

/*
*********************************************************************************************************
*                                     CRITICAL SECTIONS MANAGEMENT
*
* Method #1: Disable/Enable interrupts using simple instructions.  After a critical section, interrupts
*            will be enabled even if they were disabled before entering the critical section.
*
* Method #2: Disable/Enable interrupts and preserve the state of interrupts.  In other words, if 
*            interrupts were disabled before entering the critical section, they will be disabled when
*            leaving the critical section.
*
* Method #3: Disable/Enable interrupts and preserve the state of interrupts.  Generally speaking, you
*            would store the state of the interrupt disable flag in the local variable 'cpu_sr' and then
*            disable interrupts.  'cpu_sr' is allocated in all of uC/OS-II's functions that need to 
*            disable interrupts.  You would restore the interrupt disable state by copying back 'cpu_sr'
*            into the CPU's status register.
*********************************************************************************************************
*/

#define  OS_CRITICAL_METHOD    3

#define  OS_ENTER_CRITICAL()   cpu_sr = OS_CPU_SR_Save();
#define  OS_EXIT_CRITICAL()    OS_CPU_SR_Restore(cpu_sr);

/*
********************************************************************************************************* 
*                                                 M14K
*********************************************************************************************************
*/

#define  OS_STK_GROWTH    1                       /* Stack grows from HIGH to LOW memory               */
#define  OS_TASK_SW()     asm("\tsyscall\n");
					


/*
*********************************************************************************************************
*                                          FUNCTION PROTOTYPES
*********************************************************************************************************
*/

void       OSIntCtxSw(void);
void       OSStartHighRdy(void);
void       ExceptionHandler(void);
void       InterruptHandler(void);

void       TickInterruptClear(void);
void       CoreTmrInit(CPU_INT32U tmr_reload);
void       TickISR(CPU_INT32U tmr_reload);

OS_CPU_SR  OS_CPU_SR_Save(void);               /* See os_cpu_a.s                                       */
void       OS_CPU_SR_Restore(OS_CPU_SR);       /* See os_cpu_a.s                                       */



