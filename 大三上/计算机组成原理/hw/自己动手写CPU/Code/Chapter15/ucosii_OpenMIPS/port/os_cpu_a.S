/*
*********************************************************************************************************
*                                               uC/OS-II
*                                         The Real-Time Kernel
*
*                             (c) Copyright 2010, Micrium, Inc., Weston, FL
*                                           All Rights Reserved
*
*                                               MIPS14K
*                                              MicroMips
*
* File    : os_cpu_a.S
* Version : v2.90
* By	  : NB
*********************************************************************************************************
*/
/*
*********************************************************************************************************
*                                          PUBLIC FUNCTIONS
*********************************************************************************************************
*/

    .global  OSStartHighRdy
    .global  OSIntCtxSw
    .global  OS_CPU_SR_Save
    .global  OS_CPU_SR_Restore
    .global  InterruptHandler
    .global  ExceptionHandler
    .global  TickInterruptClear
    .global  CoreTmrInit
    .global  TickISR
    .global  DisableInterruptSource
    .global  EnableInterruptSource

/*
*********************************************************************************************************
*                           CONSTANTS USED TO ACCESS TASK CONTEXT STACK
*********************************************************************************************************
*/

.equ    STK_OFFSET_SR,      4
.equ    STK_OFFSET_EPC,     STK_OFFSET_SR    + 4
.equ    STK_OFFSET_LO,      STK_OFFSET_EPC   + 4
.equ    STK_OFFSET_HI,      STK_OFFSET_LO    + 4
.equ    STK_OFFSET_GPR1,    STK_OFFSET_HI    + 4
.equ    STK_OFFSET_GPR2,    STK_OFFSET_GPR1  + 4
.equ    STK_OFFSET_GPR3,    STK_OFFSET_GPR2  + 4
.equ    STK_OFFSET_GPR4,    STK_OFFSET_GPR3  + 4
.equ    STK_OFFSET_GPR5,    STK_OFFSET_GPR4  + 4
.equ    STK_OFFSET_GPR6,    STK_OFFSET_GPR5  + 4
.equ    STK_OFFSET_GPR7,    STK_OFFSET_GPR6  + 4
.equ    STK_OFFSET_GPR8,    STK_OFFSET_GPR7  + 4
.equ    STK_OFFSET_GPR9,    STK_OFFSET_GPR8  + 4
.equ    STK_OFFSET_GPR10,   STK_OFFSET_GPR9  + 4
.equ    STK_OFFSET_GPR11,   STK_OFFSET_GPR10 + 4
.equ    STK_OFFSET_GPR12,   STK_OFFSET_GPR11 + 4
.equ    STK_OFFSET_GPR13,   STK_OFFSET_GPR12 + 4
.equ    STK_OFFSET_GPR14,   STK_OFFSET_GPR13 + 4
.equ    STK_OFFSET_GPR15,   STK_OFFSET_GPR14 + 4
.equ    STK_OFFSET_GPR16,   STK_OFFSET_GPR15 + 4
.equ    STK_OFFSET_GPR17,   STK_OFFSET_GPR16 + 4
.equ    STK_OFFSET_GPR18,   STK_OFFSET_GPR17 + 4
.equ    STK_OFFSET_GPR19,   STK_OFFSET_GPR18 + 4
.equ    STK_OFFSET_GPR20,   STK_OFFSET_GPR19 + 4
.equ    STK_OFFSET_GPR21,   STK_OFFSET_GPR20 + 4
.equ    STK_OFFSET_GPR22,   STK_OFFSET_GPR21 + 4
.equ    STK_OFFSET_GPR23,   STK_OFFSET_GPR22 + 4
.equ    STK_OFFSET_GPR24,   STK_OFFSET_GPR23 + 4
.equ    STK_OFFSET_GPR25,   STK_OFFSET_GPR24 + 4
.equ    STK_OFFSET_GPR26,   STK_OFFSET_GPR25 + 4
.equ    STK_OFFSET_GPR27,   STK_OFFSET_GPR26 + 4
.equ    STK_OFFSET_GPR28,   STK_OFFSET_GPR27 + 4
.equ    STK_OFFSET_GPR30,   STK_OFFSET_GPR28 + 4
.equ    STK_OFFSET_GPR31,   STK_OFFSET_GPR30 + 4 
.equ    STK_CTX_SIZE,       STK_OFFSET_GPR31 + 4

