#!/bin/bash

# 配置变量
PUBLIC_KEYS_FILE="./data/public_keys.txt" # 公钥文件路径
GENESIS_FILE="./genesis.json"            # 创世块文件路径
DATA_DIR="./testchain"                   # 测试链数据目录
GETH_BINARY="../build/bin/geth"          # 替换为 Geth 的可执行文件路径
ALLOC_BALANCE="0xFFFFFFFFFFFFFFFFFFFFFFFFF" # 分配的大量余额 (单位: wei)

# 删除并创建数据目录
rm -rf $DATA_DIR && mkdir -p $DATA_DIR

# 创建创世块文件
echo "Creating genesis file..."
cat > $GENESIS_FILE <<EOL
{
  "config": {
    "chainId": 200,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0
  },
  "difficulty": "0x1",
  "gasLimit": "8000000",
  "alloc": {
EOL

# 为每个公钥分配余额
while IFS= read -r public_key; do
  if [[ -n "$public_key" ]]; then
    echo "    \"$public_key\": { \"balance\": \"$ALLOC_BALANCE\" }," >> $GENESIS_FILE
  fi
done < "$PUBLIC_KEYS_FILE"

# 删除最后一行的逗号并关闭 JSON
sed -i '$ s/,$//' $GENESIS_FILE
cat >> $GENESIS_FILE <<EOL
  }
}
EOL

echo "Genesis file created at $GENESIS_FILE."

# 初始化链
echo "Initializing the testchain..."
$GETH_BINARY --datadir $DATA_DIR init $GENESIS_FILE
if [ $? -ne 0 ]; then
  echo "Error: Failed to initialize the testchain." >&2
  exit 1
fi

# 启动测试链
echo "Starting the testchain..."
$GETH_BINARY --datadir $DATA_DIR --networkid 200 --rpc --rpcapi "personal,eth,net,web3" --miner.threads=1 --miner.gastarget=0 --allow-insecure-unlock --nodiscover console