.macro fin
    addi sp, sp, -8
    sd   ra, 0(sp)
.endm

.macro fout
    ld   ra, 0(sp)
    addi sp, sp, 8
.endm

.globl sine

default_answer = 0x312d
ans_len        = 8

.section .data
var:
.align  8
.space  100

zero_point:
 .asciz "0.04998"
 .asciz "0.14944"
 .asciz "0.24740"
 .asciz "0.34290"
 .asciz "0.43497"
 .asciz "0.52269"
 .asciz "0.60519"
 .asciz "0.68164"
 .asciz "0.75128"
 .asciz "0.81342"

one_point:
 .asciz "0.86742"
 .asciz "0.91276"
 .asciz "0.94899"
 .asciz "0.97572"
 .asciz "0.99271"
 .asciz "0.99917"

.section .text

sine:
    fin

    mv   a3, a1

    lb   t0, 0(a3)
    addi t0, t0, -48

    addi a3, a3, 1

    lb   t1, 0(a3)
    li   t2, '.'
    bne  t1, t2, erret

    addi a3, a3, 1

    lb   t1, 0(a3)
    addi t1, t1, -48

    li   t2, 0
    beq  t2, t0, first_digit_zero
    li   t2, 1
    beq  t2, t0, first_digit_one
    j    erret

first_digit_zero:
    la   a4, zero_point
    j    get_answer

first_digit_one:
    li   t2, 6
    bge  t1, t2, erret
    la   a4, one_point

get_answer:
    call get_table_shift
    add  a4, a4, t2

    li   t2, ans_len

save_answer:
    lb   t3, 0(a4)
    sb   t3, 0(a2)

    addi t2, t2, -1
    addi a4, a4, 1
    addi a2, a2, 1

    beq t2, x0, suret
    j   save_answer

get_table_shift:
    li   t2, 0

while_shift_not_found:
    beq  t1, x0, ret
    addi t2, t2, ans_len
    addi t1, t1, -1
    j    while_shift_not_found

erret:
    li   t2, default_answer
    sw   t2, 0(a2)

    ret

suret:
    fout
    ret

ret:
    ret
