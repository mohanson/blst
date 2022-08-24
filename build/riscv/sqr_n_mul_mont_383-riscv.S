.text
.globl sqr_n_mul_mont_383_rvv
.align 4
// Args:
//   a0: ret
//   a1: a
//   a2: count
//   a3: p
//   a4: n0
//   a5: b
sqr_n_mul_mont_383_rvv:
  vsetivli t0, 1, e512, m1
  vle512.v v1, (a1)
  vle512.v v5, (a5)
  li t1, 384
  beq a2, x0, loop_done
loop:
  vsetivli t0, 1, e512, m1
  vwmulu.vv v2, v1, v1
  vnsrl.wx v0, v2, zero
  vmul.vv v4, v0, v31
  vand.vv v0, v4, v29
  vwmaccu.vv v2, v0, v30
  vnsrl.wx v2, v2, t1
  vmv.v.v v1, v2
  addi a2, a2, -1
  bne a2, zero, loop
loop_done:
  vsetivli t0, 1, e512, m1
  vwmulu.vv v2, v1, v5
  vnsrl.wx v0, v2, zero
  vmul.vv v4, v0, v31
  vand.vv v0, v4, v29
  vwmaccu.vv v2, v0, v30
  vnsrl.wx v2, v2, t1
  vse512.v v2, (a0)
  ret
