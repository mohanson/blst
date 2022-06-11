TARGET := /home/ubuntu/app/riscv/bin/riscv64-unknown-elf
CC := $(TARGET)-gcc
CFLAGS := -fPIC -O3
RVV_AS := rvv-as
RUNNER := ~/src/ckb-vm-cli/target/release/ckb-vm-b-cli

x86:
	gcc $(CFLAGS) -c -D__BLST_NO_ASM__ -o bin/server.o src/server.c
	gcc $(CFLAGS) -Ibindings -o bin/bench_verify_x86 example/bench_verify.c bin/server.o

raw:
	$(CC) $(CFLAGS) -c -D__BLST_NO_ASM__ -o bin/server.o src/server.c
	$(CC) $(CFLAGS) -Ibindings -o bin/bench_verify_raw example/bench_verify.c bin/server.o

asm:
	$(CC) $(CFLAGS) -c -o bin/mul_mont_384-riscv.o build/riscv/mul_mont_384-riscv.S
	$(CC) $(CFLAGS) -c -o bin/mul_mont_384x-riscv.o build/riscv/mul_mont_384x-riscv.S
	$(RVV_AS) build/riscv/mul_mont_384_batch-riscv.S > bin/mul_mont_384_batch-riscv.S
	$(CC) $(CFLAGS) -c -o bin/mul_mont_384_batch-riscv.o bin/mul_mont_384_batch-riscv.S

imc: asm
	$(CC) $(CFLAGS) -c -D__BLST_NO_ASM__ -D__CKB_ASM_IMC__ -o bin/server.o src/server.c
	$(CC) $(CFLAGS) -Ibindings -o bin/bench_verify_imc example/bench_verify.c bin/server.o bin/mul_mont_384-riscv.o bin/mul_mont_384x-riscv.o

rvv: asm
	$(CC) $(CFLAGS) -c -D__BLST_NO_ASM__ -D__CKB_ASM_RVV__ -o bin/server.o src/server.c
	$(CC) $(CFLAGS) -Ibindings -o bin/bench_verify_rvv example/bench_verify.c bin/server.o bin/mul_mont_384_batch-riscv.o

run-x86: x86
	time bin/bench_verify_x86 100

run-raw: raw
	time $(RUNNER) --bin bin/bench_verify_raw 100

run-imc: imc
	time $(RUNNER) --bin bin/bench_verify_imc 100

run-rvv: rvv
	time $(RUNNER) --bin bin/bench_verify_rvv 100
