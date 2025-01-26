#!/bin/bash

DATA_DIR="./testchain"                   # 测试链数据目录
GETH_BINARY="../build/bin/geth"          # 替换为 Geth 的可执行文件路径

$GETH_BINARY --datadir $DATA_DIR --networkid 200 --rpc --rpcapi "personal,eth,net,web3" --allow-insecure-unlock --nodiscover console