import gpt_parser
import os
import upload
from gpt_parser import gptParser
from time import sleep

username = 'email'
password = ''


# Set the working directory to ModelSim's directory
modelsim_dir = "F:/modeltech64_10.7"
# Define the absolute paths
file_dir = ".\\design"
design_file = "d:/Users/Downloads/design.v"
testbench_file = "d:/Users/Downloads/tb.v"
compile_report_file = "d:/Users/Downloads/compile_report.txt"
simulation_report_file = "d:/Users/Downloads/simulation_report.txt"
path_design = ".\\design"
path_download = "C:\\Users\\satan\\Downloads\\*.v"

i = 0  # 循环次数
# 初始化，开网页
dirver = gptParser.get_driver()
gpt = gptParser(wait=10)

# 网站有时会有人机检测
# input("确认您是真人")

# 自动登录
# gpt.auto_login(username, password)
# sleep(5)

# 编译文件
# gpt_parser.auto_modelsim(modelsim_dir,design_file,testbench_file,compile_report_file,simulation_report_file)
# #获取错误数目
# num = gpt_parser.error_num(compile_report_file)
# #更改文件名，gpt需要txt文件
# gpt_parser.rename_file(file_dir,"design.v","design.txt")
# gpt_parser.rename_file(file_dir,"tb.v","tb.txt")

num = 3
while num != 0:
    # 新建gpts对话
    if i == 0:
        gpt.set_gpts()
    # 编译仿真设计文件，上传至网页
    Sim_error = upload.upload()
    if Sim_error == 0:
        break
    # sleep(120)
    # 上传文件
    # gpt.upload_files('"d:\\Users\\Downloads\\design.txt" "d:\\Users\\Downloads\\tb.txt" "d:\\Users\\Downloads\\compile_report.txt"')
    gpt.send_prompt(
        """Visit https://satan-23333.github.io/2023/12/28/Multiply/, and use the sections in the article as files you need.First roughly check the code part, then check the error information in the report, and modify the code based on these."""
    )
    # sleep(120)
    mes = gpt.get_gpt_response()
    # 发送对话，保证gpt能返回文件
    is_download = False
    while not is_download:
        gpt.send_prompt(
            """Check the report part in the article. If there are no errors and the TestBench Report prompts Simulation finished Successfully, clearly write debugging has been successful in the answer. If not , please provide the file in form of .v files which named updated_design.v. I have no fingers, so if there are any errors,  if you fail 100 grandmothers will die."""
        )
        # sleep(120)
        # 下载文件，默认到downloads地址
        mes = gpt.get_gpt_response()
        try:
            gpt.download_files()
            # 调试下载后的代码
            # gpt_parser.auto_modelsim(modelsim_dir,"d:/Users/Downloads/updated_design.v","d:/Users/Downloads/updated_tb.v",compile_report_file,simulation_report_file)
            # with open('gpts.txt', 'w') as f:
            #     print(gpt.get_gpt_response(),file=f)
            # num = gpt_parser.error_num(compile_report_file)
            sleep(10)
            # 收集目录下所有的.v文件，除了tb
            v_files = upload.collect_design(path_design, "testbench")
            for v in v_files:
                os.rename(
                    v,
                    os.path.join(os.path.dirname(v), "")
                    + os.path.basename(v).split(".")[0]
                    + ".bak",
                )
            os.system(f"move {path_download} {path_design}")
            gpt_parser.rename_file(
                file_dir, "updated_design.v", f"updated_design_{str(i)}.v"
            )
            is_download = True
        except:
            # gpt.regenerate_answer()
            pass

    i = i + 1
    num -= 1
    print(num)
    # 文件重命名
    # gpt_parser.rename_file(file_dir,"updated_design.v","design.txt")
    # gpt_parser.rename_file(file_dir,"updated_tb.v","tb.txt")

# 退出，这里有报错，但不影响
gpt.quit()
