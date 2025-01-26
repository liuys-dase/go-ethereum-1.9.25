// 使用 Geth 的默认账户
var fromAddress = eth.accounts[0];      // 默认使用第一个账户
var toAddress = eth.accounts[1];        // 替换为接收方地址
var password = "password";              // 替换为账户密码
var amountEther = 0.1;                 // 转账金额（单位：Ether）

// 解锁账户
personal.unlockAccount(fromAddress, password);

// 发送交易
var txHash = eth.sendTransaction({
    from: fromAddress,
    to: toAddress,
    value: web3.toWei(amountEther, "ether")
});

// 输出交易哈希
console.log("交易已发送，交易哈希：", txHash);