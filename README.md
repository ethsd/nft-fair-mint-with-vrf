# NFT Fair Mint Demo

The code in this respository is intended to be
used during the live coding session of the 
Smart Piglets Fair Mint NFT Art Campaign presentation hosted by ETH SD.

The code herein is for educational purposes only, and affords no guarantees for correctness, nor extends any waranties. This code is not intended to be used in production, and has not undergone any security audit.

Please do not use this code in production. The intention of the following code is for demonstration purposes only, does not account for edge cases, and was not designed to be a complete solution to random
nft mints with Chainlink VRF.

To participate in the coding session, download the repo:

`git clone <this repo>`

Install the dependencies:

`npm install`

Begin by compiling the contracts:

`npx hardhat compile --network hardhat`

Test the compiled contracts:

`npx hardhat test --network hardhat`

You will need to add to the test suite to make the 
last three tests pass...

Deploy a new contract:

`npx hardhat run scripts/deploy.ts --network mumbai`

*Register contract address as a consumer*

Mint a token:

`npx hardhat run scripts/mint.ts --network mumbai`

Wait for the VRF coordinator to respond with a random number.

Check for owned tokens:

`npx hardhat run scripts/ownedTokens.ts --network mumbai`
