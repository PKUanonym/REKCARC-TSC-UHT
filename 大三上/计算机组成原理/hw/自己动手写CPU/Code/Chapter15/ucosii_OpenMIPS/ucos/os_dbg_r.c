/*
*********************************************************************************************************
*                                                uC/OS-II
*                                          The Real-Time Kernel
*                                           DEBUGGER CONSTANTS
*
*                              (c) Copyright 1992-2009, Micrium, Weston, FL
*                                           All Rights Reserved
*
* File    : OS_DBG.C
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

#include <ucos_ii.h>

/*
*********************************************************************************************************
*                                             DEBUG DATA
*********************************************************************************************************
*/

INT16U  const  OSDebugEn           = OS_DEBUG_EN;               /* Debug constants are defined below   */

#if OS_DEBUG_EN > 0u

INT32U  const  OSEndiannessTest    = 0x12345678uL;              /* Variable to test CPU endianness     */

INT16U  const  OSEventEn           = OS_EVENT_EN;
INT16U  const  OSEventMax          = OS_MAX_EVENTS;             /* Number of event control blocks      */
INT16U  const  OSEventNameEn       = OS_EVENT_NAME_EN;
#if (OS_EVENT_EN) && (OS_MAX_EVENTS > 0u)
INT16U  const  OSEventSize         = sizeof(OS_EVENT);          /* Size in Bytes of OS_EVENT           */
INT16U  const  OSEventTblSize      = sizeof(OSEventTbl);        /* Size of OSEventTbl[] in bytes       */
#else
INT16U  const  OSEventSize         = 0u;
INT16U  const  OSEventTblSize      = 0u;
#endif
INT16U  const  OSEventMultiEn      = OS_EVENT_MULTI_EN;


INT16U  const  OSFlagEn            = OS_FLAG_EN;
#if (OS_FLAG_EN > 0u) && (OS_MAX_FLAGS > 0u)
INT16U  const  OSFlagGrpSize       = sizeof(OS_FLAG_GRP);       /* Size in Bytes of OS_FLAG_GRP        */
INT16U  const  OSFlagNodeSize      = sizeof(OS_FLAG_NODE);      /* Size in Bytes of OS_FLAG_NODE       */
INT16U  const  OSFlagWidth         = sizeof(OS_FLAGS);          /* Width (in bytes) of OS_FLAGS        */
#else
INT16U  const  OSFlagGrpSize       = 0u;
INT16U  const  OSFlagNodeSize      = 0u;
INT16U  const  OSFlagWidth         = 0u;
#endif
INT16U  const  OSFlagMax           = OS_MAX_FLAGS;
INT16U  const  OSFlagNameEn        = OS_FLAG_NAME_EN;

INT16U  const  OSLowestPrio        = OS_LOWEST_PRIO;

INT16U  const  OSMboxEn            = OS_MBOX_EN;

INT16U  const  OSMemEn             = OS_MEM_EN;
INT16U  const  OSMemMax            = OS_MAX_MEM_PART;           /* Number of memory partitions         */
INT16U  const  OSMemNameEn         = OS_MEM_NAME_EN;
#if (OS_MEM_EN > 0u) && (OS_MAX_MEM_PART > 0u)
INT16U  const  OSMemSize           = sizeof(OS_MEM);            /* Mem. Partition header sine (bytes)  */
INT16U  const  OSMemTblSize        = sizeof(OSMemTbl);
#else
INT16U  const  OSMemSize           = 0u;
INT16U  const  OSMemTblSize        = 0u;
#endif
INT16U  const  OSMutexEn           = OS_MUTEX_EN;

INT16U  const  OSPtrSize           = sizeof(void *);            /* Size in Bytes of a pointer          */

INT16U  const  OSQEn               = OS_Q_EN;
INT16U  const  OSQMax              = OS_MAX_QS;                 /* Number of queues                    */
#if (OS_Q_EN > 0u) && (OS_MAX_QS > 0u)
INT16U  const  OSQSize             = sizeof(OS_Q);              /* Size in bytes of OS_Q structure     */
#else
INT16U  const  OSQSize             = 0u;
#endif

INT16U  const  OSRdyTblSize        = OS_RDY_TBL_SIZE;           /* Number of bytes in the ready table  */

INT16U  const  OSSemEn             = OS_SEM_EN;

INT16U  const  OSStkWidth          = sizeof(OS_STK);            /* Size in Bytes of a stack entry      */

