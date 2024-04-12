################ CSC258H1F Winter 2024 Assembly Final Project ##################
# This file contains our implementation of Tetris.
#
# Student 1: Zijie Ma, 1008829369
# Student 2: Felix Peng, 1008883344
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       8
# - Unit height in pixels:      8
# - Display width in pixels:    256
# - Display height in pixels:   256
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL: 
    .word 0x10008000  # Base address for the display
ADDR_KBRD:
    .word 0xffff0000
seed:
    .word 123456789
##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main
# s1, s2, s3, s4 for pixel
# color store on stack 0
main:
    li $t0, 0x10008000   # Load the desired value into register $t0
    la $t1, ADDR_DSPL    # Load the address of ADDR_DSPL into register $t1
    sw $t0, 0($t1)       # Store the value of $t0 into the memory location of ADDR_DSPL
    
    lw $t0, ADDR_DSPL       # Load base address of the display into $t0
    li $t1, 0
    jal draw_line
    li $s1, 0
    li $s2, 0
    li $s3, 0
    li $s4, 0
    
    # random
    li $v0, 42
    li $a0, 0
    li $a1, 7
    syscall
    
    sw $a0, -4($sp)
    
    li $s5, 40
    li $s6, 0
    
    b loop
    b end
    
loop: # TEST TEST TEST TEST TEST TEST
    jal is_generate_pixel
    jal draw_next_pixel
    beq $s5, $s6, gravity
    addi $s6, $s6, 1
    jal sleep
    jal check_keyboard
    
    j loop
    
gravity: #The gravity feature of the game
    li $s6, 0
    j respond_to_S

sleep:
    li $v0, 32
    li $a0, 20
    syscall
    jr $ra

draw_next_pixel:
    lw $a0, -4($sp)
    
    lw $t0, ADDR_DSPL
    li $t4, 0x000000 # black
    # initial to black
    sw $t4, 360($t0)
    sw $t4, 364($t0)
    sw $t4, 368($t0)
    sw $t4, 488($t0)
    sw $t4, 492($t0)
    sw $t4, 496($t0)
    sw $t4, 616($t0)
    sw $t4, 620($t0)
    sw $t4, 624($t0)
    sw $t4, 500($t0)
    
    beq $a0, 0, draw_next_T
    beq $a0, 1, draw_next_J
    beq $a0, 2, draw_next_L
    beq $a0, 3, draw_next_O
    beq $a0, 4, draw_next_S
    beq $a0, 5, draw_next_I
    beq $a0, 6, draw_next_Z
    
    jr $ra
    
draw_next_O:
    lw $t0, ADDR_DSPL
    li $t4, 0x0000FF
    
    sw $t4, 360($t0)
    sw $t4, 364($t0)
    sw $t4, 488($t0)
    sw $t4, 492($t0)
    
    jr $ra

draw_next_I:
    lw $t0, ADDR_DSPL
    li $t4, 0xFF0000
    
    sw $t4, 488($t0)
    sw $t4, 492($t0)
    sw $t4, 496($t0)
    sw $t4, 500($t0)
    
    jr $ra

draw_next_S:
    lw $t0, ADDR_DSPL
    li $t4, 0x008000
    
    sw $t4, 364($t0)
    sw $t4, 368($t0)
    sw $t4, 492($t0)
    sw $t4, 488($t0)
    
    jr $ra

draw_next_Z:
    lw $t0, ADDR_DSPL
    li $t4, 0x8A2BE2
    
    sw $t4, 360($t0)
    sw $t4, 364($t0)
    sw $t4, 492($t0)
    sw $t4, 496($t0)
    
    jr $ra

draw_next_L:
    lw $t0, ADDR_DSPL
    li $t4, 0xFFA500
    
    sw $t4, 360($t0)
    sw $t4, 488($t0)
    sw $t4, 616($t0)
    sw $t4, 620($t0)
    
    jr $ra

draw_next_J:
    lw $t0, ADDR_DSPL
    li $t4, 0xFFC0CB
    
    sw $t4, 364($t0)
    sw $t4, 492($t0)
    sw $t4, 620($t0)
    sw $t4, 616($t0)
    
    jr $ra

draw_next_T:
    lw $t0, ADDR_DSPL
    li $t4, 0x800080
    
    sw $t4, 360($t0)
    sw $t4, 364($t0)
    sw $t4, 368($t0)
    sw $t4, 492($t0)
    
    jr $ra

