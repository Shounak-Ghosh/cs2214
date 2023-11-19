main:
    movi $2, 1      # used to get the next link after head
    lw $3, head($0) # load the first value in the linked list
    lw $4, head($2) # load the next link in the linked list
    add $1, $1, $3  # add the current value to the sum register
    jeq $4, $0, end # if the next link is 0, we are at the end of the list
    j next          # otherwise, go to the next link
next:
    lw $3, 0($4)    # load the next value in the linked list
    add $1, $1, $3  # add the current value to the sum register
    lw $4, 1($4)    # load the next link in the linked list
    jeq $4, $0, end # if the next link is 0, we are at the end of the list
    j next          # otherwise, go to the next link
end:
    halt
chain4:
    .fill 100
    .fill chain5
    .fill 300
chain7:
    .fill 16384
    .fill 909
    .fill 0
chain1:
    .fill 23
    .fill chain2
head: # beginning of linked list
    .fill 34
    .fill chain1
    .fill 82
    .fill 10
chain3:
    .fill 4
    .fill chain4
    .fill 229
    .fill 449
chain2:
    .fill 0
    .fill chain3
chain5:
    .fill 12
    .fill 0    # end of linked list
    .fill 9999
chain6:
    .fill 99
    .fill 49