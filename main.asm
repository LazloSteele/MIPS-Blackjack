					.data
					
player_hand_msg: 	.asciiz "\nPlayer Hand: "
dealer_hand_msg: 	.asciiz "\nDealer Hand: "
point_count_msg: 	.asciiz "\nTotal Point Count: "
action_prompt:		.asciiz "\nHit [0] or Stand [1] > "
blackjack:			.asciiz "\nBLACKJACK!"
bust:				.asciiz "\nBUST!"
win_msg:			.asciiz "\nYou win!"
lose_msg:			.asciiz "\nYou lose!"
push_msg:			.asciiz "\nPUSH!\nNobody wins..."
repeat_msg:			.asciiz "\nGo again? Y/N > "
invalid_msg:		.asciiz "\nInvalid input. Try again!\n"
bye: 				.asciiz "\nToodles! ;)"

_XX:				.asciiz "XX"

_AD:				.asciiz "AD"
_2D:				.asciiz "2D"
_3D:				.asciiz "3D"
_4D:				.asciiz "4D"
_5D:				.asciiz "5D"
_6D:				.asciiz "6D"
_7D:				.asciiz "7D"
_8D:				.asciiz "8D"
_9D:				.asciiz "9D"
_10D:				.asciiz "10D"
_JD:				.asciiz "JD"
_QD:				.asciiz "QD"
_KD:				.asciiz "KD"

_AC:				.asciiz "AC"
_2C:				.asciiz "2C"
_3C:				.asciiz "3C"
_4C:				.asciiz "4C"
_5C:				.asciiz "5C"
_6C:				.asciiz "6C"
_7C:				.asciiz "7C"
_8C:				.asciiz "8C"
_9C:				.asciiz "9C"
_10C:				.asciiz "10C"
_JC:				.asciiz "JC"
_QC:				.asciiz "QC"
_KC:				.asciiz "KC"

_AH:				.asciiz "AH"
_2H:				.asciiz "2H"
_3H:				.asciiz "3H"
_4H:				.asciiz "4H"
_5H:				.asciiz "5H"
_6H:				.asciiz "6H"
_7H:				.asciiz "7H"
_8H:				.asciiz "8H"
_9H:				.asciiz "9H"
_10H:				.asciiz "10H"
_JH:				.asciiz "JH"
_QH:				.asciiz "QH"
_KH:				.asciiz "KH"

_AS:				.asciiz "AS"
_2S:				.asciiz "2S"
_3S:				.asciiz "3S"
_4S:				.asciiz "4S"
_5S:				.asciiz "5S"
_6S:				.asciiz "6S"
_7S:				.asciiz "7S"
_8S:				.asciiz "8S"
_9S:				.asciiz "9S"
_10S:				.asciiz "10S"
_JS:				.asciiz "JS"
_QS:				.asciiz "QS"
_KS:				.asciiz "KS"

card_names:			.word 	_AD, _2D, _3D, _4D, _5D, _6D, _7D, _8D, _9D, _10D, _JD, _QD, _KD, 
							_AC, _2C, _3C, _4C, _5C, _6C, _7C, _8C, _9C, _10C, _JC, _QC, _KC, 
							_AH, _2H, _3H, _4H, _5H, _6H, _7H, _8H, _9H, _10H, _JH, _QH, _KH, 
							_AS, _2S, _3S, _4S, _5S, _6S, _7S, _8S, _9S, _10S, _JS, _QS, _KS
card_values:		.word	11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10,
							11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10,
							11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10,
							11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10
deck:				.word	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
							13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
							24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34,
							35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
							46, 47, 48, 49, 50, 51
deck_index:			.word	0
player_hand:		.space	44						# theoretical maximum hand size is 11 cards, 4 bytes per card
dealer_hand:		.space	44
player_cards:		.word	0
dealer_cards:		.word	0
player_score:		.word 	0
dealer_score:		.word	0
dealer_blind:		.word	1
buffer:				.space	2

					.globl		main
	
					.text