/* 2013-9-28注释：添加下面的stack section  */
        .section .stack, "aw", @nobits

.space  0x10000

/* 2013-9-28注释：添加下面的vector section  */
        .section .vectors, "ax"

	.org 0x0
_reset:
  lui $28,0x0
  la $29,_stack_addr
	la $26,main                /* 寄存器$26、$27留给中断、异常的处理程序使用 */
  jr $26
  nop

	.org 0x20
	la $26,InterruptHandler
	jr $26
	nop

	.org 0x40
	la $26,ExceptionHandler
	jr $26
	nop


    .section .text,"ax",@progbits
    .set noreorder
    .set noat



/*
*********************************************************************************************************
*                                           OSStartHighRdy()
*
* Description: Starts the highest priority task that is available to run.  OSStartHighRdy() MUST:
*
*              a) Call OSTaskSwHook()
*              b) Set OSRunning to TRUE
*              c) Switch to the highest priority task.
*
*              The stack frame of the task to resume is assumed to look as follows:
*
*              OSTCBHighRdy->OSTCBStkPtr + 0x00    Free Entry                    (LOW Memory)
*                                        + 0x04    Status Register
*                                        + 0x08    EPC
*                                        + 0x0C    Special Purpose LO Register
*                                        + 0x10    Special Purpose HI Register
*                                        + 0x14    GPR[1]
*                                        + 0x18    GPR[2]
*                                        + 0x1C    GPR[3]
*                                        + 0x20    GPR[4]
*                                               |
*                                               |
*                                              \ /
*                                               V
*                                        + 0x80    GPR[28]
*                                        + 0x84    GPR[30]
*                                        + 0x88    GPR[31]                       (HIGH Memory)
*                              
* Note(s): 1) OSTaskStkInit(), which is responsible for initializing each task's stack, sets bit 0 of the
*             entry corresponding to the Status register.  Thus, interrupts will be enabled when each
*             task first runs.
*********************************************************************************************************
*/

    .ent OSStartHighRdy
OSStartHighRdy:

    la    $8,  OSTaskSwHook                    /* Call OSTaskSwHook()                                  */
    
    /* 2013-9-27注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */
    
    jalr  $8
    nop

    addi  $8,  $0, 1                           /* Indicate that the OS is running                      */
    la    $9,  OSRunning
    sb    $8,  0($9)

    la    $8,  OSTCBHighRdy                    /* Update the current TCB                               */
    lw    $9,  0($8) 
    lw    $29, 0($9)                           /* Load the new task's stack pointer                    */

    lw    $8,  STK_OFFSET_SR($29)              /* Restore the Status register                          */
    mtc0  $8,  $12, 0

    lw    $8,  STK_OFFSET_EPC($29)             /* Restore the EPC                                      */
    mtc0  $8,  $14, 0

    lw    $8,  STK_OFFSET_LO($29)              /* Restore the contents of the LO and HI registers      */
    lw    $9,  STK_OFFSET_HI($29)
    mtlo  $8
    mthi  $9

    lw    $31, STK_OFFSET_GPR31($29)           /* Restore the General Purpose Registers                */
    lw    $30, STK_OFFSET_GPR30($29) 
    lw    $28, STK_OFFSET_GPR28($29)
    lw    $27, STK_OFFSET_GPR27($29) 
    lw    $26, STK_OFFSET_GPR26($29) 
    lw    $25, STK_OFFSET_GPR25($29) 
    lw    $24, STK_OFFSET_GPR24($29) 
    lw    $23, STK_OFFSET_GPR23($29) 
    lw    $22, STK_OFFSET_GPR22($29) 
    lw    $21, STK_OFFSET_GPR21($29) 
    lw    $20, STK_OFFSET_GPR20($29) 
    lw    $19, STK_OFFSET_GPR19($29) 
    lw    $18, STK_OFFSET_GPR18($29) 
    lw    $17, STK_OFFSET_GPR17($29) 
    lw    $16, STK_OFFSET_GPR16($29) 
    lw    $15, STK_OFFSET_GPR15($29) 
    lw    $14, STK_OFFSET_GPR14($29) 
    lw    $13, STK_OFFSET_GPR13($29) 
    lw    $12, STK_OFFSET_GPR12($29) 
    lw    $11, STK_OFFSET_GPR11($29) 
    lw    $10, STK_OFFSET_GPR10($29) 
    lw    $9,  STK_OFFSET_GPR9($29)  
    lw    $8,  STK_OFFSET_GPR8($29)  
    lw    $7,  STK_OFFSET_GPR7($29)  
    lw    $6,  STK_OFFSET_GPR6($29)  
    lw    $5,  STK_OFFSET_GPR5($29)  
    lw    $4,  STK_OFFSET_GPR4($29)  
    lw    $3,  STK_OFFSET_GPR3($29) 
    lw    $2,  STK_OFFSET_GPR2($29)  
    lw    $1,  STK_OFFSET_GPR1($29) 
    
    /* 2013-9-27注释：可以去掉ei指令 */
    /* ei */

    jr    $31                                  /* Resume execution in the new task                     */
    addi  $29, $29, STK_CTX_SIZE               /* Adjust the stack pointer                             */   

    .end OSStartHighRdy

