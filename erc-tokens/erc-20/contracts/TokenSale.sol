// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "./Token.sol";

contract atadiaSale is Ownable {

    // Token Contract
    Atadia _token;

    // rate
   uint256 public rate = 1000;
    // uint256 amountToBuy;

    // Event that logs sale operation
    event BuyTokens(address _buyer, uint256 _amountEth, uint256 _amountToken);

    constructor(address _tokenContract) {
        _token = Atadia(_tokenContract);
    }

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

    function buyToken(address reciever) public payable {
        require( msg.value > 0, "Your ETH balance is low." );
        
        uint256 base = 1 ether;
        uint256 amtpayed = div(msg.value, base, "Division by zero error");
        uint256 amountToBuy = mul(amtpayed,  rate);

        // Mint new tokens to provided address
        (bool sent) = _token.issueToken(reciever, amountToBuy);
        require(sent, "Failed to complete sale");

        emit BuyTokens(reciever, msg.value, amountToBuy);
    }

    function endSale() public onlyOwner{
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No FUNDS to transfer");

        // transfer to owner
        (bool sent,) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Sale proceeds to owner");

    }

}