INT16U  const  OSTaskCreateEn      = OS_TASK_CREATE_EN;
INT16U  const  OSTaskCreateExtEn   = OS_TASK_CREATE_EXT_EN;
INT16U  const  OSTaskDelEn         = OS_TASK_DEL_EN;
INT16U  const  OSTaskIdleStkSize   = OS_TASK_IDLE_STK_SIZE;
INT16U  const  OSTaskProfileEn     = OS_TASK_PROFILE_EN;
INT16U  const  OSTaskMax           = OS_MAX_TASKS + OS_N_SYS_TASKS; /* Total max. number of tasks      */
INT16U  const  OSTaskNameEn        = OS_TASK_NAME_EN;  
INT16U  const  OSTaskStatEn        = OS_TASK_STAT_EN;
INT16U  const  OSTaskStatStkSize   = OS_TASK_STAT_STK_SIZE;
INT16U  const  OSTaskStatStkChkEn  = OS_TASK_STAT_STK_CHK_EN;
INT16U  const  OSTaskSwHookEn      = OS_TASK_SW_HOOK_EN;
INT16U  const  OSTaskRegTblSize    = OS_TASK_REG_TBL_SIZE;

INT16U  const  OSTCBPrioTblMax     = OS_LOWEST_PRIO + 1u;       /* Number of entries in OSTCBPrioTbl[] */
INT16U  const  OSTCBSize           = sizeof(OS_TCB);            /* Size in Bytes of OS_TCB             */
INT16U  const  OSTicksPerSec       = OS_TICKS_PER_SEC;
INT16U  const  OSTimeTickHookEn    = OS_TIME_TICK_HOOK_EN;
INT16U  const  OSVersionNbr        = OS_VERSION;

INT16U  const  OSTmrEn             = OS_TMR_EN;
INT16U  const  OSTmrCfgMax         = OS_TMR_CFG_MAX;
INT16U  const  OSTmrCfgNameEn      = OS_TMR_CFG_NAME_EN;
INT16U  const  OSTmrCfgWheelSize   = OS_TMR_CFG_WHEEL_SIZE;
INT16U  const  OSTmrCfgTicksPerSec = OS_TMR_CFG_TICKS_PER_SEC;

#if (OS_TMR_EN > 0u) && (OS_TMR_CFG_MAX > 0u)
INT16U  const  OSTmrSize           = sizeof(OS_TMR);
INT16U  const  OSTmrTblSize        = sizeof(OSTmrTbl);
INT16U  const  OSTmrWheelSize      = sizeof(OS_TMR_WHEEL);
INT16U  const  OSTmrWheelTblSize   = sizeof(OSTmrWheelTbl);
#else
INT16U  const  OSTmrSize           = 0u;
INT16U  const  OSTmrTblSize        = 0u;
INT16U  const  OSTmrWheelSize      = 0u;
INT16U  const  OSTmrWheelTblSize   = 0u;
#endif

#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                             DEBUG DATA
*                            TOTAL DATA SPACE (i.e. RAM) USED BY uC/OS-II
*********************************************************************************************************
*/
#if OS_DEBUG_EN > 0u

INT16U  const  OSDataSize = sizeof(OSCtxSwCtr)
#if (OS_EVENT_EN) && (OS_MAX_EVENTS > 0u)
                          + sizeof(OSEventFreeList)
                          + sizeof(OSEventTbl)
#endif
#if (OS_FLAG_EN > 0u) && (OS_MAX_FLAGS > 0u)
                          + sizeof(OSFlagTbl)
                          + sizeof(OSFlagFreeList)
#endif
#if OS_TASK_STAT_EN > 0u
                          + sizeof(OSCPUUsage)
                          + sizeof(OSIdleCtrMax)
                          + sizeof(OSIdleCtrRun)
                          + sizeof(OSStatRdy)
                          + sizeof(OSTaskStatStk)
#endif
#if OS_TICK_STEP_EN > 0u
                          + sizeof(OSTickStepState)
#endif
#if (OS_MEM_EN > 0u) && (OS_MAX_MEM_PART > 0u)
                          + sizeof(OSMemFreeList)
                          + sizeof(OSMemTbl)
#endif
#if (OS_Q_EN > 0u) && (OS_MAX_QS > 0u)
                          + sizeof(OSQFreeList)
                          + sizeof(OSQTbl)
#endif
#if OS_TIME_GET_SET_EN > 0u   
                          + sizeof(OSTime)
#endif
#if (OS_TMR_EN > 0u) && (OS_TMR_CFG_MAX > 0u)
                          + sizeof(OSTmrFree)
                          + sizeof(OSTmrUsed)
                          + sizeof(OSTmrTime)
                          + sizeof(OSTmrSem)
                          + sizeof(OSTmrSemSignal)
                          + sizeof(OSTmrTbl)
                          + sizeof(OSTmrFreeList)
                          + sizeof(OSTmrTaskStk)
                          + sizeof(OSTmrWheelTbl)
