/*********************************************************************************************
*	main.s
*	Organización y arquitectura de computadoras - UCC
*   2025
**********************************************************************************************/
.text
.org 0x0000

.equ PERIPHERAL_BASE, 0x3F000000 // Peripheral Base Address
.equ GPIO_BASE, 0x200000 	// GPIO Base Address
.equ GPIO_GPFSEL1, 0x4 		// GPIO Function Select 1
.equ GPIO_GPSET0, 0x1C 		// GPIO Pin Output Set 0
.equ GPIO_GPCLR0, 0x28 		// GPIO Pin Output Clear 0


	// Set Cores 1..3 To Infinite Loop (no modificar)
	mrs X0, MPIDR_EL1 	// X0 = Multiprocessor Affinity Register (MPIDR)
	ands X0,X0,3 		// X0 = CPU ID (Bits 0..1)
	b.ne CoreLoop 		// IF (CPU ID != 0) Branch To Infinite Loop (Core ID 1..3)

	// Load in W0 the GPIO base address
	ldr W0,=(PERIPHERAL_BASE + GPIO_BASE)

	// Config GPIO18 as output (usar GPIO_GPFSEL1)
	// .... CODE HERE ....

	//------------------ CODE HERE ------------------------------------------------------
infloop:
	    // usar GPIO_GPSET0 y GPIO_GPCLR0 para poner 1 o 0 en el GPIO 18.

        b infloop
	//----------------------------------------------------------------------------------

CoreLoop:       // Infinite Loop For Core 1..3
  b CoreLoop