/*
*********************************************************************************************************
*                                             OSIntCtxSw()
*
* Description: This function is used to perform a context switch following an ISR.
*
*              OSIntCtxSw() implements the following pseudo-code:
*
*                  OSTaskSwHook();
*                  OSPrioCur = OSPrioHighRdy;
*                  OSTCBCur  = OSTCBHighRdy;
*                  SP        = OSTCBHighRdy->OSTCBStkPtr;
*                  Restore the Status register and the EPC to their prior states;
*                  Restore the LO and HI registers;
*                  Restore each of the general purpose registers;
*                  Adjust the stack pointer;
*                  Execute an eret instruction to begin executing the new task;
*
*              Upon entry, the registers of the task being suspended have already been saved onto that
*              task's stack and the SP for the task has been saved in its OS_TCB by the ISR.
*
*              The stack frame of the task to resume is assumed to look as follows:
*
*              OSTCBHighRdy->OSTCBStkPtr + 0x00    Free Entry                    (LOW Memory)
*                                        + 0x04    Status Register
*                                        + 0x08    EPC
*                                        + 0x0C    Special Purpose LO Register
*                                        + 0x10    Special Purpose HI Register
*                                        + 0x14    GPR[1]
*                                        + 0x18    GPR[2]
*                                        + 0x1C    GPR[3]
*                                        + 0x20    GPR[4]
*                                               |
*                                               |
*                                              \ /
*                                               V
*                                        + 0x80    GPR[28]
*                                        + 0x84    GPR[30]
*                                        + 0x88    GPR[31]                       (HIGH Memory)
*********************************************************************************************************
*/            

    .ent OSIntCtxSw
OSIntCtxSw:

    la    $8,  OSTaskSwHook                    /* Call OSTaskSwHook()                                  */
    
    /* 2013-9-27注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */
    
    jalr  $8
    nop

    la    $8,  OSPrioHighRdy                   /* Update the current priority                          */
    lbu   $9,  0($8) 
    la    $10, OSPrioCur
    sb    $9,  0($10)

    la    $8,  OSTCBHighRdy                    /* Update the current TCB                               */
    lw    $9,  0($8)
    la    $10, OSTCBCur
    sw    $9,  0($10)

    lw    $29, 0($9)                           /* Load the new task's stack pointer                    */

    lw    $8,  STK_OFFSET_SR($29)              /* Restore the Status register                          */
    mtc0  $8,  $12, 0 

    lw    $8,  STK_OFFSET_EPC($29)             /* Restore the EPC                                      */
    mtc0  $8,  $14, 0 

    lw    $8,  STK_OFFSET_LO($29)              /* Restore the contents of the LO and HI registers      */
    lw    $9,  STK_OFFSET_HI($29)
    mtlo  $8
    mthi  $9

    lw    $31, STK_OFFSET_GPR31($29)           /* Restore the General Purpose Registers                */
    lw    $30, STK_OFFSET_GPR30($29) 
    lw    $28, STK_OFFSET_GPR28($29)
    lw    $27, STK_OFFSET_GPR27($29) 
    lw    $26, STK_OFFSET_GPR26($29) 
    lw    $25, STK_OFFSET_GPR25($29) 
    lw    $24, STK_OFFSET_GPR24($29) 
    lw    $23, STK_OFFSET_GPR23($29) 
    lw    $22, STK_OFFSET_GPR22($29) 
    lw    $21, STK_OFFSET_GPR21($29) 
    lw    $20, STK_OFFSET_GPR20($29) 
    lw    $19, STK_OFFSET_GPR19($29) 
    lw    $18, STK_OFFSET_GPR18($29) 
    lw    $17, STK_OFFSET_GPR17($29) 
    lw    $16, STK_OFFSET_GPR16($29) 
    lw    $15, STK_OFFSET_GPR15($29) 
    lw    $14, STK_OFFSET_GPR14($29) 
    lw    $13, STK_OFFSET_GPR13($29) 
    lw    $12, STK_OFFSET_GPR12($29) 
    lw    $11, STK_OFFSET_GPR11($29) 
    lw    $10, STK_OFFSET_GPR10($29) 
    lw    $9,  STK_OFFSET_GPR9($29)  
    lw    $8,  STK_OFFSET_GPR8($29)  
    lw    $7,  STK_OFFSET_GPR7($29)  
    lw    $6,  STK_OFFSET_GPR6($29)  
    lw    $5,  STK_OFFSET_GPR5($29)  
    lw    $4,  STK_OFFSET_GPR4($29)  
    lw    $3,  STK_OFFSET_GPR3($29) 
    lw    $2,  STK_OFFSET_GPR2($29)  
    lw    $1,  STK_OFFSET_GPR1($29) 

    addi  $29, $29, STK_CTX_SIZE               /* Adjust the stack pointer                             */   

    /* ei */

    eret                                       /* Resume execution in new task                         */

    .end OSIntCtxSw

