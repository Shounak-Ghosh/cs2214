# mul.s //TODO update the code so that it doesnt use nested loops
# We use an incrementing bitmask on the multiplicand to create a number of smaller products which sum to the final product.
# The smaller products consist of the bitmask times the multiplier. 
# Due to the nature of the bitmask, these smaller products can be percieved as left-shifted versions of the multiplier.
# The smaller products are created by doubling the multiplier and the bitmask until the bitmask overflows.
# The smaller products are summed to the final product by adding the smaller product to the final product if the bitmask bit is 1.

movi $1, 0				        # store 0 in $1. $1 will hold the final product.
lw $2, multiplicand($0)	        # store multiplicand in $2.
movi $3, 1				        # store 1 into $3. $3 will be used as a bitmask for the multiplier.
main_loop:
	movi $4, 1			        # store 1 in $4. This will be used as a check against the current bit. 
	lw $5, multiplier($0)		# store multiplicand in $5
	jeq $3, $0, end			    # end if $3 and $0 are equal (which will only happen if the bitmask overflows)
	and $6, $2, $3			    # store the current bit in $6
	add $3, $3, $3			    # shift the bitmask left
	j sub_loop			        # jump to the sub_loop
sub_loop:                       # multiply $5 and $6. 
	jeq $6, $4, sum			    # jump to the final sum operations if $6 and $4 are the same
	add $4, $4, $4			    # double $4.
	add $5, $5, $5			    # double $5. 
	j sub_loop 			        # reiterate the sub_loop
sum:
	add $1, $1, $5			    # adds the sum in $5 to $1, our final product
	j main_loop			        # jump back to main_loop to find the next bit in n
end:
	halt				        # stop program execution
multiplicand: .fill 123			# the multiplicand (123)
multiplier: .fill 119			# the multiplier (119)

# MACHINE CODE
# ram[0] = 16'b0010000010000000;		// movi $1, 0
# ram[1] = 16'b1000000100010000;		// lw $2,multiplicand($0)
# ram[2] = 16'b0010000110000001;		// movi $3, 1
# ram[3]= 16'b0010001000000001;		// main_loop: movi $4, 1
# ram[4] = 16'b1000001010010001;		// lw $5,multiplier($0)
# ram[5] = 16'b1100110000001001;		// jeq $3,$0,end
# ram[6] = 16'b0000100111100011;		// and $6,$2,$3
# ram[7] = 16'b0000110110110000;		// add $3,$3,$3
# ram[8] = 16'b0100000000001001;		// j sub_loop
# ram[9] = 16'b1101101000000011;		// sub_loop: jeq $6,$4,sum
# ram[10] = 16'b0001001001000000;		// add $4,$4,$4
# ram[11] = 16'b0001011011010000;		// add $5,$5,$5
# ram[12] = 16'b0100000000001001;		// j sub_loop
# ram[13] = 16'b0000011010010000;		// sum: add $1,$1,$5
# ram[14] = 16'b0100000000000011;		// j main_loop
# ram[15] = 16'b0100000000001111;		// end: halt
# ram[16] = 16'b0000000001111011;		// multiplicand: .fill 123
# ram[17] = 16'b0000000001110111;		// multiplier: .fill 119


# Final state:
# 	pc=   15
#	$0=    0
#	$1=14637
#	$2=  123
#	$3=    0
#	$4=    1
#	$5=  119
#	$6=    0
#	$7=    0