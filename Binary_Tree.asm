MAIN	TD 	INDEV
	JEQ	MAIN
	RD	INDEV
	LDX	#0
	LDL	#1

	RMO	A, S . S is first input str

	LDCH	=C'I'
	COMPR	A, S
	JEQ	INPUT . jump to INPUT

	LDCH	=C'L'
	COMPR	A, S
	JEQ	LIST . jump to LIST

	LDCH	=C'D'
	COMPR	A, S
	JEQ	DELETE . jump to DELETE

	LDCH	=C'F'
	COMPR	A, S
	JEQ	FIND . jump to FIND

LINE	TD 	INDEV
	JEQ	LINE
	RD	INDEV . input 0x0A (enter)
	J	MAIN
.............................................
INPUT	TD 	INDEV
	JEQ	INPUT
	RD	INDEV
	TIX	#6
	JLT	INPUT
	RMO	A, S . S is input alphabet

	LDX	#1 . TREE's first index is 1

INPUT_L	LDCH	TREE, X . check null value
	COMP	#0
	JEQ	INPUT_A
	TIX	#16	
	JLT	INPUT_L

	LDX	#0 . clear 0 to print FULL
	J	INPUT_F

INPUT_A	RMO	S, A . input alphabet to tree
	STCH	TREE, X
	J	LINE

INPUT_F	TD 	OUTDEV . print FULL
	JEQ	INPUT_F
	LDCH	FULL, X
	WD	OUTDEV
	TIX	#4
	JLT	INPUT_F

	TD 	OUTDEV . new line
	JEQ	INPUT_F
	LDCH	=X'0A'
	WD	OUTDEV

	J	LINE
.............................................
LIST	TD 	INDEV
	JEQ	LIST
	RD	INDEV
	TIX	#3
	JLT	LIST . delete remainder input

	LDX	#1
	LDCH	TREE, X
	COMP	#0
	JEQ	LINE . if tree is empty

	LDX	#1
	LDCH	#1
	STCH	STACK, X . init stack with root
	LDS	#1 . stack's index
	LDT	#1 . res' index
	J	PRER

PRER	LDL	#1
	RMO	S, X
	LDCH	STACK, X . stack.pop()
	SUBR	L, X . X = X - 1
	RMO	X, S . S = X, stack index -1

	RMO	A, X
	LDB	TREE, X
	LDL	#0
	COMPR	B, L . if not node:
	JEQ	PRER . pass

	LDL	#1
	RMO	T, X
	STCH	RES, X . res.append()
	ADDR	L, X . X = X + 1
	RMO	X, T . T = X, res index + 1

.check left node
PRER_L	ADDR	A, A . left node, 2n
	RMO	A, B . B register is tmp for current index
	RMO	A, X
	LDCH	TREE, X
	LDL	#0
	COMPR	A, L . 0 and value
	JEQ	PRER_R

	LDL	#1
	RMO	B, A . repair A
	RMO	S, X
	ADDR	L, X . stack index + 1
	STCH	STACK, X . stack append
	RMO	X, S . S = X

.check right node
PRER_R	RMO	B, A . A repair
	LDL	#1

	ADDR	L, A . right node, left node + 1
	RMO	A, B . B register is tmp for current index
	RMO	A, X
	LDCH	TREE, X
	LDL	#0
	COMPR	A, L . 0 and value
	JEQ	PRER_C

	LDL	#1
	RMO	B, A . repair A
	RMO	S, X
	ADDR	L, X . stack index + 1
	STCH	STACK, X . stack append
	RMO	X, S . S = X

PRER_C	LDL	#0 . to compare stack size
	COMPR	L, S
	JEQ	LIST_T . break loop, print result
	J	PRER . recursive loop


LIST_T	LDL	#1
	SUBR	L, T . to print backward

LIST_P	TD 	OUTDEV 
	JEQ	LIST_P

	RMO	T, X
	LDCH	RES, X
	RMO	A, X
	LDCH	TREE, X
	WD	OUTDEV
	LDCH	=X'0A' . new line
	WD	OUTDEV
	SUBR	L, T
	RMO	T, A
	COMP	#0
	JGT	LIST_P 
	J	LINE
.............................................
DELETE	TD 	INDEV
	JEQ	DELETE
	RD	INDEV
	TIX	#7 . register A is delete target
	JLT	DELETE . delete remainder input
	RMO	A, T . move delete target to T register

	LDX	#1
	LDCH	=X'10'
	RMO	A, S
DEL_F	LDCH	TREE, X . find target value
	COMPR	A, T
	JEQ	DEL
	ADDR	L, X
	COMPR	X, S
	JEQ	DEL_T
	J	DEL_F

DEL_T	LDX	#0
DEL_N	TD 	OUTDEV . print NONE
	JEQ	DEL_N
	LDCH	NONE, X
	WD	OUTDEV
	TIX	#4
	JLT	DEL_N

	TD 	OUTDEV . new line
	JEQ	DEL_N
	LDCH	=X'0A'
	WD	OUTDEV

	J	LINE