check_keyboard:
    move $s0, $ra
    li 		$v0, 32
	li 		$a0, 1
	syscall

    li $t0, 0xffff0000              # $t0 = base address for keyboard
    lw $t9, 0($t0)                  # Load first word from keyboard
    beq $t9, 1, keyboard_input      # If first word 1, key is pressed
    jr $ra

keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x71, respond_to_Q     # Check if the key 'Q' was pressed
    beq $a0, 0x77, respond_to_W     # Check if the key 'W' was pressed
    beq $a0, 0x61, respond_to_A     # Check if the key 'A' was pressed
    beq $a0, 0x73, respond_to_S     # Check if the key 'S' was pressed
    beq $a0, 0x64, respond_to_D     # Check if the key 'D' was pressed
    beq $a0, 0x70, respond_to_P     # Check if the key 'P' was pressed
    
    # beq $a0, 0x72, respond_to_R     # Check if the key 'R' was pressed

    jr $ra

respond_to_P:
    lw $t0, ADDR_DSPL
    li $t4, 0xFFFFFF # white
    
    li $t1, 33
    sw $t1, -108($sp)
    li $t1, 42 # instrument
    sw $t1, -100($sp) # instrument
    li $t1, 100 # volume
    sw $t1, -104($sp) # volume
    
    # draw pause
    sw $t4, 996($t0)
    sw $t4, 1000($t0)
    sw $t4, 1004($t0)
    sw $t4, 1008($t0)
    sw $t4, 1012($t0)
    sw $t4, 1140($t0)
    sw $t4, 1268($t0)
    sw $t4, 1396($t0)
    sw $t4, 1524($t0)
    sw $t4, 1520($t0)
    sw $t4, 1516($t0)
    sw $t4, 1512($t0)
    sw $t4, 1508($t0)
    sw $t4, 1380($t0)
    sw $t4, 1252($t0)
    sw $t4, 1124($t0)
    sw $t4, 1636($t0)
    sw $t4, 1764($t0)
    sw $t4, 1892($t0)
    sw $t4, 2020($t0)
    sw $t4, 2148($t0)
    
    # 1
    lw $v0, -108($sp)
    li $a0, 60    # midi pitch
    li $a1, 500  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 2
    lw $v0, -108($sp)
    li $a0, 64    # midi pitch
    li $a1, 500  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 3
    lw $v0, -108($sp)
    li $a0, 69    # midi pitch
    li $a1, 500  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    j check_pause_keyboard
    
check_pause_keyboard:
    li 		$v0, 32
	li 		$a0, 1
	syscall

    li $t0, 0xffff0000               # $t0 = base address for keyboard
    lw $t9, 0($t0)                  # Load first word from keyboard
    beq $t9, 1, check_keyboard_P     # If first word 1, key is pressed
    b check_pause_keyboard

check_keyboard_P:
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x70, respond_to_P_pause     # Check if the key 'P' was pressed
    beq $a0, 0x71, respond_to_Q     # Check if the key 'Q' was pressed
    j check_pause_keyboard

respond_to_P_pause:
    lw $t0, ADDR_DSPL
    li $t4, 0x000000 # balck
    
    # 1
    lw $v0, -108($sp)
    li $a0, 69    # midi pitch
    li $a1, 500  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 2
    lw $v0, -108($sp)
    li $a0, 64    # midi pitch
    li $a1, 500  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 3
    lw $v0, -108($sp)
    li $a0, 60    # midi pitch
    li $a1, 500  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    sw $t4, 996($t0)
    sw $t4, 1000($t0)
    sw $t4, 1004($t0)
    sw $t4, 1008($t0)
    sw $t4, 1012($t0)
    sw $t4, 1140($t0)
    sw $t4, 1268($t0)
    sw $t4, 1396($t0)
    sw $t4, 1524($t0)
    sw $t4, 1520($t0)
    sw $t4, 1516($t0)
    sw $t4, 1512($t0)
    sw $t4, 1508($t0)
    sw $t4, 1380($t0)
    sw $t4, 1252($t0)
    sw $t4, 1124($t0)
    sw $t4, 1636($t0)
    sw $t4, 1764($t0)
    sw $t4, 1892($t0)
    sw $t4, 2020($t0)
    sw $t4, 2148($t0)
    
    li $t1, 33
    sw $t1, -108($sp)
    li $t1, 42 # instrument
    sw $t1, -100($sp) # instrument
    li $t1, 100 # volume
    sw $t1, -104($sp) # volume
    
    jr $ra

    

