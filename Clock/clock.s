.global _start
 _start:
 /*
 AUTHOR:İlker Rişvan 
 DATE:30/04/2020 
 */
 
 /* SET TIMER */
 LDR R1, =0xFFFEC600 // R1 points to timer
 LDR R2, =2000000// R2 is control word
 STR R2, [R1]
 // Control reigster
 // I --> 0. A --> 1. E --> 1
 MOV R2, #0b011
 STR R2, [R1, #8] 
 
 
 LDR R0, =0xFF200020 // LED ADRESS

 /* INIT REGISTERS */ 
 MOV R9, #0 // 0.01 second
 MOV R8, #0 // 0.1 second
 MOV R7, #0 // 1 second 
 MOV R6, #0 // x10 second


 /*CLOCK LOOP */
 
loop:
     STREQ R10, [R0] // show the clock (R0 = LED ADRESS)
   	 ADD R9,R9,#1 // for show +1 0.01 second on led
	 CMP R9,#10   // max value can be 9 if it reach 10 return the 0
	 MOVEQ R9,#0  // step of return 0	
	 ADDEQ R8,R8,#1 //increment 0.1 second if there is 10 0.01 second (0.01*10 = 0.1 second)
	 CMP R8,#10     // max value can be 9 if it reach 10 return the 0
	 MOVEQ R8,#0    // step of return 0
	 ADDEQ R7,R7,#1 // increment 1 second if there is 10 0.1 second (0.1*10 = 1 second)
	 CMP R7,#10     // max value can be 9 if it reach 10 return the 0
	 MOVEQ R7,#0	// step of return 0	
	 ADDEQ R6,R6,#1 //increment 10 seconds part if there is 10 1 second (1*10 = 10 seconds)
	 CMP R6,#6      // max value can be 5 if it reach 6 return the 0
	 MOVEQ R6,#0    // step of return 0
	 

       
	
/* IN THIS PART WE GET HEX VALUE OF EACH DIGIT FOR SHOW */
       /*4th digit,this digit shows 1/100 second */	 
		CMP R9,#0
		MOVEQ R2, #0x3F
	    CMP R9,#1
		MOVEQ R2, #0x06
		CMP R9,#2
		MOVEQ R2, #0x5B
		CMP R9,#3
		MOVEQ R2, #0x4F
		CMP R9,#4
		MOVEQ R2, #0x66
		CMP R9,#5
		MOVEQ R2, #0x6D
		CMP R9,#6
		MOVEQ R2, #0x7D
		CMP R9,#7
		MOVEQ R2, #0x07
		CMP R9,#8
		MOVEQ R2, #0x7F
		CMP R9,#9
		MOVEQ R2, #0x6F
		
		/*3rd digit,this digit shows 1/10 second */	
		CMP R8,#0
		MOVEQ R3, #0x3F
	    CMP R8,#1
		MOVEQ R3, #0x06
		CMP R8,#2
		MOVEQ R3, #0x5B
		CMP R8,#3
		MOVEQ R3, #0x4F
		CMP R8,#4
		MOVEQ R3, #0x66
		CMP R8,#5
		MOVEQ R3, #0x6D
		CMP R8,#6
		MOVEQ R3, #0x7D
		CMP R8,#7
		MOVEQ R3, #0x07
		CMP R8,#8
		MOVEQ R3, #0x7F
		CMP R8,#9
		MOVEQ R3, #0x6F
		
		/*3rd digit,this digit shows 1 second */	
		CMP R7,#0
		MOVEQ R4, #0x3F
	    CMP R7,#1
		MOVEQ R4, #0x06
		CMP R7,#2
		MOVEQ R4, #0x5B
		CMP R7,#3
		MOVEQ R4, #0x4F
		CMP R7,#4
		MOVEQ R4, #0x66
		CMP R7,#5
		MOVEQ R4, #0x6D
		CMP R7,#6
		MOVEQ R4, #0x7D
		CMP R7,#7
		MOVEQ R4, #0x07
		CMP R7,#8
		MOVEQ R4, #0x7F
		CMP R7,#9
		MOVEQ R4, #0x6F
		
		
		/*3rd digit,this digit shows x10 seconds,for get 1 min on total */	
		CMP R6,#0
		MOVEQ R5, #0x3F
	    CMP R6,#1
		MOVEQ R5, #0x06
		CMP R6,#2
		MOVEQ R5, #0x5B
		CMP R6,#3
		MOVEQ R5, #0x4F
		CMP R6,#4
		MOVEQ R5, #0x66
		CMP R6,#5       // 1 min 60:00 second so max. value of this digit is 6
		MOVEQ R5, #0x6D   


		
		PUSH {R12} // need more register so push a register to stack
		BL Button
		POP {R12} // get orginal register for clock


	 /*TIMER,TIMER COUNT UNTIL 0.01 SECOND*/
waitloop:
	 LDR R12, [R1, #0xC] // status reg. 
	 CMP R12, #1 // if 1, 0.01 second is completed. 
	 BNE waitloop 
	 STR R12, [R1, #0xC] // reset status flag.
	
	/*WE NEED LEFT SHIFT FOR ADD EACH OTHER AND SHOW ON LED */ 
    LSL R5,R5,#24     // left shift x10 second values
    LSL R4,R4,#16     // left shift second values
    LSL R3,R3,#8      // left shift 0.1 second values
	
	/*ADD EACH OTHER FOR GET CLOCK*/
	ADD R10,R5,R4  //10x seconds + second 
	ADD R10,R10,R3 //10x seconds + second + 0.1 second
	ADD R10,R10,R2 //10x seconds + second + 0.1 second + 0.01 second 
	/*FINAL VIEW EXAMPLE 52:26 => 52.26 second */


 
	
B loop 

/* STOP WITH PRESS ANY BUTTON  */
Button:   LDR R11, =0xFF200050  // buttons adress
		LDR R12, [R11] //adress to buttons for get value
 		CMP R12, #0    // if pressed any button write stop
		LDRNE R12, =#0x6D783F73 // stop word
        STRNE R12,[R0] // display stop
		BX LR  // exit the loop
 
 
 end: B end
 .end