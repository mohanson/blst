.text
.globl    mul_mont_384x_rvv
.align    4
// Args:
//   a0: ret[0]
//   a1: ret[1]
//   a2: a[0]
//   a3: a[1]
//   a4: b[0]
//   a5: b[1]
mul_mont_384x_rvv:
  vsetivli t0, 1, e512, m1
  vle512.v v1, (a2)
  vle512.v v2, (a3)
  vle512.v v3, (a4)
  vle512.v v4, (a5)

  // vec384 aa, bb, cc;
  // aa -> v5
  // bb -> v6
  // cc -> v7

  // add_mod_n(aa, a[0], a[1], p, NLIMBS(384));
  vadd.vv v5, v1, v2
  vmsleu.vv v0, v30, v5
  vsub.vv v5, v5, v30, v0.t

  // add_mod_n(bb, b[0], b[1], p, NLIMBS(384));
  vadd.vv v6, v3, v4
  vmsleu.vv v0, v30, v6
  vsub.vv v6, v6, v30, v0.t

  li t1, 384

  // mul_mont_384(bb, bb, aa, p, n0);
  vwmulu.vv v8, v6, v5
  vnsrl.wx v0, v8, zero
  vmul.vv v10, v0, v31
  vand.vv v0, v10, v29
  vwmaccu.vv v8, v0, v30
  vnsrl.wx v8, v8, t1
  vmsleu.vv v0, v30, v8
  vsub.vv v8, v8, v30, v0.t
  vmv.v.v v6, v8

  // mul_mont_384(aa, a[0], b[0], p, n0);
  vwmulu.vv v8, v1, v3
  vnsrl.wx v0, v8, zero
  vmul.vv v10, v0, v31
  vand.vv v0, v10, v29
  vwmaccu.vv v8, v0, v30
  vnsrl.wx v8, v8, t1
  vmsleu.vv v0, v30, v8
  vsub.vv v8, v8, v30, v0.t
  vmv.v.v v5, v8

  vsetivli t0, 1, e512, m1
  // mul_mont_384(cc, a[1], b[1], p, n0);
  vwmulu.vv v8, v2, v4
  vnsrl.wx v0, v8, zero
  vmul.vv v10, v0, v31
  vand.vv v0, v10, v29
  vwmaccu.vv v8, v0, v30
  vnsrl.wx v8, v8, t1
  vmsleu.vv v0, v30, v8
  vsub.vv v8, v8, v30, v0.t
  vmv.v.v v7, v8

  // sub_mod_n(ret[0], aa, cc, p, NLIMBS(384));
  vsub.vv v8, v5, v7
  vmsleu.vv v0, v30, v8
  vadd.vv v8, v8, v30, v0.t

  // sub_mod_n(ret[1], bb, aa, p, NLIMBS(384));
  vsub.vv v9, v6, v5
  vmsleu.vv v0, v30, v9
  vadd.vv v9, v9, v30, v0.t

  // sub_mod_n(ret[1], ret[1], cc, p, NLIMBS(384));
  vsub.vv v10, v9, v7
  vmsleu.vv v0, v30, v10
  vadd.vv v10, v10, v30, v0.t

  vse512.v v8, (a0)
  vse512.v v10, (a1)

  ret
