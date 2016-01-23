//: Playground - noun: a place where people can play

2.isPrime
42.isPrime
0x7FFFffff.isPrime // M31
0.nextPrime
Int.max.prevPrime
Int.max.primeFactors
(-42).primeFactors
0x01234567890abcdef.primeFactors
3_369_738_766_071_892_021.primeFactors
1111111111111111.primeFactors
4611686018427387821.primeFactors
for p in UInt.Prime() {
    if p > 10 { break }
    print(p)
}
(0xfedeca9876543210 as UInt).primeFactors
UInt.Prime.within(1...100)
let bigu = (UInt(UInt32.max).prevPrime * UInt(UInt32.max).prevPrime.prevPrime)

