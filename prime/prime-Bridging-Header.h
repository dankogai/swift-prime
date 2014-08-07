//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <stdint.h>
uint64_t c_powmod(uint64_t b64, uint64_t p64, uint64_t m64);
int c_mrtest(uint64_t n64, uint64_t b64);
uint64_t c_sqaddmod(uint64_t n64, uint64_t p64, uint64_t m64);
uint64_t c_ipow(uint64_t b, uint64_t n);
uint64_t c_pbrho(uint64_t n);
uint64_t c_squfof(uint64_t n);