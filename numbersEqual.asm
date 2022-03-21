.data
	lecture: .asciiz "Entrez deux nombres: \n"
	egaux: .asciiz "Les nombres sont égaux.\n"
	diff: .asciiz "Les nombres sont différents.\n"
.text
	li $v0, 4 #syscall: print string
	la $a0, lecture
	syscall
	
	li $v0, 5 # Add syscode value to read an integer
	syscall # Reads 1st integer (puts it in $v0)
	move $t0, $v0 # Moves $v0 content into $t0's
	
	li $v0, 5 # Add syscode value again to read the second integer
	syscall # Reads 2nd integer (puts it in $v0)
	
	# Here, $t0 has 1st input and $v0 has 2nd input
	
	bne $t0, $v0, Sinon # On part au label "Sinon" si $t0 != $v0
	la $a0, egaux # Le msg nombre égaux stored dans $a0 (registre lu lors du print string syscode 4)
	beq $0, $0, FinSi
Sinon:
	la $a0, diff
FinSi:
	li $v0, 4 # Add syscode value to print a string
	syscall
	li $v0, 10 #Add syscode value to exit program
	syscall
## END ##