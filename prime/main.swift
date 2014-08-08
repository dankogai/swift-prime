//
//  main.swift
//  prime
//
//  Created by Dan Kogai on 8/6/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
infix operator => { associativity left precedence 95 }
func => <A,R> (lhs:A, rhs:A->R)->R {
    return rhs(lhs)
}

2.isPrime           => println
42.isPrime          => println
0x7FFFffff.isPrime  => println
0.nextPrime         => println
Int.max.prevPrime   => println
for p in Int.Prime() {
    if p > 10 { break }
    println(p)
}
Int.Prime.within(0..<100)               => println
Int.Prime.within(Int.max-100..<Int.max) => println
func printFactors(n:Int){println("\(n):\(n.primeFactors)")}
(UInt.max, UInt.max.primeFactors)  => println
-42 => printFactors
Int.max                            => printFactors
UInt.ipow(2,63).primeFactors.count => println
Int.Prime.within(2...47).reduce(1,*)    => printFactors
0x0123456789abcdef              => printFactors
let u = (0xfedeca9876543210 as UInt)
(u, u.primeFactors)             => println
1111111111111111                => printFactors
let mp32 = 0x7fffFFFF.prevPrime
mp32 * mp32.prevPrime       => printFactors
//3_369_738_766_071_892_021   => printFactors
//4611686018427387821  => printFactors
func checkRange(r:Range<Int>) {
    println("Checking \(r)...")
    for i in r {
        let fs = i.primeFactors
        if (fs.reduce(1,*) != i) {
            println("!!\(i):\(fs).reduce(1,*) != \(i)")
        }
        if fs[0] == 1 { i => printFactors }
    }
}
checkRange(0x00000002...0x0000FFFF)
checkRange(0x7fff0000...0x7fffFFFF)
checkRange(0xffff0000...0xffffFFFF)
// checkRange(0xFFFFffff0000...0xFFFFffffFFFF)

