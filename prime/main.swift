//
//  main.swift
//  prime
//
//  Created by Dan Kogai on 8/6/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//

println(2.isPrime)
println(42.isPrime)
println(0x7FFFffff.isPrime)
println(0.nextPrime)
println(Int.max.prevPrime)
for p in Int.Prime() {
    if p > 10 { break }
    println(p)
}
println(Int.Prime.within(0..<100))
println(Int.Prime.within(Int.max-100..<Int.max))