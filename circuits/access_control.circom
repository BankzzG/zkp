pragma circom 2.0.0;

include "../circomlib/circuits/pedersen.circom";

// วงจร AccessControl ที่ยังคง Pedersen อยู่ใน circuit
// แต่เราจะรับบิตมาเป็น public inputs แทน Num2Bits

template AccessControl() {
    // Public outputs (ค่า Pedersen commitment)
    signal output commitmentX;
    signal output commitmentY;

    // Public inputs
    signal input userID;
    signal input domainCode;
    signal input roleCode;
    signal input random;

    // บิตที่ precompute มาแล้ว (off-chain)
    signal input inputBits[32];  // บิตของ inputData
    signal input randBits[64];   // บิตของ random

    // สร้าง component Pedersen(96)
    component ped = Pedersen(96);
    for (var i = 0; i < 32; i++) {
        ped.in[i]       <== inputBits[i];
    }
    for (var i = 0; i < 64; i++) {
        ped.in[32 + i]  <== randBits[i];
    }

    // ส่งออก commitmentX,Y
    commitmentX <== ped.out[0];
    commitmentY <== ped.out[1];

    // เช็ค policy
    roleCode   === 0;   // บังคับให้ roleCode == 0
    domainCode === 0;   // บังคับให้ domainCode == 0
}

component main { public [ userID, domainCode, roleCode, random ] } = AccessControl();
