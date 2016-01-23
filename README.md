swift-prime
===========

Prime number in Swift

SYNOPSIS
--------

````swift
2.isPrime                               // true
42.isPrime                              // false
0x7FFFffff.isPrime                      // true (M31)
0.nextPrime                             // 2
Int.max.prevPrime                       // 9223372036854775783 on OS X
Int.Prime.within(0..<100)               // [2, 3, 5, 7, ... 97]
Int.Prime.within(Int.max-100..<Int.max) // [9223372036854775783]
Int.max.primeFactors                    // [7, 7, 73, 127, 337, 92737, 649657]
````

TODO
----

Make it pure-swift.  For now it uses C for 128-bit arithmetics.
