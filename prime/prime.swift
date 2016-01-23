//
//  prime.swift
//  prime
//
//  Created by Dan Kogai on 8/6/14.
//  Copyright (c) 2014-2016 Dan Kogai. All rights reserved.
//
//
#if os(Linux)
    import Glibc
#else
    import Foundation
#endif
public extension UInt64 {
    /// (x * y) mod m
    /// unlike naive x * y % m, this does not overflow.
    public static func mulmod(x:UInt64, _ y:UInt64, _ m:UInt64)->UInt64 {
        if (m == 0) { fatalError("modulo by zero") }
        if (m == 1) { return 1 }
        var a = x % m;
        if a == 0 { return 0 }
        var b = y % m;
        if b == 0 { return 0 }
        var r:UInt64 = 0;
        while a > 0 {
            if a & 1 == 1 { r = (r + b) % m }
            a >>= 1
            b = (b << 1) % m
        }
        return r
        // return c_mulmod(a, b, m)
    }
}
public extension UInt {
    /// (x * y) mod m without worring about overflow.
    public static func mulmod(x:UInt, _ y:UInt, _ m:UInt)->UInt {
        if x <= 0xFFFFffff && y <= 0xFFFFffff && m <= 0xFFFFffff {
            return x * y % m
        }
        return UInt(UInt64.mulmod(UInt64(x),UInt64(y),UInt64(m)))
    }
    /// (b ** n) mod m
    public static func powmod(var b:UInt, var _ n:UInt, _ m:UInt)->UInt {
        var r:UInt = 1
        for ; n > 0 ; n >>= 1 {
            if n & 1 == 1 { r = mulmod(r, b, m) }
            b = mulmod(b, b, m)
        }
        return r
    }
    /// Greatest Common Divisor
    public static func gcd(m:UInt, _ n:UInt)->UInt {
        if n == 0 { return m }
        if m < n { return gcd(n, m) }
        let r = m % n
        return r == 0 ? n : gcd(n, r)
    }
    /// b to the n.
    /// &* is neccessary to avoid exception
    public static func ipow(var b:UInt, var _ n:UInt)->UInt {
        var result:UInt = 1
        for ; n > 0; n >>= 1, b = b &* b {
            if n & 1 == 1 {
                result = result &* b
            }
        }
        return result
    }
    /// Integer Square Root
    public static func isqrt(n:UInt)->UInt {
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
    public static func icbrt(n:UInt)->UInt {
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
public extension Int {
    /// (x * y) mod m without worring about overflow.
    public static func mulmod(x:Int, _ y:Int, _ m:Int)->Int {
        let (ax, ay, am) = (abs(x),abs(y),abs(m))
        let sxy = 0 < x ? 0 < y ? 1 : -1 : 1
        return sxy * Int(UInt.mulmod(UInt(ax),UInt(ay),UInt(am)))
    }
    public static func gcd(m:Int, _ n:Int)->Int {
        if m < 0 {
            return gcd(-m, n < 0 ? -n : n)
        }
        if n == 0 { return m }
        if m < n { return gcd(n, m) }
        let r = m % n
        return r == 0 ? n : gcd(n, r)
    }
    public static func ipow(b:Int, _ n:Int)->Int {
        return Int(UInt.ipow(UInt(b), UInt(n)))
    }
    public static func isqrt(n:Int)->Int {
        return Int(UInt.isqrt(UInt(n)))
    }
}
public extension UInt {
    public class Prime {}
}
public extension UInt.Prime {
    public class var smallPrimes:[UInt] {
    struct Static {
        static let instance:[UInt] = {
            var ps:[UInt] = [2, 3]
            for var n:UInt = 5; n < 2048; n += 2 {
                for p in ps {
                    if n % p == 0 { break }
                    if p * p > n  { ps.append(n); break }
                }
            }
            return ps
            }()
        }
        return Static.instance
    }
    public class func mrTest(n:UInt, base:UInt)->Bool {
        if n < 2      { return false }
        if n & 1 == 0 { return n == 2 }
        var d = n - 1
        while d & 1 == 0 { d >>= 1 }
        var t:UInt = d
        var y = UInt.powmod(base, t, n)
        while t != n-1 && y != 1 && y != n-1 {
            y = UInt.mulmod(y, y, n)
            t <<= 1
        }
        return y == n-1 || t & 1 == 1
    }
    // cf. https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test
    public class func mrBases(n:UInt)->[UInt] {
        return n < 2047 ? [2]
        :   n < 1_373_653 ? [2, 3]
        :   n < 9_080_191 ? [31, 73]
        :   n < 25_326_001 ? [2, 3, 5]
        :   n < 4_759_123_141 ? [2, 7, 61]
        :   n < 1_122_004_669_633 ? [2, 13, 23, 1662803]
        :   n < 2_152_302_898_747 ? [2, 3, 5, 7, 11]
        :   n < 3_474_749_660_383 ? [2, 3, 5, 7, 11, 13]
        :   n < 341_550_071_728_321 ? [2, 3, 5, 7, 11, 13, 17]
        :   n < 3_825_123_056_546_413_051
            ? [2, 3, 5, 7, 11, 13, 17, 19, 23]
        : [2, 325, 9375, 28178, 450775, 9780504, 1795265022]
    }
    public class func isPrime(n:UInt)->Bool {
        if n < 2      { return false }
        if n & 1 == 0 { return n == 2 }
        if n % 3 == 0 { return n == 3 }
        if n % 5 == 0 { return n == 5 }
        if n % 7 == 0 { return n == 7 }
        for b in mrBases(n) {
            if mrTest(n, base:b) == false { return false }
        }
        return true
    }
    public class func nextPrime(var n:UInt)->UInt {
        if n < 2 { return 2 }
        n += n & 1 == 0 ? 1 : 2
        for ; !isPrime(n); n += 2 {}
        return n
    }
    public class func prevPrime(var n:UInt)->UInt {
        if n < 2 { return 2 }
        n -= n & 1 == 0 ? 1 : 2
        for ; !isPrime(n); n -= 2 {}
        return n
    }
    public class func within(range:Range<UInt>)->[UInt] {
        var result = [UInt]()
        var p = range.startIndex
        if !p.isPrime { p = p.nextPrime }
        for ; p < range.endIndex; p = p.nextPrime {
            result.append(p)
        }
        return result
    }
    public class func pbRho(n:UInt, _ l:UInt, _ c:UInt)->UInt {
        //return UInt(c_pbrho(UInt64(n), UInt64(l), Int32(c)))
        var x:UInt = 2, y:UInt = 2, j:UInt = 2
        for i in 1...l {
            x = UInt.mulmod(x, x, n)
            x += c
            let d  = UInt.gcd(x < y ? y - x : x - y, n);
            if (d != 1) {
                return d == n ? 1 : d
            }
            if (i % j == 0) {
                y = x
                j += j
            }
        }
        return 1
    }
    // cf. http://en.wikipedia.org/wiki/Shanks'_square_forms_factorization
    // https://github.com/danaj/Math-Prime-Util/blob/master/factor.c
    public class func squfof(n:UInt)->UInt {
        let ks:[UInt] = [
            //3*5*7*11, 3*5*7, 3*5*11, 3*5, 3*7*11, 3*7, 5*7*11, 5*7,
            //3*11,     3,     5*11,   5,   7*11,   7,   11,     1
3*5*7*11, 3*5*7,  3*5*7*11*13, 3*5*7*13, 3*5*7*11*17, 3*5*11,
3*5*7*17, 3*5,    3*5*7*11*19, 3*5*11*13,3*5*7*19,    3*5*7*13*17,
3*5*13,   3*7*11, 3*7,         5*7*11,   3*7*13,      5*7,
3*5*17,   5*7*13, 3*5*19,      3*11,     3*7*17,      3,
3*11*13,  5*11,   3*7*19,      3*13,     5,           5*11*13,
5*7*19,   5*13,   7*11,        7,        3*17,        7*13,
11,       1
        ]
        for k in ks {
            //let g = UInt(c_squfof(UInt64(n), UInt64(k)))
            let g = squfof_one(n, k)
            // println("squof(\(n),\(k)) == \(k)")
            if g != 1 { return g }
        }
        return 1
    }
    public class func squfof_one(n:UInt, _ k:UInt)->UInt {
        if n < 2      { return 1 }
        if n & 1 == 0 { return 2 }
        let rn = UInt.isqrt(n)
        if rn * rn == n { return rn }
        let drnk = sqrt(Double(n) * Double(k))
        let rnk = Int(drnk)
        var p0, p1, q0, q1, q2, b, rq : Int
        var qs = [Int]()
        rq = 1;
        p0 = rnk; p1 = 1; q0 = 1;
        q1 = Int((drnk + Double(p0))*(drnk - Double(p0)))
        let l = Int(UInt.isqrt(2 * UInt.isqrt(n)))
        var i:Int
        for i = 1; i < 4*l ; i++ {
            if q1 == 1 { continue }
            b = (rnk + p0) / q1
            p1 = b * q1 - p0
            q2 = q0 + b * (p0 - p1)
            //println("p0=\(p0),q0=\(q0)q1=\(q1),q2=\(q2)")
            // skip trivial factors
            if q1 <= 2 * l {
                if q1 & 1 == 1 {
                    if q1 <= l { qs.append(q1) }
                } else {
                    qs.append(q1 >> 1)
                }
                continue;
            }
            // perfect squware check every other iter
            if i & 1 == 0 { continue }
            rq = Int.isqrt(q2);
            if rq * rq == q2  && !qs.contains(rq) {
                break
            }
            p0 = p1; q0 = q1; q1 = q2;
        }
        if i == 4*l { return 1 }
        // stage2:
        b = (rnk - p1)/rq; p0 = b*rq + p1;
        q0 = rq;
        q1 = Int((drnk + Double(p0))*(drnk - Double(p0)))/q0
        while (true) {
            b = (rnk + p0) / q1
            p1 = b * q1 - p0
            q2 = q0 + b * (p0 - p1)
            if p0 == p1 { break }
            p0 = p1; q0 = q1; q1 = q2
        }
        //printf("p0=%llu,q0=%llu,q1=%llu,q2=%llu\n",p0,q0,q1,q2);
        let g = UInt.gcd(n, UInt(p0))
        return g == n ? 1 : g;
        //return ((q1 & 1) ? q1 : q1 >> 1);
    }
    // factor n
    // stratagy is akin to Math::Prime::Util
    public class func factor(var n:UInt)->[UInt] {
        if n < 2 { return [n] }
        if isPrime(n) { return [n] }
        var result = [UInt]()
        for p in smallPrimes[0..<83] {
            while n % p == 0 { result.append(p); n /= p }
            if n == 1 { return result }
        }
        if isPrime(n) { return result + [n] }
        if n < UInt(smallPrimes.last! * smallPrimes.last!) {
            for p in smallPrimes[83..<smallPrimes.count] {
                while n % p == 0 { result.append(p); n /= p }
                if n == 1 { return result }
            }
            if n != 1 { result.append(n) }
            return result
        }
        if isPrime(n) { return result + [n] }
        let l = Swift.min(UInt.isqrt(n), 0x10_0000)
        var d = pbRho(n, l, 1)
        if d == 1 {
            d = squfof(n)
        }
        result += d != 1 ? factor(d) + factor(n/d) : [1, n]
        result.sortInPlace(<)
        return result
    }
}
extension UInt.Prime : SequenceType {
    public func generate()->AnyGenerator<UInt> {
        var currPrime:UInt = 0
        return anyGenerator {
            let nextPrime = currPrime.nextPrime
            if nextPrime > currPrime {
                currPrime = nextPrime;
                return currPrime
            }
            return nil
        }
    }
}
public extension UInt {
    public var isPrime:Bool { return Prime.isPrime(self) }
    public var nextPrime:UInt { return Prime.nextPrime(self) }
    public var prevPrime:UInt { return Prime.prevPrime(self) }
    public var primeFactors:[UInt] { return Prime.factor(self) }
}
public extension Int {
    public var isPrime:Bool {
        return self < 2 ? false : UInt(self).isPrime
    }
    public var nextPrime:Int { return Int(UInt(self).nextPrime) }
    public var prevPrime:Int { return Int(UInt(self).prevPrime) }
    public var primeFactors:[Int] {
        var result = UInt(abs(self)).primeFactors.map{ Int($0) }
        if self < 0 { result += [-1] }
        return result
    }
}
public extension Int {
    public class Prime {}
}
extension Int.Prime : SequenceType {
    public func generate()->AnyGenerator<Int> {
        var currPrime = 0
        return anyGenerator {
            if currPrime < 9223372036854775783 {
                currPrime = currPrime.nextPrime
                return currPrime
            }
            return nil
        }
    }
}
extension Int.Prime {
    public class func within(range:Range<Int>)->[Int] {
        let start = UInt(max(range.startIndex, 0))
        let end   = UInt(range.endIndex)
        return UInt.Prime.within(start..<end).map{ Int($0) }
    }
}
