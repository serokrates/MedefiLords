pragma solidity ^0.8.11;
import "./console.sol";
import "./MedefiLordsBuildings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MedefiLordsLand is ERC721Enumerable, Ownable, Console{
  using SafeMath for uint;
  MedefiLordsBuildings Building;
  uint randNonce = 0;
  uint16[] map_biom;
  uint[] map_id;


  constructor() ERC721("MedefiLordsLand", "OneDenar") public {
    Building = MedefiLordsBuildings(0xd9145CCE52D386f254917e481eB44e9943F39138);
    map_biom = [15, 15, 15, 15];
    map_id= [   0,    1,    2,    3];
  }
  event NewItem(uint id, uint16 biom, uint[] parcels);
  event arrayoutput(uint[] armour_count);
  event arrayoutput2(uint defence_count);
  event NewBuilding(uint id, uint class, bool Isset);
  event NewCompany(string nameOfCompany);

  struct Item {
    uint id;
    uint biom;
    // parcels jest do budowania budynków
    uint256[] parcels;
    // isRaided czy została najechana
    bool isRaided;
    address attackerAddress;
    //jakiej klasy są umocnienia
    uint wallsClass;
    // oraz ile aktualnie jest na nich wojska
    uint soldiersOnWallsNum;
    //jakie kompanie są na murach
    uint[] companyOnWalls;
    //czy w danym dniu zostały wydane rewardy za budynki na tej działce
    bool isRewarded;
  }


  Item[] public items;
    function isRadedTrue (uint dzialka_id, address attacker_address) external{
      // tutaj coś trzeba ograniczyć dostęp bo inaczej każdy może to zmienić
      //require(itemToOwner[dzialka_id]==msg.sender);
      items[dzialka_id].isRaided=true;
      items[dzialka_id].attackerAddress=attacker_address;
    }
    function buildOnParcel(uint itemID, uint buildingId, uint parcelId) external{
      require(Building.getaddress(buildingId)==msg.sender && itemToOwner[itemID]==msg.sender);
        items[itemID].parcels[parcelId]=buildingId;
    }
    function unBuildOnParcel(uint itemID, uint buildingId, uint parcelId) external{
      require(itemToOwner[itemID]==msg.sender);
        items[itemID].parcels[parcelId]=0;
    }


  function randModL(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
  }
  mapping (uint => address) public itemToOwner;
  mapping (address => uint) ownerItemCount;

   function _createItem(uint _id) internal {
    uint _idOfTheItem = map_id[_id];
    uint16 _biom = map_biom[_idOfTheItem];
    uint[] memory _parcelowe = new uint256[](25);
    bool isRaided = false;
    address attackerAddress;
    uint wallsClass = 0;
    uint soldiersOnWallsNum = 0;
    uint[] memory companyOnWalls;
    bool isRewarded = false;

    items.push(Item(_idOfTheItem,_biom, _parcelowe,isRaided, attackerAddress, wallsClass, soldiersOnWallsNum, companyOnWalls, isRewarded));
    itemToOwner[_idOfTheItem] = msg.sender;
    ownerItemCount[msg.sender] = ownerItemCount[msg.sender].add(1);
    emit NewItem(_idOfTheItem, _biom, _parcelowe);
    _mint(msg.sender, _idOfTheItem);
  }
  function _rollId() internal returns (uint x){
    uint xx = map_id.length;
     x = randModL(xx);
    return(x);
  }
    function createDzialka() external payable{
      require(msg.value == 1 ether);
        uint _xx = _rollId();
        _createItem(_xx);
        delete map_id[_xx];
        map_id[_xx] = map_id[map_id.length - 1];
        map_id.pop();
        payable(owner()).transfer(1 ether);
    }


}
