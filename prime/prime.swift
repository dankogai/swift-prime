//
//  prime.swift
//  prime
//
//  Created by Dan Kogai on 8/6/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
extension UInt {
    static func powmod(var b:UInt, var _ p:UInt, _ m:UInt)->UInt {
        if b > 0x7FFFffff || p > 0x7FFFffff || m > 0x7FFFffff {
            return UInt(c_powmod(UInt64(b), UInt64(p), UInt64(m)))
        } else {
            var r:UInt = 1
            for ; p > 0 ; p >>= 1 {
                if p & 1 == 1 { r = r * b % m }
                b = b * b % m
            }
            return r
        }
    }
    static func gcd(m:UInt, _ n:UInt)->UInt {
        if n == 0 { return m }
        if m < n { return gcd(n, m) }
        let r = m % n
        return r == 0 ? n : gcd(n, r)
    }
    static func ipow(var b:UInt, var _ n:UInt)->UInt {
        return UInt(c_ipow(UInt64(b), UInt64(n)))
//        var result:UInt = 1
//        for ; n > 0; n >>= 1, b *= b {
//            if n & 1 == 1 { result *= b }
//        }
//        return result
    }
    static func isqrt(var n:UInt)->UInt {
        if n == 0 { return 0 }
        if n == 1 { return 1 }
        if n == 18446744073709551615 { return 4294967295 }
        var xk = n
        do {
            let xk1 = (xk + n / xk) / 2
            if xk1 >= xk { return xk }
            xk = xk1
        } while true
    }
    static func icbrt(var n:UInt)->UInt {
        if n == 0 { return 0 }
        if n == 1 { return 1 }
        if n == 18446744073709551615 { return 2642245 }
        var xk = n
        do {
            let xk1 = (2*xk + n/xk/xk) / 3
            if xk1 >= xk { return xk }
            xk = xk1
        } while true
    }
}
extension Int {
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
extension UInt {
    class Prime {}
}
extension UInt.Prime {
    class var smallPrimes:[UInt] {
    struct Static {
        static let instance:[UInt] = {
            var ps:[UInt] = [2, 3]
            for var n:UInt = 5; n <= 2011; n += 2 {
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
    class func mrTest(n:UInt, base:UInt)->Bool {
        if n > 0x7FFFffff || base > 0x7FFFffff {
            return c_mrtest(UInt64(n), UInt64(base)) != 0
        } else {
            if n < 2      { return false }
            if n & 1 == 0 { return n == 2 }
            var d = n - 1
            while d & 1 == 0 { d >>= 1 }
            var t:UInt = d
            var y = UInt.powmod(base, t, n)
            while t != n-1 && y != 1 && y != n-1 {
                y = (y * y) % n
                t <<= 1
            }
            return y == n-1 || t & 1 == 1
        }
    }
    // cf. https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test
    class func mrBases(n:UInt)->[UInt] {
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
    class func isPrime(n:UInt)->Bool {
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
    class func nextPrime(var n:UInt)->UInt {
        if n < 2 { return 2 }
        n += n & 1 == 0 ? 1 : 2
        for ; !isPrime(n); n += 2 {}
        return n
    }
    class func prevPrime(var n:UInt)->UInt {
        if n < 2 { return 2 }
        n -= n & 1 == 0 ? 1 : 2
        for ; !isPrime(n); n -= 2 {}
        return n
    }
    class func within(range:Range<UInt>)->[UInt] {
        var result = [UInt]()
        var p = range.startIndex
        if !p.isPrime { p = p.nextPrime }
        for ; p < range.endIndex; p = p.nextPrime {
            result.append(p)
        }
        return result
    }
    class func pbRho(n:UInt, _ l:UInt, _ c:Int)->UInt {
        return UInt(c_pbrho(UInt64(n), UInt64(l), Int32(c)))
    }
    // cf. http://en.wikipedia.org/wiki/Shanks'_square_forms_factorization
    // https://github.com/danaj/Math-Prime-Util/blob/master/factor.c
    class func squfof(n:UInt)->UInt {
        let ks:[UInt64] = [
            3*5*7*11, 3*5*7, 3*5*11, 3*5, 3*7*11, 3*7, 5*7*11, 5*7,
            3*11,     3,     5*11,   5,   7*11,   7,   11,     1
        ]
        for k in ks {
            let g = UInt(c_squfof(UInt64(n), k))
            // println("squof(\(n),\(k)) == \(k)")
            if g != 1 { return g }
        }
        return 1
    }
    // factor n
    // stratagy is akin to Math::Prime::Util
    class func factor(var n:UInt)->[UInt] {
        if n < 2 { return [n] }
        if isPrime(n) { return [n] }
        var result = [UInt]()
        for p in smallPrimes {
            while n % p == 0 { result.append(p); n /= p }
            if n == 1 { return result }
        }
        if isPrime(n) { return result + [n] }
        var d = squfof(n)
        if d == 1 { return [0, n] }
        result +=  factor(d) + factor(n/d)
        result.sort(<)
        return result
    }
}
extension UInt.Prime : SequenceType {
    func generate()->GeneratorOf<UInt> {
        var currPrime:UInt = 0
        return GeneratorOf<UInt> {
            let nextPrime = currPrime.nextPrime
            if nextPrime > currPrime {
                currPrime = nextPrime;
                return currPrime
            }
            return nil
        }
    }
}
extension UInt {
    var isPrime:Bool { return Prime.isPrime(self) }
    var nextPrime:UInt { return Prime.nextPrime(self) }
    var prevPrime:UInt { return Prime.prevPrime(self) }
    var primeFactors:[UInt] { return Prime.factor(self) }
}
extension Int {
    var isPrime:Bool {
        return self < 2 ? false : UInt(self).isPrime
    }
    var nextPrime:Int { return Int(UInt(self).nextPrime) }
    var prevPrime:Int { return Int(UInt(self).prevPrime) }
    var primeFactors:[Int] {
        return self < 0
            ? [-1] + UInt(-self).primeFactors.map{ Int($0) }
            : UInt(self).primeFactors.map{ Int($0) }
    }

}
extension Int {
    class Prime {}
}
extension Int.Prime : SequenceType {
    func generate()->GeneratorOf<Int> {
        var currPrime = 0
        return GeneratorOf<Int> {
            if currPrime < 9223372036854775783 {
                currPrime = currPrime.nextPrime
                return currPrime
            }
            return nil
        }
    }
}
extension Int.Prime {
    class func within(range:Range<Int>)->[Int] {
        let start = UInt(max(range.startIndex, 0))
        let end   = UInt(range.endIndex)
        return UInt.Prime.within(start..<end).map{ Int($0) }
    }
}