#endif
                          + sizeof(OSIntNesting)
                          + sizeof(OSLockNesting)
                          + sizeof(OSPrioCur)
                          + sizeof(OSPrioHighRdy)
                          + sizeof(OSRdyGrp)
                          + sizeof(OSRdyTbl)
                          + sizeof(OSRunning)
                          + sizeof(OSTaskCtr)
                          + sizeof(OSIdleCtr)
                          + sizeof(OSTaskIdleStk)
                          + sizeof(OSTCBCur)
                          + sizeof(OSTCBFreeList)
                          + sizeof(OSTCBHighRdy)
                          + sizeof(OSTCBList)
                          + sizeof(OSTCBPrioTbl)
                          + sizeof(OSTCBTbl);

#endif

/*$PAGE*/
/*
*********************************************************************************************************
*                                        OS DEBUG INITIALIZATION
*
* Description: This function is used to make sure that debug variables that are unused in the application
*              are not optimized away.  This function might not be necessary for all compilers.  In this
*              case, you should simply DELETE the code in this function while still leaving the declaration
*              of the function itself.
*
* Arguments  : none
*
* Returns    : none
*
* Note(s)    : (1) This code doesn't do anything, it simply prevents the compiler from optimizing out
*                  the 'const' variables which are declared in this file.
*              (2) You may decide to 'compile out' the code (by using #if 0/#endif) INSIDE the function 
*                  if your compiler DOES NOT optimize out the 'const' variables above.
*********************************************************************************************************
*/

#if OS_DEBUG_EN > 0u
void  OSDebugInit (void)
{
    void  const  *ptemp;


    ptemp = (void const *)&OSDebugEn;

    ptemp = (void const *)&OSEndiannessTest;

    ptemp = (void const *)&OSEventMax;
    ptemp = (void const *)&OSEventNameEn;
    ptemp = (void const *)&OSEventEn;
    ptemp = (void const *)&OSEventSize;
    ptemp = (void const *)&OSEventTblSize;
    ptemp = (void const *)&OSEventMultiEn;

    ptemp = (void const *)&OSFlagEn;
    ptemp = (void const *)&OSFlagGrpSize;
    ptemp = (void const *)&OSFlagNodeSize;
    ptemp = (void const *)&OSFlagWidth;
    ptemp = (void const *)&OSFlagMax;
    ptemp = (void const *)&OSFlagNameEn;

    ptemp = (void const *)&OSLowestPrio;

    ptemp = (void const *)&OSMboxEn;

    ptemp = (void const *)&OSMemEn;
    ptemp = (void const *)&OSMemMax;
    ptemp = (void const *)&OSMemNameEn;
    ptemp = (void const *)&OSMemSize;
    ptemp = (void const *)&OSMemTblSize;

    ptemp = (void const *)&OSMutexEn;

    ptemp = (void const *)&OSPtrSize;

    ptemp = (void const *)&OSQEn;
    ptemp = (void const *)&OSQMax;
    ptemp = (void const *)&OSQSize;

    ptemp = (void const *)&OSRdyTblSize;

    ptemp = (void const *)&OSSemEn;

    ptemp = (void const *)&OSStkWidth;

    ptemp = (void const *)&OSTaskCreateEn;
    ptemp = (void const *)&OSTaskCreateExtEn;
    ptemp = (void const *)&OSTaskDelEn;
    ptemp = (void const *)&OSTaskIdleStkSize;
    ptemp = (void const *)&OSTaskProfileEn;
    ptemp = (void const *)&OSTaskMax;
    ptemp = (void const *)&OSTaskNameEn;
    ptemp = (void const *)&OSTaskStatEn;
    ptemp = (void const *)&OSTaskStatStkSize;
    ptemp = (void const *)&OSTaskStatStkChkEn;
    ptemp = (void const *)&OSTaskSwHookEn;

    ptemp = (void const *)&OSTCBPrioTblMax;
    ptemp = (void const *)&OSTCBSize;

    ptemp = (void const *)&OSTicksPerSec;
    ptemp = (void const *)&OSTimeTickHookEn;

#if OS_TMR_EN > 0u
    ptemp = (void const *)&OSTmrTbl[0];
    ptemp = (void const *)&OSTmrWheelTbl[0];
    
    ptemp = (void const *)&OSTmrEn;
    ptemp = (void const *)&OSTmrCfgMax;
    ptemp = (void const *)&OSTmrCfgNameEn;
    ptemp = (void const *)&OSTmrCfgWheelSize;
    ptemp = (void const *)&OSTmrCfgTicksPerSec;
    ptemp = (void const *)&OSTmrSize;
    ptemp = (void const *)&OSTmrTblSize;

    ptemp = (void const *)&OSTmrWheelSize;
    ptemp = (void const *)&OSTmrWheelTblSize;
#endif

    ptemp = (void const *)&OSVersionNbr;

    ptemp = (void const *)&OSDataSize;

    ptemp = ptemp;                             /* Prevent compiler warning for 'ptemp' not being used! */
}
#endif
	 	   	  		 			 	    		   		 		 	 	 			 	    		   	 			 	  	 		 				 		  			 		 					 	  	  		      		  	   		      		  	 		 	      		   		 		  	 		 	      		  		  		  
