	.global	generate16

generate16:		push		{R1-R12}						@ Save contents of registers R1 through R12
			mov		R1,R0							@ R1 will hold a copy of binary value to be displayed
			lsl		R1,#2							@ Add check bits 1 and 2 at the beginning of the output
			mov		R2,#0b111						@ Used to mask bits before bit 4
			and		R2,R1							@ Get the value before bit 4
			lsr		R1,#3		
			lsl		R1,#4							@ Previous (R1,#3) and this selects bit 4 and addds 0 to it
			add		R1,R2							@ Add the rest of the value before bit 4
			mov		R2,#0b1111111						@ Used to mask bits before bit 8
			and		R2,R1							@ Get the value before bit 8
			lsr		R1,#7
			lsl		R1,#8							@ Previous (R1,#7) and this command selects bit 8 and adds 0 to it
			add		R1,R2							@ Add the rest of the value before bit 8
			mov		R2,#0b111111111111111					@ Used to mask bits before bit 16
			and		R2,R1							@ Get the value before bit 16
			lsr		R1,#15
			lsl		R1,#16							@ Previous (R1,#16) and this command selects bit 16 and adds 0 to it
			add		R1,R2							@ Add the rest of the value before bit 16

			ldr		R2,=#0b111111000000000000000				@ Store the masking bits, that are needed to select the value for parity check for bit 16, to R2
			and		R2,R1							@ Select the value needed for parity check for bit 16
			mov		R3,#1							@ Number of bits to be selected at the time
			mov		R4,#20							@ Number of bits needed in total
bit16sum:		and		R5,R3,R2,LSR R4						@ R5 will hold a copy of the next bit
			eor		R6,R5							@ Exclusive OR operation to check whether the sum is odd or even
			subs		R4,#1							@ Next bit is pointed
			bge		bit16sum						@ If there are bits that have not been used select the next bit
			cmp		R6,#1							@ Check whether the sum is odd or even
			addeq		R1,#0b1000000000000000					@ If the sum is odd add 1 to bit 16
			mov		R6,#0							@ Move 0 to R6 (reset)

			ldr		R2,=#0b111111110000000					@ Store the masking bits, that are needed to select the value for parity check for bit 8, to R2
			and		R2,R1							@ Select the value needed for parity check for bit 8
			mov		R3,#1							@ Number of bits to be selected at the time
			mov		R4,#20							@ Number of bits needed in total
bit8sum:		and		R5,R3,R2,LSR R4						@ R5 will hold a copy of the next bit
			eor		R6,R5							@ Exclusive OR operation to check whether the sum is odd or even
			subs		R4,#1							@ Next bit is pointed
			bge		bit8sum							@ If there are bits that have not been used select the next bit
			cmp		R6,#1							@ Check whether the sum is odd or even
			addeq		R1,#0b10000000						@ If the sum is odd add 1 to bit 8
			mov		R6,#0							@ Move 0 to R6 (reset)

			ldr		R2,=#0b110000111100001111000				@ Store the masking bits, that are needed to select the value for parity check for bit 4, to R2
			and		R2,R1							@ Select the value needed for parity check for bit 4
			mov		R3,#1							@ Number of bits to be selected at the time
			mov		R4,#20							@ Number of bits needed in total
bit4sum:		and		R5,R3,R2,LSR R4						@ R5 will hold a copy of the next bit
			eor		R6,R5							@ Exclusive OR operation to check whether the sum is odd or even
			subs		R4,#1							@ Next bit is pointed
			bge		bit4sum							@ If there are bits that have not been used select the next bit
			cmp		R6,#1							@ Check whether the sum is odd or even
			addeq		R1,#0b1000						@ If the sum is odd add 1 to bit 4
			mov		R6,#0							@ Move 0 to R6 (reset)

			ldr		R2,=#0b1100110011001100110				@ Store the masking bits, that are needed to select the value for parity check for bit 2, to R2
			and		R2,R1							@ Select the value needed for parity check for bit 2
			mov		R3,#1							@ Number of bits to be selected at the time
			mov		R4,#20							@ Number of bits needed in total
bit2sum:		and		R5,R3,R2,LSR R4						@ R5 will hold a copy of the next bit
			eor		R6,R5							@ Exclusive OR operation to check whether the sum is odd or even
			subs		R4,#1							@ Next bit is pointed
			bge		bit2sum							@ If there are bits that have not been used select the next bit
			cmp		R6,#1							@ Check whether the sum is odd or even
			addeq		R1,#0b10						@ If the sum is odd add 1 to bit 2
			mov		R6,#0							@ Move 0 to R6 (reset)

			ldr		R2,=#0b101010101010101010101				@ Store the masking bits, that are needed to select the value for parity check for bit 1, to R2
			and		R2,R1							@ Select the value needed for parity check for bit 1
			mov		R3,#1							@ Number of bits to be selected at the time
			mov		R4,#20							@ Number of bits needed in total
bit1sum:		and		R5,R3,R2,LSR R4						@ R5 will hold a copy of the next bit
			eor		R6,R5							@ Exclusive OR operation to check whether the sum is odd or even
			subs		R4,#1							@ Next bit is pointed
			bge		bit1sum							@ If there are bits that have not been used select the next bit
			cmp		R6,#1							@ Check whether the sum is odd or even
			addeq		R1,#0b1							@ If the sum is odd add 1 to bit 1

			mov		R0,R1							@ Move the value to R0 for the output

			pop		{R1-R12}						@ Restore saved register contents
			bx		LR							@ Return to the calling program

.end
