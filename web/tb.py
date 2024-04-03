import random

num1 = []
num2 = []
result = []
for i in range(10):
    x1 = random.randint(0, (2**31) - 1)
    x2 = random.randint(0, (2**31) - 1)
    num1.append(x1)
    num2.append(x2)
    result.append(x1 * x2)

for i in range(10):
    x1 = random.randint(-(2**31), 0)
    x2 = random.randint(-(2**31), 0)
    num1.append(x1)
    num2.append(x2)
    result.append(x1 * x2)

for i in range(10):
    x1 = random.randint(0, (2**31) - 1)
    x2 = random.randint(-(2**31), 0)
    num1.append(x1)
    num2.append(x2)
    result.append(x1 * x2)

for i in range(10):
    x1 = 0
    x2 = random.randint(-(2**31), (2**31) - 1)
    num1.append(x1)
    num2.append(x2)
    result.append(x1 * x2)

hex_num1 = []
hex_num2 = []
hex_result = []
for i in range(40):
    if num1[i] >= 0:
        hex_num1.append("32'H" + hex(num1[i])[2:].zfill(8).upper())
    else:
        hex_num1.append("32'H" + hex(num1[i] + 2**32)[2:].zfill(8).upper())

    if num2[i] >= 0:
        hex_num2.append("32'H" + hex(num2[i])[2:].zfill(8).upper())
    else:
        hex_num2.append("32'H" + hex(num2[i] + 2**32)[2:].zfill(8).upper())

    if result[i] >= 0:
        hex_result.append("64'H" + hex(result[i])[2:].zfill(16).upper())
    else:
        hex_result.append("64'H" + hex(result[i] + 2**64)[2:].zfill(16).upper())

# hex_num1 = '32\'H'+hex(num1)[2:].zfill(8).upper()
# hex_num2 ='32\'H'+ hex(int(binary_num2,2))[2:].zfill(8)
# hex_result = '64\'H'+hex(int(binary_result,2))[2:].zfill(16)


print(f"乘数: ", hex_num1)
print(f"被乘数: ", hex_num2)
print(f"Result: ", hex_result)
content = ""
for i in range(40):
    # print("#500;")
    content += "#500;\n"
    if i == 0:
        print("//正数*正数")
        content += "//正数*正数\n"
    elif i == 10:
        print("//负数*负数")
        content += "//负数*负数\n"
    elif i == 20:
        print("//正数*负数")
        content += "//正数*负数\n"
    elif i == 30:
        print("//0*随机")
        content += "//0*随机\n"

    # print("mult_begin = 1;")
    content += "mult_begin = 1;\n"

    # print(f"mult_op1 = {hex_num1[i]};")
    content += f"mult_op1 = {hex_num1[i]};\n"

    # print(f"mult_op2 = {hex_num2[i]};")
    content += f"mult_op2 = {hex_num2[i]};\n"

    # print(f"Data_in_t = {hex_result[i]};\n")
    content += f"Data_in_t = {hex_result[i]};\n"

    # print("#400;\nmult_begin = 0;\n")
    content += "#400;\nmult_begin = 0;\n"

with open("tb.txt", "w") as f:  # open file for writing
    f.write(content)  # write formatted string to file
