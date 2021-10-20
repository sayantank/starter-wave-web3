// HRE is injected into our project. We don't import it

const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory(
    "StarterWaves"
  );
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.01"),
  });
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract Balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let waveTxn = await waveContract.wave("This is a message!");
  await waveTxn.wait();

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract Balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
