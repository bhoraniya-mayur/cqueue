;Circular Queue implementation in assembly of ARM-CORTEXM4
;Main function will first fill entire queue, 
;then dequeue 2 elements and then enqueue 
;then dequeue and then enqueue
;queue is of 10 element
		PRESERVE8
		THUMB
		AREA Arm_ASM,CODE,READONLY
		ENTRY
		EXPORT __main
SIZE EQU 40				;size of quque
START EQU 0				;start = front = rear
ADDR  EQU 0x20000000	;starting address of queue	

__main FUNCTION
		MOV R0, #SIZE		;R0 : Queue Size
		MOV R1, #START		;R1 : Queue rear
		MOV R3, #ADDR		;R3 : Queue start Adddress in Memory
		MOV R4, #START		;R4 : Queue front
loop		BLGT  enqueue		;call enqueue
		CMP R0,#0		;This loop will make entire queue full
		BGT loop			
		BL dequeue		;dequeue
		BL dequeue		;dequeue
		BL enqueue		;enqueue
stop 	B stop

enqueue
		CMP R0,#0			;Is queue full?
		BXEQ LR				;then element cannot be insert element
		ADD R5, #2			;R5 contains element to be inserted
		STR R5,[R3,R1]		;Store in Memory
		ADD R1,#4			;increment rear
		CMP R1,#SIZE		;if rear pointer reached to last position	
		MOVEQ R1,#START		;then, move it to first position 
		SUB R0,R0,#4		;decrement queue size
		BX	LR		

dequeue
		CMP R0,#SIZE		;Is queue empty?
		BXEQ LR 			;then element cannot be dequeue
		LDR R6, [R3,R4]		;take from memory
		ADD R4, #0x04		;increment front pointer
		ADD R0,#4			;Increment queue slots availibility
		CMP R4,#SIZE		;if front pointer reached to end of queue, 	
		MOVEQ R4,#START		;then, bring it back to initial position.
		BX  LR
		ENDFUNC
		END