respond_to_Q:
	j end
respond_to_W:
    li $t1, 33
    sw $t1, -108($sp)
    li $t1, 5 # instrument
    sw $t1, -100($sp) # instrument
    li $t1, 100 # volume
    sw $t1, -104($sp) # volume
    
    # 1
    lw $v0, -108($sp)
    li $a0, 60    # midi pitch
    li $a1, 10  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 2
    lw $v0, -108($sp)
    li $a0, 64    # midi pitch
    li $a1, 10  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 3
    lw $v0, -108($sp)
    li $a0, 69    # midi pitch
    li $a1, 10  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    li $t4, 0x000000
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    sw $t4, 0($t3)
    
    #check collision
    lw $t3, ADDR_DSPL
    sub $t5, $s1, $s2
    move $t6, $zero
    jal rotation
    add $t6, $t6, $s1
    add $t3, $t3, $t6
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    
    lw $t3, ADDR_DSPL
    sub $t5, $s1, $s3
    move $t6, $zero
    jal rotation
    add $t6, $t6, $s1
    add $t3, $t3, $t6
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    
    lw $t3, ADDR_DSPL
    sub $t5, $s1, $s4
    move $t6, $zero
    jal rotation
    add $t6, $t6, $s1
    add $t3, $t3, $t6
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    
    #start rotation
    lw $t4, 0($sp)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    sw $t4, 0($t3)

    lw $t3, ADDR_DSPL
    sub $t5, $s1, $s2
    move $t6, $zero
    jal rotation
    add $s2, $t6, $s1
    add $t3, $t3, $s2
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    sub $t5, $s1, $s3
    move $t6, $zero
    jal rotation
    add $s3, $t6, $s1
    add $t3, $t3, $s3
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    sub $t5, $s1, $s4
    move $t6, $zero
    jal rotation
    add $s4, $t6, $s1
    add $t3, $t3, $s4
    sw $t4, 0($t3)
    
    jr $s0

respond_to_A:
    li $v0, 31
    li $a0, 69    # midi pitch
    li $a1, 100  # duration
    li $a2, 27     # instrument
    li $a3, 100   # volume
    syscall
    
    lw $t0, ADDR_DSPL
    li $t4, 0x000000
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    sw $t4, 0($t3)
    
 # check collision
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    addi $t3, $t3, -4
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    addi $t3, $t3, -4
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    addi $t3, $t3, -4
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    addi $t3, $t3, -4
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    
 # Start move left one step, test should before it
    lw $t4, 0($sp)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    addi $t3, $t3, -4
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    addi $t3, $t3, -4
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    addi $t3, $t3, -4
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    addi $t3, $t3, -4
    sw $t4, 0($t3)
    
    addi $s1, $s1, -4
    addi $s2, $s2, -4
    addi $s3, $s3, -4
    addi $s4, $s4, -4
	jr $ra

respond_to_S:
    li $v0, 33
    li $a0, 69    # midi pitch
    li $a1, 15  # duration
    li $a2, 27     # instrument
    li $a3, 100   # volume
    syscall
    li $v0, 33
    li $a0, 64    # midi pitch
    li $a1, 15  # duration
    li $a2, 27     # instrument
    li $a3, 100   # volume
    syscall
    li $v0, 33
    li $a0, 60    # midi pitch
    li $a1, 15  # duration
    li $a2, 27     # instrument
    li $a3, 100   # volume
    syscall
    # Make black
    li $t4, 0x000000
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    sw $t4, 0($t3)
    
    # Test Collision
    li $t0, 0
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    addi $t3, $t3, 128
    lw $t0, 0($t3)
    bne $t0, 0x000000, S_FAIL
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    addi $t3, $t3, 128
    lw $t0, 0($t3)
    bne $t0, 0x000000, S_FAIL
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    addi $t3, $t3, 128
    lw $t0, 0($t3)
    bne $t0, 0x000000, S_FAIL
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    addi $t3, $t3, 128
    lw $t0, 0($t3)
    bne $t0, 0x000000, S_FAIL
    
    # Start move one step down
    lw $t4, 0($sp)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    addi $t3, $t3, 128
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    addi $t3, $t3, 128
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    addi $t3, $t3, 128
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    addi $t3, $t3, 128
    sw $t4, 0($t3)
    
    addi $s1, $s1, 128
    addi $s2, $s2, 128
    addi $s3, $s3, 128
    addi $s4, $s4, 128
	jr $ra
	
