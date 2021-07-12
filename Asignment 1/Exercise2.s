.data
	A: .float , 0.000000000000000000000000000000000000001, 3402823466000000000000000000.0
		.float 0.000000000000000000000000000000000000001754, 0.000000000000000000000000000000000000000000001
	B: .word 0, 0, 
		.word	0, 0, 
	N: .word 2
	M: .word 2
	X: .word 10
	msg1: .asciiz "\n"
	msg2: .asciiz ", "
.text
	.globl main
	main:
			subu $sp $sp 36
			sw $a0   ($sp)
			sw $a1  4($sp)
			sw $a2  8($sp)
			sw $a3 12($sp)
			sw $s0 16($sp)
			sw $ra 20($sp)
			sw $s1 24($sp)
			sw $s2 28($sp)
			sw $s3 32($sp)
			
			
			la $a0, A
			lw $a1, N
			lw $a2, M
			la $a3, B
			lw $s0, X
			
			subu $sp, $sp, 4 #stack
			sw $s0 ($sp)
	
			jal extractExponents #call the function
			li $s1, 0 #i
		loop3: bge $s1, $a1, end3 #loop to print the matrix
			li $s2, 0 #j
		loop4: bge $s2, $a2, end4
			li $s3,0
			mul $s3, $s1, $a2 #Get the address of the element B[i][j]
			add $s3, $s3, $s2
			mul $s3, $s3, 4
			add $s3, $s3, $a3
			lw $a0 ($s3) #store what is inside that element in the register $a0 in order to print it

			li $v0, 1 #Syscall instruction to print integers
			syscall
			
			la $a0 msg2
			li $v0, 4
			syscall
			
			addi $s2,$s2, 1 #Increase j 
			b loop4
		end4: #finish the second loop
			la $a0 msg1
			li $v0, 4
			syscall
			addi $s1,$s1, 1 #increase i
			b loop3
		end3: #finish the first loop
		
			
			
			lw $a0   ($sp)
			lw $a1  4($sp)
			lw $a2  8($sp)
			lw $a3 12($sp)
			lw $s0 16($sp)
			lw $ra 20($sp)
			lw $s1 24($sp)
			lw $s2 28($sp)
			lw $s3 32($sp)
			addu $sp $sp 36
			

			
			jr $ra #finish the main 
			
			
	
	
	
	extractExponents: 
	        lw $t8 ($sp)
			addu $sp $sp 4
			
			li $t0 0 #i
	
	
		loop1: bge $t0, $a1, end1 #enter on the matrix (rows)
			li $t1, 0 #j
		loop2: bge $t1, $a2, end2 #enter on the matrix (columns)
			mul $t2, $t0, $a2 #Get the address of the element we want
			add $t2, $t2, $t1
			mul $t2, $t2, 4
			add $t2, $t2, $a0
			lw $t6 ($t2) #Store into a float register the value of the address we got
	
			
			mul $t3, $t0, $a2 #B[i][j]
			add $t3, $t3, $t1
			mul $t3, $t3, 4
			add $t3, $t3, $a3
	
			#get the exponent of the float number
			li $t4 0x7F800000
 
			and $t4, $t4, $t6
			srl $t4, $t4, 23 #register t4 is the exponent of the float number
			sub $t4, $t4, 127 #substract the excess of 127

		
		if: blt $t4, $t8, then
			li $t5 , 99999
			sw $t5 ($t3) #stores the value of 99999 in the position B[i][j]
			
		b end5
		then: 
			sw $t4 ($t3) #storing the exponent into the matrix B[i][j]
		end5: 
			addi $t1, $t1, 1 #increases the value of j
			b loop2 #Go back to loop2
		end2:  #end the second loop2
			addi $t0, $t0, 1 #increases the value of i
			b loop1 #Go back to loop1
		end1: #end the loop1
			jr $ra #return to end the function
	
	
	
	