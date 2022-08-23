.text
.globl rvv_preload
.align 4
// a0: n
// a1: n_reverse
rvv_preload:
  vsetivli t0, 4, e512, m1
  vle512.v v30, (a0)
  vle512.v v31, (a1)
  vle512.v v29, (a2)
  ret
