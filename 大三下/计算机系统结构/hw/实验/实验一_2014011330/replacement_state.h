#ifndef REPL_STATE_H
#define REPL_STATE_H

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// This file is distributed as part of the Cache Replacement Championship     //
// workshop held in conjunction with ISCA'2010.                               //
//                                                                            //
//                                                                            //
// Everyone is granted permission to copy, modify, and/or re-distribute       //
// this software.                                                             //
//                                                                            //
// Please contact Aamer Jaleel <ajaleel@gmail.com> should you have any        //
// questions                                                                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

#include <cstdlib>
#include <cassert>
#include "utils.h"
#include "crc_cache_defs.h"

#include <algorithm>

// Replacement Policies Supported
typedef enum
{
    CRC_REPL_LRU        = 0,
    CRC_REPL_RANDOM     = 1,
    CRC_REPL_CONTESTANT = 2
} ReplacemntPolicy;

// Replacement State Per Cache Line
typedef struct
{
    UINT32  LRUstackposition;

    // CONTESTANTS: Add extra state per cache line here
    INT32 token;

    INT32 getToken() { return token; }

} LINE_REPLACEMENT_STATE;

typedef struct {
  int token;
  int way;
} line_t;

// The implementation for the cache replacement policy
class CACHE_REPLACEMENT_STATE
{

  private:
    UINT32 numsets;
    UINT32 assoc;
    UINT32 replPolicy;

    LINE_REPLACEMENT_STATE   **repl;

    COUNTER mytimer;  // tracks # of references to the cache

    // CONTESTANTS:  Add extra state for cache here
    INT32 startToken;
    UINT32 evictCandidateConfidence;
    UINT32 measureWindowSize;
    UINT32 updateCount;
    UINT32 missCount;
    UINT32 lastMissCount;
    bool lastChangeDir;

    UINT32 max_mws;
    UINT32 min_mws;
    UINT32 max_ec;
    UINT32 min_ec;
    int max_it;
    int min_it;
    int max_token;
    int min_token;

    // CONSTANTS:
    // Amount of right shift.
    const static UINT32 EVICT_PRECISION = 2;
    const static UINT32 TOKEN_STEP = 4;
    const static int MEASURE_WINDOW_DELTA_THRESHOLD = 400;
    const static UINT32 MEASURE_WINDOW_MAX = 1000;

  public:

    // The constructor CAN NOT be changed
    CACHE_REPLACEMENT_STATE( UINT32 _sets, UINT32 _assoc, UINT32 _pol );

    INT32  GetVictimInSet( UINT32 tid, UINT32 setIndex, const LINE_STATE *vicSet, UINT32 assoc, Addr_t PC, Addr_t paddr, UINT32 accessType );
    void   UpdateReplacementState( UINT32 setIndex, INT32 updateWayID );

    void   SetReplacementPolicy( UINT32 _pol ) { replPolicy = _pol; }
    void   IncrementTimer() { mytimer++; }

    void   UpdateReplacementState( UINT32 setIndex, INT32 updateWayID, const LINE_STATE *currLine,
                                   UINT32 tid, Addr_t PC, UINT32 accessType, bool cacheHit );

    ostream&   PrintStats( ostream &out);

  private:

    void   InitReplacementState();
    INT32  Get_Random_Victim( UINT32 setIndex );

    INT32  Get_LRU_Victim( UINT32 setIndex );
    void   UpdateLRU( UINT32 setIndex, INT32 updateWayID );

    INT32  Get_Token_Victim( UINT32 setIndex );
    void   UpdateToken(UINT32 setIndex, UINT32 wayIndex, bool isHit);
};


#endif
