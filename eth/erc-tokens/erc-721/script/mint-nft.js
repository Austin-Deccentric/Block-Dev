const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = `0x${process.env.PRIVATE_KEY}`;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;


const contract = require("../artifacts/contracts/atadiaNFT.sol/atadiaNFT.json");

// provider - Alchemy
const alchemyProvider = new ethers.providers.AlchemyProvider(network="rinkeby", API_KEY);

// signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);

// contract instance
const nft = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer)

// load json data
let metaData = require('../metadata/metadata.json')


function main() {
    console.log("Waiting 5 blocks for confirmation...");
    nft
        .mintNFT(process.env.PUBLIC_KEY, JSON.stringify(metaData[1]))
        .then((tx) => tx.wait(5))
        .then((receipt) => console.log(`Your transaction is confirmed, its receipt is: ${receipt.transactionHash}`))

        .catch((e) => console.log("something went wrong", e));
}
    
main();