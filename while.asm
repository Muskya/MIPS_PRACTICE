.data
	msg: .asciiz "Bonjour\n"
	msg2: .asciiz "Au revoir\n"
.text
	la $a0, msg # "Bonjour" (msg) sera affich� par le syscall dans la boucle
	li $v0, 4 # syscall to print string (stored in $a0)
TantQue:
	bne $a2, $a3, FinTantQue # Arr�te la boucle while d�s que $a2 et $a3 ne sont plus �gaux
	syscall
	j TantQue # unconditionnal jump to adress (TantQue label)
FinTantQue:
	la $a0, msg2
	syscall