#include <ulib.h>
#include <stdio.h>
#include <string.h>
#include <dir.h>
#include <file.h>
#include <stat.h>
#include <dirent.h>
#include <unistd.h>

#define printf(...)                     fprintf(1, __VA_ARGS__)
#define BUFSIZE                         4096

static char
getmode(uint32_t st_mode) {
    char mode = '?';
    if (S_ISREG(st_mode)) mode = '-';
    if (S_ISDIR(st_mode)) mode = 'd';
    if (S_ISLNK(st_mode)) mode = 'l';
    if (S_ISCHR(st_mode)) mode = 'c';
    if (S_ISBLK(st_mode)) mode = 'b';
    return mode;
}

static int
getstat(const char *name, struct stat *stat) {
    int fd, ret;
    if ((fd = open(name, O_RDONLY)) < 0) {
        return fd;
    }
    ret = fstat(fd, stat);
    close(fd);
    return ret;
}

void
lsstat(struct stat *stat, const char *filename) {
    printf("   [%c]", getmode(stat->st_mode));
    printf(" %3d(h)", stat->st_nlinks);
    printf(" %8d(b)", stat->st_blocks);
    printf(" %8d(s)", stat->st_size);
    printf("   %s\n", filename);
}

int
lsdir(const char *path) {
    struct stat __stat, *stat = &__stat;
    int ret;
    DIR *dirp = opendir(".");
    
    if (dirp == NULL) {
        return -1;
    }
    struct dirent *direntp;
    while ((direntp = readdir(dirp)) != NULL) {
        if ((ret = getstat(direntp->name, stat)) != 0) {
            goto failed;
        }
        lsstat(stat, direntp->name);
    }
    printf("lsdir: step 4\n");
    closedir(dirp);
    return 0;
failed:
    closedir(dirp);
    return ret;
}

int
ls(const char *path) {
    struct stat __stat, *stat = &__stat;
    int ret, type;
    if ((ret = getstat(path, stat)) != 0) {
        return ret;
    }

    static const char *filetype[] = {
        " [  file   ]",
        " [directory]",
        " [ symlink ]",
        " [character]",
        " [  block  ]",
        " [  ?????  ]",
    };
    switch (getmode(stat->st_mode)) {
    case '0': type = 0; break;
    case 'd': type = 1; break;
    case 'l': type = 2; break;
    case 'c': type = 3; break;
    case 'b': type = 4; break;
    default:  type = 5; break;
    }

    printf(" @ is %s", filetype[type]);
    printf(" %d(hlinks)", stat->st_nlinks);
    printf(" %d(blocks)", stat->st_blocks);
    printf(" %d(bytes) : @'%s'\n", stat->st_size, path);
    if (S_ISDIR(stat->st_mode)) {
        return lsdir(path);
    }
    return 0;
}

int
main(int argc, char **argv) {
    if (argc == 1) {
        return ls(".");
    }
    else {
        int i, ret;
        for (i = 1; i < argc; i ++) {
            if ((ret = ls(argv[i])) != 0) {
                return ret;
            }
        }
    }
    return 0;
}

