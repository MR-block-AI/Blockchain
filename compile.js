const path = require("path");
const fs = require("fs");
const solc = require("solc");

// define nombre variables ruta contract
const lotteryPath = path.resolve(__dirname, 'contracts', 'Lottery.sol');
const source = fs.readFileSync(lotteryPath, 'utf-8');

// Previo a SOLC 0.5.0
    //module.exports = solc.compile(source, 1).contracts[":Lottery"];
    //console.log(solc.compile(source,1)); // muestra log consola

// PARA SOLC 0.5.0 o superior
const imput = {
    language: 'Solidity',
    sources: {
        'Lottery.sol' : {
            content: source
        }
    },
    settings: {
        outputSelection: {
            '*': {
                '*': [ '*' ]
            }
        }
    }
}; 
console.log('compiling contract....');
//let compiledContract = JSON.parse(solc.compile(JSON.stringify(input)));

const output = JSON.parse(solc.compile(JSON.stringify(imput)));
console.log('Contract Compiled!!');

console.log("output",output) //allways check what you are getting

console.log('Creating interface...');  
//const interface = output.contracts['Lottery.sol'].Lottery.abi
const interface = output.contracts['Lottery.sol']['Lottery'].abi;

console.log('Creating bytecode...');
//const bytecode = output.contracts['Lottery.sol'].Lottery.evm.bytecode.object;
const bytecode = output.contracts['Lottery.sol']['Lottery'].evm.bytecode.object;

console.log('View bytecode...');
console.log(`bytecode: ${bytecode}`);

console.log('View interface...');  
console.log(`interface: ${JSON.stringify(interface, null, 2)}`);


console.log('Creating ModuleExports...');
//module.exports = output.contracts["Lottery.sol"]["Lottery"];
module.exports = { interface, bytecode};
