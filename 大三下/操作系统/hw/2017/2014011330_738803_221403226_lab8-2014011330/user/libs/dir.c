#include <defs.h>
#include <string.h>
#include <syscall.h>
#include <stat.h>
#include <dirent.h>
#include <file.h>
#include <dir.h>
#include <error.h>
#include <unistd.h>

DIR dir, *dirp=&dir;
DIR *
opendir(const char *path) {

    if ((dirp->fd = open(path, O_RDONLY)) < 0) {
        goto failed;
    }
    struct stat __stat, *stat = &__stat;
    if (fstat(dirp->fd, stat) != 0 || !S_ISDIR(stat->st_mode)) {
        goto failed;
    }
    dirp->dirent.offset = 0;
    return dirp;

failed:
    return NULL;
}

struct dirent *
readdir(DIR *dirp) {
    if (sys_getdirentry(dirp->fd, &(dirp->dirent)) == 0) {
        return &(dirp->dirent);
    }
    return NULL;
}

void
closedir(DIR *dirp) {
    close(dirp->fd);
}

int
getcwd(char *buffer, size_t len) {
    return sys_getcwd(buffer, len);
}

