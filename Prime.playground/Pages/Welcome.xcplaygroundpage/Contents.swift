//: Playground - noun: a place where people can play

2.isPrime
42.isPrime
0x7FFFffff.isPrime // M31
0.nextPrime
Int.max.prevPrime
Int.max.primeFactors
(-42).primeFactors
0x01234567890abcdef.primeFactors
(0xfedeca9876543210 as UInt).primeFactors
let i32pmax0 = Int(Int32.max).prevPrime
let i32pmax1 = i32pmax0.prevPrime
(i32pmax0*i32pmax1).primeFactors
for p in Int.Prime() {
    if p > 10 { break }
    print(p)
}
UInt.Prime.within(1...100)