/*
*********************************************************************************************************
*                                          DISABLE INTERRUPTS
*                                   OS_CPU_SR  OS_CPU_SR_Save(void);
*
* Description: This function saves the state of the Status register and then disables interrupts via this
*              register.  This objective is accomplished with a single instruction, di.  The di 
*              instruction's operand, $2, is the general purpose register to which the Status register's 
*              value is saved.  This value can be read by C functions that call OS_CPU_SR_Save().  
*
* Arguments  : None
*
* Returns    : The previous state of the Status register
*********************************************************************************************************
*/

    .ent OS_CPU_SR_Save
OS_CPU_SR_Save:

    
    /* 2013-9-27修改：将di指令使用下面5条MIPS32中定义的指令代替  */
    ori   $2,$2,0x0
    mfc0  $2,$12,0
    addi  $3,$0,0xfffe
    and   $3,$2,$3
    mtc0  $3,$12,0
    jr    $31
    nop
    /* di    $2 */                             /* Disable interrupts, and move the old value of the... */
                                               /* ...Status register into v0 ($2)                      */
    .end OS_CPU_SR_Save

/*
*********************************************************************************************************
*                                          ENABLE INTERRUPTS
*                                  void OS_CPU_SR_Restore(OS_CPU_SR sr);
*
* Description: This function must be used in tandem with OS_CPU_SR_Save().  Calling OS_CPU_SR_Restore()
*              causes the value returned by OS_CPU_SR_Save() to be placed in the Status register. 
*
* Arguments  : The value to be placed in the Status register
*
* Returns    : None
*********************************************************************************************************
*/

    .ent OS_CPU_SR_Restore
OS_CPU_SR_Restore:

    jr    $31
    mtc0  $4, $12, 0                           /* Restore the status register to its previous state    */

    .end OS_CPU_SR_Restore

/*
*********************************************************************************************************
*                                          InterruptHandler
*
* Description: This function handles all generated hardware interrupts, saving the current task's
*              context. The task is then restored once the pending interrupts have been processed.
*
*              The interrupted task's context is saved onto its stack as follows:
*
*
*              OSTCBHighRdy->OSTCBStkPtr + 0x00    Free Entry                    (LOW Memory)
*                                        + 0x04    Status Register
*                                        + 0x08    EPC
*                                        + 0x0C    Special Purpose LO Register
*                                        + 0x10    Special Purpose HI Register
*                                        + 0x14    GPR[1]
*                                        + 0x18    GPR[2]
*                                        + 0x1C    GPR[3]
*                                        + 0x20    GPR[4]
*                                               |
*                                               |
*                                              \ /
*                                               V
*                                        + 0x80    GPR[28]
*                                        + 0x84    GPR[30]
*                                        + 0x88    GPR[31]                       (HIGH Memory)
*********************************************************************************************************
*/

    .ent InterruptHandler
