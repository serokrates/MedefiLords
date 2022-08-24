pragma solidity ^0.8.11;

import "./console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MedefiLordsArmy is ERC721Enumerable, Ownable, Console{
  using SafeMath for uint;
  uint randNonce = 0;

  constructor() ERC721("MedefiLordsArmy", "OneDenar") public {

  }
  event NewItem(uint id, uint16 biom, uint[] parcels);
  event arrayoutput(uint[] armour_count);
  event arrayoutput2(uint defence_count);
  event NewBuilding(uint id, uint class, bool Isset);
  event NewCompany(string nameOfCompany);

  struct Company{
    //uint id;
    uint256[] combined;
    string nameOfCompany;
    uint256[] armour;
    uint256[] weapon;
    uint typeOfWeapon;
    bool horseback;
    bool ranged;
  }

  Company[] public companies;


  mapping (uint => address) public companyToOwner;
  mapping (address => uint) ownerCompanyCount;

    function armourOutput(uint itemID) external{
      emit arrayoutput(companies[itemID].armour);
    }
    function defenceOutput(uint itemID) external{
      emit arrayoutput2(companies[itemID].combined[4]);
    }

    function _createSoldier(string memory nameOfCompany,bool horseback,bool ranged, uint _typeOfWeapon) internal{
        uint256[] memory combined = new uint256[](12);
        // uint soldiersNum;
        // uint lvl;
        // uint exp;
        // uint attack;
        // uint defence;
        // uint speed;
        // uint isGarrisoned; 
        // uint barracksId;
        // uint wallId;
        // uint armorIdAddon 
        // uint armsIdAddon  
        // uint companyVeteranId 
        combined[0] = 0;
        uint256[] memory armour = new uint256[](3);
        uint256[] memory weapon = new uint256[](3);
  
        companies.push(Company(combined,nameOfCompany,armour,weapon,_typeOfWeapon,horseback,ranged));
        uint _id = companies.length - 1;
        companyToOwner[_id] = msg.sender;
        ownerCompanyCount[msg.sender] = ownerCompanyCount[msg.sender].add(1);
        emit NewCompany(nameOfCompany);
        _mint(msg.sender, _id);
    }
    function createSoldier(string memory nameOfCompany,bool horseback,bool ranged, uint typeOfWeapon) external payable{
      require(msg.value == 1 ether);
        _createSoldier(nameOfCompany,horseback,ranged,typeOfWeapon);
        payable(owner()).transfer(1 ether);
    }
    function giveWeaponToTheCompany(uint _id,uint _weaponLvl,uint _typeOfWeapon, uint _amount) external onlyOwner payable{
      require(companyToOwner[_id]==msg.sender);
      uint alreadyGiven = companies[_id].weapon[0]+companies[_id].weapon[1]+companies[_id].weapon[2];
      uint freeSpace = 100-alreadyGiven;
      if(_amount < freeSpace){
        if(_weaponLvl==1){
          require(msg.value == 1 ether);
          companies[_id].weapon[0]=companies[_id].weapon[0]+_amount;
          // linijka poniżej updejtuje armor oddziału
          companies[_id].combined[3]=companies[_id].combined[3]+_amount;
        }else if(_weaponLvl==2){
          require(msg.value == 2 ether);
          companies[_id].weapon[1]=companies[_id].weapon[0]+_amount;
          companies[_id].combined[3]=companies[_id].combined[3]+_amount*2;
        }else if(_weaponLvl==3){
          require(msg.value == 3 ether);
          companies[_id].weapon[2]=companies[_id].weapon[0]+_amount;
          companies[_id].combined[3]=companies[_id].combined[3]+_amount*3;
        }
      }
      
    }
    function giveArmorToTheCompany(uint _id,uint _armourLvl,uint _amount2) external onlyOwner payable{
      //zmiana armora kompanii
      uint alreadyGiven2 = companies[_id].armour[0]+companies[_id].armour[1]+companies[_id].armour[2];
      uint freeSpace2 = 100-alreadyGiven2;
      if(_amount2 <= freeSpace2){
        if(_armourLvl==1){
          require(msg.value == 1 ether);
          companies[_id].armour[0]=companies[_id].armour[0]+_amount2;
          // linijka poniżej updejtuje armor oddziału
          companies[_id].combined[4]=companies[_id].combined[4]+_amount2;

        }else if(_armourLvl==2){
          require(msg.value == 2 ether);
          companies[_id].armour[1]=companies[_id].armour[0]+_amount2;
          // linijka poniżej updejtuje armor oddziału
          companies[_id].combined[4]=companies[_id].combined[4]+_amount2*2;

        }else if(_armourLvl==3){
          require(msg.value == 3 ether);
          companies[_id].armour[2]=companies[_id].armour[0]+_amount2;
          // linijka poniżej updejtuje armor oddziału
          companies[_id].combined[4]=companies[_id].combined[4]+_amount2*3;

        }
      }
    }

  }

