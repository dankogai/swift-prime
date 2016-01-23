//
//  integers.swift
//  prime
//
//  Created by Dan Kogai on 8/9/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
// Collection of integer operations,
// mostly needed to handle primes
//
extension UInt64 {
    /// (x * y) mod m
    /// unlike naive x * y % m, this does not overflow.
    static func mulmod(a:UInt64, _ b:UInt64, _ m:UInt64)->UInt64 {
//        if (m == 0) { fatalError("modulo by zero") }
//        if (m == 1) { return 1 }
//        var r:UInt64 = 0
//        if a > m { a %= m }
//        if b > m { b %= m }
//        while a > 0 {
//            if a & 1 == 1 { r = (r + b) % m }
//            a >>= 1
//            b = (b << 1) % m
//        }
//        return r
        return c_mulmod(a, b, m)
    }
}
extension UInt {
    /// (x * y) mod m without worring about overflow.
    static func mulmod(x:UInt, _ y:UInt, _ m:UInt)->UInt {
        if x <= 0xFFFFffff && y <= 0xFFFFffff && m <= 0xFFFFffff {
            return x * y % m
        }
        return UInt(UInt64.mulmod(UInt64(x),UInt64(y),UInt64(m)))
    }
    /// (b ** n) mod m
    static func powmod(var b:UInt, var _ n:UInt, _ m:UInt)->UInt {
        var r:UInt = 1
        for ; n > 0 ; n >>= 1 {
            if n & 1 == 1 { r = mulmod(r, b, m) }
            b = mulmod(b, b, m)
        }
        return r
    }
    /// Greatest Common Divisor
    static func gcd(m:UInt, _ n:UInt)->UInt {
        if n == 0 { return m }
        if m < n { return gcd(n, m) }
        let r = m % n
        return r == 0 ? n : gcd(n, r)
    }
    /// b to the n.
    /// &* is neccessary to avoid exception
    static func ipow(var b:UInt, var _ n:UInt)->UInt {
        var result:UInt = 1
        for ; n > 0; n >>= 1, b = b &* b {
            if n & 1 == 1 {
                result = result &* b
            }
        }
        return result
    }
    /// Integer Square Root
    static func isqrt(n:UInt)->UInt {
        if n == 0 { return 0 }
        if n == 1 { return 1 }
        if n == 18446744073709551615 { return 4294967295 }
        var xk = n
        repeat {
            let xk1 = (xk + n / xk) / 2
            if xk1 >= xk { return xk }
            xk = xk1
        } while true
    }
    /// Integer Cube Root
    static func icbrt(n:UInt)->UInt {
        if n == 0 { return 0 }
        if n == 1 { return 1 }
        if n == 18446744073709551615 { return 2642245 }
        var xk = n
        repeat {
            let xk1 = (2*xk + n/xk/xk) / 3
            if xk1 >= xk { return xk }
            xk = xk1
        } while true
    }
}
extension Int {
    /// (x * y) mod m without worring about overflow.
    static func mulmod(x:Int, _ y:Int, _ m:Int)->Int {
        let (ax, ay, am) = (abs(x),abs(y),abs(m))
        let sxy = 0 < x ? 0 < y ? 1 : -1 : 1
        return sxy * Int(UInt.mulmod(UInt(ax),UInt(ay),UInt(am)))
    }
    static func gcd(m:Int, _ n:Int)->Int {
        if m < 0 {
            return gcd(-m, n < 0 ? -n : n)
        }
        if n == 0 { return m }
        if m < n { return gcd(n, m) }
        let r = m % n
        return r == 0 ? n : gcd(n, r)
    }
    static func ipow(b:Int, _ n:Int)->Int {
        return Int(UInt.ipow(UInt(b), UInt(n)))
    }
    static func isqrt(n:Int)->Int {
        return Int(UInt.isqrt(UInt(n)))
    }
}