main:
	jal		fy_shuffle

	li		$a0, 0
	jal		draw
	li		$a0, 1
	jal		draw
	li		$a0, 0
	jal		draw
	li		$a0, 1
	jal		draw

	jal		check_blackjack

	li		$a0, 0
	jal		display_hand
	
	li		$a0, 1
	jal		display_hand

	jal		prompt_user_turn

	la		$t0, dealer_blind
	li		$t1, 0
	sw		$t1, 0($t0)

	li		$a0, 0
	jal		display_hand
	
	li		$a0, 1
	jal		display_hand
	
	la		$t0, player_score
	lw		$t0, 0($t0)
	la		$t1, dealer_score
	lw		$t1, 0($t1)
	
	beq		$t0, $t1, push
	bgt		$t0, $t1, player_win
	
	dealer_win:
		li		$v0, 4
		la		$a0, lose_msg
		syscall
		
		j		again

	player_win:
		li		$v0, 4
		la		$a0, win_msg
		syscall
	
		j		again

fy_shuffle:
	la		$t0, deck
	la		$t1, deck				# working copy for indexing
	
	get_random_generator:
		li		$v0, 30				# get time in milliseconds to use for seed
		syscall						#
								#
		move	$t2, $a0			# save the lower 32-bits of time
								#
		li		$a0, 1				# random generator 1
		move	$a1, $t2 			# seed is the time stored in $t1
		li		$v0, 40				# 
		syscall						# save generator

	li		$t6, 0
	li		$t7, 52
	shuffle_loop:					#
		li		$a0, 1				# load generator 1
		move	$a1, $t7			# random int from remaining cards
		li		$v0, 42				#
		syscall						# generate it for card index
		
		move	$t2, $a0			#
		addi	$t3, $t2, 1			# t2 for working index

		mul		$t2, $t2, 4
		move	$t1, $t0
		add		$t1, $t1, $t2		# go to card index
		lw		$t4, 0($t1)			# and pull that card		
		array_shift_loop:
			lw		$t5, 4($t1)
			sw		$t5, 0($t1)
			
			addi	$t1, $t1, 4
			addi	$t3, $t3, 1
			
			blt		$t3, 52, array_shift_loop
			
		sw		$t4, 0($t1)
		
		addi	$t6, $t6, 1
		addi	$t7, $t7, -1
		blt		$t6, 52, shuffle_loop
		
	jr		$ra

draw:
	la		$t0, deck					# get the deck
	la		$t1, deck_index				# where is the current top of the deck
	lw		$t2, 0($t1)					#
	mul		$t3, $t2, 4					# word offset
	add		$t0, $t0, $t3				# move to the top of the deck
	lw		$t0, 0($t0)					# draw that card
	addi	$t2, $t2, 1					# move top of deck
	sw		$t2, 0($t1)					# and store
										#	
	bnez	$a0, draw_dealer_hand		# if it's the dealers turn, go to the dealer
										#
	draw_player_hand:					# otherwise:
		la		$t1, player_hand		#
		la		$t2, player_cards		#
										#
		j		draw_card				#
	draw_dealer_hand:					#
		la		$t1, dealer_hand		#
		la		$t2, dealer_cards		#
										#
	draw_card:							#
		lw		$t3, 0($t2)				# get number of cards in hand
		mul		$t4, $t3, 4				# mult by 4 for word offset
										#
		add		$t1, $t1, $t4			# offset hand index by cards in hand
		sw		$t0, 0($t1)				# store the card index in hand
										#
		addi	$t3, $t3, 1				# iterate the number of cards in hand
		sw		$t3, 0($t2)				# and store the value
										#
		jr		$ra						#
										#
