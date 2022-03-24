// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4; 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./TokenStake.sol";

contract Atadia is ERC20, Ownable, TokenStake{
    
    // rate
    uint256 public rate = 1000;

    // owner
    address private owner;
    
    constructor() ERC20("Atadia", "ATA"){
        _mint(msg.sender, 1000 * 10**18);
        owner = msg.sender;

    }

    // Event that logs sale operation
    event BuyTokens(address _buyer, uint256 _amountEth, uint256 _amountToken);

    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function buyToken() public payable {
        require( msg.value > 0, "Your ETH balance is low." );
        
        uint256 base = 1 ether;
        uint256 amtpayed = div(msg.value, base, "Division by zero error");
        uint256 amountToBuy = mul(amtpayed,  rate);

        // Mint new tokens to provided address
        (bool sent) = transfer(msg.sender, amountToBuy);
        require(sent, "Failed to complete sale");

        emit BuyTokens(msg.sender, msg.value, amountToBuy);
    }

    function modifyTokenBuyPrice(uint234 _rate) public onlyOwner  {
        rate = _rate;
    }
   
    
}