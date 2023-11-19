/*          OPCODE SRC  DST  IMMDATA */
myROM[0] = {movi, RXX, Rg2, 4'b0110};
myROM[1] = {movi, RXX, Rg1, 4'b0001};
myROM[2] = {add,  Rg1, Rg2, 4'b0000};
myROM[3] = {cmpi, RXX, Rg2, 4'b0111}; // compare rg2 to 7, zflag = 0 (rg2 != 7), zflag = 1 (rg2 == 7)
myROM[4] = {jnz,  RXX, RXX, 4'b1110};
myROM[5] = {jmp,  RXX, RXX, 4'b0000};
myROM[6] = {jmp,  RXX, RXX, 4'b0000};
myROM[7] = {jmp,  RXX, RXX, 4'b0000};
myROM[8] = {jmp,  RXX, RXX, 4'b0000};
myROM[9] = {jmp,  RXX, RXX, 4'b0000};
myROM[10] = {jmp,  RXX, RXX, 4'b0000};
myROM[11] = {jmp,  RXX, RXX, 4'b0000};
myROM[12] = {jmp,  RXX, RXX, 4'b0000};
myROM[13] = {jmp,  RXX, RXX, 4'b0000};
myROM[14] = {jmp,  RXX, RXX, 4'b0000};
myROM[15] = {jmp,  RXX, RXX, 4'b0000};

/*

Final state of register file:
	r0= x
	r1= 1
	r2= 7
	r3= x

*/