import random

num = []
flag=0
x=0
for i in range(100):
    num.append(x)
    if(x==0&flag==1):
        flag=0
        x=-1
    if(flag==0):
        x = x+1
    if(x==32):
        flag=1
    if(flag==1):
        x=x-1




bin_num = []
for i in range(100):

    bin_num.append("5'b" + bin(num[i])[2:].zfill(5).upper())



# hex_num1 = '32\'H'+hex(num1)[2:].zfill(8).upper()
# hex_num2 ='32\'H'+ hex(int(binary_num2,2))[2:].zfill(8)
# hex_result = '64\'H'+hex(int(binary_result,2))[2:].zfill(16)


# print(f"乘数: ", hex_num1)
# print(f"被乘数: ", hex_num2)
# print(f"Result: ", hex_result)
content = ""
for i in range(100):

    content += f"data[{i}] = {bin_num[i]};\n"



with open("./tb.txt", "w") as f:  # open file for writing
    f.write(content)  # write formatted string to file
