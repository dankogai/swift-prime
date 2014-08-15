swift-prime
===========

Prime number in Swift

SYNOPSIS
--------

````swift
println(2.isPrime)                                // true
println(42.isPrime)                               // false
println(0x7FFFffff.isPrime)                       // true (M31)
println(0.nextPrime)                              // 2
println(Int.max.prevPrime)                        // 9223372036854775783 on OS X
println(Int.Prime.within(0..<100))                // [2, 3, 5, 7, ... 97]
println(Int.Prime.within(Int.max-100..<Int.max))  // [9223372036854775783]
println(Int.max.primeFactors)                     // [7, 7, 73, 127, 337, 92737, 649657]
````
