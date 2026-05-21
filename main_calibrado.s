/*********************************************************************************************
*	main.s
*	Organización y arquitectura de computadoras - UCC
*   2025
**********************************************************************************************/
.text
.org 0x0000

.equ PERIPHERAL_BASE, 0x3F000000
.equ GPIO_BASE,       0x200000
.equ GPIO_GPFSEL1,    0x4
.equ GPIO_GPSET0,     0x1C
.equ GPIO_GPCLR0,     0x28

	// Set Cores 1..3 To Infinite Loop (no modificar)
	mrs  X0, MPIDR_EL1
	ands X0, X0, 3
	b.ne CoreLoop

	// W0 = base GPIO (no modificar)
	ldr W0, =(PERIPHERAL_BASE + GPIO_BASE)

	// GPIO18 como salida: bits 26:24 de GPFSEL1 = 001
	ldr W1, [X0, GPIO_GPFSEL1]
	and W1, W1, ~(0x7 << 24)
	orr W1, W1, (0x1 << 24)
	str W1, [X0, GPIO_GPFSEL1]

	// W5 = mascara GPIO18 (no modificar)
	mov W5, (1 << 18)

	// Tabla de notas — W2=delay_alto, W6=delay_bajo, W3=reps
	// Calibradas empíricamente con osciloscopio (sin I-cache, DRAM)
	//
	// Nota   F[Hz]   delay_alto  delay_bajo   reps
	// DO     261.63     8311        8698       1570  (medido: 262 Hz ✓)
	// RE     293.66     7411        7756       1762  (medido: 294 Hz ✓)
	// MI     329.63     6587        6894       1978  (medido: 330 Hz ✓)
	// FA     349.23     6237        6527       2096  (medido: 350 Hz ✓)
	// SOL    392.00     5546        5804       2352  (medido: 392 Hz ✓)
	// LA     440.00     4952        5184       2640  (medido: 440 Hz ✓)  (medido: 440 Hz ✓)
	// SI     493.88     4414        4619       2964  (medido: 494 Hz ✓)
	// SI     493.88     (pendiente)

infloop:
	ldr W2, =8311
	ldr W6, =8698
	ldr W3, =1570
	bl  play_note		// DO  261.63 Hz

	ldr W2, =7411
	ldr W6, =7756
	ldr W3, =1762
	bl  play_note		// RE  293.66 Hz

	ldr W2, =6587
	ldr W6, =6894
	ldr W3, =1978
	bl  play_note		// MI  329.63 Hz

	ldr W2, =6237
	ldr W6, =6527
	ldr W3, =2096
	bl  play_note		// FA  349.23 Hz

	ldr W2, =5546
	ldr W6, =5804
	ldr W3, =2352
	bl  play_note		// SOL 392.00 Hz

	ldr W2, =4952
	ldr W6, =5184
	ldr W3, =2640
	bl  play_note		// LA  440.00 Hz

	ldr W2, =4414
	ldr W6, =4619
	ldr W3, =2964
	bl  play_note		// SI  493.88 Hz

	b infloop

play_note:
note_period:
	str W5, [X0, GPIO_GPSET0]	// GPIO18 = 1 (semiperíodo alto)
	mov W4, W2
delay_high:
	subs W4, W4, 1
	b.ne delay_high

	str W5, [X0, GPIO_GPCLR0]	// GPIO18 = 0 (semiperíodo bajo)
	mov W4, W6
delay_low:
	subs W4, W4, 1
	b.ne delay_low

	subs W3, W3, 1
	b.ne note_period
	ret

CoreLoop:
	b CoreLoop
