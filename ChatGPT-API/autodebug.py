import file
import os
import api_text
# max_i为最大迭代次数 dir_path为当前py代码路径（目前sim.bat仿真只能对py代码路径下design仿真）
def autodebug(max_i:int,dir_path):
    # 需要用到的文件地址
    design_path=dir_path+"/design"
    bat_path=dir_path+"/sim.bat"
    spec_file_path = design_path+"/design_description.txt"
    design_file_path = design_path+"/design.v"
    testbench_file_path = design_path+"/tb.v"
    compile_report_path = design_path+"/vcompile.txt"
    simulation_report_path = design_path+"/vsim.txt"
    report_path=design_path+"/report.txt"

    GPT = api_text.GPT()

    # 对输入文件进行仿真            
    file.file_copy(design_path,dir_path,"tb.v")
    file.file_copy(design_path,dir_path,"design_description.txt")
    org_design=api_text.FileProcessor(design_file_path).read_file()
    org_design_fileline=api_text.FileProcessor(design_file_path).read_line()
    api_text.modelsim(bat_path)
    file.file_move(dir_path,design_path,"vcompile.txt")
    if os.path.exists(dir_path+"/vsim.txt"):
        file.file_move(dir_path,design_path,"vsim.txt")
    file.modelsim_done(dir_path)

    # 开始迭代
    for i in range(max_i):
        spec = api_text.FileProcessor(spec_file_path).read_file()
        des = api_text.FileProcessor(design_file_path).read_file()
        tb = api_text.FileProcessor(testbench_file_path).read_file()
        com = api_text.FileProcessor(compile_report_path).read_file()

        # 检测是否有误
        com_nerr = com.find("Errors: 0")
        if os.path.exists(simulation_report_path):
            sim = api_text.FileProcessor(simulation_report_path).read_file()
            sim_nerr = sim.find("Your Design Passed")   
        if com_nerr != -1 and sim_nerr != -1:
            print("\n\n-System: RTL code fixed with "+str(i)+" iteration(s)")
            break
        else:

            # 和gpt4交互
            if os.path.exists(simulation_report_path):
                mod = ''.join([spec, "\n", des,  "\nThis is compile report.\n", com, "\nThis is simulation report.\n", sim,"\nPlease fix the error and return the complete modified design code"])
            else:
                mod = ''.join([spec, '\n', des,  "\nThis is compile report.\n", com,"\nPlease fix the error and return the complete modified design code"])
            FIX = GPT.RTL_GPT(mod)
            print("\n-GPTFIXer:\n"+FIX.content)
            # 得到返回内容 写入report.txt   
            new_file = open(report_path, "a+")
            new_file.close()
            api_text.FileProcessor(report_path).update_file(FIX.content)
            # 修改design文件夹名称 design文件夹存放最新代码
            file.folder_rename(dir_path,"design","design("+str(i)+")")
            os.makedirs(design_path)
            new_file = open(design_file_path, "w")
            new_file.close()
            file.file_copy(dir_path,design_path,"tb.v")
            file.file_copy(dir_path,design_path,"design_description.txt")
            # filelineTemp = api_text.FileProcessor(design_file_path).read_line()
            api_text.FileProcessor(design_file_path).update_file(FIX.content)
            code = api_text.FileProcessor(design_file_path).code_fetch()
            api_text.FileProcessor(design_file_path).update_file(code)                                  #Extract the code from the answer

            if code:
                # 代码行数判断
                fileline = api_text.FileProcessor(design_file_path).read_line()
                if fileline > org_design_fileline*3/5:               #提高了代码行数检测线 之前是2/5+2        
                    # 和辅助gpt交互                        
                    scoretext = GPT.Judge_GPT("This is original design code:\n"+org_design+"\nThis is modified design code:\n"+code)
                    print("\n-GPTJUDGE:\n"+scoretext.content)
                    # 获得返回内容 并记录进report.txt
                    score=scoretext.content
                    with open(report_path, 'a+') as f:
                        f.write(score)
                    f.close()
                    try:
                        print(float(score))
                    except ValueError:
                        score=0
                    # 判断辅助gpt打分
                    if float(score) > 0.4:
                        print("\n-System: Move on")
                        api_text.modelsim(bat_path)
                        file.file_move(dir_path,design_path,"vcompile.txt")
                        if os.path.exists(dir_path+"/vsim.txt"):
                            file.file_move(dir_path,design_path,"vsim.txt")
                        file.modelsim_done(dir_path) 
                    # redo数据回滚
                    else:
                        print("\n-System: Please fix the code")
                        file.redo(dir_path,i)
                else:
                    print("\n-System: New code is too short") 
                    file.redo(dir_path,i)
            else:
                print("\n-System: No code generatedexit")                     
                file.redo(dir_path,i) 
    if os.path.exists(dir_path+"/design_description.txt"):
        os.remove(dir_path+"/design_description.txt")
    if os.path.exists(dir_path+"/tb.v"):
        os.remove(dir_path+"/tb.v")




