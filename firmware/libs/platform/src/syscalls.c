// Minimal syscall stubs for bare-metal builds.
// These are *not* real implementations – we just want to satisfy newlib so that
// linking succeeds without warnings. We don't use malloc/printf/etc. yet.

#include <errno.h>

int _close(int fd) {
    (void)fd;
    errno = ENOSYS;
    return -1;
}

int _lseek(int fd, int ptr, int dir) {
    (void)fd;
    (void)ptr;
    (void)dir;
    errno = ENOSYS;
    return -1;
}

int _read(int fd, char* buf, int len) {
    (void)fd;
    (void)buf;
    (void)len;
    errno = ENOSYS;
    return -1;
}

int _write(int fd, const char* buf, int len) {
    (void)fd;
    (void)buf;
    (void)len;
    errno = ENOSYS;
    return -1;
}

void _exit(int status) {
    (void)status;
    while (1) {
    }
}

void* _sbrk(int incr) {
    (void)incr;
    errno = ENOMEM;
    return (void*)-1;
}