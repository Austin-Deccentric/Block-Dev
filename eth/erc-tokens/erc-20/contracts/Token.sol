// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Atadia is ERC20, Ownable{
    constructor() ERC20("Atadia", "ATA"){
        _mint(msg.sender, 10**6 * 10**18);
    }
    // Contract address of TokenSale contract
    address saleContract;

    // Only the TokenSale contract can mint new tokens. 
    modifier onlyTokenSale {
        require (msg.sender == saleContract);
        _;
    }

    function issueToken(address receiver, uint256 amount) external onlyTokenSale returns(bool sent){
        _mint(receiver, amount);
        return true;
    }

    /*
     Set this before making Token sales. 
    This tells our modifier which contract has the right to mint new tokens.
    */
    function setTokenSaleAddress (address _saleContract) public onlyOwner{
        saleContract = _saleContract;
    }
}