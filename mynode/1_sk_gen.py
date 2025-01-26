import os
import sys

# 定义输出文件路径
output_file = "data/private_keys.txt"

# 生成私钥的函数
def generate_private_key():
    return os.urandom(32).hex()

# 批量生成私钥
def generate_private_keys(num_keys):
    keys_list = []
    for _ in range(num_keys):
        private_key = generate_private_key()
        keys_list.append(f"0x{private_key}")  # 以 0x 开头的私钥格式
    return keys_list

# 主函数
if __name__ == "__main__":
    # 从命令行参数获取 num_keys
    if len(sys.argv) != 2:
        print("Usage: python generate_keys.py <num_keys>")
        sys.exit(1)

    try:
        num_keys = int(sys.argv[1])
        if num_keys <= 0:
            raise ValueError
    except ValueError:
        print("Error: <num_keys> must be a positive integer.")
        sys.exit(1)

    # 生成私钥
    private_keys = generate_private_keys(num_keys)

    # 写入到 TXT 文件
    os.makedirs(os.path.dirname(output_file), exist_ok=True)  # 创建目录（如果不存在）
    with open(output_file, "w") as txt_file:
        for key in private_keys:
            txt_file.write(f"{key}\n")

    print(f"批量生成的 {num_keys} 个私钥已保存为 {output_file}")