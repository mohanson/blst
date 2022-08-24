.text
.globl    mul_mont_384x_rvv
.align    4
// Args:
//   a0: ret[0]
//   a1: ret[1]
//   a2: a
//   a3: b
mul_mont_384x_rvv:
  vsetivli t0, 4, e512, m1
  vle512.v v0, (a2)
  vle512.v v1, (a3)

  vwmulu.vv v2, v0, v1
  vnsrl.wx v0, v2, zero
  vmul.vv v4, v0, v31
  vand.vv v0, v4, v29
  vwmaccu.vv v2, v0, v30
  li t1, 384
  vnsrl.wx v2, v2, t1
  vmsleu.vv v0, v30, v2
  vsub.vv v2, v2, v30, v0.t

  vsetivli t0, 1, e512, m1
  vmv.v.v v4, v2
  vslidedown.vi v5, v2, 1
  vslidedown.vi v6, v2, 2
  vslidedown.vi v7, v2, 3
  vsub.vv v8, v4, v5
  vmsleu.vv v0, v30, v8
  vadd.vv v8, v8, v30, v0.t
  vadd.vv v10, v6, v7
  vmsleu.vv v0, v30, v10
  vsub.vv v10, v10, v30, v0.t
  vse512.v v8, (a0)
  vse512.v v10, (a1)
  ret
