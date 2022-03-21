forDigit: # digit hexadecimal -> caractere
	# $a0 == le digit hexa saisi. $v0 == le caractere de sortie (sa valeur hexa (ascii table))
	addi $v0, $a0, -9 # $v0 <- $a0 (le digit hexa saisi) - 9 
	blez $v0,forDigitFin # si $v0 <= 0, go to forDigitFin ((cas où digit >= '0' et <= '9'))
	addi $v0,$v0,7 # sinon $v0 <- $v0 + 7
forDigitFin:
	addi $v0, $v0, 0x39 # ajoute 0x39 pour retomber sur le bon caractère (ex: 0x43 == 'C')
	jr $ra	

digit: # caractère -> digit hexadecimal (decimal en MIPS) (sens inverse du forDigit)
	addi $v0, $a0, -0x39
	blez $v0, digitFin
	addi $v0, $v0, -7
digitFin:
	addi $v0, $v0, 9
	jr $ra

toHexString: # nombre non signe -> chaîne caracteres hexa
# $a0 : nombre non signe 
# $a1 : adresse du tableau de caractères tabRes
	sw $a0,0($sp) # Sauvegarde de l'état des variables dans le stack avant traitements
	sw $a1,-4($sp)
	sw $ra,-8($sp)
	sw $t0,-12($sp)
	sw $t1,-16($sp)	
	sw $v0,-20($sp)	
	addi $sp,$sp,-24 # Fin sauvegarde de l'état
	
	# Début des traitements
	add $t0, $0, $a0
	addi $t1, $0, 8 # indice de boucle
toHexStringBoucle:
	srl $a0, $t0, 28
	sll $t0, $t0, 4
	jal forDigit
	sb $v0, 0($a1)
	addi $a1, $a1, 1 # on avance d'un octet dans tabRes
	addi $t1, $t1, -1 # décrément indice de boucle
	bne $t1, $0, toHexStringBoucle # boucle tant que $t1 != 0
	sb $0, 0($a1) # null-terminating byte à la fin du tableau de caractères
	# Fin des traitements
	
	addi $sp,$sp,24 # Récupération de l'état des variables pre-traitements
	lw $a0,0($sp)
	lw $a1,-4($sp)	
	lw $ra,-8($sp)
	lw $t0,-12($sp)
	lw $t1,-16($sp)	
	lw $v0,-20($sp)	# Fin récupération de l'état
	
	jr $ra # Retour à l'appelant de cette fonction
	
toBinaryString: # nombre non signe -> chaîne bits 0/1
# $a0 : entier non signe
# $a1 :adresse chaine de caractere 
	sw $a0,0($sp)
	sw $a1,-4($sp)	
	sw $t0,-8($sp)
	sw $t1,-12($sp)	
	addi $sp,$sp,-16
	
	addi $t0, $0, 32
toBinaryStringBoucle:
	srl $t1, $a0, 31
	sll $a0, $a0, 1
	addi $t1, $t1, '0'
	sb $t1, 0($a1)
	addi $a1, $a1, 1
	addi $t0, $t0, -1
	bne $t0, $0, toBinaryStringBoucle
	sb $0, 0($a1) # null-terminating byte
	
	addi $sp,$sp,16
	lw $a0,0($sp)
	lw $a1,-4($sp)	
	lw $t0,-8($sp)
	lw $t1,-12($sp)	
	jr $ra

toUnsignedString: # nombre non signe dans une base X -> chaine caracteres decimaux
# $a0 : nbre entier non signe 
# $a1: adresse du chaine de caractÃ¨res 
# $a2: base valide  
	sw $a0,0($sp)
	sw $a1,-4($sp)
	sw $ra,-8($sp)
	sw $v0,-12($sp)	
	addi $sp,$sp,-16	
	
toUnsignedStringBoucle1: # First loop calculates the number of characters 
	# to use in the character array (dividing by the base and incrementing $a1)
	divu $a0, $a2
	mflo $a0 # hi = remainder, lo = quotient
	addi $a1, $a1, 1
	bne $a0, $0, toUnsignedStringBoucle1
	sb $0, 0($a1) # null-terminating byte)
	lw $a0, 16($sp) # gets $a0 from stack before using it with forDigit function call
toUnsignedStringBoucle2:
	addi $a1, $a1, -1
	divu $a0, $a2 # divide number by the base
	mfhi $a0 # moves HI into $a0 (hi contains the division remainder)
	jal forDigit # calls forDigit with the remainer we just put into $a0
	# and forDigit will return the char equivalent into $v0
	sb $v0, 0($a1) # stores the char equivalent in our char array
	mflo $a0
	bne $a0, $0, toUnsignedStringBoucle2 # loops until $a0 is empty 
	# and initial number has been fully converted into a string (into the char array)
	
	addi $sp,$sp,16			
	lw $a0,0($sp)
	lw $a1,-4($sp)
	lw $ra,-8($sp)
	lw $v0,-12($sp)	
	jr $ra

	
parseUnsigned: # chaine caracteres hexa -> nombre non signe
# $a1 : adresse chaine de caracteres valide
# $a2 : base valide 
# $v0 : nombre non signe
	sw $a0,0($sp) # Store data in stack
	sw $a1,-4($sp)
	sw $ra,-8($sp)
	sw $t0,-12($sp)
	addi $sp,$sp,-16
	
	addi $t0, $0, 0
parseUnsignedBoucle:
	lbu $a0, 0($a1) # loads into $a0 the current $a1's byte (character)
	beq $a0, $0, parseUnsignedFin # if loaded byte == 0, input number is invalid
	jal digit # converts character to its hexadecimal equivalent
	mult $t0, $a2 
	mflo $t0
	add $t0, $t0, $v0
	addi $a1, $a1, 1 # a1 character string increment (points to next byte (character))
	beq $0, $0, parseUnsignedBoucle
parseUnsignedFin:
	add $v0,$0,$t0
	
	addi $sp,$sp,16 # Retrieves data from stack
	lw $a0,0($sp)
	lw $a1,-4($sp)	
	lw $ra,-8($sp)
	lw $t0,-12($sp)	
	jr $ra