S_FAIL:
    lw $t4, 0($sp)
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    sw $t4, 0($t3)
    li $s1, 0
    li $s1, 0
    li $s1, 0
    li $s1, 0
    
    jr $ra

respond_to_D:
    li $v0, 31
    li $a0, 64    # midi pitch
    li $a1, 100  # duration
    li $a2, 27     # instrument
    li $a3, 100   # volume
    syscall
    
    lw $t0, ADDR_DSPL
    li $t4, 0x000000
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    sw $t4, 0($t3)
    
    # check collision
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    addi $t3, $t3, 4
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    addi $t3, $t3, 4
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    addi $t3, $t3, 4
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    addi $t3, $t3, 4
    lw $t0, 0($t3)
    bne $t0, 0x000000, fill
    
 # Start move left one step, test should before it
    lw $t4, 0($sp)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    addi $t3, $t3, 4
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    addi $t3, $t3, 4
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    addi $t3, $t3, 4
    sw $t4, 0($t3)
    
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    addi $t3, $t3, 4
    sw $t4, 0($t3)
    
    addi $s1, $s1, 4
    addi $s2, $s2, 4
    addi $s3, $s3, 4
    addi $s4, $s4, 4
	jr $ra


fill:
    lw $t4, 0($sp)
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s1
    sw $t4, 0($t3)
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s2
    sw $t4, 0($t3)
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s3
    sw $t4, 0($t3)
    lw $t3, ADDR_DSPL
    add $t3, $t3, $s4
    sw $t4, 0($t3)
    jr $s0
    
rotation:
    bgtz $t5, positive
    bltz $t5, negative
    jr $ra
       
positive:
    bge $t5, 124, positive1
    bge $t5, 4, positive2
    j rotation

positive1:
    subi $t5, $t5, 128
    addi $t6, $t6, 4
    j positive
positive2:
    subi $t5, $t5, 4
    subi $t6, $t6, 128
    j positive

negative:
    ble $t5, -124, negative1
    ble $t5, -4, negative2
    j rotation
    
negative1:
    addi $t5, $t5, 128
    subi $t6, $t6, 4
    j negative

negative2:
    addi $t5, $t5, 4
    addi $t6, $t6, 128
    j negative

is_generate_pixel:
    beq $s1, 0, is_max_speed # 0 means on aviable pixel exist
    jr $ra
    
is_max_speed:
    bgt $s5, 10, Increase_gravity_speed
    j generate_pixel

Increase_gravity_speed:
    addi $s5, $s5, -8
    li $s6, 0
    j generate_pixel

generate_pixel:
    # Call the random
    li $v0, 42
    li $a0, 0
    li $a1, 7
    syscall
    
    lw $t4, -4($sp) # the current pixel
    sw $a0, -4($sp) # the next pixel
    
    
    beq $t4, 0, generate_T
    beq $t4, 1, generate_J
    beq $t4, 2, generate_L
    beq $t4, 3, generate_O
    beq $t4, 4, generate_S
    beq $t4, 5, generate_I
    beq $t4, 6, generate_Z


generate_Z: # generate a Z type on statring location
    lw $t0, ADDR_DSPL
    
    # check colision
    li $t4, 0x000000 # black
    lw $t1, 168($t0)
    bne $t1, $t4, end
    lw $t1, 172($t0)
    bne $t1, $t4, end
    lw $t1, 300($t0)
    bne $t1, $t4, end
    lw $t1, 304($t0)
    bne $t1, $t4, end
    
    li $t4, 0x8A2BE2 # violet
    sw $t4, 0($sp)
    sw $t4, 168($t0)
    sw $t4, 172($t0)
    sw $t4, 300($t0) # *
    sw $t4, 304($t0)
    
    li $s1, 300
    li $s2, 172
    li $s3, 168
    li $s4, 304    

    jr $ra

