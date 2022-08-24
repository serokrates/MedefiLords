pragma solidity ^0.8.11;
import "./console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MedefiLordsBuildings is ERC721Enumerable, Ownable, Console{
  using SafeMath for uint;

  uint randNonce = 0;

  constructor() ERC721("MedefiLordsBuildings", "OneDenar") public {
      
  }
  event NewItem(uint id, uint16 biom, uint[] parcels);
  event arrayoutput(uint[] armour_count);
  event arrayoutput2(uint defence_count);
  event NewBuilding(uint id, uint class, bool Isset);
  event NewCompany(string nameOfCompany);

  struct Building {
    //uint id;
    uint class;
    // isSet tells us if the building has been built, if yes then it cannot be built again and the user must change the state if this variable
    bool isSet;
  }

  Building[] public buildings;

  function randModB(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
  }

  mapping (uint => address) public buildingToOwner;
  mapping (address => uint) ownerBuildingCount;

    function getaddress(uint n) external returns (address) {
        return (buildingToOwner[n]);
    }
    function setTrue(uint n) external returns (bool) {
      require(buildingToOwner[n]==msg.sender);
        buildings[n].isSet=true;
    }
    function setFalse(uint n) external returns (bool) {
      require(buildingToOwner[n]==msg.sender);
        buildings[n].isSet=false;
    }
    

    function createBuilding(uint256 class) external payable{
      uint _typeOfB = 0;
      // 1 - mine: rock 36%, coal 21%, copper 16%, iron 11%, silver 9%, gold 4%, jewels 3%,
      if(class == 1){
        require(msg.value == 1 ether);
        uint rand = randModB(100);
        
        if(rand <= 36) {
          //string memory _typeOfB = "rock";
          _typeOfB = 1;
        } else if(rand >36 && rand <= 57) {
          //string memory _typeOfB = "coal";
          _typeOfB = 2;
        } else if(rand >57 && rand <= 73) {
          //string memory _typeOfB = "copper";
          _typeOfB = 3;
        } else if(rand >73 && rand <= 84) {
          //string memory _typeOfB = "iron";
          _typeOfB = 4;
        } else if(rand >84 && rand <= 93){
          //string memory _typeOfB = "silver";
          _typeOfB = 5;
        }else if(rand >93 && rand <= 97) {
          //string memory _typeOfB = "gold";
          _typeOfB = 6;
        }else if(rand >97 && rand <= 100) {
          //string memory _typeOfB = "jewels";
          _typeOfB = 7;
        }

        _createBuildings(class,_typeOfB);
        payable(owner()).transfer(1 ether);
      // 2 - farm: crops 35% , cows 35% , sheep 20% , horses 10% ,  fruits 10%, 
      }else if(class == 2){
        require(msg.value == 1 ether);
        uint rand = randModB(100);

        if(rand <= 65) {
        } else if(rand >65 && rand <= 80) {
        } else if(rand >80 && rand <= 95) {
        } else if(rand >95 && rand <= 100) {
        }
        _createBuildings(class,_typeOfB);
        payable(owner()).transfer(1 ether);
      // 3 - workshops: tailor 35% , fletcher 35%, blacksmith 20%, armourer 10%,  goldsmith 10%,
      }else if(class == 3){
        require(msg.value == 1 ether);
        uint rand = randModB(100);

        if(rand <= 65) {
        } else if(rand >65 && rand <= 80) {
        } else if(rand >80 && rand <= 95) {
        } else if(rand >95 && rand <= 100) {
        }
        _createBuildings(class,_typeOfB);
        payable(owner()).transfer(1 ether);
      // 4 - barracks
      }else if(class == 4){
        require(msg.value == 1 ether);
        _createBuildings(class,_typeOfB);
        payable(owner()).transfer(1 ether);
      }else if(class == 4){
        
      }
    }
    function _createBuildings(uint _classOfBuilding, uint _type) internal{ 
        bool _isSet = false;
        buildings.push(Building(_classOfBuilding, _isSet));
        uint _id = buildings.length - 1 ;
        buildingToOwner[_id] = msg.sender;
        ownerBuildingCount[msg.sender] = ownerBuildingCount[msg.sender].add(1);

        emit NewBuilding(_id,_classOfBuilding, _isSet);
        _mint(msg.sender, _id);
    }

}

