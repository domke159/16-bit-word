	.global	correct16

correct16:		push		{R1-R12}						@ Save contents of registers R1 through R12
			mov		R1,R0							@ R1 will hold a copy of binary value to be displayed

			ldr		R2,=#0b111111000000000000000				@ Store the masking bits, that are needed to select the value for parity check for bit 16, to R2
			and		R2,R1							@ Select the value needed for parity check for bit 16
			mov		R3,#1							@ Number of bits to be selected at the time
			mov		R4,#20							@ Number of bits needed in total
bit16sum:		and		R5,R3,R2,LSR R4						@ R5 will hold a copy of the next bit
			eor		R6,R5							@ Exclusive OR operation to check whether the sum is odd or even
			subs		R4,#1							@ Next bit is pointed
			bge		bit16sum						@ If there are bits that have not been used select the next bit
			cmp		R6,#0							@ Check whether the sum is odd or even
			addne		R7,#0b10000						@ If the sum is odd add 1 to bit 16
			mov		R6,#0							@ Move 0 to R6 (reset)

			ldr		R2,=#0b111111110000000					@ Store the masking bits, that are needed to select the value for parity check for bit 8, to R2
			and		R2,R1							@ Select the value needed for parity check for bit 8
			mov		R3,#1							@ Number of bits to be selected at the time
			mov		R4,#20							@ Number of bits needed in total
bit8sum:		and		R5,R3,R2,LSR R4						@ R5 will hold a copy of the next bit
			eor		R6,R5							@ Exclusive OR operation to check whether the sum is odd or even
			subs		R4,#1							@ Next bit is pointed
			bge		bit8sum							@ If there are bits that have not been used select the next bit
			cmp		R6,#0							@ Check whether the sum is odd or even
			addne		R7,#0b1000						@ If the sum is odd add 1 to bit 8
			mov		R6,#0							@ Move 0 to R6 (reset)

			ldr		R2,=#0b110000111100001111000				@ Store the masking bits, that are needed to select the value for parity check for bit 4, to R2
			and		R2,R1							@ Select the value needed for parity check for bit 4
			mov		R3,#1							@ Number of bits to be selected at the time
			mov		R4,#20							@ Number of bits needed in total
bit4sum:		and			R5,R3,R2,LSR R4					@ R5 will hold a copy of the next bit
			eor		R6,R5							@ Exclusive OR operation to check whether the sum is odd or even
			subs		R4,#1							@ Next bit is pointed
			bge		bit4sum							@ If there are bits that have not been used select the next bit
			cmp		R6,#0							@ Check whether the sum is odd or even
			addne		R7,#0b100						@ If the sum is odd add 1 to bit 4
			mov		R6,#0							@ Move 0 to R6 (reset)

			ldr		R2,=#0b1100110011001100110				@ Store the masking bits, that are needed to select the value for parity check for bit 2, to R2
			and		R2,R1							@ Select the value needed for parity check for bit 2
			mov		R3,#1							@ Number of bits to be selected at the time
			mov		R4,#20							@ Number of bits needed in total
bit2sum:		and		R5,R3,R2,LSR R4						@ R5 will hold a copy of the next bit
			eor		R6,R5							@ Exclusive OR operation to check whether the sum is odd or even
			subs		R4,#1							@ Next bit is pointed
			bge		bit2sum							@ If there are bits that have not been used select the next bit
			cmp		R6,#0							@ Check whether the sum is odd or even
			addne		R7,#0b10						@ If the sum is odd add 1 to bit 2
			mov		R6,#0							@ Move 0 to R6 (reset)

			ldr		R2,=#0b101010101010101010101				@ Store the masking bits, that are needed to select the value for parity check for bit 1, to R2
			and		R2,R1							@ Select the value needed for parity check for bit 1
			mov		R3,#1							@ Number of bits to be selected at the time
			mov		R4,#20							@ Number of bits needed in total
bit1sum:		and		R5,R3,R2,LSR R4						@ R5 will hold a copy of the next bit
			eor		R6,R5							@ Exclusive OR operation to check whether the sum is odd or even
			subs		R4,#1							@ Next bit is pointed
			bge		bit1sum							@ If there are bits that have not been used select the next bit
			cmp		R6,#0							@ Check whether the sum is odd or even
			addne		R7,#0b1							@ If the sum is odd add 1 to bit 1
			mov		R6,#0							@ Move 0 to R6 (reset)

			cmp		R7,#0							@ Check the value of R7
			bxeq		LR							@ If R7 is 0, there are no currupted bits, therefore return to the calling program

			mov		R8,#1							@ R8 will act as a mask that selects the value of the corrupted bit
			lsl		R8,R7							@ If the value of R7 is 7, the 7th bit is corrupted and the value of R8 will be 1111111
			sub		R8,#1							@ Subtract 1 from R8
			eor		R1,R8							@ Exclusive OR operation to reverse the bits starting from the corrupted bit
			lsr		R8,#1							@ Delete an extra 1 at the end on R8
			eor		R1,R8							@ Exclusive OR operation to reverse the bits to how they were before the first reverse (not including the corrupted bit)

			lsr		R1,#2							@ Remove bits 0 and 1 at the right side of the value
			mov		R2,#0b1							@ R2 will act as a mask to select the bits before bit 4
			and		R2,R1							@ Get the value before bit 4
			lsr		R1,#2
			lsl		R1,#1							@ Previous (R1,#2) and this command remove the bit at the 4th position
			add		R1,R2							@ Add the rest of the value before bit 4

			mov		R2,#0b1111						@ R2 will act as a mask to select the bits before bit 8
			and		R2,R1							@ Get the value before bit 8
			lsr		R1,#5							
			lsl		R1,#4							@ Previous (R1,#5) and this command remove the bit at the 8th position
			add		R1,R2							@ Add the rest of the value before bit 8
									
			mov		R2,#0b11111111111					@ R2 will act as a mask to select the bits before bit 16
			and		R2,R1							@ Get the value before bit 16
			lsr		R1,#12
			lsl		R1,#11							@ Previous (R1,#12) and this command remove the bit at the 16th position
			add		R1,R2							@ Add the rest of the value before bit 16

			mov		R0,R1							@ Move the value to R0 for the output				

			pop		{R1-R12}						@ Restore saved register contents
			bx		LR							@ Return to the calling program

.end