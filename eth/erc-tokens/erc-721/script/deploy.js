async function main(Atadia) {
    const NFT = await ethers.getContractFactory(Atadia)
  
    // Start deployment, returning a promise that resolves to a contract object
    const nftContract = await NFT.deploy()
    await nftContract.deployed()
    console.log("Contract deployed to address:", nftContract.address)
    console.log("View on Etherscan: https://rinkeby.etherscan.io/address/".concat(nftContract.address))
  }
  
  main("atadiaNFT")
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })