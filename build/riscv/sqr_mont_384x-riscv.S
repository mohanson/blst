.text
.globl sqr_mont_384x_rvv
.align 4
// Args:
//   a0: ret[0]
//   a1: ret[1]
//   a2: a[0]
//   a3: a[1]
// Envs:
//   v29: u384 mask
//   v30: N
//   v31: N⁻¹
sqr_mont_384x_rvv:
  vsetivli t0, 1, e512, m1

  // v1 -> a[0]
  // v2 -> a[1]
  vle512.v v1, (a2)
  vle512.v v2, (a3)

  // vec384 t0, t1;
  // add_mod_384(t0, a[0], a[1], mod);
  // sub_mod_384(t1, a[0], a[1], mod);
  // v3 -> t0
  // v4 -> t1
  vadd.vv v3, v1, v2
  vmsleu.vv v0, v30, v3
  vsub.vv v3, v3, v30, v0.t
  vsub.vv v4, v1, v2
  vmsleu.vv v0, v30, v4
  vadd.vv v4, v4, v30, v0.t

  // mul_mont_384(ret[1], a[0], a[1], mod, n0);
  // v6 -> ret[1]
  vwmulu.vv v6, v1, v2
  vnsrl.wx v0, v6, zero
  vmul.vv v5, v0, v31
  vand.vv v0, v5, v29
  vwmaccu.vv v6, v0, v30
  li t1, 384
  vnsrl.wx v6, v6, t1
  vmsleu.vv v0, v30, v6
  vsub.vv v6, v6, v30, v0.t

  // mul_mont_384(ret[0], t0, t1, mod, n0);
  // v8 -> ret[0]
  vwmulu.vv v8, v3, v4
  vnsrl.wx v0, v8, zero
  vmul.vv v5, v0, v31
  vand.vv v0, v5, v29
  vwmaccu.vv v8, v0, v30
  vnsrl.wx v8, v8, t1
  vmsleu.vv v0, v30, v8
  vsub.vv v8, v8, v30, v0.t

  // add_mod_384(ret[1], ret[1], ret[1], mod);
  vadd.vv v6, v6, v6
  vmsleu.vv v0, v30, v6
  vsub.vv v6, v6, v30, v0.t

  vse512.v v8, (a0)
  vse512.v v6, (a1)

  ret
