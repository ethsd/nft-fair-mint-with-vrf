const conf = require("config");
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";


// https://wiki.polygon.technology/docs/develop/hardhat/

// const config: HardhatUserConfig = {
//   solidity: "0.8.17",
// };

// export default config;

const config: HardhatUserConfig = {
  defaultNetwork: "mumbai",
  networks: {
    hardhat: {
    },
    mumbai: {
      url: "https://matic-mumbai.chainstacklabs.com",
      accounts: [conf.get("PRIV_KEY")]
    }
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
}

export default config;

// module.exports = {
//   defaultNetwork: "mumbai",
//   networks: {
//     hardhat: {
//     },
//     mumbai: {
//       url: "https://matic-mumbai.chainstacklabs.com",
//       accounts: [conf.get("PRIV_KEY")]
//     }
//   },
//   solidity: {
//     version: "0.8.17",
//     settings: {
//       optimizer: {
//         enabled: true,
//         runs: 200
//       }
//     }
//   },
// }

// 0xC7763940AB5c830eE7ecC9B8c53f3f476D0ed1fF
// unique nut pepper luggage pilot eager shine theme key differ casual turtle