/*GUESS YOUR OPPONENT's NUMBER */

/* USER MANUAL */

/*
Press Button-3 to begin.
Player-1 enters the number using buttons 1 and 0.(button 1 for ten's button 0 for one's).
Player-1 enters that number with button 3.(save)
Player-2 enters the number prediction using the button-1 and button-0.
Player-2 can use hint with button-2.
Player-2 can use at most 10 hints.Player-1 earns points as Player-2 uses hints.
Player-2 sends the final prediction with Button-3.
SCORE IS DISPLAYED ON FINISH SCREEN.
Player2 tries to complete the game in a certain time. When the time is over, the score screen appears.
The game can be restarted by pressing button 3 on the Finish screen.
The game is closed by pressing button 2 on the Finish screen.

IMPORTANT-If lose / win appears on the screen, the score is displayed by pressing button0.

*/

.global _start
 _start:

	LDR R0, =0xFF200020 // 7 SEGMENT LEDS 0-4
	LDR R1, =0xFF200030 // 7 SEGMENT LEDS 4+
	LDR R2, =0xFF200050 // BUTTON ADRESS


	LDR R11, =0x6d78     // "St" word shown in the first two leds
	LDR R12, =0x77507800 // "Art" word shown in the leds 3-4-5

	STR R11, [R1] //SHOW "St" IN LEDS 1-2
	STR R12, [R0] //SHOW "Art" IN LEDS 3-4-5

	LDR R3,[R2] //INPUT FROM BUTTONS
	LDR R9, =600000 // TIMER 
	MOV R4,#0 //SCORE

START_SCREEN:
	LDR R3,[R2]
	CMP R3,#8
	BEQ START_SCREEN_CONTROL
B START_SCREEN


START_SCREEN_CONTROL:
	LDR R3,[R2] // BUTONDAN GELENI R3E ATTIK
	CMP R3,#0
	BEQ FIRST_PLAYER
B START_SCREEN_CONTROL


SECOND_PLAYER_CONTROL:
LDR R12,=0x00000000
STR R12,[R0]
LDR R3,[R2] // BUTONDAN GELENI R3E ATTIK
CMP R3,#0

BLEQ SECOND_PLAYER
B SECOND_PLAYER_CONTROL



FINISH_SCREEN: //RESULT
	LDR R3,[R2]//input from buttons
	
	LDR R11, =0x6D39 //"SC" word
	/*DECIMAL TO HEX (FOR SCORE) */
	CMP R4,#0
	MOVEQ R12, #0x3F
	CMP R4,#1
	MOVEQ R12, #0x06
	CMP R4,#2
	MOVEQ R12, #0x5B
	CMP R4,#3
	MOVEQ R12, #0x4F
	CMP R4,#4
	MOVEQ R12, #0x66
	CMP R4,#5
	MOVEQ R12, #0x6D
	CMP R4,#6
	MOVEQ R12, #0x7D
	CMP R4,#7
	MOVEQ R12, #0x07
	CMP R4,#8
	MOVEQ R12, #0x7F
	CMP R4,#9
	MOVEQ R12, #0x6F
	
	LDR R10, =0x500600 //"r1" word for complate SCR1

	LSL R10,R10,#8 // move one left index on led
	ADD R12,R10,R12 // add with score and show

	STR R12,[R0] //display "sc" word
	STR R11,[R1] //display "r1" word and score
	

	CMP R3,#8  // Press button 3 for play again
	MOVEQ R5,#0
	MOVEQ R6,#0
	MOVEQ R7,#0
	MOVEQ R8,#0
	MOVEQ R9,#0
	BEQ _start
	
	CMP R3,#4 // Press button 2 for close the game
	BEQ end
	
	
B FINISH_SCREEN




FIRST_PLAYER:

LDR R3,[R2] //input from buttons
LDR R11,=0x7306 //"P1" word for show on leds.
STR R11, [R1] //display the word

CMP R3,#1  // if first player press button-0 add 1 to unit digit.
BLEQ ADD_ONE_UNIT // add 1 to unit digit if eq.
CMP R3,#2 // if first player press button-0 add 1 to tens digit. 
BLEQ ADD_ONE_TENS // add 1 to tens digit if eq.

