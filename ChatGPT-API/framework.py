import file
import os
import api_text

if __name__ == "__main__":
    dir_path="d:/seu/Chatgpt-api"
    design_path=dir_path+"/design"
    bat_path=dir_path+"/sim.bat"

    spec_file_path = design_path+"/design_description.txt"
    design_file_path = design_path+"/design.v"
    testbench_file_path = design_path+"/tb.v"
    compile_report_path = design_path+"/vcompile.txt"
    simulation_report_path = design_path+"/vsim.txt"

    max_i=10

    message = []
    gpt_msg = []
    GPT = api_text.GPT()
    try:
        while True:
            print("\n-System: 1.Chat  2.RTL-FIX")
            user_input = input("\n-User: ").strip()
            # user_input=2
            if user_input == "exit" or user_input == "退出":
                break
            if user_input == "1":
                while True:
                    user_input = input("\n-User: ").strip()
                    if user_input == "exit" or user_input == "退出":
                        break
                    content = {"role": "user", "content": ""}
                    content["content"] = user_input
                    message.append(content)
                    gpt_res = GPT.ASK_GPT(message)
                    # print(gpt_res)
                    gpt_msg = {"content": "", "role": "assistant"}
                    gpt_msg["role"] = gpt_res.role
                    gpt_msg["content"] = gpt_res.content
                    print("\n-GPT:" + gpt_res.content)
                    message.append(gpt_msg)
            elif user_input == "2":
                # modelsim_path = input("\n-User: Please input the path of the Modelsim：")
                # spec_file_path = input("\n-User: Please input the path of the module description file：")
                # design_file_path = input("\n-User: Please input the path of the design file：")
                # testbench_file_path = input("\n-User: Please input the path of the testbench file：")
                # compile_report_path = input("\n-User: Please input the path of the compile report：")
                # simulation_report_path = input("\n-User: Please input the path of the simulation report：")
                
                file.file_copy(design_path,dir_path,"tb.v")
                file.file_copy(design_path,dir_path,"design_description.txt")
                api_text.modelsim(bat_path)
                file.file_move(dir_path,design_path,"vcompile.txt")
                if os.path.exists(dir_path+"/vsim.txt"):
                    file.file_move(dir,design_path,"vsim.txt")
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
                            mod = ''.join([spec, '\n', des, '\n', tb, '\n', com, '\n', sim])
                        else:
                            mod = ''.join([spec, '\n', des, '\n', tb, '\n', com])
                        FIX = GPT.RTL_GPT(mod)
                        print("\n-GPTFIXer:\n"+FIX.content)

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
                           if fileline > filelineTemp*2/5+2:                                               #Avoid Answering Extreme Laziness
                               scoretext = GPT.Judge_GPT(code)
                               print("\n-GPTJUDGE:\n"+scoretext.content)
                               score = api_text.FileProcessor(design_file_path).score_fetch(scoretext.content)
                               if float(score[0]) > 0.4:
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
                    os.remove(dir_path+"tb.v")
    except Exception as e:
        print(e)




