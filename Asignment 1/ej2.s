.data
 A: .float 8.3, 4.5, 0.0
    .float -1.2, 0.0, 40000.57
 B: .word 0, 0, 0
    .word 0, 0, 0
 N: .word 2
 M: .word 3
 X: .word 10
 msg: .asciiz ", "
 msg1: .asciiz "\n"
 msg2: .asciiz "The number of exponents lower than X is: "

 .text
  .globl main
  main:
    subu $sp, $sp, 20 # Reserving storage in the stack for registers
    sw $a0, ($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $s0, 16($sp)

    la $a0, A   # Storing the initial address of the matrix with floating point numbers in a0
    lw $a1, N   # Storing the number of rows in a1
    lw $a2, M   # Storing the number of columns in a2
    la $a3, B   # Storing the initial address of the matrix with integers in a3
    lw $s0, X   # Storing X in s0

    jal ExtractExponents  # Calling the function to obtain and store the exponents
    move $a0, $v0
    li $v0, 1
    syscall

    la $a0 msg1   # To print the msg2
    li $v0, 4
    syscall

    jal Printer   # Calling the function to print the matrix B

    li $v0, 10    # Ending the program
    syscall


    ExtractExponents:
      mul $t0, $a1, $a2   # Calculating the number of memory addresses we have to go through
      li $t4, 99999   # Value to store if the exponent is greater than X
      li $t1, 0   # To go through the matrix elements
      li $t2, -127    # To be used to know if the exponent is -127
      li $t3, -126    # To store t3 in the matrix in case the exponent is -127
      li $t7, 0   # To store the number of exponents that are lower than X
      li $t5, 0x7F800000

      loop1: bge $t1, $t0, EndLoop1    # If t1 is lower than t0, then we continue in the loop
        lw $t6, ($a0)   # Storing the initial address of the matrix with floating numbers in t6
        and $t6, $t6, $t5
        srl $t6, $t6, 23    # We store in t6 the exponent
        sub $t6, $t6, 127   # Obtaining only the important part

        blt $t6, $s0, Giver   # If t6<=s0 then the program goes to Giver
        sw $t4, ($a3)   # As the exponent is higher than X, we store 99999
        b Updater   # To update the control variables

        Giver:
          beq $t6, $t2, Storer    # If t6 is different from t2, then we store the default exponent
            sw $t6, ($a3)   # Storing the exponent on the stack
            addi $t7, $t7, 1    # Adding 1 to the counter of exponentrs that are lower than X
          b Updater

          Storer:   # If the exponent is the exponent is -127, then we store -126
            sw $t3, ($a3)
          b Updater

        Updater:
          addi $a0, $a0, 4    # We are going to the next address
          addi $a3, $a3, 4
          addi $t1, $t1, 1    # Adding 1 to the counter, we are in the next element
          b loop1   # Going up to the start of the loop

      EndLoop1:    # The end of the loop
        la $a0 msg2   # To print the msg2
        li $v0, 4
        syscall
        move $v0, $t7   # Storing the number of exponents lower than X
        jr $ra

      Printer:
        li $t1, 0   # Reinicialicing the counter to go through the matrix
        li $t2, 1   # Counter to print the ","
        la $t6, B   # Storing the initial address of the matrix with integer in t6
        li $t3, 1

        loop2: bge $t1, $t0, EndLoop2
          lw $a0, ($t6)   # Storing the first element of the matrix B in a0
          li $v0, 1   # To print integers
          syscall

          bge $t2, $t0, EndLoop2
          la $a0 msg    # To print the ","
          li $v0, 4
          syscall

          bne $t3, 3, Updater2   # Every 3 positions a \n is inserted
            li $t3, 0   # Reinicialicing the counter to 0
            la $a0 msg1    # To print the "\n"
            li $v0, 4
            syscall
          b Updater2

          Updater2:
            addi $t3, $t3, 1    # Adding 1 to t3 so when it raises 3 we print a "\n"
            addi $t6, $t6, 4    # Going to the next memory address
            addi $t1, $t1, 1    # Updating the counter
            addi $t2, $t2, 1    # Updating the counter
            b loop2   # Going up to the start of the loop

      EndLoop2:   # The end of the loop
        jr $ra
