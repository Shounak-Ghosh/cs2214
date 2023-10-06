/*          OPCODE SRC  DST  IMMDATA */
myROM[0] = {movi, RXX, Rg0, 4'b0111};
myROM[1] = {movi,  RXX, Rg1, 4'b0010};
myROM[2] = {mov,  Rg0, Rg2, 4'b0000};
myROM[3] = {cmp,  Rg1, Rg2, 4'b0000};
myROM[4] = {jz,  RXX, Rg2, 4'b0101}; 
myROM[5] = {cmpi,  RXX, Rg2, 4'b0000};
myROM[6] = {jz,  RXX, RXX, 4'b0101}; 
myROM[7] = {addi,  RXX, Rg2, 4'b0001};
myROM[8] = {jmp,  RXX, RXX, 4'b1011}; 
myROM[9] = {movi,  RXX, Rg2, 4'b0001};
myROM[10] = {jmp,  RXX, RXX, 4'b0000};
myROM[11] = {movi,  RXX, Rg2, 4'b0000};
myROM[12] = {jmp,  RXX, RXX, 4'b0000};
myROM[13] = {jmp,  RXX, RXX, 4'b0000};
myROM[14] = {jmp,  RXX, RXX, 4'b0000};
myROM[15] = {jmp,  RXX, RXX, 4'b0000};

/*
Expected output:

Final state of register file:
    r0= 7
    r1= 2
    r2= 0
    r3= x

*/