generate_O: # generate a O type on statring location, test will later.
    lw $t0, ADDR_DSPL
    
    # check colision
    li $t4, 0x000000 # black
    lw $t1, 168($t0)
    bne $t1, $t4, end
    lw $t1, 172($t0)
    bne $t1, $t4, end
    lw $t1, 296($t0)
    bne $t1, $t4, end
    lw $t1, 300($t0)
    bne $t1, $t4, end
    
    li $t4, 0x0000FF # blue
    sw $t4, 0($sp)
    sw $t4, 168($t0)
    sw $t4, 172($t0)
    sw $t4, 296($t0) # *
    sw $t4, 300($t0)
    
    li $s1, 296
    li $s2, 300
    li $s3, 168
    li $s4, 172
    
    jr $ra

generate_I: # generate a I type on statring location
    lw $t0, ADDR_DSPL
    
    # check colision
    li $t4, 0x000000 # black
    lw $t1, 164($t0)
    bne $t1, $t4, end
    lw $t1, 168($t0)
    bne $t1, $t4, end
    lw $t1, 172($t0)
    bne $t1, $t4, end
    lw $t1, 176($t0)
    bne $t1, $t4, end
    
    li $t4, 0xFF0000 # red
    sw $t4, 0($sp)
    sw $t4, 164($t0)
    sw $t4, 168($t0)
    sw $t4, 172($t0) # *
    sw $t4, 176($t0)
    
    li $s1, 172
    li $s2, 164
    li $s3, 168
    li $s4, 176
    
    jr $ra

generate_S: # generate a S type on statring location
    lw $t0, ADDR_DSPL
    
    # check colision
    li $t4, 0x000000 # black
    lw $t1, 172($t0)
    bne $t1, $t4, end
    lw $t1, 176($t0)
    bne $t1, $t4, end
    lw $t1, 300($t0)
    bne $t1, $t4, end
    lw $t1, 296($t0)
    bne $t1, $t4, end
    
    li $t4, 0x008000 # green
    sw $t4, 0($sp)
    sw $t4, 172($t0)
    sw $t4, 176($t0) 
    sw $t4, 300($t0) # *
    sw $t4, 296($t0)
    
    li $s1, 300
    li $s2, 172
    li $s3, 176
    li $s4, 296
    
    jr $ra

generate_L: # generate a L type on statring location
    lw $t0, ADDR_DSPL
    
    # check colision
    li $t4, 0x000000 # black
    lw $t1, 300($t0)
    bne $t1, $t4, end
    lw $t1, 172($t0)
    bne $t1, $t4, end
    lw $t1, 428($t0)
    bne $t1, $t4, end
    lw $t1, 432($t0)
    bne $t1, $t4, end
    
    li $t4, 0xFFA500 # orange
    sw $t4, 0($sp)
    sw $t4, 172($t0)
    sw $t4, 300($t0)
    sw $t4, 428($t0) # *
    sw $t4, 432($t0)
    
    li $s1, 428
    li $s2, 432
    li $s3, 300
    li $s4, 172
    
    jr $ra

generate_J: # generate a J type on statring location
    lw $t0, ADDR_DSPL
    
    # check colision
    li $t4, 0x000000 # black
    lw $t1, 300($t0)
    bne $t1, $t4, end
    lw $t1, 172($t0)
    bne $t1, $t4, end
    lw $t1, 428($t0)
    bne $t1, $t4, end
    lw $t1, 424($t0)
    bne $t1, $t4, end
    
    li $t4, 0xFFC0CB
    sw $t4, 0($sp)
    sw $t4, 172($t0)
    sw $t4, 300($t0)
    sw $t4, 428($t0) # *
    sw $t4, 424($t0) 
    
    li $s1, 424
    li $s2, 428
    li $s3, 300
    li $s4, 172
    
    jr $ra

generate_T: # generate a T type on statring location
    lw $t0, ADDR_DSPL
    
    # check colision
    li $t4, 0x000000 # black
    lw $t1, 176($t0)
    bne $t1, $t4, end
    lw $t1, 172($t0)
    bne $t1, $t4, end
    lw $t1, 168($t0)
    bne $t1, $t4, end
    lw $t1, 300($t0)
    bne $t1, $t4, end
    
    li $t4, 0x800080
    sw $t4, 0($sp)
    sw $t4, 172($t0) 
    sw $t4, 176($t0)
    sw $t4, 168($t0)
    sw $t4, 300($t0) # *
    
    li $s1, 300
    li $s2, 172
    li $s3, 176
    li $s4, 168
    
    jr $ra

