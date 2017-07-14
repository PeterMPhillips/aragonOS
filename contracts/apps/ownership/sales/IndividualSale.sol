pragma solidity ^0.4.11;

import "./TokenSale.sol";

contract IndividualSale is TokenSale {
  address public buyer;
  uint public tokensOffered;
  uint public price;
  uint64 public expireBlock;

  function instantiate(address _dao, OwnershipApp _ownershipApp, ERC20 _raiseToken, ERC20 _saleToken, address _buyer, uint _price, uint _tokensOffered, uint64 _expireBlock) {
    super.instantiate(_dao, _ownershipApp, _raiseToken, _saleToken);

    require(buyer == 0 && _buyer != 0);
    require(_tokensOffered > 0 && _price > 0);
    require(getBlockNumber() < _expireBlock);

    buyer = _buyer;
    tokensOffered = _tokensOffered;
    price = _price;
    expireBlock = _expireBlock;
  }

  function buy(address _holder, uint _tokenAmount) internal {
    require(getBlockNumber() < expireBlock);
    require(_holder == buyer);
    require(_tokenAmount == tokensOffered * price);

    mintTokens(_holder, tokensOffered);
    closeSale();

    Buy(_holder, tokensOffered);
  }

  function close() {
    require(getBlockNumber() >= expireBlock);
    closeSale();
  }

  function sell(address holder, uint x) internal { throw; }
}
