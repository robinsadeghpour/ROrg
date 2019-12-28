############################################
# MATRIKELNUMMER: xxxxxx
# VORNAME: xxxxxx
# NACHNAME: xxxxxx
############################################
# ID-STRING | DO NOT CHANGE!
# ~~~ rorg_ws1920_ha1_a3 ~~~
# ~~~ Version: 20191210  ~~~
# ID-STRING | DO NOT CHANGE!
############################################
#
# Bitte nur im Abschnitt "YOUR SOLUTION HERE" Änderungen vornehmen!
#
########################################################################################

# Sie duerfen die unten stehenden Werte veraendern um Ihre Implementierung zu testen.
.data 
	sketch: 	.align 	4
				.space 	1280
	height:		.word	5
	width:		.word	64
	
	q: 			.word 	44 47 53 0 3 59 3 39 9 19 21 50 36 23 6 24 24 12 58 1 38 39 23 46 24 17 37 25 13 8 9 20 51 16 51 5 62 15 47 0 18 35 24 49 51 29 19 19 14 39 32 1 9 57 63 32 31 10 52 23 35 62 11 50 55 28 34 0 0 36 53 5 38 40 52 17 15 4 41 42 58 31 56 1 1 39 41 57 35 38 55 11 46 18 27 0 14 35 53 12 57 42 20 11 4 6 4 47 63 52 3 12 36 52 40 14 15 20 35 58 23 15 13 53 21 48 49 5 41 35 0 31 5 30 0 49 50 36 34 48 29 3 34 42 13 48 39 21 9 63 0 10 50 43 58 63 23 59 2 57
	
	keys: 		.word   0 1 2 3 4 5 6 7 
	length: 	.word   8

##############################################################################
# Der Sketch sollte nach dem Einfuegen der Werte 0-7 wie folgt aussehen:
#
# 1001000000000000000000000110000000000000000010010000011000000000
# 2000000000000000200000000000000000020000000000000002000000000000
# 1000000001000000000001000000100000100000000100000000000100000010
# 1000000000000010000000101000000000010000000001000000010000010000
# 2000000000200000000000000000000000020000020000000000000000000000
#
##############################################################################

.text 
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	la $a0, sketch 		# Lade Argumente 
	la $a1, q
	la $a2, keys

	jal update			# update Funktion aufrufen  

	la $a0, sketch
	jal print_sketch	# Zur Verifikation den Sketch ausgeben  
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	li $v0, 10  		# Programm beenden 
	syscall

#################################
#Argumente:
# $a0: Die Adresse vom Sketch
#################################
print_sketch:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t0, height
	lw $t1, width
	li $t2, 0			# Zaehler ueber den sketch 

	move $t5, $a0
	
	height_loop:
	bge $t2, $t0, end_height_loop
		li $t3, 0			# zaehler ueber die Breite 
		
		width_loop:
		bge $t3, $t1, end_width_loop
			sll $t4, $t2, 6
			add $t4, $t4, $t3
			sll $t4, $t4, 2 
			add $t4, $t4, $t5
			lw $a0, 0($t4)		# Eintrag zum ausgeben  
			jal print_int
			
			addi $t3, $t3, 1 
			j width_loop
		end_width_loop:
	
	# Neue Zeile
    jal print_new_line
	
	addi $t2, $t2, 1 
	
	j height_loop
	
	end_height_loop: 
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra


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

# Calclulates the H3-hash value for a given key and seed
# 
# $a0: Base address of array q
# $a1: Seed value
# $a2: Key value

# $v0: Calculated hashvalue
H3_hash:
	li $v0, 0
	
	##
	## COPY YOUR SOLUTION FROM PREVIOUS ASSIGNMENT OR LEAVE THIS FUNCTION AS IT IS
	##
	
	jr $ra
	
############################################
#
# YOUR SOLUTION HERE BELOW!
#
############################################

# Inserts a key into all rows of a sketch
# 
# $a0: Base address of the sketch buffer
# $a1: Base address of array q
# $a2: Key to be inserted

# Return type: void
insert:
	
	jr $ra
	
# Iterates of an array of keys to be inserted
# 
# $a0: Base address of the sketch buffer
# $a1: Base address of array q
# $a2: Base address of key array to be inserted

# Return type: void 
update:

	### ALWAYS LOAD FIRST KEY, FOR DEBUGGING
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $a2, 0($a2)
	jal insert
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	### ALWAYS LOAD FIRST KEY, FOR DEBUGGING
	
	jr $ra 
	
############################################
#
# YOUR SOLUTION HERE ABOVE!
#
############################################

########################################################################################	
