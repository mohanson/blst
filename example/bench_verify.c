#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>

#include "blst.h"

const static uint8_t g_dst_label[] =
    "BLS_SIG_BLS12381G2_XMD:SHA-256_SSWU_RO_NUL_";
const static size_t g_dst_label_len = 43;

int once() {
  const uint8_t sig[96] = {
      0xAC, 0xFC, 0x4E, 0x0B, 0x16, 0xCE, 0x56, 0x8C, 0x78, 0xBA, 0x3C, 0xCB,
      0xE9, 0xFA, 0x6F, 0x26, 0x23, 0x1B, 0xEF, 0x65, 0xBC, 0xDB, 0x67, 0x04,
      0xD9, 0x26, 0x46, 0x87, 0x09, 0xED, 0xFE, 0x31, 0x2C, 0x79, 0x67, 0xF1,
      0x01, 0x75, 0x4A, 0xF1, 0xC2, 0x28, 0xD5, 0x25, 0x68, 0xA1, 0x75, 0x4E,
      0x09, 0xE2, 0x93, 0x08, 0xCF, 0x1C, 0x9F, 0x11, 0x39, 0x13, 0xE3, 0x0C,
      0x59, 0x5E, 0xF5, 0x50, 0x02, 0x12, 0xB5, 0xBB, 0xE7, 0x9E, 0x47, 0xAD,
      0xE4, 0xFC, 0xB6, 0x5F, 0xAA, 0xE4, 0x87, 0x99, 0xAF, 0x72, 0xD5, 0x6B,
      0xEB, 0x2C, 0x38, 0xD6, 0xA3, 0xD0, 0x45, 0x56, 0xB1, 0xC0, 0x8E, 0xC2};
  const uint8_t pk[48] = {
      0x91, 0x12, 0xA0, 0x38, 0x6A, 0x23, 0x40, 0x71, 0x4B, 0xA0, 0xC6, 0xD2,
      0xDF, 0x23, 0x53, 0x77, 0xA8, 0x67, 0x9C, 0x38, 0x99, 0xD0, 0x3E, 0x6E,
      0xF0, 0x4D, 0xBA, 0x7A, 0x50, 0xEF, 0x49, 0xE5, 0xA1, 0xDC, 0x93, 0x10,
      0x5E, 0x93, 0x74, 0xE9, 0x3E, 0xD3, 0x01, 0xB6, 0x34, 0x87, 0xE1, 0x7C};
  const uint8_t msg[12] = {0x68, 0x65, 0x6C, 0x6C, 0x6F, 0x2C,
                           0x20, 0x77, 0x6F, 0x72, 0x6C, 0x64};
  size_t msg_len = 12;
  blst_p1_affine pk_p1_affine;
  blst_p1_uncompress(&pk_p1_affine, pk);
  blst_p2_affine sig_p2_affine;
  blst_p2_uncompress(&sig_p2_affine, sig);
  BLST_ERROR err =
      blst_core_verify_pk_in_g1(&pk_p1_affine, &sig_p2_affine, 1, msg, msg_len,
                                g_dst_label, g_dst_label_len, NULL, 0);
  return err;
}

int main(int argc, const char *argv[]) {
  blst_init();

  if (argc <= 1) {
    if (once() != 0) {
      return 1;
    }
    return 0;
  }

  int n = atoi(argv[1]);
  for (int i = 0; i < n; i++) {
    if (once() != 0) {
      return 1;
    }
  }
  return 0;
}
