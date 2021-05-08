// SPDX-License-Identifier: MIT
pragma solidity >=0.4.1 <0.8.0;
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/security/Pausable.sol";
import "./VRF20.sol";


// NEW CONTRACT 0x65492442B42c4B07750f55C8232052D11DeB43Bf 2021-05-03 14:16 hrs

contract Lottery is Pausable,  VRFD20(0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B,0x01BE23585060835E02B77ef475b0Cc51aA1e0709,
 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311,100000000000000000){
  // define variables  type variable visibilidad variable y nombre de variable
    address public manager; // Inicializa a administrador
    //address[10] public players; // arreglo fijo tamaño 10 de direcciones
    //address[] public players; // arreglo dinamico de direcciones
    address payable [] public players;
    event DiceWinner(address players_win;
   
    // Requiere oracles Chainlink
    // address vrfCoordinator;
    // address link;  
    // bytes32 keyHash;  
    // uint256 fee;

    // define funcion tipo constructor con igual nombre que el contrato
    //function Lottery() public {
    constructor() public {
        //owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        manager=msg.sender;
         // TESTNET RINKEBY 
        //_vrfCoordinator = 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B;
        //_link = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;  
        //_keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;  
        //_fee = 100000000000000000;
    }
    // funcion recibe valor payable
    // funcion candidata a pausable
    function enter() public payable  whenNotPaused {
      // Valid MIN ETHER deposito
        require(msg.value >= 0.001 ether);
        // ingresa address en players (matriz direcciones)
        players.push(msg.sender);
        
         //UNIRSE A NOMINA DE LANZADORES VRFD20
        lanzaInscribe((msg.value)*10000, msg.sender);
   }
   // funcion privada solo ejecuta internamente
   // funcion candidata a oraculo
   function random() private view whenNotPaused  returns (uint256){
       // funcion pseudo aleatoria, con block, time y cantidad players
       // retorno numero gigante en uint
        //return uint(sha3(block.difficulty, now, players)); // sha3 identico a keccak256
       //return uint(sha3(block.difficulty, block.timestamp, players)); // sha3 identico a keccak256
       // sha3 identico a keccak256 tradicional 
       return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players))); 
       
   }
   
   // funcion que selecciona al ganador de sorteo
    function PickWinner() public onlyOwner whenNotPaused returns ( address){
    // solo manager//owner call a winner
     //require (msg.sender == manager);
     require (msg.sender == owner);
    // index return indice de players ganador a partir de function random
     uint index = random() % players.length;
     // player[index] contiene address de ganador
     // method .transfer permite transferir valor acumulados
     // address(this).balance method que transfiere el total del valor acumulado
     players[index].transfer(address(this).balance);
     emit DiceWinner(players[index]);
    //
    //NEW METHOD CASA FORTUNA VRFD20
    //getnombreCasas(players[index]);
    
     // Reestablece Matriz dinamica de Players limpia para nuevos juegos con valores 0
     players= new address payable [](0); // arreglo de address con largo 0 inicial
     }
     
    // funcion modifier permite restriccion only owner
    modifier restricted() {
     require(msg.sender==manager);
     // permite continuar codigo
     _;
    }
    // funcion devuelve detalle usuarios y address participantes
    // funcion devuelve lista dinamica de address almacenada en players
    function getPlayers() public view returns ( address payable [] memory){
     return players;
    }
    
    // funcion devuelve balance almacenado total contrato
    function getBalance() public  view whenNotPaused  returns (uint256  ){
     return (address(this).balance);
    }

    // funcion realiza pausa contrato
    function pausar() external onlyOwner  {
        _pause();
    }

    // funcion realiza despausa contrato
    function unpausar() external onlyOwner  {
        _unpause();
    }
    
    // funcion realiza muestra Nombre Casas
    function getnombreCasas(address _player_house) view private onlyOwner whenNotPaused returns (string memory ) {
      return  house(_player_house);
    }

      // funcion realiza muestra Nombre Casas
      //  function nombreCasasID(address player_house) view external restricted  {
    //        houseID(player_house);
     //   }


    // funcion realiza lanzamiento dado
    function lanzaInscribe(uint256 _userProvidedSeed, address _roller) private whenNotPaused {
        rollDice(_userProvidedSeed%players.length, _roller);
    }
    
}