display_hand:
	move	$s0, $a0							# whose hand is it?
												#
	li		$t0, 0								# iterator for cards in hand
	li		$t5, 0								# for counting points
	li		$t8, 0								# number of aces
	bnez	$s0, display_dealer_hand
	
	display_player_hand:
		lw		$t1, player_cards
		la		$t2, player_hand
		la		$t7, player_score
				
		la		$a0, player_hand_msg
	
		j		display_loop
		
	display_dealer_hand:
		lw		$t1, dealer_cards
		la		$t2, dealer_hand
		la		$t7, dealer_score
		lw		$t9, dealer_blind
		
		la		$a0, dealer_hand_msg
	
	display_loop:
		addi	$t1, $t1, -1					# 0 based indexing
		li		$v0, 4
		syscall

		for_card_in_hand:
			beqz	$s0, not_blind_dealer
			beqz	$t9, not_blind_dealer
			bnez	$t0, not_blind_dealer
			
			la		$a0, _XX
			li		$v0, 4
			syscall

			j	normal_print			
			
			not_blind_dealer:
				lw		$t3, 0($t2)					# current card
				mul		$t3, $t3, 4					# word offset
													#
				la		$t4, card_names				# load table of card name pointers
				add		$t4, $t4, $t3				# move to index of current card
													#
				lw		$a0, 0($t4)					# load the address of the current card name pointer
				li		$v0, 4						#
				syscall								# and print the card
												#
				la		$t4, card_values			# load table of card value pointers
				add		$t4, $t4, $t3				# move to index of current card
												#
				lw		$t6, 0($t4)					# load the address of current card value pointer
				bne		$t6, 11, no_ace				# if not 11 then not an ace
				addi	$t8, $t8, 1					# add one ace to the hand count
												#
			no_ace:								#
				add		$t5, $t5, $t6			# add that to current entity score
												#
			normal_print:						#
				beq		$t0, $t1, display_done		# terminate here to avoid trailing ", "
												#
				li		$v0, 11					#
				li		$a0, ','					#
				syscall								#
				li		$a0, ' '					#
				syscall								#
												#
				addi	$t0, $t0, 1					# iterate the card counter
				addi	$t2, $t2, 4					# iterate the current card pointer address
												#
			j for_card_in_hand					# do the timewarp
												#
	display_done:								#												#
		ace_low_loop:							#
			ble		$t5, 21, no_ace_low			# if under 21 then no ace low
			beqz	$t8, no_ace_low				# if no aces then no ace low
												#
			addi	$t5, $t5, -10				# turn the ace 11 into a 1
			addi	$t8, $t8, -1				# one less ace to turn low in hand
												#
			j		ace_low_loop				#
												#
		no_ace_low:								#
			sw		$t5, 0($t7)					# store the score at the entities score address
												#
			la		$a0, point_count_msg		#
			li		$v0, 4						#
			syscall								#
												#
			move	$a0, $t5					#
			li		$v0, 1						#
			syscall								# print the score
												#												#
			jr		$ra							#
												#
prompt_user_turn:
	la		$a0, action_prompt
	li		$v0, 4
	syscall
	
	la		$a0, buffer
	li		$a1, 2
	li		$v0, 8
	syscall
	
	la		$t0, buffer
	lb		$t0, 0($t0)

	beq		$t0, '0', hit
	beq		$t0, '1', stand
	
	la		$a0, invalid_msg
	li		$v0, 4
	syscall
	
	j		prompt_user_turn
	
	hit:
		move	$s1, $ra
		li		$a0, 0
		jal		draw
		
		li		$a0, 0
		jal		display_hand
		
		la		$a0, player_score
		jal		check_bust
		bnez	$v0, player_bust
		
		move	$ra, $s1
		
		j		prompt_user_turn
		
	stand:
		jr		$ra

check_blackjack:
	li		$t0, 0
	li		$t1, 0
	
	la		$t2, player_hand				#
	li		$t3, 0							# player score
	
	player_check_blackjack:					
		lw		$t4, 0($t2)
		add		$t3, $t3, $t4
		lw		$t4, 4($t2)
		add		$t3, $t3, $t4
		seq		$t0, $t3, 21
				
	la		$t2, player_hand				#
	li		$t3, 0							# dealer score
	dealer_check_blackjack:
		lw		$t4, 0($t2)
		add		$t3, $t3, $t4
		lw		$t4, 4($t2)
		add		$t3, $t3, $t4
		seq		$t1, $t3, 21
	check_blackjack_done:
		bnez	$t0, player_blackjack
		bnez	$t1, dealer_blackjack
		
		jr		$ra
	push:
		li		$v0, 4
		la		$a0, push_msg
		syscall
		
		j		again
		
	player_blackjack:
		beq		$t0, $t1, push
		li		$v0, 4
		la		$a0, blackjack
		syscall

		la		$a0, win_msg
		syscall
		
		j		again
	
	dealer_blackjack:
		li		$t2, 0
		la		$t3, dealer_blind
		sw		$t2, 0($t3)
		
		li		$a0, 1
		move	$s0, $ra
		jal		display_hand
		move	$ra, $s0
	
		li		$v0, 4
		la		$a0, blackjack
		syscall

		la		$a0, lose_msg
		syscall
		
		j		again