STR R12, [R0] //show input numbers on leds.(last 4 led from led) 
		
		/*DECIMAL TO HEX ONES */
		CMP R5,#0
		MOVEQ R10, #0x3F
		CMP R5,#1
		MOVEQ R10, #0x06
		CMP R5,#2
		MOVEQ R10, #0x5B
		CMP R5,#3
		MOVEQ R10, #0x4F
		CMP R5,#4
		MOVEQ R10, #0x66
		CMP R5,#5
		MOVEQ R10, #0x6D
		CMP R5,#6
		MOVEQ R10, #0x7D
		CMP R5,#7
		MOVEQ R10, #0x07
		CMP R5,#8
		MOVEQ R10, #0x7F
		CMP R5,#9
		MOVEQ R10, #0x6F
		
		/*DECIMAL TO HEX TENS DIGIT*/
		CMP R6,#0
		MOVEQ R12, #0x3F
		CMP R6,#1
		MOVEQ R12, #0x06
		CMP R6,#2
		MOVEQ R12, #0x5B
		CMP R6,#3
		MOVEQ R12, #0x4F
		CMP R6,#4
		MOVEQ R12, #0x66
		CMP R6,#5
		MOVEQ R12, #0x6D
		CMP R6,#6
		MOVEQ R12, #0x7D
		CMP R6,#7
		MOVEQ R12, #0x07
		CMP R6,#8
		MOVEQ R12, #0x7F
		CMP R6,#9
		MOVEQ R12, #0x6F
	// NEED LEF SHIFT FOR ADD EACH OTHER AND SHOW ON LEDS	
	LSL R12,R12,#16 // shift and move to third index on leds(actually this hex code convert eg.0x--0000)
	LSL R10,R10,#8  // shift and move to second index on leds(actually this hex code convert eg.0x++00)
	ADD R12,R12,R10 // add them for display(0x--0000 + 0x++00 -> 0x--++00 (-- means r12's hex ++ means r10's). 

	CMP R3,#8 //If button-3 is pressed, the player changes to 2.
	BLEQ SECOND_PLAYER_CONTROL //for get correct button input and control it

B FIRST_PLAYER




SECOND_PLAYER:

	CMP R9,#0 // control time
	BEQ FINISH_SCREEN // if time is up,finish and show score
	SUBNE R9,R9,#1 // decrease 1 until the R9(timer) is 0


	LDR R3,[R2]//input from buttons

	LDR R11,=0x735B //"P2" word
	STR R11, [R1] //show "P2" word

	CMP R3,#1 // if player-2 press button-0 add 1 to unit digit.
	BLEQ ADD_ONE_UNIT_P2 // add 1 to unit digit if eq.
	CMP R3,#2 // if player-2 press button-1 add 1 to tens digit.
	BLEQ ADD_ONE_TENS_P2

			/*DECIMAL TO HEX TENS DIGIT*/
			CMP R7,#0
			MOVEQ R10, #0x3F
			CMP R7,#1
			MOVEQ R10, #0x06
			CMP R7,#2
			MOVEQ R10, #0x5B
			CMP R7,#3
			MOVEQ R10, #0x4F
			CMP R7,#4
			MOVEQ R10, #0x66
			CMP R7,#5
			MOVEQ R10, #0x6D
			CMP R7,#6
			MOVEQ R10, #0x7D
			CMP R7,#7
			MOVEQ R10, #0x07
			CMP R7,#8
			MOVEQ R10, #0x7F
			CMP R7,#9
			MOVEQ R10, #0x6F
			
			/*DECIMAL TO HEX TENS DIGIT*/
			CMP R8,#0
			MOVEQ R12, #0x3F
			CMP R8,#1
			MOVEQ R12, #0x06
			CMP R8,#2
			MOVEQ R12, #0x5B
			CMP R8,#3
			MOVEQ R12, #0x4F
			CMP R8,#4
			MOVEQ R12, #0x66
			CMP R8,#5
			MOVEQ R12, #0x6D
			CMP R8,#6
			MOVEQ R12, #0x7D
			CMP R8,#7
			MOVEQ R12, #0x07
			CMP R8,#8
			MOVEQ R12, #0x7F
			CMP R8,#9
			MOVEQ R12, #0x6F


		LSL R12,R12,#16 // shift and move to third index on leds(actually this hex code convert eg.0x--0000)
		LSL R10,R10,#8  // shift and move to second index on leds(actually this hex code convert eg.0x++00)
		ADD R12,R12,R10 // add them for display(0x--0000 + 0x++00 -> 0x--++00 (-- means r12's hex ++ means r10's). 
		STR R12, [R0] //show input numbers on leds.(last 4 led from led) 

		CMP R3,#4 // if player-2 press button 2 for use hint
		ADDEQ R4,R4,#1 //increase 1 player1's score 
		BLEQ HINT //branch hint(the return is provided to another subroutines too) 

		CMP R3,#8  // if player-2 press button 3 and send guess
		BEQ FINAL_GUESS // branch compare (no return)


B SECOND_PLAYER


HINT:
	CMP R9,#0 // control time
	BEQ FINISH_SCREEN // if time is up,finish and show score
	SUBNE R9,R9,#1 // decrease 1 until the R9(timer) is 0

	 LDR R3,[R2]//input from buttons
	 CMP R3,#0  // return control (for press than pull,in pull case r3=0 )
	 BXEQ LR // for return second_player
	 
	 CMP R6,R8 // compare tens digit player-1's and player-2's
	 LDRGT R12,=0x383f3e3e // "LOW" word,if player-1's tens digit > player-2's tens digit
	 STRGT R12, [R0] // display the word on leds

	 CMP R6,R8 // compare tens digit player-1's and player-2's
	 LDRLT R12,=0x007c303d // "BIG" word,f player-1's tens digit < player-2's tens digit
	 STRLT R12, [R0] // display the word on leds


	 CMP R6,R8 // compare tens digit player-1's and player-2's
	 BLEQ UNIT_CHECK_HINT


	 CMP R4,#10 // player-2 can use hint up to 10 
	 MOVEQ R4,#0 // if use 10 hint,r4 update
	 BEQ FINISH_SCREEN

 B HINT
 
