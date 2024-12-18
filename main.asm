# Class Final: Blackjack
# Author: Lazlo F. Steele
# Due Date : Dec. 7, 2024 Course: CSC2025-2H1
# Created: Nov. 25, 2024
# Last Modified: Dec. 1, 2024
# Functional Description: Play Blackjack.
# Language/Architecture: MIPS 32 Assembly
####################################################################################################
# Algorithmic Description:
#	welcome user
#
#	shuffle deck (fisher-yates algorithm):
#		for n in deck.length():
#			x = 51 - n
#			i = random integer from 0-x
#			card = value of deck[i]
#			for cards from deck[i]-deck[51]:
#				deck[i] = deck[i+1]
#			deck[51] = card
#
#	deal card to player
#	deal card to dealer
#	deal card to player
#	deal card to dealer
#
#	if only player has a score of 21:
#		player wins
#	if only dealer has a score of 21:
#		dealer wins
#	if both have a score of 21: 
#		push and prompt to play again?
#
#	while player has not busted (gone over a score of 21):
#		display game state
#		prompt for hit/stand
#		if hit:
#			draw card
#			display game state
#			check for bust
#		else:	
#			proceed to dealer turn
#
#	if dealer has not busted and is under 17:
#		display unblinded dealer hand
#		draw card
#		check for bust
#	
#	if player score > dealer score:
#		player wins
#		play again?
#	if player score < dealer score:
#		dealer wins
#		play again?
#	if player score == dealer score:
#		push
#		play again?
####################################################################################################

					.data
welcome_msg:		.asciiz "I am the blackjacker! Prepare to be jacked!\n\nGet as close to 21 as possible without busting!\nShuffling may take a second..."					
player_hand_msg: 	.asciiz "\n\nPlayer Hand: "
dealer_hand_msg: 	.asciiz "\n\nDealer Hand: "
point_count_msg: 	.asciiz "\nTotal Point Count: "
action_prompt:		.asciiz "\nHit [0] or Stand [1] > "
dealer_hits:		.asciiz "\nDealer hits..."
dealer_stands:		.asciiz "\nDealer stands..."
blackjack:			.asciiz "\n\nBLACKJACK!"
bust:				.asciiz "\n\nBUST!"
win_msg:			.asciiz "\nYou win!"
lose_msg:			.asciiz "\nYou lose!"
push_msg:			.asciiz "\n\nPUSH!\nNobody wins..."
repeat_msg:			.asciiz "\n\nGo again? Y/N > "
invalid_msg:		.asciiz "\nInvalid input. Try again!\n"
bye: 				.asciiz "\n\nToodles! ;)"

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

					.align	2
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
player_hand:		.space	44	# theoretical maximum hand size is 11 cards, 4 bytes per card
dealer_hand:		.space	44
player_cards:		.word	0	# number of cards in hand
dealer_cards:		.word	0
player_score:		.word 	0
dealer_score:		.word	0
dealer_blind:		.word	1	# dealer starts by displaying blind (one card face down)
buffer:				.space	2

					.globl		main

					.text
####################################################################################################
# function: main
# purpose: to control program flow
# registers used:
#	$a0 - player = 0, dealer = 1
####################################################################################################
main:								#
	jal		welcome					# welcome the user
									#
	jal		fy_shuffle				# fisher yates shuffle algorithm
									#
	li		$a0, 0					# pass player as argument 
	jal		draw					# draw card
	li		$a0, 1					# pass dealer as argument
	jal		draw					# draw card
	li		$a0, 0					# player draw
	jal		draw					#
	li		$a0, 1					# dealer draw
	jal		draw					#
									#
	jal		check_blackjack			# does anybody have 21 points?
									#
	li		$a0, 0					# pass player as argument
	jal		display_hand			# show player hand
									#
	li		$a0, 1					# pass dealer as argument
	jal		display_hand			# show dealer hand
									#
	jal		prompt_user_turn		# player turn
									#
	jal		dealer_turn				# dealer turn
									#
	jal		check_score				# who won?
									#
####################################################################################################
# function: check_score
# purpose: to check for who won
# registers used:
#	$a0 - player/dealer, and messages for print
#	$v0 - syscall codes
#	$t0 - player score
#	$t1 - dealer score
####################################################################################################
check_score:						# 
	li		$a0, 0					# 
	jal		display_hand			# display player hand
									#
	li		$a0, 1					#
	jal		display_hand			# display dealer hand
									#
	la		$t0, player_score		#
	lw		$t0, 0($t0)				# get player score
	la		$t1, dealer_score		#
	lw		$t1, 0($t1)				# get dealer score
									#
	beq		$t0, $t1, push			# if player score == dealer score then push
	bgt		$t0, $t1, player_win	# if player score > dealer score then player wins
									#
	dealer_win:						# otherwise:
		li		$v0, 4				#
		la		$a0, lose_msg		#
		syscall						# player loses
									#
		j		again				#
									#
	player_win:						#
		li		$v0, 4				#
		la		$a0, win_msg		#
		syscall						#
									#
		j		again				#
									#