check_bust:
	lw		$t0, 0($a0)
	li		$v0, 0
	
	ble		$t0, 21, check_done
	
	li		$v0, 1
	
	check_done:
		jr		$ra
		
player_bust:
	la		$a0, bust
	li		$v0, 4
	syscall
	
	la		$a0, lose_msg
	syscall
	
	j		again
	
dealer_bust:
	la		$a0, bust
	li		$v0, 4
	syscall
	
	la		$a0, win_msg
	syscall
	
	j		again
	
####################################################################################################
# macro: upper
# purpose: to make printing messages more eloquent
# registers used:
#	$t0 - string to check for upper case
#	$t1 - ascii 'a', 'A'-'Z' is all lower value than 'a'
# variables used:
#	%message - message to be printed
####################################################################################################		
upper:							#
	move $t0, $a0				# load the buffer address
	li $t1, 'a'					# lower case a to compare
	upper_loop:					#
		lb $t2, 0($t0)			# load next byte from buffer
		blt $t2, $t1, is_upper	# bypass uppercaserizer if character is already upper case (or invalid)
		to_upper:				# 
			subi $t2, $t2, 32	# Convert to uppercase (ASCII difference between 'a' and 'A' is 32)
		is_upper:				#
			sb $t2, 0($t0)		# store byte
		addi $t0, $t0, 1		# next byte
		bne $t2, 0, upper_loop	# if not end of buffer go again!
	jr $ra						#
								#
####################################################################################################
# function: again
# purpose: to user to repeat or close the program
# registers used:
#	$v0 - syscall codes
#	$a0 - message storage for print and buffer storage
#	$t0 - stores the memory address of the buffer and first character of the input received
#	$t1 - ascii 'a', 'Y', and 'N'
####################################################################################################
again:							#		
	la $a0, repeat_msg			#
	li $v0, 4					#
	syscall						#
								#
	la $a0, buffer				#
	la $a1, 2					#
	li $v0, 8					#
	syscall						#
								#
	la $a0, buffer				#
	jal upper					# load the buffer for string manipulation
								#
	la $t0, buffer				#
	lb $t0, 0($t0)				#
	li $t1, 'Y'					# store the value of ASCII 'Y' for comparison
	beq $t0, $t1, reenter		# If yes, go back to the start of main
	li $t1, 'N'					# store the value of ASCII 'N' for comparison
	beq $t0, $t1, end			# If no, goodbye!
								#
	again_invalid:				#
		la $a0, invalid_msg		#
		li $v0, 4				#
		syscall					#
								#
		j again					#
								#
####################################################################################################
# function: reenter
# purpose: to clear program to default values for re-entry
# registers used:
#	$v0 - syscall codes
#	$a0 - message addresses
####################################################################################################	
reenter:									#
	la		$t0, dealer_blind
	li		$t1, 1
	sw		$t1, 0($t0)

	la		$t0, deck_index
	li		$t1, 0
	sw		$t1, 0($t0)
	
	la		$t0, player_cards
	sw		$t1, 0($t0)
	la		$t0, player_score
	sw		$t1, 0($t0)
	
	la		$t0, dealer_cards
	sw		$t1, 0($t0)
	la		$t0, dealer_score
	sw		$t1, 0($t0)
	
	li		$t2, 0
	la		$t3, player_hand
	la		$t4, dealer_hand
	reset_hands:
		sw		$t1, 0($t3)
		sw		$t1, 0($t4)
		
		addi	$t3, $t3, 4
		addi	$t4, $t4, 4
		
		addi	$t2, $t2, 1
		
		blt		$t2, 11, reset_hands
	
	j	main								# truly do the timewarp again
											#
####################################################################################################
# function: end
# purpose: to eloquently terminate the program
# registers used:
#	$v0 - syscall codes
#	$a0 - message addresses
####################################################################################################	
end:	 					#
	la		$a0, bye		#
	li		$v0, 4			#
	syscall					#
							#
	li 		$v0, 10			# system call code for returning control to system
	syscall					# GOODBYE!
							#
####################################################################################################	

