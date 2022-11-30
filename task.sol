// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./ERC721mock.sol";

contract Quiz is ERC721{
   constructor(string memory name, string memory symbol) ERC721(name, symbol) {} 

struct asset{
        string name;
        address payable assetOwner;
        uint price;
        uint noOfShares;
        uint pricePerShare;       
}

mapping (uint => asset) assetListing;  

/*  Checks if the asset that buyer is trying to buy exists or not, 
    Is it In stock?
    & Do the buyer have enugh balance to buy it */
 modifier checkAssetAvailability(uint tokenId){   
            require(assetListing[tokenId].noOfShares > 0, "The asset you're trying to but does not exist");
            require(msg.sender.balance>= assetListing[tokenId].price, "You do not have enough funds to buy  this asset");  
        _; }

 modifier assetExits(uint tokenId){   
            require(_exists(tokenId)== true, "The asset you're trying to but does not exist");
        _; }

function ownerOf(uint tokenId) public view override returns (address){
        return assetListing[tokenId].assetOwner;
}

function listAsset( uint tokenId, 
                    string memory _name, 
                    address payable assetOwner, 
                    uint _price, 
                    uint _noOfShares, 
                    uint _pricePerShare) 
    assetExits(tokenId) public{    
        require(assetListing[tokenId].assetOwner == msg.sender, "You are not the owner of this asset");
        assetListing[tokenId]= asset(_name, assetOwner, _price, _noOfShares, _pricePerShare) ;
}

function buyAsset(uint tokenId) checkAssetAvailability(tokenId) assetExits(tokenId) payable public{
            IERC721 paytoken;
            assetListing[tokenId].assetOwner.transfer(assetListing[tokenId].price);
            paytoken.transferFrom(assetListing[tokenId].assetOwner, msg.sender, tokenId);
 }
 
}
