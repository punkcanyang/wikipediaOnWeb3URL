// scripts/deploy.js

// const hre = require("hardhat");

import hre from "hardhat";

async function main() {
  const MyContract = await hre.ethers.getContractFactory("manualMode");
  const myContract = await MyContract.deploy();

  // await myContract.deployed();

  console.log("MyContract deployed to:", await myContract.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
