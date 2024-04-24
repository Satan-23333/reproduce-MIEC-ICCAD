import random

num1 = []
num2 = []
result = []
for i in range(10):
    x1 = random.randint(0, (2**7) - 1)
    x2 = random.randint(0, (2**7) - 1)
    num1.append(x1)
    num2.append(x2)
    result.append(x1 * x2)

for i in range(10):
    x1 = random.randint(-(2**7), 0)
    x2 = random.randint(-(2**7), 0)
    num1.append(x1)
    num2.append(x2)
    result.append(x1 * x2)

for i in range(10):
    x1 = random.randint(0, (2**7) - 1)
    x2 = random.randint(-(2**7), 0)
    num1.append(x1)
    num2.append(x2)
    result.append(x1 * x2)

for i in range(10):
    x1 = 0
    x2 = random.randint(-(2**7), (2**7) - 1)
    num1.append(x1)
    num2.append(x2)
    result.append(x1 * x2)

hex_num1 = []
hex_num2 = []
hex_result = []
for i in range(40):
    if num1[i] >= 0:
        hex_num1.append("8'H" + hex(num1[i])[2:].zfill(2).upper())
    else:
        hex_num1.append("8'H" + hex(num1[i] + 2**8)[2:].zfill(2).upper())

    if num2[i] >= 0:
        hex_num2.append("8'H" + hex(num2[i])[2:].zfill(2).upper())
    else:
        hex_num2.append("8'H" + hex(num2[i] + 2**8)[2:].zfill(2).upper())

    if result[i] >= 0:
        hex_result.append("16'H" + hex(result[i])[2:].zfill(4).upper())
    else:
        hex_result.append("16'H" + hex(result[i] + 2**16)[2:].zfill(4).upper())



# hex_num1 = '32\'H'+hex(num1)[2:].zfill(8).upper()
# hex_num2 ='32\'H'+ hex(int(binary_num2,2))[2:].zfill(8)
# hex_result = '64\'H'+hex(int(binary_result,2))[2:].zfill(16)


# print(f"乘数: ", hex_num1)
# print(f"被乘数: ", hex_num2)
# print(f"Result: ", hex_result)
content = ""
for i in range(40):

    content += f"num_a[{i}] = {hex_num1[i]};\n"

    content += f"num_b[{i}] = {hex_num2[i]};\n"

    content += f"result[{i}] = {hex_result[i]};\n"


with open("./tb.txt", "w") as f:  # open file for writing
    f.write(content)  # write formatted string to file
