/*
*********************************************************************************************************
*                                                uC/OS-II
*                                          The Real-Time Kernel
*
*                              (c) Copyright 1992-2009, Micrium, Weston, FL
*                                           All Rights Reserved
*
* File    : uCOS_II.H
* By      : Jean J. Labrosse
* Version : V2.91
*
* LICENSING TERMS:
* ---------------
*   uC/OS-II is provided in source form for FREE evaluation, for educational use or for peaceful research.
* If you plan on using  uC/OS-II  in a commercial product you need to contact Micriµm to properly license
* its use in your product. We provide ALL the source code for your convenience and to help you experience
* uC/OS-II.   The fact that the  source is provided does  NOT  mean that you can use it without  paying a
* licensing fee.
*********************************************************************************************************
*/

#ifndef   OS_uCOS_II_H
#define   OS_uCOS_II_H

#ifdef __cplusplus
extern "C" {
#endif

/*
*********************************************************************************************************
*                                          uC/OS-II VERSION NUMBER
*********************************************************************************************************
*/

#define  OS_VERSION                 291u                /* Version of uC/OS-II (Vx.yy mult. by 100)    */

/*
*********************************************************************************************************
*                                           INCLUDE HEADER FILES
*********************************************************************************************************
*/

#include <app_cfg.h>
#include <os_cfg.h>
#include <os_cpu.h>

/*
*********************************************************************************************************
*                                             MISCELLANEOUS
*********************************************************************************************************
*/

#ifdef   OS_GLOBALS
#define  OS_EXT
#else
#define  OS_EXT  extern
#endif

#ifndef  OS_FALSE
#define  OS_FALSE                       0u
#endif

#ifndef  OS_TRUE
#define  OS_TRUE                        1u
#endif

#define  OS_ASCII_NUL            (INT8U)0

#define  OS_PRIO_SELF                0xFFu              /* Indicate SELF priority                      */

#if OS_TASK_STAT_EN > 0u
#define  OS_N_SYS_TASKS                 2u              /* Number of system tasks                      */
#else
#define  OS_N_SYS_TASKS                 1u
#endif

#define  OS_TASK_STAT_PRIO  (OS_LOWEST_PRIO - 1u)       /* Statistic task priority                     */
#define  OS_TASK_IDLE_PRIO  (OS_LOWEST_PRIO)            /* IDLE      task priority                     */

#if OS_LOWEST_PRIO <= 63u
#define  OS_EVENT_TBL_SIZE ((OS_LOWEST_PRIO) / 8u + 1u) /* Size of event table                         */
#define  OS_RDY_TBL_SIZE   ((OS_LOWEST_PRIO) / 8u + 1u) /* Size of ready table                         */
#else
#define  OS_EVENT_TBL_SIZE ((OS_LOWEST_PRIO) / 16u + 1u)/* Size of event table                         */
#define  OS_RDY_TBL_SIZE   ((OS_LOWEST_PRIO) / 16u + 1u)/* Size of ready table                         */
#endif

#define  OS_TASK_IDLE_ID            65535u              /* ID numbers for Idle, Stat and Timer tasks   */
#define  OS_TASK_STAT_ID            65534u
#define  OS_TASK_TMR_ID             65533u

#define  OS_EVENT_EN           (((OS_Q_EN > 0u) && (OS_MAX_QS > 0u)) || (OS_MBOX_EN > 0u) || (OS_SEM_EN > 0u) || (OS_MUTEX_EN > 0u))

#define  OS_TCB_RESERVED        ((OS_TCB *)1)

/*$PAGE*/
/*
*********************************************************************************************************
*                              TASK STATUS (Bit definition for OSTCBStat)
*********************************************************************************************************
*/
#define  OS_STAT_RDY                 0x00u  /* Ready to run                                            */
#define  OS_STAT_SEM                 0x01u  /* Pending on semaphore                                    */
#define  OS_STAT_MBOX                0x02u  /* Pending on mailbox                                      */
#define  OS_STAT_Q                   0x04u  /* Pending on queue                                        */
#define  OS_STAT_SUSPEND             0x08u  /* Task is suspended                                       */
#define  OS_STAT_MUTEX               0x10u  /* Pending on mutual exclusion semaphore                   */
#define  OS_STAT_FLAG                0x20u  /* Pending on event flag group                             */
#define  OS_STAT_MULTI               0x80u  /* Pending on multiple events                              */

#define  OS_STAT_PEND_ANY         (OS_STAT_SEM | OS_STAT_MBOX | OS_STAT_Q | OS_STAT_MUTEX | OS_STAT_FLAG)

/*
*********************************************************************************************************
*                           TASK PEND STATUS (Status codes for OSTCBStatPend)
*********************************************************************************************************
*/
#define  OS_STAT_PEND_OK                0u  /* Pending status OK, not pending, or pending complete     */
#define  OS_STAT_PEND_TO                1u  /* Pending timed out                                       */
#define  OS_STAT_PEND_ABORT             2u  /* Pending aborted                                         */

/*
*********************************************************************************************************
*                                        OS_EVENT types
*********************************************************************************************************
*/
#define  OS_EVENT_TYPE_UNUSED           0u
#define  OS_EVENT_TYPE_MBOX             1u
#define  OS_EVENT_TYPE_Q                2u
#define  OS_EVENT_TYPE_SEM              3u
#define  OS_EVENT_TYPE_MUTEX            4u
#define  OS_EVENT_TYPE_FLAG             5u

#define  OS_TMR_TYPE                  100u  /* Used to identify Timers ...                             */
                                            /* ... (Must be different value than OS_EVENT_TYPE_xxx)    */

/*
*********************************************************************************************************
*                                         EVENT FLAGS
*********************************************************************************************************
*/
#define  OS_FLAG_WAIT_CLR_ALL           0u  /* Wait for ALL    the bits specified to be CLR (i.e. 0)   */
#define  OS_FLAG_WAIT_CLR_AND           0u

#define  OS_FLAG_WAIT_CLR_ANY           1u  /* Wait for ANY of the bits specified to be CLR (i.e. 0)   */
#define  OS_FLAG_WAIT_CLR_OR            1u

#define  OS_FLAG_WAIT_SET_ALL           2u  /* Wait for ALL    the bits specified to be SET (i.e. 1)   */
#define  OS_FLAG_WAIT_SET_AND           2u

#define  OS_FLAG_WAIT_SET_ANY           3u  /* Wait for ANY of the bits specified to be SET (i.e. 1)   */
#define  OS_FLAG_WAIT_SET_OR            3u


#define  OS_FLAG_CONSUME             0x80u  /* Consume the flags if condition(s) satisfied             */


#define  OS_FLAG_CLR                    0u
#define  OS_FLAG_SET                    1u

/*
*********************************************************************************************************
*                                   Values for OSTickStepState
*
* Note(s): This feature is used by uC/OS-View.
*********************************************************************************************************
*/

#if OS_TICK_STEP_EN > 0u
#define  OS_TICK_STEP_DIS               0u  /* Stepping is disabled, tick runs as mormal               */
#define  OS_TICK_STEP_WAIT              1u  /* Waiting for uC/OS-View to set OSTickStepState to _ONCE  */
#define  OS_TICK_STEP_ONCE              2u  /* Process tick once and wait for next cmd from uC/OS-View */
#endif

/*
*********************************************************************************************************
*       Possible values for 'opt' argument of OSSemDel(), OSMboxDel(), OSQDel() and OSMutexDel()
*********************************************************************************************************
*/
#define  OS_DEL_NO_PEND                 0u
#define  OS_DEL_ALWAYS                  1u

/*
*********************************************************************************************************
*                                        OS???Pend() OPTIONS
*
* These #defines are used to establish the options for OS???PendAbort().
*********************************************************************************************************
*/
#define  OS_PEND_OPT_NONE               0u  /* NO option selected                                      */
#define  OS_PEND_OPT_BROADCAST          1u  /* Broadcast action to ALL tasks waiting                   */

/*
*********************************************************************************************************
*                                     OS???PostOpt() OPTIONS
*
* These #defines are used to establish the options for OSMboxPostOpt() and OSQPostOpt().
*********************************************************************************************************
*/
#define  OS_POST_OPT_NONE            0x00u  /* NO option selected                                      */
#define  OS_POST_OPT_BROADCAST       0x01u  /* Broadcast message to ALL tasks waiting                  */
#define  OS_POST_OPT_FRONT           0x02u  /* Post to highest priority task waiting                   */
#define  OS_POST_OPT_NO_SCHED        0x04u  /* Do not call the scheduler if this option is selected    */

/*
*********************************************************************************************************
*                                 TASK OPTIONS (see OSTaskCreateExt())
*********************************************************************************************************
*/
#define  OS_TASK_OPT_NONE          0x0000u  /* NO option selected                                      */
#define  OS_TASK_OPT_STK_CHK       0x0001u  /* Enable stack checking for the task                      */
#define  OS_TASK_OPT_STK_CLR       0x0002u  /* Clear the stack when the task is create                 */
#define  OS_TASK_OPT_SAVE_FP       0x0004u  /* Save the contents of any floating-point registers       */

/*
*********************************************************************************************************
*                            TIMER OPTIONS (see OSTmrStart() and OSTmrStop())
*********************************************************************************************************
*/
#define  OS_TMR_OPT_NONE                0u  /* No option selected                                      */

#define  OS_TMR_OPT_ONE_SHOT            1u  /* Timer will not automatically restart when it expires    */
#define  OS_TMR_OPT_PERIODIC            2u  /* Timer will     automatically restart when it expires    */

#define  OS_TMR_OPT_CALLBACK            3u  /* OSTmrStop() option to call 'callback' w/ timer arg.     */
#define  OS_TMR_OPT_CALLBACK_ARG        4u  /* OSTmrStop() option to call 'callback' w/ new   arg.     */

/*
*********************************************************************************************************
*                                            TIMER STATES
*********************************************************************************************************
*/
#define  OS_TMR_STATE_UNUSED            0u
#define  OS_TMR_STATE_STOPPED           1u
#define  OS_TMR_STATE_COMPLETED         2u
#define  OS_TMR_STATE_RUNNING           3u

/*
*********************************************************************************************************
*                                             ERROR CODES
*********************************************************************************************************
*/
#define OS_ERR_NONE                     0u

#define OS_ERR_EVENT_TYPE               1u
#define OS_ERR_PEND_ISR                 2u
#define OS_ERR_POST_NULL_PTR            3u
#define OS_ERR_PEVENT_NULL              4u
#define OS_ERR_POST_ISR                 5u
#define OS_ERR_QUERY_ISR                6u
#define OS_ERR_INVALID_OPT              7u
#define OS_ERR_ID_INVALID               8u
#define OS_ERR_PDATA_NULL               9u

#define OS_ERR_TIMEOUT                 10u
#define OS_ERR_EVENT_NAME_TOO_LONG     11u
#define OS_ERR_PNAME_NULL              12u
#define OS_ERR_PEND_LOCKED             13u
#define OS_ERR_PEND_ABORT              14u
#define OS_ERR_DEL_ISR                 15u
#define OS_ERR_CREATE_ISR              16u
#define OS_ERR_NAME_GET_ISR            17u
#define OS_ERR_NAME_SET_ISR            18u
#define OS_ERR_ILLEGAL_CREATE_RUN_TIME 19u

#define OS_ERR_MBOX_FULL               20u

#define OS_ERR_Q_FULL                  30u
#define OS_ERR_Q_EMPTY                 31u

#define OS_ERR_PRIO_EXIST              40u
#define OS_ERR_PRIO                    41u
#define OS_ERR_PRIO_INVALID            42u

#define OS_ERR_SCHED_LOCKED            50u
#define OS_ERR_SEM_OVF                 51u

#define OS_ERR_TASK_CREATE_ISR         60u
#define OS_ERR_TASK_DEL                61u
#define OS_ERR_TASK_DEL_IDLE           62u
#define OS_ERR_TASK_DEL_REQ            63u
#define OS_ERR_TASK_DEL_ISR            64u
#define OS_ERR_TASK_NAME_TOO_LONG      65u
#define OS_ERR_TASK_NO_MORE_TCB        66u
#define OS_ERR_TASK_NOT_EXIST          67u
#define OS_ERR_TASK_NOT_SUSPENDED      68u
#define OS_ERR_TASK_OPT                69u
#define OS_ERR_TASK_RESUME_PRIO        70u
#define OS_ERR_TASK_SUSPEND_IDLE       71u
#define OS_ERR_TASK_SUSPEND_PRIO       72u
#define OS_ERR_TASK_WAITING            73u

#define OS_ERR_TIME_NOT_DLY            80u
#define OS_ERR_TIME_INVALID_MINUTES    81u
#define OS_ERR_TIME_INVALID_SECONDS    82u
#define OS_ERR_TIME_INVALID_MS         83u
#define OS_ERR_TIME_ZERO_DLY           84u
#define OS_ERR_TIME_DLY_ISR            85u

#define OS_ERR_MEM_INVALID_PART        90u
#define OS_ERR_MEM_INVALID_BLKS        91u
#define OS_ERR_MEM_INVALID_SIZE        92u
#define OS_ERR_MEM_NO_FREE_BLKS        93u
#define OS_ERR_MEM_FULL                94u
#define OS_ERR_MEM_INVALID_PBLK        95u
#define OS_ERR_MEM_INVALID_PMEM        96u
#define OS_ERR_MEM_INVALID_PDATA       97u
#define OS_ERR_MEM_INVALID_ADDR        98u
#define OS_ERR_MEM_NAME_TOO_LONG       99u

#define OS_ERR_NOT_MUTEX_OWNER        100u

#define OS_ERR_FLAG_INVALID_PGRP      110u
#define OS_ERR_FLAG_WAIT_TYPE         111u
#define OS_ERR_FLAG_NOT_RDY           112u
#define OS_ERR_FLAG_INVALID_OPT       113u
#define OS_ERR_FLAG_GRP_DEPLETED      114u
#define OS_ERR_FLAG_NAME_TOO_LONG     115u

#define OS_ERR_PIP_LOWER              120u

#define OS_ERR_TMR_INVALID_DLY        130u
#define OS_ERR_TMR_INVALID_PERIOD     131u
#define OS_ERR_TMR_INVALID_OPT        132u
#define OS_ERR_TMR_INVALID_NAME       133u
#define OS_ERR_TMR_NON_AVAIL          134u
#define OS_ERR_TMR_INACTIVE           135u
#define OS_ERR_TMR_INVALID_DEST       136u
#define OS_ERR_TMR_INVALID_TYPE       137u
#define OS_ERR_TMR_INVALID            138u
#define OS_ERR_TMR_ISR                139u
#define OS_ERR_TMR_NAME_TOO_LONG      140u
#define OS_ERR_TMR_INVALID_STATE      141u
#define OS_ERR_TMR_STOPPED            142u
#define OS_ERR_TMR_NO_CALLBACK        143u

/*$PAGE*/
/*
*********************************************************************************************************
*                                          EVENT CONTROL BLOCK
*********************************************************************************************************
*/

#if OS_LOWEST_PRIO <= 63u
typedef  INT8U    OS_PRIO;
#else
typedef  INT16U   OS_PRIO;
#endif

#if (OS_EVENT_EN) && (OS_MAX_EVENTS > 0u)
typedef struct os_event {
    INT8U    OSEventType;                    /* Type of event control block (see OS_EVENT_TYPE_xxxx)    */
    void    *OSEventPtr;                     /* Pointer to message or queue structure                   */
    INT16U   OSEventCnt;                     /* Semaphore Count (not used if other EVENT type)          */
    OS_PRIO  OSEventGrp;                     /* Group corresponding to tasks waiting for event to occur */
    OS_PRIO  OSEventTbl[OS_EVENT_TBL_SIZE];  /* List of tasks waiting for event to occur                */

#if OS_EVENT_NAME_EN > 0u
    INT8U   *OSEventName;
#endif
} OS_EVENT;
#endif


/*
*********************************************************************************************************
*                                       EVENT FLAGS CONTROL BLOCK
*********************************************************************************************************
*/

#if (OS_FLAG_EN > 0u) && (OS_MAX_FLAGS > 0u)

#if OS_FLAGS_NBITS == 8u                    /* Determine the size of OS_FLAGS (8, 16 or 32 bits)       */
typedef  INT8U    OS_FLAGS;
#endif

#if OS_FLAGS_NBITS == 16u
typedef  INT16U   OS_FLAGS;
#endif

#if OS_FLAGS_NBITS == 32u
typedef  INT32U   OS_FLAGS;
#endif


typedef struct os_flag_grp {                /* Event Flag Group                                        */
    INT8U         OSFlagType;               /* Should be set to OS_EVENT_TYPE_FLAG                     */
    void         *OSFlagWaitList;           /* Pointer to first NODE of task waiting on event flag     */
    OS_FLAGS      OSFlagFlags;              /* 8, 16 or 32 bit flags                                   */
#if OS_FLAG_NAME_EN > 0u
    INT8U        *OSFlagName;
#endif
} OS_FLAG_GRP;



typedef struct os_flag_node {               /* Event Flag Wait List Node                               */
    void         *OSFlagNodeNext;           /* Pointer to next     NODE in wait list                   */
    void         *OSFlagNodePrev;           /* Pointer to previous NODE in wait list                   */
    void         *OSFlagNodeTCB;            /* Pointer to TCB of waiting task                          */
    void         *OSFlagNodeFlagGrp;        /* Pointer to Event Flag Group                             */
    OS_FLAGS      OSFlagNodeFlags;          /* Event flag to wait on                                   */
    INT8U         OSFlagNodeWaitType;       /* Type of wait:                                           */
                                            /*      OS_FLAG_WAIT_AND                                   */
                                            /*      OS_FLAG_WAIT_ALL                                   */
                                            /*      OS_FLAG_WAIT_OR                                    */
                                            /*      OS_FLAG_WAIT_ANY                                   */
} OS_FLAG_NODE;
#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                          MESSAGE MAILBOX DATA
*********************************************************************************************************
*/

#if OS_MBOX_EN > 0u
typedef struct os_mbox_data {
    void   *OSMsg;                         /* Pointer to message in mailbox                            */
    OS_PRIO OSEventTbl[OS_EVENT_TBL_SIZE]; /* List of tasks waiting for event to occur                 */
    OS_PRIO OSEventGrp;                    /* Group corresponding to tasks waiting for event to occur  */
} OS_MBOX_DATA;
#endif

/*
*********************************************************************************************************
*                                     MEMORY PARTITION DATA STRUCTURES
*********************************************************************************************************
*/

#if (OS_MEM_EN > 0u) && (OS_MAX_MEM_PART > 0u)
typedef struct os_mem {                   /* MEMORY CONTROL BLOCK                                      */
    void   *OSMemAddr;                    /* Pointer to beginning of memory partition                  */
    void   *OSMemFreeList;                /* Pointer to list of free memory blocks                     */
    INT32U  OSMemBlkSize;                 /* Size (in bytes) of each block of memory                   */
    INT32U  OSMemNBlks;                   /* Total number of blocks in this partition                  */
    INT32U  OSMemNFree;                   /* Number of memory blocks remaining in this partition       */
#if OS_MEM_NAME_EN > 0u
    INT8U  *OSMemName;                    /* Memory partition name                                     */
#endif
} OS_MEM;


typedef struct os_mem_data {
    void   *OSAddr;                    /* Pointer to the beginning address of the memory partition     */
    void   *OSFreeList;                /* Pointer to the beginning of the free list of memory blocks   */
    INT32U  OSBlkSize;                 /* Size (in bytes) of each memory block                         */
    INT32U  OSNBlks;                   /* Total number of blocks in the partition                      */
    INT32U  OSNFree;                   /* Number of memory blocks free                                 */
    INT32U  OSNUsed;                   /* Number of memory blocks used                                 */
} OS_MEM_DATA;
#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                    MUTUAL EXCLUSION SEMAPHORE DATA
*********************************************************************************************************
*/

#if OS_MUTEX_EN > 0u
typedef struct os_mutex_data {
    OS_PRIO OSEventTbl[OS_EVENT_TBL_SIZE];  /* List of tasks waiting for event to occur                */
    OS_PRIO OSEventGrp;                     /* Group corresponding to tasks waiting for event to occur */
    BOOLEAN OSValue;                        /* Mutex value (OS_FALSE = used, OS_TRUE = available)      */
    INT8U   OSOwnerPrio;                    /* Mutex owner's task priority or 0xFF if no owner         */
    INT8U   OSMutexPIP;                     /* Priority Inheritance Priority or 0xFF if no owner       */
} OS_MUTEX_DATA;
#endif

/*
*********************************************************************************************************
*                                          MESSAGE QUEUE DATA
*********************************************************************************************************
*/

#if OS_Q_EN > 0u
typedef struct os_q {                   /* QUEUE CONTROL BLOCK                                         */
    struct os_q   *OSQPtr;              /* Link to next queue control block in list of free blocks     */
    void         **OSQStart;            /* Pointer to start of queue data                              */
    void         **OSQEnd;              /* Pointer to end   of queue data                              */
    void         **OSQIn;               /* Pointer to where next message will be inserted  in   the Q  */
    void         **OSQOut;              /* Pointer to where next message will be extracted from the Q  */
    INT16U         OSQSize;             /* Size of queue (maximum number of entries)                   */
    INT16U         OSQEntries;          /* Current number of entries in the queue                      */
} OS_Q;


typedef struct os_q_data {
    void          *OSMsg;               /* Pointer to next message to be extracted from queue          */
    INT16U         OSNMsgs;             /* Number of messages in message queue                         */
    INT16U         OSQSize;             /* Size of message queue                                       */
    OS_PRIO        OSEventTbl[OS_EVENT_TBL_SIZE];  /* List of tasks waiting for event to occur         */
    OS_PRIO        OSEventGrp;          /* Group corresponding to tasks waiting for event to occur     */
} OS_Q_DATA;
#endif

/*
*********************************************************************************************************
*                                           SEMAPHORE DATA
*********************************************************************************************************
*/

#if OS_SEM_EN > 0u
typedef struct os_sem_data {
    INT16U  OSCnt;                          /* Semaphore count                                         */
    OS_PRIO OSEventTbl[OS_EVENT_TBL_SIZE];  /* List of tasks waiting for event to occur                */
    OS_PRIO OSEventGrp;                     /* Group corresponding to tasks waiting for event to occur */
} OS_SEM_DATA;
#endif

/*
*********************************************************************************************************
*                                            TASK STACK DATA
*********************************************************************************************************
*/

#if OS_TASK_CREATE_EXT_EN > 0u
typedef struct os_stk_data {
    INT32U  OSFree;                    /* Number of free bytes on the stack                            */
    INT32U  OSUsed;                    /* Number of bytes used on the stack                            */
} OS_STK_DATA;
#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                          TASK CONTROL BLOCK
*********************************************************************************************************
*/

typedef struct os_tcb {
    OS_STK          *OSTCBStkPtr;           /* Pointer to current top of stack                         */

#if OS_TASK_CREATE_EXT_EN > 0u
    void            *OSTCBExtPtr;           /* Pointer to user definable data for TCB extension        */
    OS_STK          *OSTCBStkBottom;        /* Pointer to bottom of stack                              */
    INT32U           OSTCBStkSize;          /* Size of task stack (in number of stack elements)        */
    INT16U           OSTCBOpt;              /* Task options as passed by OSTaskCreateExt()             */
    INT16U           OSTCBId;               /* Task ID (0..65535)                                      */
#endif

    struct os_tcb   *OSTCBNext;             /* Pointer to next     TCB in the TCB list                 */
    struct os_tcb   *OSTCBPrev;             /* Pointer to previous TCB in the TCB list                 */

#if (OS_EVENT_EN)
    OS_EVENT        *OSTCBEventPtr;         /* Pointer to          event control block                 */
#endif

#if (OS_EVENT_EN) && (OS_EVENT_MULTI_EN > 0u)
    OS_EVENT       **OSTCBEventMultiPtr;    /* Pointer to multiple event control blocks                */
#endif

#if ((OS_Q_EN > 0u) && (OS_MAX_QS > 0u)) || (OS_MBOX_EN > 0u)
    void            *OSTCBMsg;              /* Message received from OSMboxPost() or OSQPost()         */
#endif

#if (OS_FLAG_EN > 0u) && (OS_MAX_FLAGS > 0u)
#if OS_TASK_DEL_EN > 0u
    OS_FLAG_NODE    *OSTCBFlagNode;         /* Pointer to event flag node                              */
#endif
    OS_FLAGS         OSTCBFlagsRdy;         /* Event flags that made task ready to run                 */
#endif

    INT32U           OSTCBDly;              /* Nbr ticks to delay task or, timeout waiting for event   */
    INT8U            OSTCBStat;             /* Task      status                                        */
    INT8U            OSTCBStatPend;         /* Task PEND status                                        */
    INT8U            OSTCBPrio;             /* Task priority (0 == highest)                            */

    INT8U            OSTCBX;                /* Bit position in group  corresponding to task priority   */
    INT8U            OSTCBY;                /* Index into ready table corresponding to task priority   */
    OS_PRIO          OSTCBBitX;             /* Bit mask to access bit position in ready table          */
    OS_PRIO          OSTCBBitY;             /* Bit mask to access bit position in ready group          */

#if OS_TASK_DEL_EN > 0u
    INT8U            OSTCBDelReq;           /* Indicates whether a task needs to delete itself         */
#endif

#if OS_TASK_PROFILE_EN > 0u
    INT32U           OSTCBCtxSwCtr;         /* Number of time the task was switched in                 */
    INT32U           OSTCBCyclesTot;        /* Total number of clock cycles the task has been running  */
    INT32U           OSTCBCyclesStart;      /* Snapshot of cycle counter at start of task resumption   */
    OS_STK          *OSTCBStkBase;          /* Pointer to the beginning of the task stack              */
    INT32U           OSTCBStkUsed;          /* Number of bytes used from the stack                     */
#endif

#if OS_TASK_NAME_EN > 0u
    INT8U           *OSTCBTaskName;
#endif

#if OS_TASK_REG_TBL_SIZE > 0u
    INT32U           OSTCBRegTbl[OS_TASK_REG_TBL_SIZE];
#endif
} OS_TCB;

/*$PAGE*/
/*
************************************************************************************************************************
*                                                   TIMER DATA TYPES
************************************************************************************************************************
*/

#if OS_TMR_EN > 0u
typedef  void (*OS_TMR_CALLBACK)(void *ptmr, void *parg);



typedef  struct  os_tmr {
    INT8U            OSTmrType;                       /* Should be set to OS_TMR_TYPE                                  */
    OS_TMR_CALLBACK  OSTmrCallback;                   /* Function to call when timer expires                           */
    void            *OSTmrCallbackArg;                /* Argument to pass to function when timer expires               */
    void            *OSTmrNext;                       /* Double link list pointers                                     */
    void            *OSTmrPrev;
    INT32U           OSTmrMatch;                      /* Timer expires when OSTmrTime == OSTmrMatch                    */
    INT32U           OSTmrDly;                        /* Delay time before periodic update starts                      */
    INT32U           OSTmrPeriod;                     /* Period to repeat timer                                        */
#if OS_TMR_CFG_NAME_EN > 0u
    INT8U           *OSTmrName;                       /* Name to give the timer                                        */
#endif
    INT8U            OSTmrOpt;                        /* Options (see OS_TMR_OPT_xxx)                                  */
    INT8U            OSTmrState;                      /* Indicates the state of the timer:                             */
                                                      /*     OS_TMR_STATE_UNUSED                                       */
                                                      /*     OS_TMR_STATE_RUNNING                                      */
                                                      /*     OS_TMR_STATE_STOPPED                                      */
} OS_TMR;



typedef  struct  os_tmr_wheel {
    OS_TMR          *OSTmrFirst;                      /* Pointer to first timer in linked list                         */
    INT16U           OSTmrEntries;
} OS_TMR_WHEEL;
#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                            GLOBAL VARIABLES
*********************************************************************************************************
*/

OS_EXT  INT32U            OSCtxSwCtr;               /* Counter of number of context switches           */

#if (OS_EVENT_EN) && (OS_MAX_EVENTS > 0u)
OS_EXT  OS_EVENT         *OSEventFreeList;          /* Pointer to list of free EVENT control blocks    */
OS_EXT  OS_EVENT          OSEventTbl[OS_MAX_EVENTS];/* Table of EVENT control blocks                   */
#endif

#if (OS_FLAG_EN > 0u) && (OS_MAX_FLAGS > 0u)
OS_EXT  OS_FLAG_GRP       OSFlagTbl[OS_MAX_FLAGS];  /* Table containing event flag groups              */
OS_EXT  OS_FLAG_GRP      *OSFlagFreeList;           /* Pointer to free list of event flag groups       */
#endif

#if OS_TASK_STAT_EN > 0u
OS_EXT  INT8U             OSCPUUsage;               /* Percentage of CPU used                          */
OS_EXT  INT32U            OSIdleCtrMax;             /* Max. value that idle ctr can take in 1 sec.     */
OS_EXT  INT32U            OSIdleCtrRun;             /* Val. reached by idle ctr at run time in 1 sec.  */
OS_EXT  BOOLEAN           OSStatRdy;                /* Flag indicating that the statistic task is rdy  */
OS_EXT  OS_STK            OSTaskStatStk[OS_TASK_STAT_STK_SIZE];      /* Statistics task stack          */
#endif

OS_EXT  INT8U             OSIntNesting;             /* Interrupt nesting level                         */

OS_EXT  INT8U             OSLockNesting;            /* Multitasking lock nesting level                 */

OS_EXT  INT8U             OSPrioCur;                /* Priority of current task                        */
OS_EXT  INT8U             OSPrioHighRdy;            /* Priority of highest priority task               */

OS_EXT  OS_PRIO           OSRdyGrp;                        /* Ready list group                         */
OS_EXT  OS_PRIO           OSRdyTbl[OS_RDY_TBL_SIZE];       /* Table of tasks which are ready to run    */

OS_EXT  BOOLEAN           OSRunning;                       /* Flag indicating that kernel is running   */

OS_EXT  INT8U             OSTaskCtr;                       /* Number of tasks created                  */

OS_EXT  volatile  INT32U  OSIdleCtr;                                 /* Idle counter                   */

#ifdef OS_SAFETY_CRITICAL_IEC61508
OS_EXT  BOOLEAN           OSSafetyCriticalStartFlag;
#endif

OS_EXT  OS_STK            OSTaskIdleStk[OS_TASK_IDLE_STK_SIZE];      /* Idle task stack                */


OS_EXT  OS_TCB           *OSTCBCur;                        /* Pointer to currently running TCB         */
OS_EXT  OS_TCB           *OSTCBFreeList;                   /* Pointer to list of free TCBs             */
OS_EXT  OS_TCB           *OSTCBHighRdy;                    /* Pointer to highest priority TCB R-to-R   */
OS_EXT  OS_TCB           *OSTCBList;                       /* Pointer to doubly linked list of TCBs    */
OS_EXT  OS_TCB           *OSTCBPrioTbl[OS_LOWEST_PRIO + 1u];    /* Table of pointers to created TCBs   */
OS_EXT  OS_TCB            OSTCBTbl[OS_MAX_TASKS + OS_N_SYS_TASKS];   /* Table of TCBs                  */

#if OS_TICK_STEP_EN > 0u
OS_EXT  INT8U             OSTickStepState;          /* Indicates the state of the tick step feature    */
#endif

#if (OS_MEM_EN > 0u) && (OS_MAX_MEM_PART > 0u)
OS_EXT  OS_MEM           *OSMemFreeList;            /* Pointer to free list of memory partitions       */
OS_EXT  OS_MEM            OSMemTbl[OS_MAX_MEM_PART];/* Storage for memory partition manager            */
#endif

#if (OS_Q_EN > 0u) && (OS_MAX_QS > 0u)
OS_EXT  OS_Q             *OSQFreeList;              /* Pointer to list of free QUEUE control blocks    */
OS_EXT  OS_Q              OSQTbl[OS_MAX_QS];        /* Table of QUEUE control blocks                   */
#endif

#if OS_TIME_GET_SET_EN > 0u
OS_EXT  volatile  INT32U  OSTime;                   /* Current value of system time (in ticks)         */
#endif

#if OS_TMR_EN > 0u
OS_EXT  INT16U            OSTmrFree;                /* Number of free entries in the timer pool        */
OS_EXT  INT16U            OSTmrUsed;                /* Number of timers used                           */
OS_EXT  INT32U            OSTmrTime;                /* Current timer time                              */

OS_EXT  OS_EVENT         *OSTmrSem;                 /* Sem. used to gain exclusive access to timers    */
OS_EXT  OS_EVENT         *OSTmrSemSignal;           /* Sem. used to signal the update of timers        */

OS_EXT  OS_TMR            OSTmrTbl[OS_TMR_CFG_MAX]; /* Table containing pool of timers                 */
OS_EXT  OS_TMR           *OSTmrFreeList;            /* Pointer to free list of timers                  */
OS_EXT  OS_STK            OSTmrTaskStk[OS_TASK_TMR_STK_SIZE];

OS_EXT  OS_TMR_WHEEL      OSTmrWheelTbl[OS_TMR_CFG_WHEEL_SIZE];
#endif

extern  INT8U   const     OSUnMapTbl[256];          /* Priority->Index    lookup table                 */

/*$PAGE*/
/*
*********************************************************************************************************
*                                          FUNCTION PROTOTYPES
*                                     (Target Independent Functions)
*********************************************************************************************************
*/

/*
*********************************************************************************************************
*                                            MISCELLANEOUS
*********************************************************************************************************
*/

#if (OS_EVENT_EN)

#if (OS_EVENT_NAME_EN > 0u)
INT8U         OSEventNameGet          (OS_EVENT        *pevent,
                                       INT8U          **pname,
                                       INT8U           *perr);

void          OSEventNameSet          (OS_EVENT        *pevent,
                                       INT8U           *pname,
                                       INT8U           *perr);
#endif

#if (OS_EVENT_MULTI_EN > 0u)
INT16U        OSEventPendMulti        (OS_EVENT       **pevents_pend,
                                       OS_EVENT       **pevents_rdy,
                                       void           **pmsgs_rdy,
                                       INT32U           timeout,
                                       INT8U           *perr);
#endif

#endif

/*
*********************************************************************************************************
*                                         EVENT FLAGS MANAGEMENT
*********************************************************************************************************
*/

#if (OS_FLAG_EN > 0u) && (OS_MAX_FLAGS > 0u)

#if OS_FLAG_ACCEPT_EN > 0u
OS_FLAGS      OSFlagAccept            (OS_FLAG_GRP     *pgrp,
                                       OS_FLAGS         flags,
                                       INT8U            wait_type,
                                       INT8U           *perr);
#endif

OS_FLAG_GRP  *OSFlagCreate            (OS_FLAGS         flags,
                                       INT8U           *perr);

#if OS_FLAG_DEL_EN > 0u
OS_FLAG_GRP  *OSFlagDel               (OS_FLAG_GRP     *pgrp,
                                       INT8U            opt,
                                       INT8U           *perr);
#endif

#if (OS_FLAG_EN > 0u) && (OS_FLAG_NAME_EN > 0u)
INT8U         OSFlagNameGet           (OS_FLAG_GRP     *pgrp,
                                       INT8U          **pname,
                                       INT8U           *perr);

void          OSFlagNameSet           (OS_FLAG_GRP     *pgrp,
                                       INT8U           *pname,
                                       INT8U           *perr);
#endif

OS_FLAGS      OSFlagPend              (OS_FLAG_GRP     *pgrp,
                                       OS_FLAGS         flags,
                                       INT8U            wait_type,
                                       INT32U           timeout,
                                       INT8U           *perr);

OS_FLAGS      OSFlagPendGetFlagsRdy   (void);
OS_FLAGS      OSFlagPost              (OS_FLAG_GRP     *pgrp,
                                       OS_FLAGS         flags,
                                       INT8U            opt,
                                       INT8U           *perr);

#if OS_FLAG_QUERY_EN > 0u
OS_FLAGS      OSFlagQuery             (OS_FLAG_GRP     *pgrp,
                                       INT8U           *perr);
#endif
#endif

/*
*********************************************************************************************************
*                                        MESSAGE MAILBOX MANAGEMENT
*********************************************************************************************************
*/

#if OS_MBOX_EN > 0u

#if OS_MBOX_ACCEPT_EN > 0u
void         *OSMboxAccept            (OS_EVENT        *pevent);
#endif

OS_EVENT     *OSMboxCreate            (void            *pmsg);

#if OS_MBOX_DEL_EN > 0u
OS_EVENT     *OSMboxDel               (OS_EVENT        *pevent,
                                       INT8U            opt,
                                       INT8U           *perr);
#endif

void         *OSMboxPend              (OS_EVENT        *pevent,
                                       INT32U           timeout,
                                       INT8U           *perr);

#if OS_MBOX_PEND_ABORT_EN > 0u
INT8U         OSMboxPendAbort         (OS_EVENT        *pevent,
                                       INT8U            opt,
                                       INT8U           *perr);
#endif

#if OS_MBOX_POST_EN > 0u
INT8U         OSMboxPost              (OS_EVENT        *pevent,
                                       void            *pmsg);
#endif

#if OS_MBOX_POST_OPT_EN > 0u
INT8U         OSMboxPostOpt           (OS_EVENT        *pevent,
                                       void            *pmsg,
                                       INT8U            opt);
#endif

#if OS_MBOX_QUERY_EN > 0u
INT8U         OSMboxQuery             (OS_EVENT        *pevent,
                                       OS_MBOX_DATA    *p_mbox_data);
#endif
#endif

/*
*********************************************************************************************************
*                                           MEMORY MANAGEMENT
*********************************************************************************************************
*/

#if (OS_MEM_EN > 0u) && (OS_MAX_MEM_PART > 0u)

OS_MEM       *OSMemCreate             (void            *addr,
                                       INT32U           nblks,
                                       INT32U           blksize,
                                       INT8U           *perr);

void         *OSMemGet                (OS_MEM          *pmem,
                                       INT8U           *perr);
#if OS_MEM_NAME_EN > 0u
INT8U         OSMemNameGet            (OS_MEM          *pmem,
                                       INT8U          **pname,
                                       INT8U           *perr);

void          OSMemNameSet            (OS_MEM          *pmem,
                                       INT8U           *pname,
                                       INT8U           *perr);
#endif
INT8U         OSMemPut                (OS_MEM          *pmem,
                                       void            *pblk);

#if OS_MEM_QUERY_EN > 0u
INT8U         OSMemQuery              (OS_MEM          *pmem,
                                       OS_MEM_DATA     *p_mem_data);
#endif

#endif

/*
*********************************************************************************************************
*                                MUTUAL EXCLUSION SEMAPHORE MANAGEMENT
*********************************************************************************************************
*/

#if OS_MUTEX_EN > 0u

#if OS_MUTEX_ACCEPT_EN > 0u
BOOLEAN       OSMutexAccept           (OS_EVENT        *pevent,
                                       INT8U           *perr);
#endif

OS_EVENT     *OSMutexCreate           (INT8U            prio,
                                       INT8U           *perr);

#if OS_MUTEX_DEL_EN > 0u
OS_EVENT     *OSMutexDel              (OS_EVENT        *pevent,
                                       INT8U            opt,
                                       INT8U           *perr);
#endif

void          OSMutexPend             (OS_EVENT        *pevent,
                                       INT32U           timeout,
                                       INT8U           *perr);

INT8U         OSMutexPost             (OS_EVENT        *pevent);

#if OS_MUTEX_QUERY_EN > 0u
INT8U         OSMutexQuery            (OS_EVENT        *pevent,
                                       OS_MUTEX_DATA   *p_mutex_data);
#endif

#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                         MESSAGE QUEUE MANAGEMENT
*********************************************************************************************************
*/

#if (OS_Q_EN > 0u) && (OS_MAX_QS > 0u)

#if OS_Q_ACCEPT_EN > 0u
void         *OSQAccept               (OS_EVENT        *pevent,
                                       INT8U           *perr);
#endif

OS_EVENT     *OSQCreate               (void           **start,
                                       INT16U           size);

#if OS_Q_DEL_EN > 0u
OS_EVENT     *OSQDel                  (OS_EVENT        *pevent,
                                       INT8U            opt,
                                       INT8U           *perr);
#endif

#if OS_Q_FLUSH_EN > 0u
INT8U         OSQFlush                (OS_EVENT        *pevent);
#endif

void         *OSQPend                 (OS_EVENT        *pevent,
                                       INT32U           timeout,
                                       INT8U           *perr);

#if OS_Q_PEND_ABORT_EN > 0u
INT8U         OSQPendAbort            (OS_EVENT        *pevent,
                                       INT8U            opt,
                                       INT8U           *perr);
#endif

#if OS_Q_POST_EN > 0u
INT8U         OSQPost                 (OS_EVENT        *pevent,
                                       void            *pmsg);
#endif

#if OS_Q_POST_FRONT_EN > 0u
INT8U         OSQPostFront            (OS_EVENT        *pevent,
                                       void            *pmsg);
#endif

#if OS_Q_POST_OPT_EN > 0u
INT8U         OSQPostOpt              (OS_EVENT        *pevent,
                                       void            *pmsg,
                                       INT8U            opt);
#endif

#if OS_Q_QUERY_EN > 0u
INT8U         OSQQuery                (OS_EVENT        *pevent,
                                       OS_Q_DATA       *p_q_data);
#endif

#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                          SEMAPHORE MANAGEMENT
*********************************************************************************************************
*/
#if OS_SEM_EN > 0u

#if OS_SEM_ACCEPT_EN > 0u
INT16U        OSSemAccept             (OS_EVENT        *pevent);
#endif

OS_EVENT     *OSSemCreate             (INT16U           cnt);

#if OS_SEM_DEL_EN > 0u
OS_EVENT     *OSSemDel                (OS_EVENT        *pevent,
                                       INT8U            opt,
                                       INT8U           *perr);
#endif

void          OSSemPend               (OS_EVENT        *pevent,
                                       INT32U           timeout,
                                       INT8U           *perr);

#if OS_SEM_PEND_ABORT_EN > 0u
INT8U         OSSemPendAbort          (OS_EVENT        *pevent,
                                       INT8U            opt,
                                       INT8U           *perr);
#endif

INT8U         OSSemPost               (OS_EVENT        *pevent);

#if OS_SEM_QUERY_EN > 0u
INT8U         OSSemQuery              (OS_EVENT        *pevent,
                                       OS_SEM_DATA     *p_sem_data);
#endif

#if OS_SEM_SET_EN > 0u
void          OSSemSet                (OS_EVENT        *pevent,
                                       INT16U           cnt,
                                       INT8U           *perr);
#endif

#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                            TASK MANAGEMENT
*********************************************************************************************************
*/
#if OS_TASK_CHANGE_PRIO_EN > 0u
INT8U         OSTaskChangePrio        (INT8U            oldprio,
                                       INT8U            newprio);
#endif

#if OS_TASK_CREATE_EN > 0u
INT8U         OSTaskCreate            (void           (*task)(void *p_arg),
                                       void            *p_arg,
                                       OS_STK          *ptos,
                                       INT8U            prio);
#endif

#if OS_TASK_CREATE_EXT_EN > 0u
INT8U         OSTaskCreateExt         (void           (*task)(void *p_arg),
                                       void            *p_arg,
                                       OS_STK          *ptos,
                                       INT8U            prio,
                                       INT16U           id,
                                       OS_STK          *pbos,
                                       INT32U           stk_size,
                                       void            *pext,
                                       INT16U           opt);
#endif

#if OS_TASK_DEL_EN > 0u
INT8U         OSTaskDel               (INT8U            prio);
INT8U         OSTaskDelReq            (INT8U            prio);
#endif

#if OS_TASK_NAME_EN > 0u
INT8U         OSTaskNameGet           (INT8U            prio,
                                       INT8U          **pname,
                                       INT8U           *perr);

void          OSTaskNameSet           (INT8U            prio,
                                       INT8U           *pname,
                                       INT8U           *perr);
#endif

#if OS_TASK_SUSPEND_EN > 0u
INT8U         OSTaskResume            (INT8U            prio);
INT8U         OSTaskSuspend           (INT8U            prio);
#endif

#if (OS_TASK_STAT_STK_CHK_EN > 0u) && (OS_TASK_CREATE_EXT_EN > 0u)
INT8U         OSTaskStkChk            (INT8U            prio,
                                       OS_STK_DATA     *p_stk_data);
#endif

#if OS_TASK_QUERY_EN > 0u
INT8U         OSTaskQuery             (INT8U            prio,
                                       OS_TCB          *p_task_data);
#endif



#if OS_TASK_REG_TBL_SIZE > 0u
INT32U        OSTaskRegGet            (INT8U            prio,
                                       INT8U            id,
                                       INT8U           *perr);

void          OSTaskRegSet            (INT8U            prio,
                                       INT8U            id,
                                       INT32U           value,
                                       INT8U           *perr);
#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                            TIME MANAGEMENT
*********************************************************************************************************
*/

void          OSTimeDly               (INT32U           ticks);

#if OS_TIME_DLY_HMSM_EN > 0u
INT8U         OSTimeDlyHMSM           (INT8U            hours,
                                       INT8U            minutes,
                                       INT8U            seconds,
                                       INT16U           ms);
#endif

#if OS_TIME_DLY_RESUME_EN > 0u
INT8U         OSTimeDlyResume         (INT8U            prio);
#endif

#if OS_TIME_GET_SET_EN > 0u
INT32U        OSTimeGet               (void);
void          OSTimeSet               (INT32U           ticks);
#endif

void          OSTimeTick              (void);

/*
*********************************************************************************************************
*                                            TIMER MANAGEMENT
*********************************************************************************************************
*/

#if OS_TMR_EN > 0u
OS_TMR      *OSTmrCreate              (INT32U           dly,
                                       INT32U           period,
                                       INT8U            opt,
                                       OS_TMR_CALLBACK  callback,
                                       void            *callback_arg,
                                       INT8U           *pname,
                                       INT8U           *perr);

BOOLEAN      OSTmrDel                 (OS_TMR          *ptmr,
                                       INT8U           *perr);

#if OS_TMR_CFG_NAME_EN > 0u
INT8U        OSTmrNameGet             (OS_TMR          *ptmr,
                                       INT8U          **pdest,
                                       INT8U           *perr);
#endif
INT32U       OSTmrRemainGet           (OS_TMR          *ptmr,
                                       INT8U           *perr);

INT8U        OSTmrStateGet            (OS_TMR          *ptmr,
                                       INT8U           *perr);

BOOLEAN      OSTmrStart               (OS_TMR          *ptmr,
                                       INT8U           *perr);

BOOLEAN      OSTmrStop                (OS_TMR          *ptmr,
                                       INT8U            opt,
                                       void            *callback_arg,
                                       INT8U           *perr);

INT8U        OSTmrSignal              (void);
#endif

/*
*********************************************************************************************************
*                                             MISCELLANEOUS
*********************************************************************************************************
*/

void          OSInit                  (void);

void          OSIntEnter              (void);
void          OSIntExit               (void);

#ifdef OS_SAFETY_CRITICAL_IEC61508
void          OSSafetyCriticalStart   (void);
#endif

#if OS_SCHED_LOCK_EN > 0u
void          OSSchedLock             (void);
void          OSSchedUnlock           (void);
#endif

void          OSStart                 (void);

void          OSStatInit              (void);

INT16U        OSVersion               (void);

/*$PAGE*/
/*
*********************************************************************************************************
*                                      INTERNAL FUNCTION PROTOTYPES
*                            (Your application MUST NOT call these functions)
*********************************************************************************************************
*/

#if OS_TASK_DEL_EN > 0u
void          OS_Dummy                (void);
#endif

#if (OS_EVENT_EN)
INT8U         OS_EventTaskRdy         (OS_EVENT        *pevent,
                                       void            *pmsg,
                                       INT8U            msk,
                                       INT8U            pend_stat);

void          OS_EventTaskWait        (OS_EVENT        *pevent);

void          OS_EventTaskRemove      (OS_TCB          *ptcb,
                                       OS_EVENT        *pevent);

#if (OS_EVENT_MULTI_EN > 0u)
void          OS_EventTaskWaitMulti   (OS_EVENT       **pevents_wait);

void          OS_EventTaskRemoveMulti (OS_TCB          *ptcb,
                                       OS_EVENT       **pevents_multi);
#endif

void          OS_EventWaitListInit    (OS_EVENT        *pevent);
#endif

#if (OS_FLAG_EN > 0u) && (OS_MAX_FLAGS > 0u)
void          OS_FlagInit             (void);
void          OS_FlagUnlink           (OS_FLAG_NODE    *pnode);
#endif

void          OS_MemClr               (INT8U           *pdest,
                                       INT16U           size);

void          OS_MemCopy              (INT8U           *pdest,
                                       INT8U           *psrc,
                                       INT16U           size);

#if (OS_MEM_EN > 0u) && (OS_MAX_MEM_PART > 0u)
void          OS_MemInit              (void);
#endif

#if OS_Q_EN > 0u
void          OS_QInit                (void);
#endif

void          OS_Sched                (void);

#if (OS_EVENT_NAME_EN > 0u) || (OS_FLAG_NAME_EN > 0u) || (OS_MEM_NAME_EN > 0u) || (OS_TASK_NAME_EN > 0u)
INT8U         OS_StrLen               (INT8U           *psrc);
#endif

void          OS_TaskIdle             (void            *p_arg);

void          OS_TaskReturn           (void);

#if OS_TASK_STAT_EN > 0u
void          OS_TaskStat             (void            *p_arg);
#endif

#if (OS_TASK_STAT_STK_CHK_EN > 0u) && (OS_TASK_CREATE_EXT_EN > 0u)
void          OS_TaskStkClr           (OS_STK          *pbos,
                                       INT32U           size,
                                       INT16U           opt);
#endif

#if (OS_TASK_STAT_STK_CHK_EN > 0u) && (OS_TASK_CREATE_EXT_EN > 0u)
void          OS_TaskStatStkChk       (void);
#endif

INT8U         OS_TCBInit              (INT8U            prio,
                                       OS_STK          *ptos,
                                       OS_STK          *pbos,
                                       INT16U           id,
                                       INT32U           stk_size,
                                       void            *pext,
                                       INT16U           opt);

#if OS_TMR_EN > 0u
void          OSTmr_Init              (void);
#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                          FUNCTION PROTOTYPES
*                                      (Target Specific Functions)
*********************************************************************************************************
*/

#if OS_DEBUG_EN > 0u
void          OSDebugInit             (void);
#endif

void          OSInitHookBegin         (void);
void          OSInitHookEnd           (void);

void          OSTaskCreateHook        (OS_TCB          *ptcb);
void          OSTaskDelHook           (OS_TCB          *ptcb);

void          OSTaskIdleHook          (void);

void          OSTaskReturnHook        (OS_TCB          *ptcb);

void          OSTaskStatHook          (void);
OS_STK       *OSTaskStkInit           (void           (*task)(void *p_arg),
                                       void            *p_arg,
                                       OS_STK          *ptos,
                                       INT16U           opt);

#if OS_TASK_SW_HOOK_EN > 0u
void          OSTaskSwHook            (void);
#endif

void          OSTCBInitHook           (OS_TCB          *ptcb);

#if OS_TIME_TICK_HOOK_EN > 0u
void          OSTimeTickHook          (void);
#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                          FUNCTION PROTOTYPES
*                                   (Application Specific Functions)
*********************************************************************************************************
*/

#if OS_APP_HOOKS_EN > 0u
void          App_TaskCreateHook      (OS_TCB          *ptcb);
void          App_TaskDelHook         (OS_TCB          *ptcb);
void          App_TaskIdleHook        (void);

void          App_TaskReturnHook      (OS_TCB          *ptcb);

void          App_TaskStatHook        (void);

#if OS_TASK_SW_HOOK_EN > 0u
void          App_TaskSwHook          (void);
#endif

void          App_TCBInitHook         (OS_TCB          *ptcb);

#if OS_TIME_TICK_HOOK_EN > 0u
void          App_TimeTickHook        (void);
#endif
#endif

/*
*********************************************************************************************************
*                                          FUNCTION PROTOTYPES
*
* IMPORTANT: These prototypes MUST be placed in OS_CPU.H
*********************************************************************************************************
*/

#if 0
void          OSStartHighRdy          (void);
void          OSIntCtxSw              (void);
void          OSCtxSw                 (void);
#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                   LOOK FOR MISSING #define CONSTANTS
*
* This section is used to generate ERROR messages at compile time if certain #define constants are
* MISSING in OS_CFG.H.  This allows you to quickly determine the source of the error.
*
* You SHOULD NOT change this section UNLESS you would like to add more comments as to the source of the
* compile time error.
*********************************************************************************************************
*/

/*
*********************************************************************************************************
*                                            EVENT FLAGS
*********************************************************************************************************
*/

#ifndef OS_FLAG_EN
#error  "OS_CFG.H, Missing OS_FLAG_EN: Enable (1) or Disable (0) code generation for Event Flags"
#else
    #ifndef OS_MAX_FLAGS
    #error  "OS_CFG.H, Missing OS_MAX_FLAGS: Max. number of Event Flag Groups in your application"
    #else
        #if     OS_MAX_FLAGS > 65500u
        #error  "OS_CFG.H, OS_MAX_FLAGS must be <= 65500"
        #endif
    #endif

    #ifndef OS_FLAGS_NBITS
    #error  "OS_CFG.H, Missing OS_FLAGS_NBITS: Determine #bits used for event flags, MUST be either 8, 16 or 32"
    #endif

    #ifndef OS_FLAG_WAIT_CLR_EN
    #error  "OS_CFG.H, Missing OS_FLAG_WAIT_CLR_EN: Include code for Wait on Clear EVENT FLAGS"
    #endif

    #ifndef OS_FLAG_ACCEPT_EN
    #error  "OS_CFG.H, Missing OS_FLAG_ACCEPT_EN: Include code for OSFlagAccept()"
    #endif

    #ifndef OS_FLAG_DEL_EN
    #error  "OS_CFG.H, Missing OS_FLAG_DEL_EN: Include code for OSFlagDel()"
    #endif

    #ifndef OS_FLAG_NAME_EN
    #error  "OS_CFG.H, Missing OS_FLAG_NAME_EN: Enable flag group names"
    #endif

    #ifndef OS_FLAG_QUERY_EN
    #error  "OS_CFG.H, Missing OS_FLAG_QUERY_EN: Include code for OSFlagQuery()"
    #endif
#endif

/*
*********************************************************************************************************
*                                           MESSAGE MAILBOXES
*********************************************************************************************************
*/

#ifndef OS_MBOX_EN
#error  "OS_CFG.H, Missing OS_MBOX_EN: Enable (1) or Disable (0) code generation for MAILBOXES"
#else
    #ifndef OS_MBOX_ACCEPT_EN
    #error  "OS_CFG.H, Missing OS_MBOX_ACCEPT_EN: Include code for OSMboxAccept()"
    #endif

    #ifndef OS_MBOX_DEL_EN
    #error  "OS_CFG.H, Missing OS_MBOX_DEL_EN: Include code for OSMboxDel()"
    #endif

    #ifndef OS_MBOX_PEND_ABORT_EN
    #error  "OS_CFG.H, Missing OS_MBOX_PEND_ABORT_EN: Include code for OSMboxPendAbort()"
    #endif

    #ifndef OS_MBOX_POST_EN
    #error  "OS_CFG.H, Missing OS_MBOX_POST_EN: Include code for OSMboxPost()"
    #endif

    #ifndef OS_MBOX_POST_OPT_EN
    #error  "OS_CFG.H, Missing OS_MBOX_POST_OPT_EN: Include code for OSMboxPostOpt()"
    #endif

    #ifndef OS_MBOX_QUERY_EN
    #error  "OS_CFG.H, Missing OS_MBOX_QUERY_EN: Include code for OSMboxQuery()"
    #endif
#endif

/*
*********************************************************************************************************
*                                           MEMORY MANAGEMENT
*********************************************************************************************************
*/

#ifndef OS_MEM_EN
#error  "OS_CFG.H, Missing OS_MEM_EN: Enable (1) or Disable (0) code generation for MEMORY MANAGER"
#else
    #ifndef OS_MAX_MEM_PART
    #error  "OS_CFG.H, Missing OS_MAX_MEM_PART: Max. number of memory partitions"
    #else
        #if     OS_MAX_MEM_PART > 65500u
        #error  "OS_CFG.H, OS_MAX_MEM_PART must be <= 65500"
        #endif
    #endif

    #ifndef OS_MEM_NAME_EN
    #error  "OS_CFG.H, Missing OS_MEM_NAME_EN: Enable memory partition names"
    #endif

    #ifndef OS_MEM_QUERY_EN
    #error  "OS_CFG.H, Missing OS_MEM_QUERY_EN: Include code for OSMemQuery()"
    #endif
#endif

/*
*********************************************************************************************************
*                                       MUTUAL EXCLUSION SEMAPHORES
*********************************************************************************************************
*/

#ifndef OS_MUTEX_EN
#error  "OS_CFG.H, Missing OS_MUTEX_EN: Enable (1) or Disable (0) code generation for MUTEX"
#else
    #ifndef OS_MUTEX_ACCEPT_EN
    #error  "OS_CFG.H, Missing OS_MUTEX_ACCEPT_EN: Include code for OSMutexAccept()"
    #endif

    #ifndef OS_MUTEX_DEL_EN
    #error  "OS_CFG.H, Missing OS_MUTEX_DEL_EN: Include code for OSMutexDel()"
    #endif

    #ifndef OS_MUTEX_QUERY_EN
    #error  "OS_CFG.H, Missing OS_MUTEX_QUERY_EN: Include code for OSMutexQuery()"
    #endif
#endif

/*
*********************************************************************************************************
*                                              MESSAGE QUEUES
*********************************************************************************************************
*/

#ifndef OS_Q_EN
#error  "OS_CFG.H, Missing OS_Q_EN: Enable (1) or Disable (0) code generation for QUEUES"
#else
    #ifndef OS_MAX_QS
    #error  "OS_CFG.H, Missing OS_MAX_QS: Max. number of queue control blocks"
    #else
        #if     OS_MAX_QS > 65500u
        #error  "OS_CFG.H, OS_MAX_QS must be <= 65500"
        #endif
    #endif

    #ifndef OS_Q_ACCEPT_EN
    #error  "OS_CFG.H, Missing OS_Q_ACCEPT_EN: Include code for OSQAccept()"
    #endif

    #ifndef OS_Q_DEL_EN
    #error  "OS_CFG.H, Missing OS_Q_DEL_EN: Include code for OSQDel()"
    #endif

    #ifndef OS_Q_FLUSH_EN
    #error  "OS_CFG.H, Missing OS_Q_FLUSH_EN: Include code for OSQFlush()"
    #endif

    #ifndef OS_Q_PEND_ABORT_EN
    #error  "OS_CFG.H, Missing OS_Q_PEND_ABORT_EN: Include code for OSQPendAbort()"
    #endif

    #ifndef OS_Q_POST_EN
    #error  "OS_CFG.H, Missing OS_Q_POST_EN: Include code for OSQPost()"
    #endif

    #ifndef OS_Q_POST_FRONT_EN
    #error  "OS_CFG.H, Missing OS_Q_POST_FRONT_EN: Include code for OSQPostFront()"
    #endif

    #ifndef OS_Q_POST_OPT_EN
    #error  "OS_CFG.H, Missing OS_Q_POST_OPT_EN: Include code for OSQPostOpt()"
    #endif

    #ifndef OS_Q_QUERY_EN
    #error  "OS_CFG.H, Missing OS_Q_QUERY_EN: Include code for OSQQuery()"
    #endif
#endif

/*
*********************************************************************************************************
*                                              SEMAPHORES
*********************************************************************************************************
*/

#ifndef OS_SEM_EN
#error  "OS_CFG.H, Missing OS_SEM_EN: Enable (1) or Disable (0) code generation for SEMAPHORES"
#else
    #ifndef OS_SEM_ACCEPT_EN
    #error  "OS_CFG.H, Missing OS_SEM_ACCEPT_EN: Include code for OSSemAccept()"
    #endif

    #ifndef OS_SEM_DEL_EN
    #error  "OS_CFG.H, Missing OS_SEM_DEL_EN: Include code for OSSemDel()"
    #endif

    #ifndef OS_SEM_PEND_ABORT_EN
    #error  "OS_CFG.H, Missing OS_SEM_PEND_ABORT_EN: Include code for OSSemPendAbort()"
    #endif

    #ifndef OS_SEM_QUERY_EN
    #error  "OS_CFG.H, Missing OS_SEM_QUERY_EN: Include code for OSSemQuery()"
    #endif

    #ifndef OS_SEM_SET_EN
    #error  "OS_CFG.H, Missing OS_SEM_SET_EN: Include code for OSSemSet()"
    #endif
#endif

/*
*********************************************************************************************************
*                                             TASK MANAGEMENT
*********************************************************************************************************
*/

#ifndef OS_MAX_TASKS
#error  "OS_CFG.H, Missing OS_MAX_TASKS: Max. number of tasks in your application"
#else
    #if     OS_MAX_TASKS < 2u
    #error  "OS_CFG.H,         OS_MAX_TASKS must be >= 2"
    #endif

    #if     OS_MAX_TASKS >  ((OS_LOWEST_PRIO - OS_N_SYS_TASKS) + 1u)
    #error  "OS_CFG.H,         OS_MAX_TASKS must be <= OS_LOWEST_PRIO - OS_N_SYS_TASKS + 1"
    #endif

#endif

#if     OS_LOWEST_PRIO >  254u
#error  "OS_CFG.H,         OS_LOWEST_PRIO must be <= 254 in V2.8x and higher"
#endif

#ifndef OS_TASK_IDLE_STK_SIZE
#error  "OS_CFG.H, Missing OS_TASK_IDLE_STK_SIZE: Idle task stack size"
#endif

#ifndef OS_TASK_STAT_EN
#error  "OS_CFG.H, Missing OS_TASK_STAT_EN: Enable (1) or Disable(0) the statistics task"
#endif

#ifndef OS_TASK_STAT_STK_SIZE
#error  "OS_CFG.H, Missing OS_TASK_STAT_STK_SIZE: Statistics task stack size"
#endif

#ifndef OS_TASK_STAT_STK_CHK_EN
#error  "OS_CFG.H, Missing OS_TASK_STAT_STK_CHK_EN: Check task stacks from statistics task"
#endif

#ifndef OS_TASK_CHANGE_PRIO_EN
#error  "OS_CFG.H, Missing OS_TASK_CHANGE_PRIO_EN: Include code for OSTaskChangePrio()"
#endif

#ifndef OS_TASK_CREATE_EN
#error  "OS_CFG.H, Missing OS_TASK_CREATE_EN: Include code for OSTaskCreate()"
#endif

#ifndef OS_TASK_CREATE_EXT_EN
#error  "OS_CFG.H, Missing OS_TASK_CREATE_EXT_EN: Include code for OSTaskCreateExt()"
#endif

#ifndef OS_TASK_DEL_EN
#error  "OS_CFG.H, Missing OS_TASK_DEL_EN: Include code for OSTaskDel()"
#endif

#ifndef OS_TASK_NAME_EN
#error  "OS_CFG.H, Missing OS_TASK_NAME_EN: Enable task names"
#endif

#ifndef OS_TASK_SUSPEND_EN
#error  "OS_CFG.H, Missing OS_TASK_SUSPEND_EN: Include code for OSTaskSuspend() and OSTaskResume()"
#endif

#ifndef OS_TASK_QUERY_EN
#error  "OS_CFG.H, Missing OS_TASK_QUERY_EN: Include code for OSTaskQuery()"
#endif

#ifndef OS_TASK_REG_TBL_SIZE
#error  "OS_CFG.H, Missing OS_TASK_REG_TBL_SIZE: Include code for task specific registers"
#else
    #if     OS_TASK_REG_TBL_SIZE > 255u
    #error  "OS_CFG.H,         OS_TASK_REG_TBL_SIZE must be <= 255"
    #endif
#endif

/*
*********************************************************************************************************
*                                             TIME MANAGEMENT
*********************************************************************************************************
*/

#ifndef OS_TICKS_PER_SEC
#error  "OS_CFG.H, Missing OS_TICKS_PER_SEC: Sets the number of ticks in one second"
#endif

#ifndef OS_TIME_DLY_HMSM_EN
#error  "OS_CFG.H, Missing OS_TIME_DLY_HMSM_EN: Include code for OSTimeDlyHMSM()"
#endif

#ifndef OS_TIME_DLY_RESUME_EN
#error  "OS_CFG.H, Missing OS_TIME_DLY_RESUME_EN: Include code for OSTimeDlyResume()"
#endif

#ifndef OS_TIME_GET_SET_EN
#error  "OS_CFG.H, Missing OS_TIME_GET_SET_EN: Include code for OSTimeGet() and OSTimeSet()"
#endif

/*
*********************************************************************************************************
*                                             TIMER MANAGEMENT
*********************************************************************************************************
*/

#ifndef OS_TMR_EN
#error  "OS_CFG.H, Missing OS_TMR_EN: When (1) enables code generation for Timer Management"
#elif   OS_TMR_EN > 0u
    #if     OS_SEM_EN == 0u
    #error  "OS_CFG.H, Semaphore management is required (set OS_SEM_EN to 1) when enabling Timer Management."
    #error  "          Timer management require TWO semaphores."
    #endif

    #ifndef OS_TMR_CFG_MAX
    #error  "OS_CFG.H, Missing OS_TMR_CFG_MAX: Determines the total number of timers in an application (2 .. 65500)"
    #else
        #if OS_TMR_CFG_MAX < 2u
        #error  "OS_CFG.H, OS_TMR_CFG_MAX should be between 2 and 65500"
        #endif

        #if OS_TMR_CFG_MAX > 65500u
        #error  "OS_CFG.H, OS_TMR_CFG_MAX should be between 2 and 65500"
        #endif
    #endif

    #ifndef OS_TMR_CFG_WHEEL_SIZE
    #error  "OS_CFG.H, Missing OS_TMR_CFG_WHEEL_SIZE: Sets the size of the timer wheel (1 .. 1023)"
    #else
        #if OS_TMR_CFG_WHEEL_SIZE < 2u
        #error  "OS_CFG.H, OS_TMR_CFG_WHEEL_SIZE should be between 2 and 1024"
        #endif

        #if OS_TMR_CFG_WHEEL_SIZE > 1024u
        #error  "OS_CFG.H, OS_TMR_CFG_WHEEL_SIZE should be between 2 and 1024"
        #endif
    #endif

    #ifndef OS_TMR_CFG_NAME_EN
    #error  "OS_CFG.H, Missing OS_TMR_CFG_NAME_EN: Enable Timer names"
    #endif

    #ifndef OS_TMR_CFG_TICKS_PER_SEC
    #error  "OS_CFG.H, Missing OS_TMR_CFG_TICKS_PER_SEC: Determines the rate at which tiem timer management task will run (Hz)"
    #endif

    #ifndef OS_TASK_TMR_STK_SIZE
    #error  "OS_CFG.H, Missing OS_TASK_TMR_STK_SIZE: Determines the size of the Timer Task's stack"
    #endif
#endif


/*
*********************************************************************************************************
*                                            MISCELLANEOUS
*********************************************************************************************************
*/

#ifndef OS_ARG_CHK_EN
#error  "OS_CFG.H, Missing OS_ARG_CHK_EN: Enable (1) or Disable (0) argument checking"
#endif


#ifndef OS_CPU_HOOKS_EN
#error  "OS_CFG.H, Missing OS_CPU_HOOKS_EN: uC/OS-II hooks are found in the processor port files when 1"
#endif


#ifndef OS_APP_HOOKS_EN
#error  "OS_CFG.H, Missing OS_APP_HOOKS_EN: Application-defined hooks are called from the uC/OS-II hooks"
#endif


#ifndef OS_DEBUG_EN
#error  "OS_CFG.H, Missing OS_DEBUG_EN: Allows you to include variables for debugging or not"
#endif


#ifndef OS_LOWEST_PRIO
#error  "OS_CFG.H, Missing OS_LOWEST_PRIO: Defines the lowest priority that can be assigned"
#endif


#ifndef OS_MAX_EVENTS
#error  "OS_CFG.H, Missing OS_MAX_EVENTS: Max. number of event control blocks in your application"
#else
    #if     OS_MAX_EVENTS > 65500u
    #error  "OS_CFG.H, OS_MAX_EVENTS must be <= 65500"
    #endif
#endif


#ifndef OS_SCHED_LOCK_EN
#error  "OS_CFG.H, Missing OS_SCHED_LOCK_EN: Include code for OSSchedLock() and OSSchedUnlock()"
#endif


#ifndef OS_EVENT_MULTI_EN
#error  "OS_CFG.H, Missing OS_EVENT_MULTI_EN: Include code for OSEventPendMulti()"
#endif


#ifndef OS_TASK_PROFILE_EN
#error  "OS_CFG.H, Missing OS_TASK_PROFILE_EN: Include data structure for run-time task profiling"
#endif


#ifndef OS_TASK_SW_HOOK_EN
#error  "OS_CFG.H, Missing OS_TASK_SW_HOOK_EN: Allows you to include the code for OSTaskSwHook() or not"
#endif


#ifndef OS_TICK_STEP_EN
#error  "OS_CFG.H, Missing OS_TICK_STEP_EN: Allows to 'step' one tick at a time with uC/OS-View"
#endif


#ifndef OS_TIME_TICK_HOOK_EN
#error  "OS_CFG.H, Missing OS_TIME_TICK_HOOK_EN: Allows you to include the code for OSTimeTickHook() or not"
#endif

/*
*********************************************************************************************************
*                                         SAFETY CRITICAL USE
*********************************************************************************************************
*/

#ifdef SAFETY_CRITICAL_RELEASE

#if    OS_ARG_CHK_EN < 1u
#error "OS_CFG.H, OS_ARG_CHK_EN must be enabled for safety-critical release code"
#endif

#if    OS_APP_HOOKS_EN > 0u
#error "OS_CFG.H, OS_APP_HOOKS_EN must be disabled for safety-critical release code"
#endif

#if    OS_DEBUG_EN > 0u
#error "OS_CFG.H, OS_DEBUG_EN must be disabled for safety-critical release code"
#endif

#ifdef CANTATA
#error "OS_CFG.H, CANTATA must be disabled for safety-critical release code"
#endif

#ifdef OS_SCHED_LOCK_EN
#error "OS_CFG.H, OS_SCHED_LOCK_EN must be disabled for safety-critical release code"
#endif

#ifdef VSC_VALIDATION_MODE
#error "OS_CFG.H, VSC_VALIDATION_MODE must be disabled for safety-critical release code"
#endif

#if    OS_TASK_STAT_EN > 0u
#error "OS_CFG.H, OS_TASK_STAT_EN must be disabled for safety-critical release code"
#endif

#if    OS_TICK_STEP_EN > 0u
#error "OS_CFG.H, OS_TICK_STEP_EN must be disabled for safety-critical release code"
#endif

#if    OS_FLAG_EN > 0u
    #if    OS_FLAG_DEL_EN > 0
    #error "OS_CFG.H, OS_FLAG_DEL_EN must be disabled for safety-critical release code"
    #endif
#endif

#if    OS_MBOX_EN > 0u
    #if    OS_MBOX_DEL_EN > 0u
    #error "OS_CFG.H, OS_MBOX_DEL_EN must be disabled for safety-critical release code"
    #endif
#endif

#if    OS_MUTEX_EN > 0u
    #if    OS_MUTEX_DEL_EN > 0u
    #error "OS_CFG.H, OS_MUTEX_DEL_EN must be disabled for safety-critical release code"
    #endif
#endif

#if    OS_Q_EN > 0u
    #if    OS_Q_DEL_EN > 0u
    #error "OS_CFG.H, OS_Q_DEL_EN must be disabled for safety-critical release code"
    #endif
#endif

#if    OS_SEM_EN > 0u
    #if    OS_SEM_DEL_EN > 0u
    #error "OS_CFG.H, OS_SEM_DEL_EN must be disabled for safety-critical release code"
    #endif
#endif

#if    OS_TASK_EN > 0u
    #if    OS_TASK_DEL_EN > 0u
    #error "OS_CFG.H, OS_TASK_DEL_EN must be disabled for safety-critical release code"
    #endif
#endif

#if    OS_CRITICAL_METHOD != 3u
#error "OS_CPU.H, OS_CRITICAL_METHOD must be type 3 for safety-critical release code"
#endif

#endif  /* ------------------------ SAFETY_CRITICAL_RELEASE ------------------------ */

#ifdef __cplusplus
}
#endif

#endif
	 	   	  		 			 	    		   		 		 	 	 			 	    		   	 			 	  	 		 				 		  			 		 					 	  	  		      		  	   		      		  	 		 	      		   		 		  	 		 	      		  		  		  
