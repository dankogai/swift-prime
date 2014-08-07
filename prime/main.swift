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
UInt.ipow(2,63).primeFactors.count => println
UInt.max.primeFactors   => println
Int.max.primeFactors    => println
0x0123456789abcdef.primeFactors => println
(0xfedeca9876543210 as UInt).primeFactors   => println
11111111111111111.primeFactors => println
(UInt(65521*65537)*UInt(65521*65537)).primeFactors => println
// The follwing is commented out because they take seconds
//(2147483629*2147483629).primeFactors => println
//(2147483629*2147483629.prevPrime).primeFactors => println
//3_369_738_766_071_892_021.primeFactors => println
