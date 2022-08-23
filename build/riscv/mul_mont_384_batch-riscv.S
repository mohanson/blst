.text
.globl mul_mont_384_batch
.align 4
// Args:
//   a0: ret
//   a1: x
//   a2: y
//   a3: size
// Envs:
//   v29: u384 mask
//   v30: N
//   v31: N⁻¹
mul_mont_384_batch:
  vsetvli t0, a3, e512, m1

  vle512.v v0, (a1)     // v0 -> x
  vle512.v v1, (a2)     // v1 -> y

  // T = x * y
  vwmulu.vv v2, v0, v1  // v2 + v3 -> T

  // m = (T * N⁻¹) % R
  vnsrl.wx v0, v2, zero // v0 -> T % 2^512
  vmul.vv v4, v0, v31   // v4 -> T * N⁻¹
  vand.vv v0, v4, v29   // v0 -> m

  // t = (T + m * N) / R
  vwmaccu.vv v2, v0, v30
  li t1, 384
  vnsrl.wx v2, v2, t1   // v2 -> t

  // if (N <= t):
  //    t -= N
  vmsleu.vv v0, v30, v2
  vsub.vv v2, v2, v30, v0.t

  vse512.v v2, (a0)
  ret
