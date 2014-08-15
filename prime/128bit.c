//
//  128bit.c
//  prime
//
//  Created by Dan Kogai on 8/6/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
uint64_t c_mulmod(uint64_t x64, uint64_t y64, uint64_t m64) {
    return (uint64_t)((__uint128_t)x64 * (__uint128_t)y64 % m64);
}
uint64_t c_powmod(uint64_t b64, uint64_t p64, uint64_t m64) {
    uint64_t r64;
    for (r64 = 1; p64 > 0; p64 >>= 1) {
        if ((p64 & 1) == 1) { r64 = c_mulmod(r64, b64, m64); }
        b64 = c_mulmod(b64, b64, m64);
    }
    return r64;
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
uint64_t c_sqaddmod(uint64_t n64, uint64_t p64, uint64_t m64) {
    __uint128_t r128 = n64 * n64 + p64;
    return (uint64_t)(r128 % m64);
}
uint64_t gcd(uint64_t m, uint64_t n){
    if (n == 0) { return m; }
    if (m < n) { return gcd(n, m); }
    uint64_t r = m < (n << 1) ? m - n : m % n;
    return r == 0 ? n : gcd(n, r);
}
uint64_t c_ipow(uint64_t b, uint64_t n) {
    uint64_t result = 1;
    for (; n > 0; n >>= 1, b *= b) {
        if ((n & 1) == 1) { result *= b; }
    }
    return result;
}
uint64_t isqrt(uint64_t n) {
    if (n == 0) { return 0; }
    if (n == 1) { return 1; }
    if (n == 0xffffffffffffffffULL) { return 0xffffffff; }
    uint64_t x0 = n;
    do {
        uint64_t x1 = (x0 + n / x0) / 2;
        if (x1 >= x0) { return x0; }
        x0 = x1;
    } while(1);
}
uint64_t c_pbrho(uint64_t n, uint64_t l, int c) {
    uint64_t x = 2, y = 2;
    if (c < 0) {
        c = -c;
        x = y = arc4random();
    }
    int i, j;
    for (i = 1, j = 2; i < l; i++) {
        x  = c_sqaddmod(x, c, n);
        uint64_t d = gcd(x < y ? y - x : x - y, n);
        if (d != 1) {
            return d == n ? 1 : d;
        }
        if (i % j == 0) {
            y = x;
            j += j;
        }
    }
    return 1;
}
uint64_t isqrt2(uint64_t n, uint64_t w) {
    //return isqrt(n) * isqrt(w);
    //return (uint64_t)sqrtl((long double)n * (long double)w);
    if (n == 0) { return 0; }
    if (n == 1) { return isqrt(w); }
    __uint128_t nw = n * w;
    __uint128_t x0 = nw;
    do {
        __uint128_t x1 = (x0 + nw / x0) / 2;
        if (x1 >= x0) { return (uint64_t)x0; }
        x0 = x1;
    } while(1);
}
#define QLEN 64
#define KNP2(k,n,p0) \
  (uint64_t)((__uint128_t)((k)*(n))-(__uint128_t)((p0)*(p0)))
uint64_t c_squfof(uint64_t n, uint64_t k) {
    if (n < 2)        { return 1; }
    if ((n & 1) == 0) { return 2; }
    uint64_t rnk = isqrt(n);
    if (rnk * rnk == n) return rnk;
    rnk = isqrt2(n, k);
    int l = (int)isqrt(2*isqrt(n));
    uint64_t p0, p1 = 0, q0, q1, q2, b, rq = 1;
    p0 = rnk, q0 = 1; q1 = KNP2(k, n, p0);
    uint64_t qs[QLEN];
    int i, qi = 0;
    for (i = 1; i < 4 * l; i++) {
        if (q1 == 1) continue;
        b = (rnk + p0)/q1;
        p1 = b*q1 - p0;
        q2 = q0 + b*(p0 - p1);
        // skip trivial factors
        if (q1 <= 2 * l) {
            if (q1 & 1) {
                if (q1 <= l) qs[qi++] = q1;
            } else {
                qs[qi++] = q1 >> 1;
            }
            if (qi == QLEN) return 1;
            continue;
        }
        // perfect squware check every other iter
        if ((i & 1) == 0) continue;
        rq = isqrt(q2);
        if (rq * rq == q2) {
            int j;
            for (j = qi-1; j >= 0; j--) {
                if (rq == qs[j]) {
                    // printf("squfof:skip %llu\n", rq);
                    goto stage1e;
                }
            }
            break;
        }
    stage1e:
        p0 = p1, q0 = q1, q1 = q2;
    }
    if (i == 4l) return 1;
    // stage2:
    b = (rnk - p1)/rq, p0 = b*rq + p1,
    q0 = rq, q1 = KNP2(k, n, p0)/q0;
    while (1) {
        b = (rnk + p0)/q1;
        // t = rnk + p0 - q1; b = 1; if (t > q1) b += t / q1;
        p1 = b*q1 - p0;
        q2 = q0 + b*(p0 - p1);
        if (p0 == p1) break;
        p0 = p1, q0 = q1, q1 = q2;
    }
    //printf("p0=%llu,q0=%llu,q1=%llu,q2=%llu\n",p0,q0,q1,q2);
    uint64_t g = gcd(n, p0);
    return g == n ? 1 : g;
    //return ((q1 & 1) ? q1 : q1 >> 1);
}
