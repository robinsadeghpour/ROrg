############################################
# MATRIKELNUMMER: xxxxxx
# VORNAME: xxxxxx
# NACHNAME: xxxxxx
############################################
# ID-STRING | DO NOT CHANGE!
# ~~~ rorg_ws1920_ha1_a3 ~~~
# ~~~ Version: 20200107  ~~~
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
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	lw $s0, height
	lw $s1, width
	li $s2, 0			# Zaehler ueber den sketch 

	move $s3, $a0
	
	height_loop:
	bge $s2, $s0, end_height_loop
		li $s4, 0			# zaehler ueber die Breite 
		
		width_loop:
		bge $s4, $s1, end_width_loop
			mul $t0, $s2, $s1
			add $t0, $t0, $s4
			sll $t0, $t0, 2 
			add $t0, $t0, $s3
			
			lw $a0, 0($t0)		# Eintrag zum ausgeben  
			jal print_int
			
			addi $s4, $s4, 1 
			j width_loop
		
		end_width_loop:
	# Neue Zeile
    jal print_new_line
	
	addi $s2, $s2, 1 
	j height_loop
	
	end_height_loop: 
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	
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
	li $v0, 0			# $v0 = 0
		
	sll $t4, $a1, 7			# $t4 = $a1 * 32 (2^5) * 4 (2^2) (= $a1 * 2^7) <- Offset				
	
	li $t0, 0			# $t0 = 0
	
	j loop_keybits			
	
	jr $ra
	
loop_keybits:	
	move $t3, $a0			# copy address of $a0 to $t3
				
	beq $a2, $zero, quit_loop	# if key == 0 stop iterating	 
	andi $t1, $a2, 0x01		# get least signaficant bit of $a2
	
	li $t2, 1			# $t2 = 1
	bne $t1, $t2, jump_bit		# if the bit is set ($t1 == 1) 	
	
	sll $t2, $t0, 2			# $t2 = $t0 * 4	
	
	add $t3, $t3, $t4		# shift the array with the offset $t4
	add $t3, $t3, $t2		# shift the index of array  
	
	lw  $t2, 0($t3) 		# $t2 = value of $a0 				
	
	xor $v0, $v0, $t2		# previous value xor new value	
	
	srl $a2, $a2, 1			# shift $a2 to next bit
	addi $t0, $t0, 1		# $t0++
	
	j loop_keybits

jump_bit:	
	srl $a2, $a2, 1			# shift $a2 to next bit
	addi $t0, $t0, 1		# $t0++
	
	j loop_keybits			

quit_loop:				
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
	subi $sp, $sp, 28		# allocate room on stack
	
	sw $s0, 0($sp)			# store $s0 on stack
	sw $s1, 4($sp)			# store $s1 on stack
	sw $s2, 8($sp)			# store $s2 on stack
	sw $s3, 12($sp)			# store $s3 on stack
	sw $s4, 16($sp)			# store $s4 on stack
	sw $s5, 20($sp)			# store $s5 on stack
	sw $ra, 24($sp)			# store $ra address on stack
	
	lw $s0, height			# $t0 = height of sketch
	lw $s1, width			# $t1 = width of sketch
	
	li $s2, 0			# $t2 = 0
	
	la $s3, ($a0)			# safe base address of sketch buffer in $s3
	la $s4, ($a1)			# safe base address of array q in $s4
	la $s5, ($a2)			# safe key in $s5
	
	j loop_rows			# jump to loop_rows
	
loop_rows:
	bge $s2, $s0, quit_loop_rows	# if $s2 >= $s0 then jump to quit_loop_rows
	
	la $a0, ($a1)			# load base address of array q to %a0 as argument for h3_hash 	
	la $a1, ($s2)			# load row index to %a1 as seed	as argument for h3_hash
	
	jal H3_hash			# jump to h3, get column index 
	
	la $a0, ($s3)			# restore argument	
	la $a1, ($s4)			# restore argument
	la $a2, ($s5)			# restore argument
	
	mul $t4, $s2, $s1       	# $t4 = seed*width
	add $t4, $t4, $v0		# $t4 = $t4 + hash value
	sll $t4, $t4, 2			# $t4 = $t4 * 4
	
	add $t6, $a0, $t4 		# $t6 = base address of sketch buffer + $t4
	lw $t5, 0($t6) 			# load value from sketch buffer
	addi $t5, $t5, 1		# $t5 = $t5 + 1  						
	sw $t5, 0($t6)			# store value back to sketch buffer
					
	addi $s2, $s2, 1		# $s2++
	
	j loop_rows			# jump to loop rows
	
quit_loop_rows:
	lw $s0, 0($sp)			# restore $s0 
	lw $s1, 4($sp)			# restore $s1 
	lw $s2, 8($sp)			# restore $s2 
	lw $s3, 12($sp)			# restore $s3 
	lw $s4, 16($sp)			# restore $s4
	lw $s5, 20($sp)			# restore $s5
	lw $ra, 24($sp)			# restore $ra
		
	addi $sp, $sp, 28		# free stack
	
	jr $ra				# go back
	
	
# Iterates of an array of keys to be inserted
# 
# $a0: Base address of the sketch buffer
# $a1: Base address of array q
# $a2: Base address of key array to be inserted

# Return type: void 
update:
	subi $sp, $sp, 24		# allocate stack
	
	sw $s0, 0($sp)			# store $s0 on stack
	sw $s1, 4($sp)			# store $s1 on stack
	sw $s2, 8($sp)			# store $s2 on stack
	sw $s3, 12($sp)			# store $s3 on stack
	sw $s4, 16($sp)			# store $s4 on stack
	sw $ra, 20($sp)			# store $ra on stack
	
	lw $s0, length  		# $s0 = length of key array
	la $s1, ($a2)			# safe argument in $s1
	la $s3, ($a0)			# safe argument in $s3
	la $s4, ($a1)			# safe argument in $s4
	
	li $s2, 0			# $s2 = 0
	
	j key_loop			# jump to key_loop
	
	jr $ra 				# jump back to $ra

key_loop:
	beq $s2, $s0, quit_key_loop	# if $s1 = length quit_key_loop
	
	sll $t0, $s2, 2			# $t0 = $s2 * 4
	add $t0, $t0, $a2		# $t0 = baseaddress of array + $s2   
	lw  $a2, 0($t0)			# load value from $t0 to $a2 
		
	jal insert			# call insert 
	
	la $a0, ($s3)			# restore argument
	la $a1, ($s4)			# restore argument
	la $a2, ($s1)			# restore argument
	
	addi $s2, $s2, 1		# $s2++
	j key_loop			# jump key_loop
	
quit_key_loop:
	lw $s0, 0($sp)			# restore $s0
	lw $s1, 4($sp)			# restore $s1 
	lw $s2, 8($sp)			# restore $s2 
	lw $s3, 12($sp)			# restore $s3 
	lw $s4, 16($sp)			# restore $s4 
	lw $ra, 20($sp)			# restore $ra
	
	addi $sp, $sp, 24		# free stack 

	jr $ra				# jump back to $ra
	
############################################
#
# YOUR SOLUTION HERE ABOVE!
#
############################################

########################################################################################	
