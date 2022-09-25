const { readFile } = require('fs/promises');
import { ethers } from "hardhat";

const baseURI = 'https://smart-piglets-founders-club-metadata.s3.us-east-2.amazonaws.com/';
const abiPath = './artifacts/contracts/MyNFT.sol/MyNFT.json';

async function main() {
    const accounts = await ethers.getSigners();
    console.log(`using address: ${accounts[0].address}`);

    let file = await readFile('deployed.txt', {encoding: 'utf-8'});
    let contracts = file.split('\n');
    let contractAddress = 
        (contracts[contracts.length - 1]) === '' 
            ? contracts[contracts.length - 2] 
            : contracts[contracts.length - 1];
    console.log(`using contract address: ${contractAddress}`);

    let contractJSON = await readFile(abiPath, { encoding: 'utf-8'});
    let abi = JSON.parse(contractJSON).abi;
    const nftContract = new ethers.Contract(contractAddress, abi, accounts[0]);
    console.log('connecting to contract: ', await nftContract.name());

    console.log('current baseURI: ', await nftContract.baseURI());
    console.log(`setting baseURI to ${baseURI}`);
    let tx = await nftContract.setBaseURI(baseURI);
    console.log(`tx hash: ${tx.hash}`);
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});