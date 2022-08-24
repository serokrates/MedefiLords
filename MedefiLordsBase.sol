pragma solidity ^0.8.11;
import "./MedefiLordsLand.sol";
import "./MedefiLordsBuildings.sol";
import "./MedefiLordsArmy.sol";
import "./console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MedefiLordsBase is ERC721Enumerable, Ownable, Console{
  using SafeMath for uint;
    MedefiLordsLand Land;
    MedefiLordsBuildings Building;
    MedefiLordsArmy Army;
    
  uint startTime;

  bool isInitialized = false;

  constructor() ERC721("MedefiLordsBase", "OneDenar") public {
    Land = MedefiLordsLand(0xf8e81D47203A594245E36C48e151709F0C19fBe8);
    Army = MedefiLordsArmy(0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8);
    Building = MedefiLordsBuildings(0xd9145CCE52D386f254917e481eB44e9943F39138);

  }


    function tmp() public view returns(uint){
        require(startTime != 0);
        return (block.timestamp - startTime)/(1 minutes);
    }
    function callThisToStart() public{
        startTime = block.timestamp;
    }
    function callThisToStop() public{
        startTime = 0;
    }
    function doSomething() public returns (uint){
        return tmp();
    }
    ////////////////////////////////////////////////////////////////////
    
    function build(uint itemID, uint buildingId, uint parcelId) external onlyOwner{
      address adr = Building.getaddress(itemID);
      require(adr==msg.sender);
      Building.setTrue(buildingId);
      Land.buildOnParcel(itemID,buildingId,parcelId);
    }
    function unbuild(uint itemID, uint buildingId, uint parcelId) external onlyOwner{
      address adr = Building.getaddress(itemID);
      require(adr==msg.sender);
      Building.setFalse(buildingId);
      Land.unBuildOnParcel(itemID,buildingId,parcelId);
    }
    function onWalls() public{
    }
    function offWalls() public{}
    function onBarracks() public{
    }
    function offBarracks() public{
    }

    function battle() public{
      // if(attacker_won==True){
      //   raiding(attacker_address);
      // }
    }
    //////// it could look like this - thi is just my assumptions
    function raiding(uint dzialka_id,address attacker_address) public{
      Land.isRadedTrue(dzialka_id,attacker_address);
      //Land.items[dzialka_id].isRaided=true;
      //Land.items[dzialka_id].attackerAddress=attacker_address;
    }

    function createLordFlag() public{

    }
    function createFlag() public{

    }
    function rewards(uint dzialka_id) internal{
      if(Land.items[dzialka_id].isRewarded=false){
        if(Land.items[dzialka_id].attackerAddress!=address(0)){
          sendRewards(Land.items[dzialka_id].attackerAddress);
          Land.items[dzialka_id].isRewarded=true;
        }
      }else if(Land.items[dzialka_id].isRewarded=true){
        require (Land.items[dzialka_id].isRewarded);

      }
    }
  function sendRewards(address _attackerAddress) internal{
  }
  }

