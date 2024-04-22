import os
import json
import time
from datetime import datetime
import tqdm

from file import *
import Debug_Files as DF
import GPTs
import Normal_GPT
from Update_csv import update_csv


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


def Simulate(Do_file, sim_path) -> float:
    """仿真设计文件

    Args:
        Do_file (str): .do文件路径
        sim_path (str): 要仿真的文件夹路径

    Returns:
        float: 仿真时间
    """
    sim_start_time = time.time()
    path_temp = os.getcwd()
    # 将.do文件复制到工作目录中
    if not os.path.exists(sim_path + "\\wave.do"):
        file_copy(Do_file, sim_path, "wave.do")
    # 进入工作目录
    os.chdir(sim_path)
    # 执行.do文件
    os.system("vsim -c -do wave.do -do quit")
    os.chdir(path_temp)
    sim_end_time = time.time()
    return sim_end_time - sim_start_time


def Start_Debug(json_data):
    """开始进行自动Debug

    Args:
        json_data (dict): 运行的config数据

    Returns:
        Debug_Success: 是否成功
        design_content: 修复后的code
        Iterations: 迭代次数
        Total_time: 总时间
        Sim_time: 仿真时间
        Debug_time: Debug时间
        Score_time: 评分时间
    """
    Debug_start_time = time.time()
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
    Sim_time_list = []
    Debug_time_list = []

    Score_time_list = []

    One_sim_time = Simulate(Root_path, work_path)
    modelsim_done(work_path)
    Sim_time_list.append(One_sim_time)

    max_i = 11
    GPT = GPTs.GPTS(
        "DebugGPT", "asst_HvM228Prmecq2ILVkS7GkLYx"
    )  # ,"asst_8nl7vABDrwbFr0wdCGLhKdJw")
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
            for _ in range(3):
                try:
                    FIX, One_debug_time = GPT.ASK_GPTs(
                        Question
                        + "\nOffer just corrected Verilog design code without testbench, no explanation. "
                    )
                    # FIX = ''
                    Debug_time_list.append(One_debug_time)
                    break
                except Exception as e:
                    continue
            print("\n-GPTFIXer:\n" + FIX)

            # 从回答中提取代码
            filelineTemp = len(design.split("\n"))
            fixed_code = code_fetch(FIX)
            origin_code = design
            # 重命名文件夹,并将新生成的设计文件复制到工作目录中
            folder_rename(work_path, "design", f"design({str(i)})")
            os.makedirs(work_design_path)
            Debug_Files.Update_Design_Content(fixed_code)
            Debug_Files.Create_Design(work_design_path)

            # 纠错机制
            if fixed_code:
                fileline = len(fixed_code.split("\n"))
                if (
                    fileline > filelineTemp * 2 / 5 + 2
                ):  # Avoid Answering Extreme Laziness
                    scoretext, One_score_time = ScoreGPT.Get_Code_Score(
                        spec, origin_code, fixed_code
                    )
                    # scoretext = '30'
                    Score_time_list.append(One_score_time)
                    print("\n-GPTJUDGE:\n" + scoretext)
                    # 如果使用gpts模型则使用下面的代码
                    # scoretext = ScoreGPT.ASK_GPTs(code)
                    score = score_fetch(scoretext)
                    print("\n-System: " + scoretext)

                    if score[1] + 4 >= score[0]:
                        print("\n-System: Move on")
                        Debug_Files.Create_Testbench(work_design_path)

                        One_sim_time = Simulate(Root_path, work_path)
                        modelsim_done(work_path)
                        Sim_time_list.append(One_sim_time)
                    else:
                        print("\n-System: Please fix the code")
                        redo(work_path, i)
                        Debug_Files.Rollback_Design_Content(work_design_path)
                else:
                    print("\n-System: New code is too short")
                    redo(work_path, i)
                    i = i - 1
                    Debug_Files.Rollback_Design_Content(work_design_path)
            else:
                print("\n-System: No code generatedexit")
                redo(work_path, i)
                i = i - 1
                Debug_Files.Rollback_Design_Content(work_design_path)

        Debug_end_time = time.time()
        Total_time = Debug_end_time - Debug_start_time
        # 生成最终报告
        if Debug_Success:
            os.mkdir(work_path + "\\Success Output")
            Debug_Files.Create_Design(work_path + "\\Success Output")
            with open(
                work_path + f"\\Success Output\\{str(i)} times.txt",
                "a",
                encoding="UTF-8",
            ) as file:
                file.write(
                    f"RTL code fixed with {Total_time} seconds and {str(i)} iteration(s)"
                )

        else:
            os.mkdir(work_path + "\\Fail Output")
            Debug_Files.Create_Design(work_path + "\\Fail Output")
            with open(
                work_path + f"\\Fail Output\\{str(i+1)} times.txt",
                "a",
                encoding="UTF-8",
            ) as file:
                file.write(
                    f"RTL code failed with {Total_time} seconds and {str(i+1)} iteration(s)"
                )

        Sim_time = sum(Sim_time_list)
        Debug_time = sum(Debug_time_list)
        Score_time = sum(Score_time_list)
        return (
            Debug_Success,
            Debug_Files.Get_Design_Content(),
            i,
            Total_time,
            Sim_time,
            Debug_time,
            Score_time,
        )
        # os.system("pause")

    except Exception as e:
        print(e)
        # os.system("pause")
        return False, "", 0, 0, 0, 0, 0


