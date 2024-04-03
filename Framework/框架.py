import os
import json
from file import *
import Debug_Files as DF
import GPTs
import Normal_GPT


def Create_Work_Dir(design_path, work_path):
    """创建工作目录,将设计文件复制到工作目录中

    Args:
        design_path (str): 待处理的设计文件路径
        work_path (str): 工作目录路径
    """
    if not os.path.exists(work_path):
        os.makedirs(work_path)
    else:
        shutil.rmtree(work_path)
        os.makedirs(work_path)
    os.makedirs(work_path + "\\" + "design")


def Simulate(Do_file, sim_path):
    """仿真设计文件

    Args:
        Do_file (str): .do文件路径
        sim_path (str): 要仿真的文件夹路径
    """
    path_temp = os.getcwd()
    # 将.do文件复制到工作目录中
    if not os.path.exists(sim_path + "\\wave.do"):
        file_copy(Do_file, sim_path, "wave.do")
    # 进入工作目录
    os.chdir(sim_path)
    # 执行.do文件
    os.system("vsim -c -do wave.do -do quit")
    os.chdir(path_temp)


def Start_Debug(json_data):
    # 设计文件的名称
    Design_name = json_data.get("Design_name")
    # 设计文件的路径
    Origin_design_path = json_data.get("Origin_design_path")
    # 工作路径
    work_path = Root_path + "\\" + json_data.get("Work_Dir_name") + "\\" + Design_name
    work_design_path = work_path + "\\design"

    # 创建工作目录,将设计文件复制到工作目录中
    Create_Work_Dir(Origin_design_path, work_path)
    Debug_Files = DF.DEBUG_FILES(json_data)
    # 初始仿真
    Debug_Files.Create_Design(work_design_path)
    Debug_Files.Create_Testbench(work_design_path)
    Simulate(Root_path, work_path)
    modelsim_done(work_path)

    max_i = 10
    GPT = GPTs.GPTS("DebugGPT")
    ScoreGPT = Normal_GPT.GPT("ScoreGPT")
    # 如果使用gpts模型则使用下面的代码
    # ScoreGPT = GPTs.GPTS("ScoreGPT")
    try:
        Debug_Success = False
        for i in range(max_i):
            # 获取Design内容
            spec = Debug_Files.Get_Spec_Content()
            design = Debug_Files.Get_Design_Content()
            tb = Debug_Files.Get_Testbench_Content()
            compile = Debug_Files.Get_Compile_Report(work_design_path)
            sim = Debug_Files.Get_Simulation_Report(work_design_path)

            if "Errors: 0" in compile and "Your Design Passed" in sim:
                # 如果仿真没有错误则退出
                print("\n\n-System: RTL code fixed with " + str(i) + " iteration(s)")
                Debug_Success = True
                break

            if sim is not None:
                # 生成问题，如果编译不通过则使用编译报告，否则使用仿真报告
                Question = f"The Spec(design description) is\n\n{spec}\n\nThe Design Code is\n\n{design}\n\nThe Simulation Report is\n\n{sim}"
            else:
                Question = f"The Spec(design description) is\n\n{spec}\n\nThe Design Code is\n\n{design}\n\nThe Compile Report is\n\n{compile}"

            # 与GPT模型交互
            FIX = GPT.ASK_GPTs(
                Question
                + "\nOffer just corrected Verilog design code without testbench, no explanation. "
            )
            # FIX = ''
            # print("\n-GPTFIXer:\n" + FIX.content)

            # 从回答中提取代码
            filelineTemp = len(design.split("\n"))
            code = code_fetch(FIX)
            # 重命名文件夹,并将新生成的设计文件复制到工作目录中
            folder_rename(work_path, "design", f"design({str(i)})")
            os.makedirs(work_design_path)
            Debug_Files.Update_Design_Content(code)
            Debug_Files.Create_Design(work_design_path)

            # 纠错机制
            if code:
                fileline = len(code.split("\n"))
                if (
                    fileline > filelineTemp * 2 / 5 + 2
                ):  # Avoid Answering Extreme Laziness
                    scoretext = ScoreGPT.Get_Code_Score(code)
                    # scoretext = '30'
                    print("\n-GPTJUDGE:\n" + scoretext)
                    # 如果使用gpts模型则使用下面的代码
                    # scoretext = ScoreGPT.ASK_GPTs(code)
                    score = score_fetch(scoretext)

                    if float(score[0]) > 40:
                        print("\n-System: Move on")
                        Debug_Files.Create_Testbench(work_design_path)

                        Simulate(Root_path, work_path)
                        modelsim_done(work_path)
                    else:
                        print("\n-System: Please fix the code")
                        redo(work_path, i)
                        Debug_Files.Rollback_Design_Content(work_design_path)
                else:
                    print("\n-System: New code is too short")
                    redo(work_path, i)
                    Debug_Files.Rollback_Design_Content(work_design_path)
            else:
                print("\n-System: No code generatedexit")
                redo(work_path, i)
                Debug_Files.Rollback_Design_Content(work_design_path)

        # 生成最终报告
        if Debug_Success:
            os.mkdir(work_path + "\\Success Output")
            Debug_Files.Create_Design(work_path + "\\Success Output")
            with open(
                work_path + f"\\Success Output/{str(i)} times.txt",
                "a",
                encoding="UTF-8",
            ) as file:
                file.write(f"RTL code fixed with {str(i)} iteration(s)")

        else:
            os.mkdir(work_path + "\\Fail Output")
            Debug_Files.Create_Design(work_path + "\\Fail Output")
            with open(
                work_path + f"\\Fail Output/{str(i+1)} times.txt", "a", encoding="UTF-8"
            ) as file:
                file.write(f"RTL code failed with {str(i+1)} iteration(s)")

        # os.system("pause")

    except Exception as e:
        print(e)
        os.system("pause")


if __name__ == "__main__":
    try:
        Root_path = os.path.dirname(os.path.realpath(__file__))
    except:
        Root_path = os.getcwd()

    Config_path = Root_path + "\\config.json"
    with open(Config_path, "r", encoding="utf-8") as f:
        json_data = json.load(f)
    dir_names = collect_dirname("RTLLM")
    for i in dir_names:
        json_data["Work_Dir_name"] = "workdir\\" + i
        json_data["Origin_design_path"] = "RTLLM\\" + i
        design_files = collect_design("RTLLM\\" + i)
        for j in design_files:
            json_data["Design_name"] = j.split(".")[0]
            json_data["Design_File"] = j
            Start_Debug(json_data)
