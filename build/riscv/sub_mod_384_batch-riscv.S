.text
.globl sub_mod_384_batch
.align 4
// a0: ret
// a1: x
// a2: y
// a3: n
// a4: size
sub_mod_384_batch:
  vsetvli t0, a4, e512, m1

  vle512.v v1, (a1)     // v1 -> x
  vle512.v v2, (a2)     // v2 -> y
  vle512.v v3, (a3)     // v3 -> n

  vsub.vv v4, v1, v2
  vmsleu.vv v0, v3, v4
  vadd.vv v4, v4, v3, v0.t
  vse512.v v4, (a0)
  ret