####################################################################################################
# function: fy_shuffle
# purpose: a fisher-yates shuffling algorithm
# registers used:
#	$a0 - arguments for prng
#	$v0 - syscall codes
#	$t0 - deck
#	$t1 - working copy of deck
#	$t2 - random card index
#	$t3 - working index in deck
#	$t4 - random card value
#	$t5 - next card in deck
#	$t6 - iterator for deck
#	$t7 - negative offset for random number generation
####################################################################################################									
fy_shuffle:										#
	la		$t0, deck							# deck
	la		$t1, deck							# working copy for indexing
												#
	get_random_generator:						#
		li		$v0, 30							# get time in milliseconds to use for seed
		syscall									#
												#
		move	$t2, $a0						# save the lower 32-bits of time
												#
		li		$a0, 1							# random generator 1
		move	$a1, $t2 						# seed is the time stored in $t1
		li		$v0, 40							# 
		syscall									# save generator
												#
	li		$t6, 0								# iterator for deck size
	li		$t7, 52								# offset for random generation
	shuffle_loop:								#
		li		$a0, 1							# load generator 1
		move	$a1, $t7						# random int from remaining cards
		li		$v0, 42							#
		syscall									# generate it for card index
												#
		move	$t2, $a0						#
		addi	$t3, $t2, 1						# t2 for working index
												#
		mul		$t2, $t2, 4						# multiply index by four for word offset
		move	$t1, $t0						# load the deck
		add		$t1, $t1, $t2					# go to card index
		lw		$t4, 0($t1)						# and pull that card		
		array_shift_loop:						#
			lw		$t5, 4($t1)					# go to next card
			sw		$t5, 0($t1)					# and move it down the deck
												#
			addi	$t1, $t1, 4					# iterate the deck index
			addi	$t3, $t3, 1					# iterate the iterator
												#
			blt		$t3, 52, array_shift_loop	# and if it has not reached the end of the deck then recurse
												#
		sw		$t4, 0($t1)						# then put the drawn card at the end of the deck
												#
		addi	$t6, $t6, 1						# iterate the iterator
		addi	$t7, $t7, -1					# iterate down the remaining cards to shuffle
		blt		$t6, 52, shuffle_loop			# if you have not shuffled all cards then recurse!
												#
	jr		$ra									#
												#
