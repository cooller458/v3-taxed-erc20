const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("CREPE_V3", (m) => {
  // CREPE V3 token'ı deploy et
  const crepeV3 = m.contract("CREPE_V3");

  return { crepeV3 };
}); 