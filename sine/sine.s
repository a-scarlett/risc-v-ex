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
# if you need some data, put it here
var:
.align  8
.space  100

zero_point:
 .asciz "0.00000"
 .asciz "0.09983"
 .asciz "0.19866"
 .asciz "0.29552"
 .asciz "0.38941"
 .asciz "0.47942"
 .asciz "0.56464"
 .asciz "0.64421"
 .asciz "0.71735"
 .asciz "0.78332"

one_point:
 .asciz "0.84147"
 .asciz "0.89120"
 .asciz "0.93203"
 .asciz "0.96355"
 .asciz "0.98544"
 .asciz "0.99749"

.section .text

# Sine
#   Params
#   a1 -- input buffer will contain string with the argument
#   a2 -- output string buffer for the string result
sine:
    fin

    # Load input address to the pointer
    mv   a3, a1

    # Load first digit
    lb   t0, 0(a3)
    addi t0, t0, -48

    # Move pointer to the next char
    addi a3, a3, 1

    # Load point
    lb   t1, 0(a3)
    li   t2, '.'
    bne  t1, t2, erret

    # Move pointer to the next char
    addi a3, a3, 1

    # Load second digit
    lb   t1, 0(a3)
    addi t1, t1, -48

    # Check the value of the first digit
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
