//
//  main.swift
//  prime
//
//  Created by Dan Kogai on 8/6/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
let test = TAP()
test.eq(2.isPrime, true, "2 is prime")
test.eq(42.isPrime, false, "42 is not prime")
test.eq(0x7FFFffff.isPrime, true, "\(0x7FFFffff) is prime")
test.eq(UInt.max.isPrime, false, "\(UInt.max) is prime")
test.eq(0.nextPrime, 2, "0.nextPrime is 2")
test.eq(Int.max.prevPrime, 9223372036854775783, "\(Int.max).prevPrime is 9223372036854775783")
test.ok(Int.max.primeFactors == [7, 7, 73, 127, 337, 92737, 649657], "\(Int.max).primeFactors")
test.done()
/*
//for p in Int.Prime() {
//    if p > 10 { break }
//    println(p)
//}
Int.Prime.within(0..<100)               => say
Int.Prime.within(Int.max-100..<Int.max) => say
//// factors
func printFactors(n:Int){print("\(n):\(n.primeFactors)")}
(UInt.max, UInt.max.primeFactors)  => say
-42 => printFactors
Int.max                            => printFactors
UInt.ipow(2,63).primeFactors.count => say
Int.Prime.within(2...47).reduce(1,combine: *)    => printFactors
0x0123456789abcdef              => printFactors
let u = (0xfedeca9876543210 as UInt)
(u, u.primeFactors)             => say
1111111111111111                => printFactors
let mp32 = 0x7fffFFFF.prevPrime
mp32 * mp32.prevPrime       => printFactors
3_369_738_766_071_892_021   => printFactors
4611686018427387821  => printFactors
//// for developer
func checkRange(r:Range<UInt>) {
    let gauge = UInt(r.endIndex - r.startIndex) / 256;
    print("Checking \(r)")
    for i in r {
        let fs = i.primeFactors
        if (fs.reduce(1,combine: *) != i) {
            print("!!\(i):\(fs).reduce(1,*) != \(i)")
        }
        if fs[0] == 1 { print("\(i) => \(fs)") }
        if i % gauge == 0 { print(".", terminator: "") }
    }
    print("Done.")
}
*/
//checkRange(0x00000002...0x0000FFFF)
//checkRange(0x7fff0000...0x7fffFFFF)
//checkRange(0xffff0000...0xffffFFFF)
//checkRange(0x7FFFffffFFFF0000...0x7FFFffffFFFFffff)
