// networking/md5.h
#ifndef MD5_HELPER_H
#define MD5_HELPER_H
int md5_file_hex(const char *path, char out_hex_33[33]); // NUL-terminated 32 hex chars
#endif