####################################################################################################
# function: draw
# purpose: to draw a card
# registers used:
#	$a0 - player/dealer
#	$t0 - deck address, drawn card
#	$t1 - deck index address, hand address
#	$t2 - index value for current top of the deck, number of cards address
#	$t3 - index value multiplied by four for word offset, number of cards in hand
#	$t4 - number of cards multiplied by four for word offset
#	$ra	- return address
####################################################################################################
draw:									#
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
####################################################################################################
# function: display_hand
# purpose: to display cards in hands
# registers used:
#	$a0 - player or dealer?
#	$t0 - iterator for cards in hand
#	$t1 - cards in hand
#	$t2 - hand address
#	$t3 - current card
#	$t4 - card value table and display table addresses
#	$t5 - working score
#	$t6 - current card value
#	$t7 - score address
#	$t8 - number of aces found in hand
#	$t9 - display dealer as blind (first card face down)? 0: No, 1: Yes
#	$s0 - player or dealer, saved
####################################################################################################										
display_hand:									#
	move	$s0, $a0							# whose hand is it?
												#
	li		$t0, 0								# iterator for cards in hand
	li		$t5, 0								# for counting points
	li		$t8, 0								# number of aces
	bnez	$s0, display_dealer_hand			#
												#
	display_player_hand:						# load:
		lw		$t1, player_cards				#	player card count
		la		$t2, player_hand				#	player hand
		la		$t7, player_score				#	player score
												#
		la		$a0, player_hand_msg			#	player hand message
												#
		j		display_loop					#
												#
	display_dealer_hand:						# load:
		lw		$t1, dealer_cards				#	the same for the dealer plus...
		la		$t2, dealer_hand				#
		la		$t7, dealer_score				#
		lw		$t9, dealer_blind				#	if the dealer is displaying blind (first card face down)
												#
		la		$a0, dealer_hand_msg			#
												#
	display_loop:								#
		addi	$t1, $t1, -1					# 0 based indexing
		li		$v0, 4							#
		syscall									# display whose hand it is
												#
		for_card_in_hand:						#
			beqz	$s0, not_blind_dealer		# if player then not blind dealer
			beqz	$t9, not_blind_dealer		# if dealer not blind then not blind dealer
			bnez	$t0, not_blind_dealer		# if not first card then not blind dealer
												#
			la		$a0, _XX					#
			li		$v0, 4						#
			syscall								# print first card as "XX" for blind
												#
			j	normal_print					#
												#
			not_blind_dealer:					#
				lw		$t3, 0($t2)				# current card
				mul		$t3, $t3, 4				# word offset
												#
				la		$t4, card_names			# load table of card name pointers
				add		$t4, $t4, $t3			# move to index of current card
												#
				lw		$a0, 0($t4)				# load the address of the current card name pointer
				li		$v0, 4					#
				syscall							# and print the card
												#
				la		$t4, card_values		# load table of card value pointers
				add		$t4, $t4, $t3			# move to index of current card
												#
				lw		$t6, 0($t4)				# load the address of current card value pointer
				bne		$t6, 11, no_ace			# if not 11 then not an ace
				addi	$t8, $t8, 1				# add one ace to the hand count
												#
			no_ace:								#
				add		$t5, $t5, $t6			# add that to current entity score
												#
			normal_print:						#
				beq		$t0, $t1, display_done	# terminate here to avoid trailing ", "
												#
				li		$v0, 11					#
				li		$a0, ','				#
				syscall							#
				li		$a0, ' '				#
				syscall							#
												#
				addi	$t0, $t0, 1				# iterate the card counter
				addi	$t2, $t2, 4				# iterate the current card pointer address
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
####################################################################################################
# function: prompt_user_turn
# purpose: to handle player turn
# registers used:
#	$a0 - arguments
#	$a1 - arguments
#	$v0 - syscall codes and return values
#	$t0 - player turn value
#	$s1 - saved return address
#	$ra - return address
####################################################################################################
prompt_user_turn:					#
	la		$a0, action_prompt		#
	li		$v0, 4					#
	syscall							# print the action prompt
									#
	la		$a0, buffer				#
	li		$a1, 2					#
	li		$v0, 8					#
	syscall							# read string input
									#
	la		$t0, buffer				#
	lb		$t0, 0($t0)				# load the inputted value
									#
	beq		$t0, '0', hit			# if value is 0 hit
	beq		$t0, '1', stand			# if value is 1 stand
									#
	la		$a0, invalid_msg		#
	li		$v0, 4					#
	syscall							# otherwise display invalid input
									#
	j		prompt_user_turn		# and try again
									#
	hit:							#
		move	$s1, $ra			# save return addres 
		li		$a0, 0				# load player flag
		jal		draw				# and draw
									#
		li		$a0, 0				# load player flag
		jal		display_hand		# and show hand
									#
		la		$a0, player_score	#
		jal		check_bust			# did player bust (go over 21 points)
		move	$ra, $s1			# restore return address
		bnez	$v0, player_bust	# if bust flag true then player busted
									#
									#
		j		prompt_user_turn	# go again
									#
	stand:							#
		jr		$ra					# if stand, return to caller
									#
####################################################################################################
# function: dealer_turn
# purpose: to handle the dealer turn
# registers used:
#	$a0 - arguments
#	$v0 - syscall codes and return values
#	$t0 - card value
#	$s1 - saved return address
#	$ra - return address
####################################################################################################
dealer_turn:						#
	la		$t0, dealer_blind		# 
	li		$t1, 0					#
	sw		$t1, 0($t0)				# dealer_blind = false
									#
	li $v0, 32						# 
	li $a0, 1000					#
	syscall							# pause for effect
									#
	move	$s1, $ra				#
	li		$a0, 1					#
	jal		display_hand			# show the dealer hand
	move	$ra, $s1				#
									#
	la		$t0, dealer_score		#
	lw		$t0, 0($t0)				# get the dealer score
									#
	move	$s1, $ra				#
	la		$a0, dealer_score		#
	jal		check_bust				# did the dealer bust?
	move	$ra, $s1				#
	bnez	$v0, dealer_bust		#
									#
									#
	li $v0, 32						# 
	li $a0, 1000					#
	syscall							# pause for effect
									#
									#
	bge		$t0, 17, dealer_stand	# if the score >= 17 stand
									#
	li		$v0, 4					#
	la		$a0, dealer_hits		#
	syscall							# dealer hits message
									#
	move	$s1, $ra				#
	li		$a0, 1					#
	jal		draw					# dealer draws
	move	$ra, $s1				#
									#
									#
									#
	j		dealer_turn				# and go again
									#
	dealer_stand:					#
		li		$v0, 4				#
		la		$a0, dealer_stands	#
		syscall						# dealer stands message
									#
		jr		$ra					# return to caller
									#
