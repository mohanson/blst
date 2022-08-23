cd ~/src/ckb-vm
cargo build --features=asm --example ckb-vm-runner --release

cd ~/src/blst
make run-rvv