DEL	RMO	X, A . copy X to A
	LDX	#1
	STCH	STACK, X . init stack with sub root
	LDS	#1 . stack's index
	J	DELR

DELR	LDL	#1
	RMO	S, X
	LDCH	STACK, X . stack.pop()
	SUBR	L, X . X = X - 1
	RMO	X, S . S = X, stack index -1

	RMO	A, B . backup current index
	RMO	A, X . move index to X to delete TREE node
	LDCH	=X'00'
	STCH	TREE, X . clear current node
	RMO	B, A

.check left node
DELR_L	ADDR	A, A . left node, 2n
	RMO	A, B . B register is tmp for current index
	RMO	A, X
	LDCH	TREE, X
	LDL	#0
	COMPR	A, L . 0 and value
	JEQ	DELR_R

	LDL	#1
	RMO	B, A . repair A
	RMO	S, X
	ADDR	L, X . stack index + 1
	STCH	STACK, X . stack append
	RMO	X, S . S = X

.check right node
DELR_R	RMO	B, A . A repair
	LDL	#1

	ADDR	L, A . right node, left node + 1
	RMO	A, B . B register is tmp for current index
	RMO	A, X
	LDCH	TREE, X
	LDL	#0
	COMPR	A, L . 0 and value
	JEQ	DELR_C

	LDL	#1
	RMO	B, A . repair A
	RMO	S, X
	ADDR	L, X . stack index + 1
	STCH	STACK, X . stack append
	RMO	X, S . S = X

DELR_C	LDL	#0 . to compare stack size
	COMPR	L, S
	JEQ	LINE
	J	DELR . recursive loop
.............................................
FIND	TD 	INDEV
	JEQ	FIND
	RD	INDEV
	TIX	#5 . register A is search target
	JLT	FIND . delete remainder input

	STCH	TARGET . store find value

	LDX	#1
	LDCH	TREE, X . print NONE if no root
	LDX	#0
	COMPR	X, A
	JEQ	DEL_T 

	RMO	A, B
	LDX	#1
	LDCH	#1
	LDS	#1 . stack's index
	LDT	#1 . res' index
	J	FINI

	. jump if root is zero !!

FINI	RMO	A, B . B register is tmp for current index
	RMO	A, X
	LDCH	TREE, X
	LDL	#0
	COMPR	A, L . 0 and value
	JEQ	FINO

	LDL	#1
	RMO	B, A . repair A
	RMO	S, X
	STCH	STACK, X . stack append
	ADDR	L, X . stack index + 1
	RMO	X, S . S = X

	RMO	B, A
	ADDR	A, A
	RMO	A, X
	LDCH	TREE, X . check left node
	LDL	#0
	COMPR	A, L . 0 and value
	JEQ	FINO . no left node, jump outer loop
	RMO	X, A . left node!
	J	FINI

FINO	LDL	#1
	RMO	B, A .,..........
	RMO	S, X
	SUBR	L, X . X = X - 1
	RMO	X, S . S = X, stack index -1
	LDCH	STACK, X . stack.pop()

	RMO	A, B
	LDL	#1
	RMO	T, X
	STCH	RES, X . res.append()
	ADDR	L, X . X = X + 1
	RMO	X, T . T = X, res index + 1

FINOR	LDL	#1
	RMO	B, A
	ADDR	A, A
	ADDR	L, A . right node

	RMO	A, X
	LDCH	TREE, X
	LDL	#0
	COMPR	A, L . if not node:
	JEQ	FINOT . no right node
	RMO	X, A . APPEND 
	J	FINI

FINOT	LDL	#1
	RMO	B, A
	COMPR	S, L
	JEQ	FIND_PS . break loop

	J	FINO

FIND_PS	LDX	#1
FIND_P	TD 	OUTDEV . print inorder traversal
	JEQ	FIND_P
	RMO	X, B . backup index for counting
	LDCH	RES, X
	RMO	A, X
	LDCH	TREE, X
	WD	OUTDEV
	RMO	A, S
	LDCH	=X'0A' . new line
	WD	OUTDEV

	LDCH	TARGET
	COMPR	A, S
	JEQ	FIND_N

	ADDR	L, B
	RMO	B, X
	COMPR	X, T
	JEQ	DEL_T
	J	FIND_P

FIND_N	TD 	OUTDEV . print count number
	JEQ	FIND_N
	RMO	B, X
	LDCH	NUM, X
	WD	OUTDEV
	LDCH	=X'0A' . new line
	WD	OUTDEV
	J	LINE


INDEV	BYTE	0
OUTDEV	BYTE	1
TARGET	RESB	2
FULL	BYTE	C'FULL'
NONE	BYTE	C'NONE'
NUM	BYTE	C'0123456789ABCDEF'
TREE	RESB	40
STACK	RESB    20
RES	RESB	20