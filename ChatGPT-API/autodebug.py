import file
import os
import api_text

def autodebug(max_i:int,dir_path):
    design_path=dir_path+"/design"
    bat_path=dir_path+"/sim.bat"
    spec_file_path = design_path+"/design_description.txt"
    design_file_path = design_path+"/design.v"
    testbench_file_path = design_path+"/tb.v"
    compile_report_path = design_path+"/vcompile.txt"
    simulation_report_path = design_path+"/vsim.txt"
    report_path=design_path+"/report.txt"

    GPT = api_text.GPT()
                
    file.file_copy(design_path,dir_path,"tb.v")
    file.file_copy(design_path,dir_path,"design_description.txt")
    api_text.modelsim(bat_path)
    file.file_move(dir_path,design_path,"vcompile.txt")
    if os.path.exists(dir_path+"/vsim.txt"):
        file.file_move(dir_path,design_path,"vsim.txt")
    file.modelsim_done(dir_path)
    for i in range(max_i):
        # api_text.modelsim(modelsim_path, design_file_path, testbench_file_path, compile_report_path, simulation_report_path)
        
        spec = api_text.FileProcessor(spec_file_path).read_file()
        des = api_text.FileProcessor(design_file_path).read_file()
        tb = api_text.FileProcessor(testbench_file_path).read_file()
        com = api_text.FileProcessor(compile_report_path).read_file()
        com_nerr = com.find("Errors: 0")
        # com_nerr = api_text.error_detect(compile_report_path,"Errors: 0")
        if os.path.exists(simulation_report_path):
            sim = api_text.FileProcessor(simulation_report_path).read_file()
            sim_nerr = sim.find("Your Design Passed")
            # sim_nerr = api_text.error_detect(simulation_report_path,"Your Design Passed")
        
        
        if com_nerr != -1 and sim_nerr != -1:
            print("\n\n-System: RTL code fixed with "+str(i)+" iteration(s)")
            break
        else:
            if os.path.exists(simulation_report_path):
                mod = ''.join([spec, "\n", des,  "\nThis is compile report.\n", com, "\nThis is simulation report.\n", sim,"\nPlease fix the error and return the complete modified design code"])
            else:
                mod = ''.join([spec, '\n', des,  "\nThis is compile report.\n", com,"\nPlease fix the error and return the complete modified design code"])
            FIX = GPT.RTL_GPT(mod)
            print("\n-GPTFIXer:\n"+FIX.content)
            new_file = open(report_path, "w")
            new_file.close()
            api_text.FileProcessor(report_path).update_file(FIX.content)
            file.folder_rename(dir_path,"design","design("+str(i)+")")
            os.makedirs(design_path)
            new_file = open(design_file_path, "w")
            new_file.close()
            file.file_copy(dir_path,design_path,"tb.v")
            file.file_copy(dir_path,design_path,"design_description.txt")

            filelineTemp = api_text.FileProcessor(design_file_path).read_line()
            api_text.FileProcessor(design_file_path).update_file(FIX.content)
            code = api_text.FileProcessor(design_file_path).code_fetch()
            api_text.FileProcessor(design_file_path).update_file(code)                                  #Extract the code from the answer

            if code:
                fileline = api_text.FileProcessor(design_file_path).read_line()
                if fileline > filelineTemp*3/5:               #提高了代码行数检测线 之前是2/5+2                                #Avoid Answering Extreme Laziness
                    scoretext = GPT.Judge_GPT(code)
                    print("\n-GPTJUDGE:\n"+scoretext.content)
                    # score = api_text.FileProcessor(design_file_path).score_fetch(scoretext.content)
                    score=scoretext.content
                    with open(report_path, 'a+') as f:
                        f.write(score)
                    f.close()
                    try:
                        print(float(score))
                    except ValueError:
                        score=0
                    if float(score) > 0.4:
                        print("\n-System: Move on")
                        api_text.modelsim(bat_path)
                        file.file_move(dir_path,design_path,"vcompile.txt")
                        if os.path.exists(dir_path+"/vsim.txt"):
                            file.file_move(dir_path,design_path,"vsim.txt")
                        file.modelsim_done(dir_path) 
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




