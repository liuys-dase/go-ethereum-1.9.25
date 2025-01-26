#!/bin/bash

# 生成私钥
python3 1_sk_gen.py 10

# 根据私钥创建账户，保存公钥
bash 2_pk_gen.sh

# 生成创世块文件，同时为账户分配初始化余额
bash 3_chain_gen.sh