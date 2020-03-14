pragma solidity <0.7.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Covid19CryptoFund is Ownable {
    using SafeMath for uint256;

    uint256 public weiBalance;
    mapping ( address => uint256 ) public balances;

    function sendEth(address to, uint amount) external onlyOwner {
        weiBalance.sub(amount);

        to.transfer(amount);
    }

    function sendERC20(address to, address erc20Contract, uint tokens) external onlyOwner {
        balances[erc20Contract].sub(tokens);
        
        IERC20(erc20Contract).transfer(msg.sender, balances[msg.sender]);
    }

    function receiveERC20(uint256 tokens, address erc20Contract) external {
        IERC20(erc20Contract).approve(address(this), tokens);

        IERC20(erc20Contract).transferFrom(msg.sender, address(this), tokens);

        balances[erc20Contract].add(tokens);
    }
    
    receive() external payable {
        weiBalance.add(msg.value);
    }
}