draw_line:
    # Initialize $t6 with the color to draw the walls
    li $t6, 0xFFF00F        # Red color for the walls

    # Draw two vertical walls
    li $t1, 0               # Loop counter for vertical walls
draw_vertical_walls:
    bge $t1, 32, draw_horizontal_walls # Break loop after 32 iterations

    # Calculate address for the left wall pixel and store color
    sll $t2, $t1, 7         # i * 128 (shift left by 7 is equivalent to multiply by 128)
    add $t3, $t0, $t2       # Calculate memory address for the pixel
    sw $t6, 0($t3)          # Draw the left wall

    # Calculate address for the right wall pixel (70% width) and store color
    li $t4, 88              # Offset for 70% width (22 blocks * 4 bytes per pixel)
    add $t3, $t3, $t4       # Adjust address for the right wall
    sw $t6, 0($t3)          # Draw the right wall

    addi $t1, $t1, 1        # Increment loop counter
    j draw_vertical_walls   # Jump back to the start of the loop

draw_horizontal_walls:
    li $t1, 0               # Reset loop counter for horizontal walls
    li $t5, 3968            # Pre-calculate offset for the bottom line

draw_horizontal_line:
    bge $t1, 22, jump_back        # Break loop after 22 iterations

    # Calculate address for the top wall pixel and store color
    sll $t2, $t1, 2         # i * 4
    add $t3, $t0, $t2       # Calculate memory address for the pixel
    sw $t6, 0($t3)          # Draw the top wall

    # Calculate address for the bottom wall pixel and store color
    add $t3, $t0, $t2       # Re-calculate base address for the pixel
    add $t3, $t3, $t5       # Adjust address for the bottom wall
    sw $t6, 0($t3)          # Draw the bottom wall

    addi $t1, $t1, 1        # Increment loop counter
    j draw_horizontal_line  # Jump back to the start of the loop
jump_back:
    jr $ra
    
end:
    two_tiger:
    li $t1, 33
    sw $t1, -108($sp)
    li $t1, 60 # instrument
    sw $t1, -100($sp) # instrument
    li $t1, 100 # volume
    sw $t1, -104($sp) # volume
    
    # 1
    lw $v0, -108($sp)
    li $a0, 60    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 2
    lw $v0, -108($sp)
    li $a0, 60    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 1
    lw $v0, -108($sp)
    li $a0, 67    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 2
    lw $v0, -108($sp)
    li $a0, 67    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 1
    lw $v0, -108($sp)
    li $a0, 69    # midi pitch
    li $a1, 250   # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 2
    lw $v0, -108($sp)
    li $a0, 69    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 1
    lw $v0, -108($sp)
    li $a0, 67    # midi pitch
    li $a1, 500  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 2
    lw $v0, -108($sp)
    li $a0, 65    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 1
    lw $v0, -108($sp)
    li $a0, 65    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 2
    lw $v0, -108($sp)
    li $a0, 64    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 1
    lw $v0, -108($sp)
    li $a0, 64    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 2
    lw $v0, -108($sp)
    li $a0, 62    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 1
    lw $v0, -108($sp)
    li $a0, 62    # midi pitch
    li $a1, 250  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # 2
    lw $v0, -108($sp)
    li $a0, 60    # midi pitch
    li $a1, 500  # duration
    lw $a2, -100($sp)     # instrument
    lw $a3, -104($sp)   # volume
    syscall
    
    # Clear the screen
    lw $t0, ADDR_DSPL       # Load base address for the display into $t0
    li $t1, 0x0000         # Color black
    li $t2, 0x4000         # Pixel count (256*256)/2 because of word access
    

clear_screen:
    sw $t1, 0($t0)         # Set pixel to black
    addi $t0, $t0, 4       # Move to the next pixel
    addi $t2, $t2, -1      # Decrement the pixel counter
    bnez $t2, clear_screen # Continue until the screen is cleared

    # Draw "GAME OVER"
    jal draw_GG
    
    # Exit the program on R or Q
    j restart_loop

