############################################
# MATRIKELNUMMER: 410893
# VORNAME: ROBIN	
# NACHNAME: SADEGHPOUR
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
	
	la $a0, wrong_number	## load address of number as argument
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
	subi $sp, $sp, 4		## Non-leaf function, make space for 1 reg
	li $s1, 0			# s1 = 0 for sum		
	move $t6, $a0			# copy address from $a0 to $t6
	sw $s1, 8($sp)			# save value on stack
	
	li $t1, 1			# $t1 = 0			
	
	j iterate_string 		
	
	li $v0, -1	 		## return -1 for error
	
	jr $ra				## jump back

		
iterate_string:
	li $t2, 48 			# $t1 = 0
	li $t3, 57			# $t3 = "space"	
	li $t4, 32 			# $t2 = 9
	
	
	lb $t0, 0($t6)			# load single byte from string in $t0
	
	beq $t0, $zero, end_luhn	# if $t0 == 0 stop iterating
	beq $t0, $t4, ignore_space	# if $t0 == "space" then jump to ignore_space	
	bgt $t0, $t3, fail_luhn	# if $t0 > 9 (ascii 57) then fail
	blt $t0, $t2, fail_luhn	# if $t0 < 0 (ascii 52) then fail
	
	## is digit ##
	
	li $t2, 2			# $t2 = 2 for x mod 2 operation
	
	subi $t3, $t0, 48		# $t3 = $t0 - 48 <- ascii to digit
				
	div $t1, $t2			# $t1 / 2 <= hi = $t1 mod 2
	mfhi $t4			# $t4 = $t1 mod 2
	
	beq $t4, $zero, add_sum  	# if $t1 mod 2 != 0 then jump to add_sum 
	add $t3, $t3, $t3		# $t3  = $t3 + $t3 <- $t3 = $t3 * 2
	
	li $t5, 9
	ble $t3, $t5, add_sum		# if $t3 <= $t5 then jump to add_sum
	sub $t3, $t3, $t5		# $t3 = $t3 -9 
	j add_sum
	  			  			
	addi $t1, $t1, 1		# $t1++		
	addi $t6, $t6, 1		# $t6++
	
	j iterate_string

end_luhn:
	li $t1, 10			# $t1 = 10 for x mod 10 operation
	
	div $s1, $t1			# $s1 / 10 <- hi register contains remainder
	sw $s1, 8($sp)			# save value on stack				
	
	mfhi $v0			# return $v0 = $s1 mod 10 
	
	lw $s1, 8($sp)			## restore previous value of s1 from stack
	addi $sp, $sp, 4		## free memory
	
	jr $ra				## jump back 

ignore_space:
	## do nothing and iterate with next byte ##
	
	addi $t6, $t6, 1		# $t6++
	
	j iterate_string		# jump to iterate_string

fail_luhn:
	## string does not only contain digits ##
	
	li $v0, -1			## return $v0 = -1 for error
	
	jr $ra				## jump back 
	
add_sum: 
	add $s1, $s1, $t3		# $s1 = $s1 + $t3 <- sum = sum + digit
	sw $s1, 8($sp)			# save value on stack
	
	addi $t1, $t1, 1		# $t1++
	addi $t6, $t6, 1		# $t6++
	
	j iterate_string		# jump to iterate_string
	
############################################
# 
# YOUR SOLUTION HERE ABOVE!
#
############################################

########################################################################################