InterruptHandler:
    /* 2013-9-27注释：可以去掉此处的di指令  */
    /* di */
 
/*
    ori $4,$0,0x4567
    jal PrintInfo
    nop   
*/

    addi  $29, $29, -STK_CTX_SIZE              /* Adjust the stack pointer                             */

    sw    $1,  STK_OFFSET_GPR1($29)            /* Save the General Pupose Registers                    */
    sw    $2,  STK_OFFSET_GPR2($29)
    sw    $3,  STK_OFFSET_GPR3($29)
    sw    $4,  STK_OFFSET_GPR4($29)
    sw    $5,  STK_OFFSET_GPR5($29)
    sw    $6,  STK_OFFSET_GPR6($29)
    sw    $7,  STK_OFFSET_GPR7($29)
    sw    $8,  STK_OFFSET_GPR8($29)
    sw    $9,  STK_OFFSET_GPR9($29)
    sw    $10, STK_OFFSET_GPR10($29)
    sw    $11, STK_OFFSET_GPR11($29)
    sw    $12, STK_OFFSET_GPR12($29)
    sw    $13, STK_OFFSET_GPR13($29)
    sw    $14, STK_OFFSET_GPR14($29)
    sw    $15, STK_OFFSET_GPR15($29)
    sw    $16, STK_OFFSET_GPR16($29)
    sw    $17, STK_OFFSET_GPR17($29)
    sw    $18, STK_OFFSET_GPR18($29)
    sw    $19, STK_OFFSET_GPR19($29)
    sw    $20, STK_OFFSET_GPR20($29)
    sw    $21, STK_OFFSET_GPR21($29)
    sw    $22, STK_OFFSET_GPR22($29)
    sw    $23, STK_OFFSET_GPR23($29)
    sw    $24, STK_OFFSET_GPR24($29)
    sw    $25, STK_OFFSET_GPR25($29)
    sw    $26, STK_OFFSET_GPR26($29)
    sw    $27, STK_OFFSET_GPR27($29)
    sw    $28, STK_OFFSET_GPR28($29)
    sw    $30, STK_OFFSET_GPR30($29)
    sw    $31, STK_OFFSET_GPR31($29)

/*
    ori $4,$0,0x0123
    jal PrintInfo
    nop       
*/
                                        /* Save the contents of the LO and HI registers         */
    mflo  $8
    mfhi  $9
    sw    $8,  STK_OFFSET_LO($29)
    sw    $9,  STK_OFFSET_HI($29)

    mfc0  $8,  $14, 0                          /* Save the EPC                                         */
    sw    $8,  STK_OFFSET_EPC($29)

    mfc0  $8,  $12, 0
    sw    $8,  STK_OFFSET_SR($29)

    la    $8,  OSIntNesting                    /* See if OSIntNesting == 0                             */
    lbu   $9,  0($8)

/*
    ori $4,$9,0x0
    jal PrintInfo
    nop  
*/

    bne   $0,  $9, TICK_INC_NESTING
    nop

    la    $10, OSTCBCur                        /* Save the current task's stack pointer                */
    lw    $11, 0($10)
    sw    $29, 0($11)

TICK_INC_NESTING:

    addi  $9,  $9, 1                           /* Increment OSIntNesting                               */
    sb    $9,  0($8)

INT_LOOP:

    mfc0  $8,  $13                             /* Get the "Interrupt Pending" field from the Cause reg */

 
  li    $9, 0xff00                           /* 将上面代码使用这句代码代替 */

    and   $8,  $9

    clz   $8,  $8                              /* Count leading zeros to find all pending interrupts   */
    move  $4,  $8
    la    $8,  BSP_Interrupt_Handler           /* Call BSP_Interrupt_Handler() to handle the interrupt */

    li    $9,  32                              /* Load the compared value for the loop(while cnt != 32)*/

/*
    ori $4,$0,0x55
    jal PrintInfo
    nop  

    ori $4,$9,0x0
    jal PrintInfo
    nop  
*/
    beq   $4,  $9, INT_LOOP_END
    nop

    /* 2013-9-27注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */

    jalr  $8
    nop

    b     INT_LOOP
    nop

