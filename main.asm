					.data
					
player_hand_msg: 	.asciiz "\nPlayer Hand: "
dealer_hand_msg: 	.asciiz "\nDealer Hand: "
point_count_msg: 	.asciiz "\nTotal Point Count: "
action_prompt:		.asciiz "\nHit [0] or Stand [1] > " 

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
buffer:				.space	2

					.globl		main
	
					.text
main:
	li		$a0, 0
	jal		draw
	li		$a0, 1
	jal		draw
	li		$a0, 0
	jal		draw
	li		$a0, 1
	jal		draw


	li		$a0, 0
	jal		display_hand
	
	li		$a0, 1
	jal		display_hand


	li $v0, 10
	syscall
	
draw:
	la		$t0, deck					# get the deck
	la		$t1, deck_index				# where is the current top of the deck
	lw		$t2, 0($t1)
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
	li		$t0, 0								# iterator for cards in hand
	li		$t5, 0								# for counting points
	bnez	$a0, display_dealer_hand
	
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
		
		la		$a0, dealer_hand_msg
	
	display_loop:
		addi	$t1, $t1, -1					# 0 based indexing
		li		$v0, 4
		syscall

		for_card_in_hand:
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
			add		$t5, $t5, $t6				# add that to current entity score
												#
			beq		$t0, $t1, display_done		# terminate here to avoid trailing ", "
												#
			li		$v0, 11						#
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
	display_done:								#
		sw		$t5, 0($t7)						# store the score at the entities score address
												#
		la		$a0, point_count_msg			#
		li		$v0, 4							#
		syscall									#
												#
		move	$a0, $t5						#
		li		$v0, 1							#
		syscall									# print the score
												#
		jr		$ra								#
												#
count_points:
	li		$t0, 0
	