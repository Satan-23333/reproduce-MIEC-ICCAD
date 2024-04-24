import random

num1 = []
num2 = []
num3 = []
num4 = []
result = []
for i in range(40):
    x1 = random.randint(0, (2**8) - 1)
    x2 = random.randint(0, (2**8) - 1)
    x3 = random.randint(0, (2**8) - 1)
    x4 = random.randint(0, (2**8) - 1)
    num1.append(x1)
    num2.append(x2)
    num3.append(x3)
    num4.append(x4)
    result.append(x1 + x2 + x3 + x4)


hex_num1 = []
hex_num2 = []
hex_num3 = []
hex_num4 = []
hex_result = []
for i in range(40):

    hex_num1.append("8'H" + hex(num1[i])[2:].zfill(2).upper())

    hex_num2.append("8'H" + hex(num2[i])[2:].zfill(2).upper())

    hex_num3.append("8'H" + hex(num3[i])[2:].zfill(2).upper())

    hex_num4.append("8'H" + hex(num4[i])[2:].zfill(2).upper())

    hex_result.append("10'H" + hex(result[i])[2:].zfill(3).upper())


# hex_num1 = '32\'H'+hex(num1)[2:].zfill(8).upper()
# hex_num2 ='32\'H'+ hex(int(binary_num2,2))[2:].zfill(8)
# hex_result = '64\'H'+hex(int(binary_result,2))[2:].zfill(16)


# print(f"乘数: ", hex_num1)
# print(f"被乘数: ", hex_num2)
# print(f"Result: ", hex_result)
content = ""
content += "#(PERIOD*1+0.01);\n"
for i in range(40):

    content += "#(PERIOD)"
    content += "valid_in = 1;"
    content += f"data_in = {hex_num1[i]};\n"

    content += "#(PERIOD)"
    content += f"data_in = {hex_num2[i]};\n"

    content += "#(PERIOD)"
    content += f"data_in = {hex_num3[i]};\n"

    content += "#(PERIOD)"
    content += f"data_in = {hex_num4[i]};\n"

    content += f"result[{i}] = {hex_result[i]};\n"

content += "#(PERIOD*2);\n"

with open("./tb.txt", "w") as f:  # open file for writing
    f.write(content)  # write formatted string to file
