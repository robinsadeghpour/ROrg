############################################
# MATRIKELNUMMER: xxxxxx
# VORNAME: xxxxxx
# NACHNAME: xxxxxx
############################################
# ID-STRING | DO NOT CHANGE!
# ~~~ rorg_ws1920_ha1_a1 ~~~
# ~~~ Version: 20191210  ~~~
# ID-STRING | DO NOT CHANGE!
############################################
#
# Bitte nur im Abschnitt "YOUR SOLUTION HERE" Änderungen vornehmen!
#
########################################################################################

# Sie dürfen die unten stehenden Werte verändern um Ihre Implementierung zu testen.
.data
	correct_number:		.asciiz 	"4748 2936 5483 4787"		## returns 0 (==> correct)
	wrong_number:		.asciiz 	"4748 3726 2746 4926"		## returns 6 (==> wrong)
	
	STRING_1:			.asciiz		"Your algorithm returned: "
	STRING_2:			.asciiz		"The credit card number is correct."
	STRING_3:			.asciiz		"The credit card number is NOT correct!"
		
########################################################################################

#
# main  
.text
.globl main

main:	
	li $t3, 3
	addi $sp, $sp, -8		## Non-leaf function, make space for 2 reg
	sw $ra, 0($sp)			## save return address on stack
	sw $s0, 4($sp)			## save previous value of s0 on stack
	
	la $a0, correct_number	## load address of number as argument
	jal luhn				## call luhn-function
	move $s0, $v0			## save returned value
	
	la $a0, STRING_1		## print STRING_1
	jal print_string
	
	move $a0, $s0			## print result of luhn-algo
	jal print_int
	jal print_new_line
	
	li $t0, 0
	beq $s0, $t0, main_is_zero	## if s0 != 0
	
	la $a0, STRING_3			## then 
	jal print_string
	j main_end
	
main_is_zero:					## else
	la $a0, STRING_2
	jal print_string

main_end:	
	lw $s0, 4($sp)			## restore previous value of s0 from stack
	lw $ra, 0($sp)			## restore return address from stack
	addi $sp, $sp, 8		## free memory

	li $v0, 10				## exit syscall
	syscall
	
#
# end main
#

########################################################################################
#Anfang der Hilfsfunktionen

# $a0: int to print
print_int:
	li $v0, 1
	syscall

	jr $ra
	
# $a0: char to print
print_char:
	li $v0, 11
	syscall
	jr $ra

print_new_line:
	addi $a0, $0, 0x0A		## ASCII \n
	li $v0, 11
	syscall

	jr $ra

# $a0: string address to print
print_string:
	li $v0, 4
	syscall

	jr $ra

#Ende der Hilfsfunktionen
########################################################################################

############################################
# 
# YOUR SOLUTION HERE BELOW!
#
############################################

# Calculates the checksum for a given credit card number with the luhn algorithm
#
# $a0: address of credit-card number (as 0-terminated STRING!)
#
# $v0: result of luhn-algorithm (should be 0 for correct credit-card number, > 0 if incorrect, -1 if error) 
	
luhn:	
	move $a1, $a0			# copy address from $a0 to $a1
	li $v1, 1			# $v1 = 1
	li $t1, 48 			# $t1 = 0
	li $t2, 57			# $t3 = "space"	
	li $t3, 32 			# $t2 = 9
	
	jal iterate_string 
			
	li $v0, -1			## return -1 for error
	
	jr $ra				## jump back
	
iterate_string:
	lb $t0, 0($a1)
	beq $t0, $zero, stop_iterating	# if a1 == 0 stop iterating
	li $v1, 1
	beq $t0, $t3, ignore_space	# if $a1 == "space" then jump to ignore_space	
	bgt $t0, $t2, fail_iterating	# if $a1 > 57 then fail
	blt $t0, $t1, fail_iterating	# if $a2 < 32 then fail
	
	addi $a1, $a1, 1		# $a1 + 4
	j iterate_string

stop_iterating:
	jr $ra				# return 

ignore_space:
	addi $a1, $a1, 1		# $a1 + 4
	j iterate_string		# jump back to iterate_string

fail_iterating:
	li $v1, 0			# $v1 = 0
	jr $ra				# return to luhn
	
	
	
############################################
# 
# YOUR SOLUTION HERE ABOVE!
#
############################################

########################################################################################