####################################################################################################
# function: check_blackjack
# purpose: did anybody get dealt 21 on the opening hand?
# registers used:
#	$t0 - player blackjack
#	$t1 - dealer blackjack
#	$t2 - player/dealer hand
#	$t3 - player/dealer score
#	$t4 - current card
#	$t5 - card value
####################################################################################################
check_blackjack:							#
	li		$t0, 0							# player blackjack flag
	li		$t1, 0							# dealer blackjack flag
											#
	la		$t2, player_hand				#
	lw		$t3, player_score				# player score
	player_check_blackjack:					#
		lw		$t4, 0($t2)					# get card		
		mul		$t4, $t4, 4					#
											#
		la		$t5, card_values			#
		add		$t5, $t5, $t4				# get value of card
		lw		$t5, 0($t5)					#
											#
		add		$t3, $t3, $t5				# add to point total
											#
		lw		$t4, 4($t2)					# get second card
		mul		$t4, $t4, 4					#
											#
		la		$t5, card_values			#
		add		$t5, $t5, $t4				# get value of card
		lw		$t5, 0($t5)					#
											#
		add		$t3, $t3, $t5				# add to point total
											#
		seq		$t0, $t3, 21				# if 21, then blackjack
											#
	la		$t2, dealer_hand				#
	lw		$t3, dealer_score				# dealer score
	dealer_check_blackjack:					#
		lw		$t4, 0($t2)					#
		mul		$t4, $t4, 4					#
											#
		la		$t5, card_values			#
		add		$t5, $t5, $t4				# get value of card
		lw		$t5, 0($t5)					#
											#
		add		$t3, $t3, $t5				# add to point total
											#
		lw		$t4, 4($t2)					#
		mul		$t4, $t4, 4					#
											#
		la		$t5, card_values			#
		add		$t5, $t5, $t4				# get value of card
		lw		$t5, 0($t5)					#
											#
		add		$t3, $t3, $t5				# add to point total
											#
		seq		$t1, $t3, 21				#
	check_blackjack_done:					#
		bnez	$t0, player_blackjack		#
		bnez	$t1, dealer_blackjack		#
											#
		jr		$ra							#
	push:									#
		li		$v0, 4						#
		la		$a0, push_msg				#
		syscall								# it's a tie!
											#
		j		again						#
											#
	player_blackjack:						#
		beq		$t0, $t1, push				#
		li		$v0, 4						#
		la		$a0, blackjack				#
		syscall								# print blackjack
											#
		la		$a0, win_msg				#
		syscall								# player wins!
											#
		j		again						# play again?
											#
	dealer_blackjack:						#
		li		$t2, 0						#
		la		$t3, dealer_blind			#
		sw		$t2, 0($t3)					# dealer_blind = false
											#
		li		$a0, 1						#
		move	$s0, $ra					#
		jal		display_hand				# show dealer hand
		move	$ra, $s0					#
											#
		li		$v0, 4						#
		la		$a0, blackjack				#
		syscall								# print blackjack
											#
		la		$a0, lose_msg				#
		syscall								# player loses
											#
		j		again						# play again?
											#
####################################################################################################
# function: check_bust
# purpose: did somebody go over 21?
# registers used:
#	$a0 - score argument
#	$v0 - bust flag
#	$t0 - score
####################################################################################################
check_bust:							#
	lw		$t0, 0($a0)				# move score
	li		$v0, 0					# set bust flag to false
									#
	ble		$t0, 21, check_done		# if the score is less than or equal to 21 then return
									#
	li		$v0, 1					# else raise flag and return
									#
	check_done:						#
		jr		$ra					#
									#
####################################################################################################
# function: player_bust
# purpose: display loss message
# registers used:
####################################################################################################
player_bust:						#
	la		$a0, bust				#
	li		$v0, 4					#
	syscall							# print bust
									#
	la		$a0, lose_msg			#
	syscall							# print player loses
									#
	j		again					# play again?
									#
####################################################################################################
# function: dealer_bust
# purpose: display win message
# registers used:
####################################################################################################
dealer_bust:						#
	la		$a0, bust				#
	li		$v0, 4					#
	syscall							# print bust
									#
	la		$a0, win_msg			# print player wins	
	syscall							#
									#
	j		again					# play again?
									#
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
# function: welcome
# purpose: to welcome the user to our program
# registers used:
#	$v0 - syscall codes
#	$a0 - passing arugments to subroutines
#	$ra	- return address
####################################################################################################	
welcome:							# 
	la	$a0, welcome_msg			# load welcome message
	li	$v0, 4						# 
	syscall							# and print
									#
	jr	$ra							# return to caller
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

