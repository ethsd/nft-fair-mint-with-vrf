const { appendFile } = require('fs/promises');
import { ethers } from "hardhat";

// run with command:
// npx hardhat run scripts/deploy.js --network mumbai

// async function main() {
//   const currentTimestampInSeconds = Math.round(Date.now() / 1000);
//   const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
//   const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

//   const lockedAmount = ethers.utils.parseEther("1");

//   const Lock = await ethers.getContractFactory("Lock");
//   const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

//   await lock.deployed();

//   console.log(`Lock with 1 ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`);
// }

// replace with custom values
const myName = "MiniPigs";
const mySymbol = "mpNFT"; 
const mintPrice = 0;
const totalSupply = 10; // max value 33,333
const subId = 2003; // don't replace this

async function main() {
  const nftFactory = await ethers.getContractFactory("MyNFT");
  const nftContract = await nftFactory.deploy(
    myName,
    mySymbol,
    mintPrice,
    totalSupply,
    subId
  );

  await nftContract.deployed();

  let data = `${nftContract.address}\n`;
  await appendFile('deployed.txt', data, {encoding: 'utf-8'});
  console.log(`MyNFT contract deployed to ${nftContract.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
