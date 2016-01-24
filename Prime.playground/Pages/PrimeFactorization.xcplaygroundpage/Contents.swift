//: [Previous](@previous)

/*:
## Inside prime.swift : Prime Factorization

Prime factorization is much harder than primarity test.  prime.swift does so as follows.

0. Simple trial division up for `UInt.Prime.tinyPrimes` -- primes less than 2048
0. [Pollard's rho] up to `sqrt(UInt32.max)`
0. [SQUFOF] as a last resort.

[Pollard's rho]: https://en.wikipedia.org/wiki/Pollard%27s_rho_algorithm
[SQUFOF]: http://en.wikipedia.org/wiki/Shanks'_square_forms_factorization

Because [SQUFOF] is naively implemented within 64-bit signed integer limit (for the time being), it is good only up to `Int.max`.  Numbers like multiples of primes near `UInt32.max` fails to factor.

In such cases, `.primeFactors` prepend `1` to the result so the axiom:

    n.primeFactor.reduce(1,combine:*) == n

still holds.
*/

// this one factors nicely.
let i32pmax0  = Int(Int32.max).prevPrime
let i32pmax1  = i32pmax0.prevPrime
(i32pmax1*i32pmax0).primeFactors

// this one does not.
let u32pmax0  = UInt(UInt32.max).prevPrime
let u32pmax1  = u32pmax0.prevPrime
(u32pmax1*u32pmax0).primeFactors

/*:

Since prime.swift only covers 64-bit integers and `UInt` is rarely used in Swift, this should be good enough.  To go beyound that we need BigInt support to begin with...

*/

//: [Next](@next)