INT_LOOP_END:

    la    $8,  OSIntExit                       /* Call OSIntExit()                                     */

    /* 2013-9-27注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */

    jalr  $8
    nop

    lw    $8,  STK_OFFSET_SR($29)              /* Restore the Status register                          */
    mtc0  $8,  $12, 0

    lw    $8,  STK_OFFSET_EPC($29)             /* Restore the EPC                                      */
    mtc0  $8,  $14, 0

    lw    $8,  STK_OFFSET_LO($29)              /* Restore the contents of the LO and HI registers      */
    lw    $9,  STK_OFFSET_HI($29)
    mtlo  $8
    mtlo  $9

    lw    $31, STK_OFFSET_GPR31($29)           /* Restore the General Purpose Registers                */
    lw    $30, STK_OFFSET_GPR30($29)
    lw    $28, STK_OFFSET_GPR28($29)
    lw    $27, STK_OFFSET_GPR27($29)
    lw    $26, STK_OFFSET_GPR26($29)
    lw    $25, STK_OFFSET_GPR25($29)
    lw    $24, STK_OFFSET_GPR24($29)
    lw    $23, STK_OFFSET_GPR23($29)
    lw    $22, STK_OFFSET_GPR22($29)
    lw    $21, STK_OFFSET_GPR21($29)
    lw    $20, STK_OFFSET_GPR20($29)
    lw    $19, STK_OFFSET_GPR19($29)
    lw    $18, STK_OFFSET_GPR18($29)
    lw    $17, STK_OFFSET_GPR17($29)
    lw    $16, STK_OFFSET_GPR16($29)
    lw    $15, STK_OFFSET_GPR15($29)
    lw    $14, STK_OFFSET_GPR14($29)
    lw    $13, STK_OFFSET_GPR13($29)
    lw    $12, STK_OFFSET_GPR12($29)
    lw    $11, STK_OFFSET_GPR11($29)
    lw    $10, STK_OFFSET_GPR10($29)
    lw    $9,  STK_OFFSET_GPR9($29)
    lw    $8,  STK_OFFSET_GPR8($29)
    lw    $7,  STK_OFFSET_GPR7($29)
    lw    $6,  STK_OFFSET_GPR6($29)
    lw    $5,  STK_OFFSET_GPR5($29)
    lw    $4,  STK_OFFSET_GPR4($29)
    lw    $3,  STK_OFFSET_GPR3($29)
    lw    $2,  STK_OFFSET_GPR2($29)
    lw    $1,  STK_OFFSET_GPR1($29)

    addi  $29, $29, STK_CTX_SIZE               /* Adjust the stack pointer                             */
    
    /* 2013-9-27注释：可以去掉ei指令 */
    /* ei */                                   /* Enable Interrupts                                   */

    eret

    .end InterruptHandler

/*
*********************************************************************************************************
*                                          ExceptionHandler
*
* Description: This function handles all generated exceptions, saving the current task's context. The
*              task is then restored once the pending interrupts have been processed.
*
*              The interrupted task's context is saved onto its stack as follows:
*
*
*              OSTCBHighRdy->OSTCBStkPtr + 0x00    Free Entry                    (LOW Memory)
*                                        + 0x04    Status Register
*                                        + 0x08    EPC
*                                        + 0x0C    Special Purpose LO Register
*                                        + 0x10    Special Purpose HI Register
*                                        + 0x14    GPR[1]
*                                        + 0x18    GPR[2]
*                                        + 0x1C    GPR[3]
*                                        + 0x20    GPR[4]
*                                               |
*                                               |
*                                              \ /
*                                               V
*                                        + 0x80    GPR[28]
*                                        + 0x84    GPR[30]
*                                        + 0x88    GPR[31]                       (HIGH Memory)
*********************************************************************************************************
*/

    .ent ExceptionHandler
