#5
def toggleBit2(x):
    return x ^ 2

print(toggleBit2(90),toggleBit2(45))

#6
def flipOffBit5(x):
    return x & ~(1 << 4)

print(flipOffBit5(90),flipOffBit5(45))

#7
def repeatBitsThrice(x):
    return (x & 7) << 6 | (x & 7) << 3 | (x & 7)

print(repeatBitsThrice(5))

#8
def detectBitPattern(x):
    print(bin((x & 15 << 5) >> 5))
    return (x & 15 << 5) >> 5 == 9 | (x & 15 << 5) >> 5 == 13


print(detectBitPattern(943),detectBitPattern(47))

