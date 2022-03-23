async function main(Atadia) {
    const TOKEN = await ethers.getContractFactory(Atadia)
    
  
    // Start deployment, returning a promise that resolves to a contract object
    const TOKEN_CONTRACT = await TOKEN.deploy()
    await TOKEN_CONTRACT.deployed()
    console.log("Contract deployed to address:", TOKEN_CONTRACT.address)
    console.log("View on Etherscan: https://ropsten.etherscan.io/address/".concat(TOKEN_CONTRACT.address))
  }
  
  main("Atadia")
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })