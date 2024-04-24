import random

num = []
hour=0
min=0
sec=0
num.append(0)
for i in range(4000):
    num.append(sec+min*64+hour*64*64)
    sec=sec+1
    if(sec==60):
        min=min+1
        sec=0
    if(min==60):
        hour=hour+1
        min=0





hex_num = []
for i in range(4000):

    hex_num.append("18'H" + hex(num[i])[2:].zfill(5).upper())



# hex_num1 = '32\'H'+hex(num1)[2:].zfill(8).upper()
# hex_num2 ='32\'H'+ hex(int(binary_num2,2))[2:].zfill(8)
# hex_result = '64\'H'+hex(int(binary_result,2))[2:].zfill(16)


# print(f"乘数: ", hex_num1)
# print(f"被乘数: ", hex_num2)
# print(f"Result: ", hex_result)
content = ""
for i in range(4000):

    content += f"data[{i}] = {hex_num[i]};\n"



with open("./tb.txt", "w") as f:  # open file for writing
    f.write(content)  # write formatted string to file
