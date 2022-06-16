.text
.globl mul_mont_384_batch
.align 4
// Args:
//   a0: ret
//   a1: x
//   a2: y
//   a3: size
// Envs:
//   v30: N
//   v31: N⁻¹
mul_mont_384_batch:
  vsetvli t0, a3, e512, m1

  vle512.v v1, (a1)     // v1 -> x
  vle512.v v2, (a2)     // v2 -> y

  // T = x * y
  vwmulu.vv v4, v1, v2  // v4 + v5 -> T

  // m = (T * N⁻¹) % R
  vnsrl.wx v3, v4, zero // v3 -> T % 2^512
  li t1, 128
  vsll.vx v3, v3, t1
  vsrl.vx v3, v3, t1    // v3 -> T % 2^384
  vwmulu.vv v6, v3, v31
  vnsrl.wx v3, v6, zero
  vsll.vx v3, v3, t1
  vsrl.vx v3, v3, t1    // v3 -> m

  // t = (T + m * N) / R
  vwmaccu.vv v4, v3, v30
  li t1, 384
  vnsrl.wx v4, v4, t1   // v4 -> t

  // if (N <= t):
  //    t -= N
  vmsleu.vv v0, v30, v4
  vsub.vv v4, v4, v30, v0.t

  vse512.v v4, (a0)
  ret