ExceptionHandler:
    /* 2013-9-27注释：可以去掉此处的di指令  */
    /* di */

    addi  $29, $29, -STK_CTX_SIZE              /* Adjust the stack pointer                             */                      

    sw    $1,  STK_OFFSET_GPR1($29)            /* Save the General Pupose Registers                    */
    sw    $2,  STK_OFFSET_GPR2($29)
    sw    $3,  STK_OFFSET_GPR3($29)
    sw    $4,  STK_OFFSET_GPR4($29)
    sw    $5,  STK_OFFSET_GPR5($29)
    sw    $6,  STK_OFFSET_GPR6($29)
    sw    $7,  STK_OFFSET_GPR7($29)
    sw    $8,  STK_OFFSET_GPR8($29)
    sw    $9,  STK_OFFSET_GPR9($29)
    sw    $10, STK_OFFSET_GPR10($29)
    sw    $11, STK_OFFSET_GPR11($29)
    sw    $12, STK_OFFSET_GPR12($29)
    sw    $13, STK_OFFSET_GPR13($29)
    sw    $14, STK_OFFSET_GPR14($29)
    sw    $15, STK_OFFSET_GPR15($29)
    sw    $16, STK_OFFSET_GPR16($29)
    sw    $17, STK_OFFSET_GPR17($29)
    sw    $18, STK_OFFSET_GPR18($29)
    sw    $19, STK_OFFSET_GPR19($29)
    sw    $20, STK_OFFSET_GPR20($29)
    sw    $21, STK_OFFSET_GPR21($29)
    sw    $22, STK_OFFSET_GPR22($29)
    sw    $23, STK_OFFSET_GPR23($29)
    sw    $24, STK_OFFSET_GPR24($29)
    sw    $25, STK_OFFSET_GPR25($29)
    sw    $26, STK_OFFSET_GPR26($29)
    sw    $27, STK_OFFSET_GPR27($29)
    sw    $28, STK_OFFSET_GPR28($29)
    sw    $30, STK_OFFSET_GPR30($29)
    sw    $31, STK_OFFSET_GPR31($29)
                                               /* Save the contents of the LO and HI registers         */
    mflo  $8
    mfhi  $9
    sw    $8,  STK_OFFSET_LO($29)
    sw    $9,  STK_OFFSET_HI($29)

    mfc0  $8,  $14, 0                          /* Save the EPC                                         */
    addi  $8,  $8, 4
    sw    $8,  STK_OFFSET_EPC($29)

    mfc0  $8,  $12, 0
    sw    $8,  STK_OFFSET_SR($29)

    la    $10, OSTCBCur                        /* Save the current task's stack pointer                */
    lw    $11, 0($10)
    sw    $29, 0($11)
  
    la    $8,  BSP_Exception_Handler           /* Call BSP_ISR_Handler() to handle the interrupt       */
    
    /* 2013-9-27注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */

    jalr  $8
    nop
    
    la    $10, OSTCBCur
    lw    $9,  0($10)

    lw    $29, 0($9)                           /* Load the new task's stack pointer                    */

    lw    $8,  STK_OFFSET_SR($29)              /* Restore the Status register                          */
    mtc0  $8,  $12, 0

    lw    $8,  STK_OFFSET_EPC($29)             /* Restore the EPC                                      */
    mtc0  $8,  $14, 0

    lw    $8,  STK_OFFSET_LO($29)              /* Restore the contents of the LO and HI registers      */
    lw    $9,  STK_OFFSET_HI($29)
    mtlo  $8
    mtlo  $9

    lw    $31, STK_OFFSET_GPR31($29)           /* Restore the General Purpose Registers                */
    lw    $30, STK_OFFSET_GPR30($29) 
    lw    $28, STK_OFFSET_GPR28($29)
    lw    $27, STK_OFFSET_GPR27($29) 
    lw    $26, STK_OFFSET_GPR26($29) 
    lw    $25, STK_OFFSET_GPR25($29) 
    lw    $24, STK_OFFSET_GPR24($29) 
    lw    $23, STK_OFFSET_GPR23($29) 
    lw    $22, STK_OFFSET_GPR22($29) 
    lw    $21, STK_OFFSET_GPR21($29) 
    lw    $20, STK_OFFSET_GPR20($29) 
    lw    $19, STK_OFFSET_GPR19($29) 
    lw    $18, STK_OFFSET_GPR18($29) 
    lw    $17, STK_OFFSET_GPR17($29) 
    lw    $16, STK_OFFSET_GPR16($29) 
    lw    $15, STK_OFFSET_GPR15($29) 
    lw    $14, STK_OFFSET_GPR14($29) 
    lw    $13, STK_OFFSET_GPR13($29) 
    lw    $12, STK_OFFSET_GPR12($29) 
    lw    $11, STK_OFFSET_GPR11($29) 
    lw    $10, STK_OFFSET_GPR10($29) 
    lw    $9,  STK_OFFSET_GPR9($29)  
    lw    $8,  STK_OFFSET_GPR8($29)  
    lw    $7,  STK_OFFSET_GPR7($29)  
    lw    $6,  STK_OFFSET_GPR6($29)  
    lw    $5,  STK_OFFSET_GPR5($29)  
    lw    $4,  STK_OFFSET_GPR4($29)  
    lw    $3,  STK_OFFSET_GPR3($29) 
    lw    $2,  STK_OFFSET_GPR2($29)  
    lw    $1,  STK_OFFSET_GPR1($29) 

    addi  $29, $29, STK_CTX_SIZE               /* Adjust the stack pointer                             */
    
    /* 2013-9-27注释：可以去掉ei指令 */
    /* ei */

    eret                                   

    .end ExceptionHandler

