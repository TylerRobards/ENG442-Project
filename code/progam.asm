main:
    addi x1, x0, 5 # x1 = 5
    addi x2, x0, 10 # x2 = 10

    add  x3, x1, x2 # x3 = 15
    sub  x4, x2, x1 # x4 = 5

    sw   x3, 0(x0 # memory[0] = 15
    lw   x5, 0(x0 # x5 = 15

    beq  x3, x5, equal # should branch
    addi x6, x0, 99 # should be skipped

equal:
    addi x6, x0, 1 # x6 = 1

    jal  x7, jump_target # jump and store return address in x7
    addi x8, x0, 99 # should be skipped

jump_target:
    addi x8, x0, 2 # x8 = 2

done:
    beq x0, x0, done # infinite loop
