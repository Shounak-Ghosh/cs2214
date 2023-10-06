/*          OPCODE SRC  DST  IMMDATA */
// myROM[0] = {movi, RXX, Rg0, 4'b0001};
// myROM[1] = {movi,  RXX, Rg1, 4'b0010};
// myROM[2] = {cmp,  Rg0, Rg1, 4'b0000};
// myROM[3] = {jz,  RXX, RXX, 4'b1000};
// myROM[4] = {subi, RXX, Rg0, 4'b0001};
// myROM[5] = {subi, RXX, Rg1, 4'b0001};
// myROM[6] = {cmpi,  RXX, Rg0, 4'b0000};
// myROM[7] = {jz,  RXX, RXX, 4'b0100};
// myROM[8] = {cmpi,  RXX, Rg1, 4'b0000};
// myROM[9] = {jz,  RXX, RXX, 4'b0100};
// myROM[10] = {jmp,  RXX, RXX, 4'b1010};
// myROM[11] = {movi,  RXX, Rg2, 4'b0001};
// myROM[12] = {jmp,  RXX, RXX, 4'b0000};
// myROM[13] = {movi,  RXX, Rg2, 4'b0000};
// myROM[14] = {jmp,  RXX, RXX, 4'b0000};
// myROM[15] = {jmp,  RXX, RXX, 4'b0000};


myROM[0] = {movi, RXX, Rg0, 4'b0010};
myROM[1] = {movi,  RXX, Rg1, 4'b0111};
myROM[2] = {mov,  Rg0, Rg2, 4'b0000};
myROM[3] = {cmp,  Rg1, Rg2, 4'b0000};
myROM[4] = {jz,  RXX, Rg2, 4'b0011}; 
myROM[5] = {cmpi,  RXX, Rg2, 4'b0000};
myROM[6] = {jz,  RXX, RXX, 4'b0011}; 
myROM[7] = {addi,  RXX, Rg2, 4'b0001};
myROM[8] = {jmp,  RXX, RXX, 4'b1011}; 
myROM[9] = {movi,  RXX, Rg2, 4'b0000};
myROM[10] = {jmp,  RXX, RXX, 4'b0000};
myROM[11] = {movi,  RXX, Rg2, 4'b0001};
myROM[12] = {jmp,  RXX, RXX, 4'b0000};
myROM[13] = {jmp,  RXX, RXX, 4'b0000};
myROM[14] = {jmp,  RXX, RXX, 4'b0000};
myROM[15] = {jmp,  RXX, RXX, 4'b0000};

// TODO Rearrange to compare first before first subtraction
/*
{movi, RXX, Rg0, 4'b0111};
{movi,  RXX, Rg1, 4'b0010};
{cmp,  Rg0, Rg1, 4'b0000};
{jz,  RXX, RXX, 4'b1000};
{subi, RXX, Rg0, 4'b0001};
{subi, RXX, Rg1, 4'b0001};
{cmpi,  RXX, Rg0, 4'b0000};
{jz,  RXX, RXX, 4'b0100};
{cmpi,  RXX, Rg1, 4'b0000};
{jz,  RXX, RXX, 4'b0100};
{jmp,  RXX, RXX, 4'b1010};
{movi,  RXX, Rg2, 4'b0001};
{jmp,  RXX, RXX, 4'b0000};
{movi,  RXX, Rg2, 4'b0000};
{jmp,  RXX, RXX, 4'b0000};
{jmp,  RXX, RXX, 4'b0000};


*/

/*
Expected output:

Final state of register file:
    r0= 7
    r1= 2
    r2= 0
    r3= x

*/
