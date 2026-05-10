const hre = require("hardhat");

async function main() {
  const Music = await hre.ethers.getContractFactory("BlockchainMusik");
  const music = await Music.deploy("0xFdDA0ef673e6A2FE1ABcF4e285B91a99320b3708");
  await music.waitForDeployment();
  console.log("Contract deployed to:", await music.getAddress());
}

main().catch(console.error);
