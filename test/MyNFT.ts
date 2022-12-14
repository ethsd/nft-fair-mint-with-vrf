import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

const myName = "Smart Piglets NFT project";
const mySymbol = "SPNFT";
const mintPrice = 0;
const totalSupply = 10;
const subscriptionId = Math.floor(Math.random() * 1000);

describe("MyNFT", function() {
    async function deployNFTFixture() {

        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();

        const NFTContract = await ethers.getContractFactory("MyNFT");
        const contract = await NFTContract.deploy(
            myName, 
            mySymbol, 
            mintPrice,
            totalSupply,
            subscriptionId
        );

        return { contract, owner, otherAccount };
    }

    describe("Deployment", function() {
        it("Should have the correct name", async function() {
            const { contract } = await loadFixture(deployNFTFixture);
            expect(await contract.name()).to.equal(myName);
        });

        it("Should have the correct symbol", async () => { // optional function declaration
            const { contract } = await loadFixture(deployNFTFixture);
            expect(await contract.symbol()).to.equal(mySymbol);
        });

        it("Should have the correct mint price", async () => { 
            const { contract } = await loadFixture(deployNFTFixture);
            // make a passing expect statement
            expect(await contract.mintPrice()).to.equal("replace me");
        });

        it("Should have the correct token supply", async () => { 
            const { contract } = await loadFixture(deployNFTFixture);
            // add a passing expect statement
            await expect.fail("replace with passing test");
        });

        it("Should have the correct subscription id", async () => { 
            const { contract } = await loadFixture(deployNFTFixture);
            // add a passing expect statement
            await expect.fail("replace with passing test");
        });
    });
})