ram[0] = 16'b0010000010001010;		// movi $1, 10
ram[1] = 16'b0010010101111001;		// addi $2,$1,-7
ram[2] = 16'b0100000000000010;		// halt

// Check the addi instruction with a negative immediate value
// $1 = 10, $2 = 3