pragma solidity <0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/access/Ownable.sol";

contract Covid19CryptoFund is Ownable {
    
    event EthReceived(uint256);
    event ERC20Received(address, uint256);
    
    using SafeMath for uint256;

    uint256 public weiBalance;
    mapping ( address => uint256 ) public balances;

    function sendEth(address payable to, uint amount) external onlyOwner {
        require(amount <= weiBalance, "Insufficient ethers balance");
        
        weiBalance = weiBalance.sub(amount);

        to.transfer(amount);
    }

    function sendERC20(address to, address erc20Contract, uint tokens) external onlyOwner {
        require(tokens <= balances[erc20Contract], "Insufficient token balance");
        
        balances[erc20Contract] = balances[erc20Contract].sub(tokens);
        
        bool result = IERC20(erc20Contract).transfer(to, tokens);
        
        require(result, "Something went wrong");
    }
    
    function receiveERC20(uint256 tokens, address erc20Contract) external {
        erc20Contract.delegatecall(
            abi.encodeWithSignature(
                "transfer(address,uint)",
                address(this),
                tokens
            )
        );

        balances[erc20Contract] = balances[erc20Contract].add(tokens);

        emit ERC20Received(erc20Contract, tokens);
    }

    function receiveEth() external payable {
        require(msg.value > 0, "No ethers sent");
        
        emit EthReceived(msg.value);
        
        weiBalance = weiBalance.add(msg.value);
    }
}