/*COMPARE WHEN TENS DIGITS ARE EQUAL*/ 
UNIT_CHECK_HINT:
 CMP R9,#0 // control time
 BEQ FINISH_SCREEN // if time is up,finish and show score
 SUBNE R9,R9,#1 // decrease 1 until the R9(timer) is 0


 LDR R3,[R2] //input from buttons
 CMP R3,#1 // when guess is true player-2 can return finish screen with button-0
 BEQ FINISH_SCREEN

 CMP R5,R7 // compare unit digit player-1's and player-2's
 LDRGT R12,=0x383f3e3e // "LOW" word,if player-1's unit digit > player-2's unit digit
 STRGT R12, [R0] //display the word
 BXGT LR // return back for return second_player	
 
 CMP R5,R7  // compare unit digit player-1's and player-2's
 LDRLT R12,=0x007c303d // "BIG" word,if player-1's unit digit < player-2's unit digit
 STRLT R12, [R0]//display the word
 BXLT LR // return back for return second_player	
 
 CMP R5,R7 //
 LDREQ R12,=0x78501C79 //"TRUE" word,if unit and tens digits are equal eg.10 = 10
 STREQ R12, [R0] //BUTTON adress for get value
 BEQ UNIT_CHECK_HINT
 
 
/*COMPARE WHEN TENS DIGITS ARE EQUAL*/ 
UNIT_CHECK_COMPERE:
	LDR R3,[R2] //input from buttons
	CMP R3,#1 // return finish screen with button-0
	BEQ FINISH_SCREEN


	CMP R5,R7 // compare unit digits final guess and player-1's number 
	LDRNE R12,=0x383f6d79 // "LOSE" word,if final guess not equal to player-1's number
	STRNE R12, [R0] //display the word 
	BNE UNIT_CHECK_COMPERE  //display the word 


	CMP R5,R7 // compare unit digits final guess and player-1's number
	LDREQ R12,=0x3E3E3054 // "WIN" word,if final guess equal to player-1's number
	STREQ R12, [R0] //display the word 
	BEQ UNIT_CHECK_COMPERE  //display the word 

/*IN FINAL GUESS COMPARE TEN DIGITS IF THESE ARE NOT EQUAL FINAL GUESS IS FALSE IF THESE ARE EQUAL CHECK UNITS*/
FINAL_GUESS:

	 LDR R3,[R2] //input from buttons
	 CMP R3,#1 // return finish screen with button-0
	 BLEQ FINISH_SCREEN 

	 CMP R6,R8 // compare TENS digits final guess and player-1's number
	 LDRNE R12,=0x383f6d79  // "LOSE" word,if final guess not equal to player-1's number 
	 STRNE R12, [R0] //display the word 
	 BNE FINAL_GUESS 

	 CMP R6,R8 // compare TENS digits final guess and player-1's number
	 BLEQ UNIT_CHECK_COMPERE // if tens are not equeal compare units.

ADD_ONE_UNIT:
	LDR R3,[R2] //input from buttons

	CMPEQ R3,#0 // check,does player-1 press button0 than pull
	ADDEQ R5,R5,#1 // if player-1 does,increase unit +1

	CMP R5,#10 //unit can be 9 max.
	MOVEQ R5,#0 // if unit reach 10,reset it
	
	CMP R3,#1 // when player-1 press button0
	BEQ ADD_ONE_UNIT
	
	BX LR

ADD_ONE_UNIT_P2:
	LDR R3,[R2]//input from buttons

	CMPEQ R3,#0 // check,does player-2 press button0 than pull
	ADDEQ R7,R7,#1 // if player-2 does,increase unit +1

	CMP R7,#10 // unit can be 9 max.
	MOVEQ R7,#0 // if unit reach 10,reset it
	
	CMP R3,#1 // when player-2 press button0
	BEQ ADD_ONE_UNIT_P2
	BX LR


ADD_ONE_TENS:
	LDR R3,[R2] //input from buttons

	CMPEQ R3,#0 // check,does player-1 press button than pull
	ADDEQ R6,R6,#1 // if player-1 does,increase tens digit +1

	CMP R6,#10 // tens digit can be 9 max.
	MOVEQ R6,#0 // if tens digit reach 10,reset it

	CMP R3,#2 // when player-1 press button1
	BEQ ADD_ONE_TENS

	BX LR


	ADD_ONE_TENS_P2:
	LDR R3,[R2]

	CMPEQ R3,#0 // check,does player-2 press button than pull
	ADDEQ R8,R8,#1 // if player-2 does,increase tens digit +1

	CMP R8,#10 // tens digit can be 9 max.
	MOVEQ R8,#0 // if tens digit reach 10,reset it

	CMP R3,#2 // when player-2 press button1
	BEQ ADD_ONE_TENS_P2

	BX LR


end: 

LDR R11,=0x7954
LDR R12,=0x5e7c6e79
STR R11, [R1] //adress to SW for get value
STR R12, [R0] //BUTTON adress for get value
B end
 .end
	