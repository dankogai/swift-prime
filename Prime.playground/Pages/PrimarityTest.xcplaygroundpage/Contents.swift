//: [Previous](@previous)
/*:
## Inside prime.swift : Primarity Test 

Pretty simple and fast.  Deterministic up to `UInt.max`

0. Simple trial division up to 7.
0. [Miller-Rabin] Test on bases up to nth primes in [A014233].

[Miller-Rabin]: https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test
[A014233]: https://oeis.org/A014233

The following code illustrates how `3825123056546413051.isPrime` becomes `false`.

*/

UInt.Prime.millerRabinTest(3825123056546413051, base: 2)
UInt.Prime.millerRabinTest(3825123056546413051, base: 3)
UInt.Prime.millerRabinTest(3825123056546413051, base: 5)
UInt.Prime.millerRabinTest(3825123056546413051, base: 7)
UInt.Prime.millerRabinTest(3825123056546413051, base: 11)
UInt.Prime.millerRabinTest(3825123056546413051, base: 13)
UInt.Prime.millerRabinTest(3825123056546413051, base: 17)
UInt.Prime.millerRabinTest(3825123056546413051, base: 19)
UInt.Prime.millerRabinTest(3825123056546413051, base: 23)
UInt.Prime.millerRabinTest(3825123056546413051, base: 29)
UInt.Prime.millerRabinTest(3825123056546413051, base: 31)
UInt.Prime.millerRabinTest(3825123056546413051, base: 37)

//: [Next](@next)
