
// 随机生成 blockNum 个区块，每个区块包含 txNumPerBlock 笔交易

var password = "password";          // 替换为账户密码
var amountEther = 0.01;             // 转账金额（单位：Ether）
var addressNum = 10;                 // 使用的地址数
var blockNum = 8;                  // 区块数
var txNumPerBlock = 5;              // 每个区块的交易数

// 创建 addressNum 个发送地址（并且解锁） 和 目标地址
var fromAddresses = [];
var toAddresses = [];
for (var i = 0; i < addressNum; i++) {
    fromAddresses.push(eth.accounts[i]);
    toAddresses.push(eth.accounts[i]);
    personal.unlockAccount(eth.accounts[i], password);
}

// 开始生成交易和区块
for (var block = 0; block < blockNum; block++) {
    console.log("正在生成第", block + 1, "个区块...");
    
    for (var tx = 0; tx < txNumPerBlock; tx++) {
        var fromAddress = fromAddresses[Math.floor(Math.random() * fromAddresses.length)];
        var toAddress = toAddresses[Math.floor(Math.random() * toAddresses.length)];

        console.log("fromAddress: ", fromAddress, "toAddress: ", toAddress);

        // 发送交易
        var txHash = eth.sendTransaction({
            from: fromAddress,
            to: toAddress,
            value: web3.toWei(amountEther, "ether")
        });
    }

    // 等待挖矿生成区块
    miner.start(1);         // 开始挖矿（1个线程）
    admin.sleepBlocks(1);   // 确保区块生成完成
    miner.stop();           // 停止挖矿
}

console.log("所有区块生成完成！");