restart_loop: # check keyboard Q or R
    jal check_restart_keyboard
    j restart_loop

check_restart_keyboard:
    li 		$v0, 32
	li 		$a0, 1
	syscall

    li $t0, 0xffff0000               # $t0 = base address for keyboard
    lw $t9, 0($t0)                  # Load first word from keyboard
    beq $t9, 1, check_keyboard_R_Q      # If first word 1, key is pressed
    b check_restart_keyboard

check_keyboard_R_Q:
    li $t4, 0x10008000
    li $t1, 0x000000
    li $t2, 0x4000
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x72, respond_to_R     # Check if the key 'R' was pressed
    beq $a0, 0x71, respond_to_Q_restart     # Check if the key 'Q' was pressed
    
    jr $ra

respond_to_Q_restart:
    li $v0, 33
    li $a0, 60    # midi pitch
    li $a1, 1000  # duration
    li $a2, 127   # instrument
    li $a3, 100   # volume
    syscall
    
    li $v0, 10              # terminate the program gracefully
    syscall

respond_to_R:
    sw $t1, 0($t4)         # Set pixel to black
    addi $t4, $t4, 4       # Move to the next pixel
    addi $t2, $t2, -1      # Decrement the pixel counter
    bnez $t2, respond_to_R # Continue until the screen is cleared
    
    li $v0, 33
    li $a0, 60    # midi pitch
    li $a1, 250  # duration
    li $a2, 32     # instrument
    li $a3, 100   # volume
    syscall
    
    li $v0, 33
    li $a0, 64    # midi pitch
    li $a1, 250  # duration
    li $a2, 32     # instrument
    li $a3, 100   # volume
    syscall
    
    li $v0, 33
    li $a0, 69    # midi pitch
    li $a1, 250  # duration
    li $a2, 32     # instrument
    li $a3, 100   # volume
    syscall
    
    j main

