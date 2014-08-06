//
//  128bit.c
//  prime
//
//  Created by Dan Kogai on 8/6/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//

#include <stdint.h>
uint64_t c_powmod(uint64_t b64, uint64_t p64, uint64_t m64) {
    __uint128_t b128, r128;
    for (r128 = 1, b128 = b64; p64 > 0; p64 >>= 1) {
        if ((p64 & 1) == 1) { r128 = (r128 * b128) % m64; }
        b128 = (b128 * b128) % m64;
    }
    return (uint64_t)r128;
}
int c_mrtest(uint64_t n64, uint64_t b64) {
    if (n64 < 2)  { return 0; }
    if ((n64 & 1) == 0) { return n64 == 2; }
    uint64_t d64 = n64-1;
    while((d64 & 1) == 0) { d64 >>= 1; }
    uint64_t    t64 = d64;
    __uint128_t y128 = c_powmod(b64, t64, n64);
    while (t64 != n64-1 && y128 != 1 && y128 != n64-1) {
        y128 = (y128 * y128) % n64;
        t64 <<= 1;
    }
    return y128 == n64-1 || (t64 & 1) == 1;
}
