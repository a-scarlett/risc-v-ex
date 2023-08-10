exit    = 93
read    = 63
write   = 64
ds      = 0x20000

.section .data

newline: .byte 0x0A

input:  .asciz "0.234"
.space  100

output:
.align  4
.space  100

.section .text 
.globl _start

_start:
    li  gp, ds

    li  a7, read
    li  a0, 0
    la  a1, input
    li  a2, 100
    ecall

    la  a1, input
    la  a2, output
    call    sine

    li  a7, write
    li  a0, 1
    la  a1, output
    la  a2, 100
    ecall

    li  a7, write
    li  a0, 1
    la  a1, newline
    li  a2, 1
    ecall
    
    li  a0, 0
    li  a7, exit
    ecall

	la	a1, input
	la	a2, output
	call 	sine


	li	a0, 0
	li	a7, exit
	ecall
