// require('dotenv').config();

async function main(Atadia) {
    const TOKEN_CONTRACT = process.env.TOKEN_CONTRACT
    const SALE = await ethers.getContractFactory(Atadia)
    
  
    // Start deployment, returning a promise that resolves to a contract object
    const SALE_CONTRACT = await SALE.deploy(TOKEN_CONTRACT)
    await SALE_CONTRACT.deployed()
    console.log("Contract deployed to address:", SALE_CONTRACT.address)
    console.log("View on Etherscan: https://ropsten.etherscan.io/address/".concat(SALE_CONTRACT.address))
  }
  
  main("atadiaSale")
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })