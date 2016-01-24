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
test.eq(Int.max.primeFactors, [7,7,73,127,337,92737,649657], "Int.max.primeFactors")
let two63 = [UInt](count:63, repeatedValue:2)
let i32max = UInt(Int32.max)
let i32pmax0  = UInt(Int32.max).prevPrime
let i32pmax1  = i32pmax0.prevPrime
let composites:[UInt:[UInt]] = [
    two63.reduce(1,combine:*) : two63,
    i32max*i32max       : [i32max, i32max],
    i32pmax0*i32pmax1   : [i32pmax1, i32pmax0],
    11111111111111111   : [2071723, 5363222357],
    614889782588491410  : [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47],
    3369738766071892021 : [204518747, 16476429743],
    // 10023859281455311421:[1308520867, 7660450463]
]
for (k, v) in composites {
    test.eq(k.primeFactors, v, "\(k).primeFactor == \(v)")
}
let u32pmax0  = UInt(UInt32.max).prevPrime
let u32pmax1  = u32pmax0.prevPrime
test.ok( (u32pmax0*u32pmax1).primeFactors.contains(1), "\(u32pmax0)*\(u32pmax1) is too large")
test.done()
