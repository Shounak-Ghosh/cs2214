TODO create test cases for these scenarios: (Check vea documentation)

- What are the initial values of the registers, the program counter, and the memory cells?
    - 0 for all
-  What should happen if a program sets a register to a value outside of the range expressible as a
16-bit unsigned number? Consider both positive and negative numbers that cannot be expressed
in 16 bits.
    -  The register should wrap around to account for the overflow.
- What should happen if a program tries to change the value of $0?
    -  Reset to 0 at the end of each instruction
- What should happen if a program uses slt to compare a negative number to a positive number?
    -  The slt comparision is unsigned, so the negative number will be treated as a large positive number
-  What range of memory address are valid? What should happen if a program tries to read or write
a memory cell whose address is outside of the range of valid addresses?
    -  13 bit memory addresses   
-  What should happen if a program sets the program counter to a value outside of the range of
valid addresses?
    - the program counter should wrap around to the correct value
- What should happen if a program uses a negative immediate value in addi or jeq?
    -  Addi, subtraction should occur, jeq: TODO
-  What should happen if a program uses a negative immediate value in lw or sw?
    - lw: TODO, sw: TODO
-  What should happen if a program modifies a memory cell containing machine code?
    - While this behavior is risky, it should be allowed. If a crash occurs, so be it.
-  What should happen if the program counter reaches the address of the last memory cell?
    -  The program should either halt or wrap around to pc = 0 
-  When should your simulator stop ?
    - When a halt instruction is reached