#ifndef __LIBS_STAT_H__
#define __LIBS_STAT_H__

#include <defs.h>

struct stat {
    uint32_t st_mode;                   // protection mode and file type
    size_t st_nlinks;                   // number of hard links
    size_t st_blocks;                   // number of blocks file is using
    size_t st_size;                     // file size (bytes)
};

#define S_IFMT          070000          // mask for type of file
#define S_IFREG         010000          // ordinary regular file
#define S_IFDIR         020000          // directory
#define S_IFLNK         030000          // symbolic link
#define S_IFCHR         040000          // character device
#define S_IFBLK         050000          // block device

#define S_ISREG(mode)                   (((mode) & S_IFMT) == S_IFREG)      // regular file
#define S_ISDIR(mode)                   (((mode) & S_IFMT) == S_IFDIR)      // directory
#define S_ISLNK(mode)                   (((mode) & S_IFMT) == S_IFLNK)      // symlink
#define S_ISCHR(mode)                   (((mode) & S_IFMT) == S_IFCHR)      // char device
#define S_ISBLK(mode)                   (((mode) & S_IFMT) == S_IFBLK)      // block device

#endif /* !__LIBS_STAT_H__ */

