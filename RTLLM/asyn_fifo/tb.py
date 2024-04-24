import random

num = []

for i in range(48):
    num.append(0)





hex_num = []
for i in range(48):

    hex_num.append( hex(num[i])[2:].zfill(1).upper())



# hex_num1 = '32\'H'+hex(num1)[2:].zfill(8).upper()
# hex_num2 ='32\'H'+ hex(int(binary_num2,2))[2:].zfill(8)
# hex_result = '64\'H'+hex(int(binary_result,2))[2:].zfill(16)


# print(f"乘数: ", hex_num1)
# print(f"被乘数: ", hex_num2)
# print(f"Result: ", hex_result)
content = ""
for i in range(48):

    content += f"data2[{i}] = {hex_num[i]};\n"



with open("./tb.txt", "w") as f:  # open file for writing
    f.write(content)  # write formatted string to file
