/*          OPCODE SRC  DST  IMMDATA */
myROM[0]  = {movi, RXX, Rg1, 4'b1010};
myROM[1]  = {movi, RXX, Rg2, 4'b1111};
myROM[2]  = {cmp,  Rg1, Rg2, 4'b0000};
myROM[3]  = {jnz,  RXX, RXX, 4'b0010};
myROM[4]  = {jmp,  RXX, RXX, 4'b0000};
myROM[5]  = {movi, RXX, Rg3, 4'b0001};
myROM[6]  = {jmp,  RXX, RXX, 4'b0000};
myROM[7]  = {jmp,  RXX, RXX, 4'b0000};
myROM[8]  = {jmp,  RXX, RXX, 4'b0000};
myROM[9]  = {jmp,  RXX, RXX, 4'b0000};
myROM[10] = {jmp,  RXX, RXX, 4'b0000};
myROM[11] = {jmp,  RXX, RXX, 4'b0000};
myROM[12] = {jmp,  RXX, RXX, 4'b0000};
myROM[13] = {jmp,  RXX, RXX, 4'b0000};
myROM[14] = {jmp,  RXX, RXX, 4'b0000};
myROM[15] = {jmp,  RXX, RXX, 4'b0000};

/*
Final state of register file:
	r0= x
	r1=10
	r2=15
	r3= 1
*/