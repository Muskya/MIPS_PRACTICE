.text 
	lui $sp, 0x7FFF # $sp == 0x7FFF'EFFC
	ori $sp, $sp, 0xEFFC # stack pointer starting address
	
	addi $a0, $a0, 3 # $a0 == parameter n in C/C++ == 3
	jal fact # $ra == "add $a0, $0, $v0" line 6's address 
	add $a0, $0, $v0 # store fact's $v0 returned value into $a0
	
	addi $v0, $0, 1 # print integer syscall
	syscall # $a0 content printed
	addi $v0, $0, 10 # terminate program execution syscall
	syscall # terminate run
fact:
	bne $a0, $0, factSuite # $ra doesn't change on branch statements
	addi $v0, $0, 1 # if (n==0) return 1
	jr $ra
factSuite: # éq. du else de fact()
	sw $a0, 0($sp) # stores $a0 in first $sp address (3)
	sw $ra, -4($sp) # $ra is still line 6's address
	addi $sp, $sp, -8 # decreases $sp pointing location by 8 bytes (2 words, $a0 and $ra)
	addi $a0, $a0, -1 # decrement $a0 (every new recursive call)
	jal fact 
	addi $sp, $sp, 8 # be go down the stack by 8 bytes
	lw $a0, 0($sp) # fetches value
	lw $ra, -4($sp) # fetches value
	mult $a0, $v0 # $LO <- $a0 * $v0
	mflo $v0 # $v0 <- $LO
	jr $ra # jumps back to main return address since we took $ra from the -4($sp) address of the 
			# first $ra we inserted in the stack
