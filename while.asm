.data
	msg: .asciiz "Bonjour\n"
	msg2: .asciiz "Au revoir\n"
.text
	la $a0, msg # "Bonjour" (msg) sera affiché par le syscall dans la boucle
	li $v0, 4 # syscall to print string (stored in $a0)
TantQue:
	bne $a2, $a3, FinTantQue # Arrête la boucle while dès que $a2 et $a3 ne sont plus égaux
	syscall
	j TantQue # unconditionnal jump to adress (TantQue label)
FinTantQue:
	la $a0, msg2
	syscall