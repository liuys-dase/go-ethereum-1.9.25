#!/bin/bash

# 配置变量
PRIVATE_KEYS_FILE="./data/private_keys.txt"  # 私钥文件路径
PASSWORD="password"                  # 账户密码
PASSWORD_FILE="./password.txt"       # 密码临时文件
TEMP_KEY_FILE="./temp_key.txt"       # 临时私钥文件
GETH_BINARY="../build/bin/geth"      # 替换为 Geth 的可执行路径
DATA_DIR="./testchain"               # 数据目录
PUBLIC_KEYS_FILE="./data/public_keys.txt" # 存放公钥的文件

# 创建数据目录
mkdir -p $DATA_DIR

# 清空公钥文件（如果已存在）
> $PUBLIC_KEYS_FILE

# 创建密码文件
echo "$PASSWORD" > $PASSWORD_FILE

# 遍历私钥文件中的每个私钥并导入
while IFS= read -r private_key; do
  if [[ -n "$private_key" ]]; then
    echo "Importing private key: $private_key"
    # 将私钥写入临时文件
    echo "${private_key#0x}" > $TEMP_KEY_FILE
    # 使用临时文件导入私钥
    OUTPUT=$($GETH_BINARY --datadir $DATA_DIR account import --password $PASSWORD_FILE $TEMP_KEY_FILE 2>&1)
    if [ $? -ne 0 ]; then
      echo "Error: Failed to import private key $private_key." >&2
      # 清理临时文件
      rm -f $TEMP_KEY_FILE $PASSWORD_FILE
      exit 1
    fi

    # 提取公钥地址，并添加 0x 前缀
    if echo "$OUTPUT" | grep -q "Address:"; then
      PUBLIC_KEY=$(echo "$OUTPUT" | grep "Address:" | awk -F'[{}]' '{print $2}')
      PUBLIC_KEY_WITH_PREFIX="0x$PUBLIC_KEY"
      echo "Imported account with public key: $PUBLIC_KEY_WITH_PREFIX"
      echo "$PUBLIC_KEY_WITH_PREFIX" >> $PUBLIC_KEYS_FILE
    else
      echo "Error: Could not extract public key for $private_key." >&2
      rm -f $TEMP_KEY_FILE $PASSWORD_FILE
      exit 1
    fi
  fi
done < "$PRIVATE_KEYS_FILE"

# 清理临时文件
rm -f $TEMP_KEY_FILE $PASSWORD_FILE

echo "All private keys have been successfully imported."
echo "Public keys have been saved to $PUBLIC_KEYS_FILE."