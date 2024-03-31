import { ethers } from "hardhat";
import "@nomiclabs/hardhat-ethers";

async function main() {
  const DataContent = await ethers.getContractFactory("DataContent");
  const dataContent = await DataContent.deploy();

  const tx = await dataContent.deployed();
  const rec = await tx.deployTransaction.wait();
  console.log(`Contract deployed to '${dataContent.address}'`);
  console.log(`Transaction hash: '${rec.transactionHash}'\n`);

  const tableName = await dataContent.tableName();
  console.log(`Table name '${tableName}' minted to contract.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
