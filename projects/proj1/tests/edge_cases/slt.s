ram[0] = 16'b0010000011111011;		// movi $1, -5
ram[1] = 16'b0010000100000101;		// movi $2, 5
ram[2] = 16'b0000010100110100;		// slt $3,$1,$2
ram[3] = 16'b0000100011000100;		// slt $4,$2,$1
ram[4] = 16'b0100000000000100;		// halt

// Test slt instruction with a negative and positive number
// $1 = large positive number, $2 = 5
// Expected output: $3 = 0, $4 = 1