/*
*********************************************************************************************************
*                                            TickInterruptClear()
*
* Description : This function writes a value of '0' to the Compare register so that the timer interrupt
*               pending is cleared
*
* Arguments   : None
*
* Returns     : None
*
* Note(s)     : This function MUST be called before OSStart due to the fact that the count register is
*               automatically started at run time. Because of this, the timer interrupt occurs during
*               the start up code and before the initialization of the Tick ISR, which should be done
*               in the first task
*********************************************************************************************************
*/

    .ent TickInterruptClear
TickInterruptClear:

    mtc0  $0,  $11                              /* Set up the period in the compare reg                 */
    jr    $31
    nop

    .end TickInterruptClear

/*
*********************************************************************************************************
*                                            CoreTmrInit()
*
* Description: This function should initialize the timers used by your application
*
* Arguments  : tmr_reload($4) Value that the compare register is incremented by to simulate the correct
                              clock frequency
*
* Returns    : None
*********************************************************************************************************
*/

    .ent CoreTmrInit
CoreTmrInit:

    mtc0  $4,  $11                              /* Set up the period in the compare reg                */
    nop
    mtc0  $0,  $9                               /* Clear the count reg                                 */
    jr    $31
    nop

    .end CoreTmrInit

/*
*********************************************************************************************************
*                                              TickISR()
*
* Description : This function provides the ISR executed at each Core clock tick
*
* Arguments   : tmr_reload($4) Value that the compare register is incremented by to simulate the correct
*                              clock frequency
*
* Returns     : None
*********************************************************************************************************
*/

    .ent TickISR
TickISR:
    addiu $29,$29,-24
    sw $16, 0x4($29)
    sw $8, 0x8($29)
    sw $31, 0xC($29)

   /*  move  $16, $31 */

    mfc0  $8,  $11                              /* Get the old compare time                            */
    addu  $8,  $4                               /* Add the increment value BSP_TMR_RELOAD              */
    mtc0  $8,  $11                              /* Set up the period in the compare reg                */

    la    $8,  OSTimeTick                       /* Call OSTimeTick() to signal to the OS a clock tick  */

    /* 2013-9-27注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */

    jalr  $8
    nop

    /* move  $31, $16 */
    lw $31, 0xC($29)
    lw $16, 0x4($29)
    lw $8, 0x8($29)
    addiu $29,$29,24
    jr    $31
    nop

    .end TickISR

/*
*********************************************************************************************************
*                                       DisableInterruptSource()
*
* Description : This function disables a particular hardware interrupt source
*
* Arguments   : src_nbr($4) Hardware interrupt source to disable
*
* Returns     : None
*********************************************************************************************************
*/

    .ent DisableInterruptSource
DisableInterruptSource:

    mfc0  $8,  $12
    and   $8,  $4
    mtc0  $8,  $12
    jr    $31
    nop

    .end DisableInterruptSource

/*
*********************************************************************************************************
*                                       EnableInterruptSource()
*
* Description : This function enables a particular hardware interrupt source
*
* Arguments   : src_nbr($4) Hardware interrupt source to enable
*
* Returns     : None
*********************************************************************************************************
*/

    .ent EnableInterruptSource
EnableInterruptSource:

    mfc0  $8,  $12
    or    $8,  $4
    mtc0  $8,  $12
    jr    $31
    nop

    .end EnableInterruptSource

