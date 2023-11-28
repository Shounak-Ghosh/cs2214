Shounak Ghosh, shounak.ghosh@nyu.edu

To the best of my knowledge, I have completed the assignment. I have used the following resources: The E20 manual provided on Brightspace, and a test case from Arthur Lee.

My simulator is based on the following design decisions.

The program counter is initialized as an unsigned 16 bit integer. The registers are defined as an array of REG_SIZE (8) unsigned 16 bit integers. The memory is defined as an array of MEM_SIZE (2^13) unsigned 16 bit integers. The pc, regs, and memory are all initialized to 0. The unsigned 16 bit integer type is uint16_t, which is provided by the cstdint library  

In order to interpret E20 instructions, a while loop is continiously executed until the assembler halt directive (an immediate jump to the same address) is encountered. Upon entering the loop, the program counter is modded by MEM_SIZE, to ensure that it is within the bounds of the memory array. The instruction is then fetched from memory, and a potential opcode (the 3 MSB) is extracted via bitwise manipulation from the instruction. 

A switch statement is used to determine the relevant instruction to be executed based on the opcode. For the "000" opcode, a nested switch statement based on the immediate value is used to determine the instruction to be executed. Once the correct instruction is determined, the registers and memory are manipulated accordingly, and the program counter is updated. 

However, there are some exceptions. The $0 register is defined as immutable, so a check is used for all instructions with a destination register to ensure that if the destination register is $0, it is reset to the value 0, before continuing loop execution. 

If the program attempts to set a register to a value outside the bounds of a 16 bit unsigned integer, the value assigned will be the modulus of the value and 2^16 (overflow will occur). This also occurs for negative values, which are resultingly stored as large unsigned integers.

This results in counterintuitive behavior with regards to the slt instruction. When comparing a register storing a negative value to a register storing a positive value, the negative value will be considered greater than the positive value. This is because the negative value is stored as a large unsigned integer, and is therefore greater than the positive value.

MEM_SIZE defines the range of valid memory addresses. If the program attempts to access a memory address outside of this range, the modulo of the value and MEM_SIZE will be used to determine the memory cell accessed. However, it is possible to set the program counter outside the range of MEM_SIZE, since it is a 16 bit unsigned integer. However, as mentioned above, the program counter is modded by MEM_SIZE before each instruction is fetched, so invalid memory addresses will not be accessed.
This also means that when the last memory address is reached, the program counter will be incremented by 1 and then modded by MEM_SIZE, resulting in the program counter wrapping around to 0. 

Using a negative immediate value in lw and sw results in sign extension, and the value is stored as a large unsigned integer. This is added to the register address value, and the resulting value is used to access the memory cell, with the 3 most significant bits being ignored.

Using a negative immediate value in addi results in correct behavior, since the value is stored as a large unsigned integer. Addition is performed on the large unsigned integer, which results in overflow to the value equivalent to subtraction.

Using a negative immediate value in jeq results in sign extension, and the value is stored as a large unsigned integer. This is added to the program counter value. However, since only the 13 least significant bits are used to access memory at the very beginning of each loop, no invalid memory addresses are accessed.

If the program modifies a memory cell containing machine code, this behavior, albeit risky, is still allowed. If a memory cell which cannot be interpreted as an instruction is accessed, the program will continue indefinetly as a halt directive will never be encountered. This behavior is intentional, as it reflects a potential error in the program, rather than the E20 simulator