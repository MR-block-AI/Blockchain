// const ganache = require('ganache-cli'); 

const HDWalletProvider = require("truffle-hdwallet-provider");
const Web3 = require("web3");
//const { interface, bytecode } = require("./compile"); // Old version Solc 0.5.0 
const { interface, bytecode } = require("./compile"); // New version Solc 0.5.0 

const provider = new HDWalletProvider(
  // nemotecnic wallet ether
  // incorporate your seed testing here, each word separated by space 
  "word1 word2 word3 word4 word5 word6 word7 word8 word9 word10 word11 word12",
  
  // enlace a red conectar with INFURA
  "https://rinkeby.infura.io/v3/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" // walletProvider access Rinkeby
);
const web3 = new Web3(provider); // utiliza provider y genera constructor web3 para red rinkeby

//truffle-hdwallet-provider versions 0.0.4, 0.0.5 and 0.0.6
//    const result = await new web3.eth.Contract(JSON.parse(interface))
//         .deploy({data: '0x' + bytecode, arguments: ['Hi there!']}) // add 0x bytecode
//         .send({from: accounts[0]}); // remove 'gas'

// funcion extra ayuda a conexion asyncronica
const deploy = async () => {
  const accounts = await web3.eth.getAccounts();
  console.log("contract creado por cuenta", accounts[0]); // cuenta[0] creadora contrat
  // constructor
  // manera de utilizar constructor y de generar el contrato inicializado en cualquier red
  
  //const result = await new web3.eth.Contract(JSON.parse(interface)) // usa provider para desplegar contrato Old solc 0.5.0 or minor
  const result = await new web3.eth.Contract(interface) // usa provider para desplegar contrato NEW solc 0.5.0 or HIGER
  // Contract lottery no requiere parametros entrada, arguments empty
  //.deploy({ data: bytecode, arguments: ['Hi'] }) // add 0x bytecode in NEW SOLC 0.5.0 or HIGER
  .deploy({ data: '0x' + bytecode }) // add 0x bytecode in NEW SOLC 0.5.0 or HIGER
  .send({ from: accounts[0], gas: "2000000"}); // remove 'gas' but problem Error: intrinsic gas too low// solution include Gas Limit
  //  .deploy({ data: "0x" + bytecode }) // add 0x bytecode
  //  .send({ gas: "1000000", from: accounts[0] }); // remove 'gas' but problem Error: intrinsic gas too low// solution include Gas Limit
  // despliega consola interface contrato
  console.log(interface);
  console.log("contract desplegado en:", result.options.address); //nuestra direccion contrato
};
deploy();
