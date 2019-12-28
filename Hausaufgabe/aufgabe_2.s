############################################
# MATRIKELNUMMER: xxxxxx
# VORNAME: xxxxxx
# NACHNAME: xxxxxx
############################################
# ID-STRING | DO NOT CHANGE!
# ~~~ rorg_ws1920_ha1_a2 ~~~
# ~~~ Version: 20191210  ~~~
# ID-STRING | DO NOT CHANGE!
############################################
#
# Bitte nur im Abschnitt "YOUR SOLUTION HERE" Änderungen vornehmen!
#
########################################################################################

# Sie duerfen die unten stehenden Werte veraendern um Ihre Implementierung zu testen.
.data 
	q:				.word 	44 47 53 0 3 59 3 39 9 19 21 50 36 23 6 24 24 12 58 1 38 39 23 46 24 17 37 25 13 8 9 20 51 16 51 5 62 15 47 0 18 35 24 49 51 29 19 19 14 39 32 1 9 57 63 32 31 10 52 23 35 62 11 50 55 28 34 0 0 36 53 5 38 40 52 17 15 4 41 42 58 31 56 1 1 39 41 57 35 38 55 11 46 18 27 0 14 35 53 12 57 42 20 11 4 6 4 47 63 52 3 12 36 52 40 14 15 20 35 58 23 15 13 53 21 48 49 5 41 35 0 31 5 30 0 49 50 36 34 48 29 3 34 42 13 48 39 21 9 63 0 10 50 43 58 63 23 59 2 57
	seed: 			.word 	0
	key: 			.word	5

	output_text: 	.asciiz "Der Hashwert beträgt: "

############################################
# Keys mit ihren korrespondierenden Hashwerten fuer den Seed 0
# Key	- > Hashwert 
#  0	- >		0
#  1	- > 	44
#  2 	- >		47 
#  3 	- > 	3
#  4 	- >		53
#  5 	- > 	25 
#  6	- > 	26 
#  7 	- > 	54
############################################

.text 

main:
	# Register save
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	la $a0, q
	lw $a1, seed
	lw $a2, key 
	jal H3_hash
	move $s0, $v0 
	
	la $a0, output_text
	jal print_string
	
	move $a0, $s0
	jal print_int
	jal print_new_line
	
	# Register restore
	lw $ra, 0($sp)
	lw $s0, 4($sp)	
	addi $sp, $sp, 8
	
	# exit programm 
	li $v0, 10
	syscall

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
#################################

# Calclulates the H3-hash value for a given key and seed
# 
# $a0: Base address of array q
# $a1: Seed value
# $a2: Key value

# $v0: Calculated hashvalue
H3_hash:
	li $v0, 1
	
	jr $ra
	
############################################
# 
# YOUR SOLUTION HERE ABOVE!
#
############################################

########################################################################################
