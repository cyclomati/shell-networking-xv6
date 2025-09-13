// mini-project1/networking/md5_macos.c
// MD5 helper for macOS: prefers OpenSSL if available, falls back to CommonCrypto
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if __has_include(<openssl/evp.h>)
#include <openssl/evp.h>
int md5_file_hex(const char *path, char out_hex[33]) {
    FILE *fp = fopen(path, "rb");
    if (!fp) return -1;

    EVP_MD_CTX *ctx = EVP_MD_CTX_new();
    if (!ctx) { fclose(fp); return -1; }
    if (EVP_DigestInit_ex(ctx, EVP_md5(), NULL) != 1) { EVP_MD_CTX_free(ctx); fclose(fp); return -1; }

    unsigned char buf[4096];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), fp)) > 0) {
        if (EVP_DigestUpdate(ctx, buf, n) != 1) { EVP_MD_CTX_free(ctx); fclose(fp); return -1; }
    }

    unsigned char md[EVP_MAX_MD_SIZE];
    unsigned int mdlen = 0;
    if (EVP_DigestFinal_ex(ctx, md, &mdlen) != 1) { EVP_MD_CTX_free(ctx); fclose(fp); return -1; }
    EVP_MD_CTX_free(ctx);
    fclose(fp);

    static const char hexdig[] = "0123456789abcdef";
    for (unsigned i = 0; i < mdlen && i*2+1 < 33; ++i) {
        out_hex[i*2]   = hexdig[(md[i] >> 4) & 0xF];
        out_hex[i*2+1] = hexdig[(md[i]     ) & 0xF];
    }
    out_hex[32] = '\0';
    return 0;
}
#else
#include <CommonCrypto/CommonDigest.h>
int md5_file_hex(const char *path, char out_hex[33]) {
    FILE *fp = fopen(path, "rb");
    if (!fp) return -1;

    CC_MD5_CTX ctx;
    CC_MD5_Init(&ctx);
    unsigned char buf[4096];
    size_t n;
    while ((n = fread(buf, 1, sizeof(buf), fp)) > 0) {
        CC_MD5_Update(&ctx, buf, (CC_LONG)n);
    }
    fclose(fp);

    unsigned char md[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(md, &ctx);

    static const char hexdig[] = "0123456789abcdef";
    for (unsigned i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        out_hex[i*2]   = hexdig[(md[i] >> 4) & 0xF];
        out_hex[i*2+1] = hexdig[(md[i]     ) & 0xF];
    }
    out_hex[32] = '\0';
    return 0;
}
#endif
