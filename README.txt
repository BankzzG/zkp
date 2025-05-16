# ZKP Access Control using PLONK + Pedersen Commitment

## Requirements
- circom 0.5.46
- snarkjs 0.7.5
- nodejs

## Setup

1. **Install circomlib**
```
mkdir circomlib 
cd circomlib
git clone https://github.com/iden3/circomlib.git .
```

2. **Compile**
```
cd ..
mkdir build
circom circuits/access_control.circom --r1cs --wasm --sym -o build
```

3. **Setup Trusted Setup**
``
cd build
snarkjs powersoftau new bn128 13 pot13_0000.ptau -v
snarkjs powersoftau contribute pot13_0000.ptau pot13_final.ptau --name="First Contribution" -v
snarkjs powersoftau prepare phase2 pot13_final.ptau pot13_final_prepared.ptau
snarkjs plonk setup access_control.r1cs pot13_final_prepared.ptau access_control.zkey
snarkjs zkey export verificationkey access_control.zkey verification_key.json
snarkjs zkey export solidityverifier access_control.zkey verifier.sol
```

4. **Generate Witness and Proof**
```
cd access_control_js
node generate_witness.js access_control.wasm ..\..\input.json witness.wtns
snarkjs plonk prove build/access_control.zkey build/witness.wtns build/proof.json build/public.json
```

5. **Verify**
```
snarkjs plonk verify build/verification_key.json build/public.json build/proof.json
```

6. **Deploy Solidity verifier.sol on-chain**
Use `verifier.sol` in your Solidity project.