def main():
    start_time = time.time()

    init_time = datetime.now().strftime("%Y-%m-%d_%H-%M")
    Json_Start_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    Config_path = Root_path + "\\config.json"
    with open(Config_path, "r", encoding="utf-8") as f:
        json_data = json.load(f)

    output_json = os.path.join("Output", f"Output_{init_time}.json")
    output_csv = os.path.join("Output", f"统计_{init_time}.csv")

    os.makedirs("Output", exist_ok=True)

    Debug_list = []
    output_content = {"Start time": Json_Start_time}
    # Debug_Success, design, Debug_time, Iterations = Start_Debug(json_data)

    # Debug_list.append(
    #     {
    #         "Name": json_data["Design_name"],
    #         "Is_Success": bool(Debug_Success),
    #         "Iterations": Iterations,
    #         "Debug_time": round(Debug_time, 2),
    #     }
    # )
    # output_content["Debug_list"] = Debug_list

    """
    以下为批量运行
    """
    dir_names = collect_dirname("RTLLM")
    for i, dir_name in enumerate(dir_names):
        json_data["Work_Dir_name"] = "workdir\\" + dir_name
        json_data["Origin_design_path"] = "RTLLM\\" + dir_name
        design_files = collect_design("RTLLM\\" + dir_name)
        module_list = []
        Debug_list.append({"module_name": dir_name, "module_list": module_list})
        for design_file in design_files:
            json_data["Design_name"] = design_file.split(".")[0]
            json_data["Design_File"] = design_file
            (
                Debug_Success,
                design_content,
                Iterations,
                Total_time,
                Sim_time,
                Debug_time,
                Score_time,
            ) = Start_Debug(json_data)

            # 测试
            # (
            #     Debug_Success,
            #     design_content,
            #     Iterations,
            #     Total_time,
            #     Sim_time,
            #     Debug_time,
            #     Score_time,
            # ) = (True, "", 0, 0, 0, 0, 0)
            module_list.append(
                {
                    "Name": json_data["Design_name"],
                    "Is_Success": bool(Debug_Success),
                    "Error_type": "func" if "func" in design_file else "syc",
                    "Iterations": Iterations,
                    "Total_time": round(Total_time, 2),
                    "Sim_time": round(Sim_time, 2),
                    "Debug_time": round(Debug_time, 2),
                    "Score_time": round(Score_time, 2),
                    "Trans_time": round(
                        Total_time - Sim_time - Debug_time - Score_time, 2
                    ),
                }
            )
            Debug_list[i]["module_list"] = module_list
            output_content["Debug_list"] = Debug_list
            with open(output_json, "w", encoding="UTF-8") as file:
                json.dump(output_content, file, indent=4)
            update_csv(output_content, output_csv)

    # 输出结束时间和总时间
    Json_End_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    output_content["End time"] = Json_End_time
    end_time = time.time()
    output_content["Total time"] = round(end_time - start_time, 2)
    with open(output_json, "w", encoding="UTF-8") as file:
        json.dump(output_content, file, indent=4)


if __name__ == "__main__":
    try:
        Root_path = os.path.dirname(os.path.realpath(__file__))
    except:
        Root_path = os.getcwd()
    for i in tqdm.tqdm(range(10)):
        main()
