const fs = require('fs');

function toBits(x, len) {
  const bits = Array(len).fill(0);
  for (let i = 0; i < len; i++) {
    bits[i] = Number((x >> BigInt(i)) & 1n);
  }
  return bits;
}

async function main() {
  // โหลด input.json
  const input = JSON.parse(fs.readFileSync('input.json'));

  // คำนวณ inputData = userID + domainCode*1e6 + roleCode*1e8
  const data = BigInt(input.userID)
             + BigInt(input.domainCode) * 1000000n
             + BigInt(input.roleCode)   * 100000000n;

  // สร้างบิตทั้งสองชุด
  input.inputBits = toBits(data, 32);
  input.randBits  = toBits(BigInt(input.random), 64);

  // เขียนกลับ input.json
  fs.writeFileSync('input.json', JSON.stringify(input, null, 2));

  console.log('✔ อัปเดต inputBits และ randBits ใน input.json เรียบร้อย');
}

main();
