#ifndef __LIBS_DIRENT_H__
#define __LIBS_DIRENT_H__

#include <defs.h>
#include <unistd.h>

struct dirent {
    off_t offset;
    char name[FS_MAX_FNAME_LEN + 1];
};

#endif /* !__LIBS_DIRENT_H__ */