draw_GG:
    li $t1, 0xf0f0f0        # $t1 = white
    
    li $t0, 0x10007FFC      # $t0 = base address for display -4 (for beauty)
    # G
    sw $t1, 672($t0)
    sw $t1, 540($t0)
    sw $t1, 536($t0)
    sw $t1, 532($t0)
    sw $t1, 656($t0)
    sw $t1, 780($t0)
    sw $t1, 908($t0)
    sw $t1, 1036($t0)
    sw $t1, 1164($t0)
    sw $t1, 1292($t0)
    sw $t1, 1424($t0)
    sw $t1, 1556($t0)
    sw $t1, 1560($t0)
    sw $t1, 1564($t0)
    sw $t1, 1568($t0)
    sw $t1, 1440($t0)
    sw $t1, 1312($t0)
    sw $t1, 1184($t0)
    sw $t1, 1180($t0)
    sw $t1, 1176($t0)
    # A
    sw $t1, 1576($t0)
    sw $t1, 1448($t0)
    sw $t1, 1320($t0)
    sw $t1, 1192($t0)
    sw $t1, 1064($t0)
    sw $t1, 940($t0)
    sw $t1, 812($t0)
    sw $t1, 684($t0)
    sw $t1, 560($t0)
    sw $t1, 564($t0)
    sw $t1, 696($t0)
    sw $t1, 824($t0)
    sw $t1, 952($t0)
    sw $t1, 1084($t0)
    sw $t1, 1212($t0)
    sw $t1, 1340($t0)
    sw $t1, 1468($t0)
    sw $t1, 1596($t0)
    sw $t1, 1324($t0)
    sw $t1, 1328($t0)
    sw $t1, 1332($t0)
    sw $t1, 1336($t0)
    # M
    sw $t1, 1604($t0)
    sw $t1, 1476($t0)
    sw $t1, 1348($t0)
    sw $t1, 1220($t0)
    sw $t1, 1092($t0)
    sw $t1, 964($t0)
    sw $t1, 836($t0)
    sw $t1, 708($t0)
    sw $t1, 584($t0)
    sw $t1, 588($t0)
    sw $t1, 720($t0)
    sw $t1, 848($t0)
    sw $t1, 976($t0)
    sw $t1, 1104($t0)
    sw $t1, 976($t0)
    sw $t1, 1104($t0)
    sw $t1, 1232($t0)
    sw $t1, 1360($t0)
    sw $t1, 1488($t0)
    sw $t1, 1616($t0)
    sw $t1, 596($t0)
    sw $t1, 600($t0)
    sw $t1, 732($t0)
    sw $t1, 860($t0)
    sw $t1, 988($t0)
    sw $t1, 1116($t0)
    sw $t1, 1244($t0)
    sw $t1, 1372($t0)
    sw $t1, 1500($t0)
    sw $t1, 1628($t0)
    # E
    sw $t1, 1652($t0)
    sw $t1, 1648($t0)
    sw $t1, 1644($t0)
    sw $t1, 1640($t0)
    sw $t1, 1636($t0)
    sw $t1, 1508($t0)
    sw $t1, 1380($t0)
    sw $t1, 1252($t0)
    sw $t1, 1124($t0)
    sw $t1, 996($t0)
    sw $t1, 868($t0)
    sw $t1, 740($t0)
    sw $t1, 612($t0)
    sw $t1, 616($t0)
    sw $t1, 620($t0)
    sw $t1, 624($t0)
    sw $t1, 628($t0)
    sw $t1, 1128($t0)
    sw $t1, 1132($t0)
    sw $t1, 1136($t0)
    sw $t1, 1140($t0)
    # O
    sw $t1, 2192($t0)
    sw $t1, 2196($t0)
    sw $t1, 2200($t0)
    sw $t1, 2204($t0)
    sw $t1, 2336($t0)
    sw $t1, 2464($t0)
    sw $t1, 2592($t0)
    sw $t1, 2720($t0)
    sw $t1, 2848($t0)
    sw $t1, 2976($t0)
    sw $t1, 3104($t0)
    sw $t1, 3228($t0)
    sw $t1, 3224($t0)
    sw $t1, 3220($t0)
    sw $t1, 3216($t0)
    sw $t1, 3084($t0)
    sw $t1, 2956($t0)
    sw $t1, 2828($t0)
    sw $t1, 2700($t0)
    sw $t1, 2572($t0)
    sw $t1, 2444($t0)
    sw $t1, 2316($t0)
    # V
    sw $t1, 2216($t0)
    sw $t1, 2344($t0)
    sw $t1, 2476($t0)
    sw $t1, 2604($t0)
    sw $t1, 2732($t0)
    sw $t1, 2864($t0)
    sw $t1, 2992($t0)
    sw $t1, 3124($t0)
    sw $t1, 3252($t0)
    sw $t1, 3000($t0)
    sw $t1, 2872($t0)
    sw $t1, 2748($t0)
    sw $t1, 2620($t0)
    sw $t1, 2492($t0)
    sw $t1, 2368($t0)
    sw $t1, 2240($t0)
    # E
    sw $t1, 2248($t0)
    sw $t1, 2252($t0)
    sw $t1, 2256($t0)
    sw $t1, 2260($t0)
    sw $t1, 2264($t0)
    sw $t1, 2764($t0)
    sw $t1, 2768($t0)
    sw $t1, 2772($t0)
    sw $t1, 2776($t0)
    sw $t1, 2376($t0)
    sw $t1, 2504($t0)
    sw $t1, 2632($t0)
    sw $t1, 2760($t0)
    sw $t1, 2888($t0)
    sw $t1, 3016($t0)
    sw $t1, 3144($t0)
    sw $t1, 3272($t0)
    sw $t1, 3276($t0)
    sw $t1, 3280($t0)
    sw $t1, 3284($t0)
    sw $t1, 3288($t0)
    # R
    sw $t1, 3300($t0)
    sw $t1, 3172($t0)
    sw $t1, 3044($t0)
    sw $t1, 2916($t0)
    sw $t1, 2788($t0)
    sw $t1, 2660($t0)
    sw $t1, 2532($t0)
    sw $t1, 2404($t0)
    sw $t1, 2276($t0)
    sw $t1, 2280($t0)
    sw $t1, 2284($t0)
    sw $t1, 2288($t0)
    sw $t1, 2420($t0)
    sw $t1, 2548($t0)
    sw $t1, 2676($t0)
    sw $t1, 2800($t0)
    sw $t1, 2796($t0)
    sw $t1, 2792($t0)
    sw $t1, 2932($t0)
    sw $t1, 3060($t0)
    sw $t1, 3188($t0)
    sw $t1, 3316($t0)
    
    jr $ra  # Return from subroutine

