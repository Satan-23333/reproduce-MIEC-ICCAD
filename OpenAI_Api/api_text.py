# 初始化配置
from openai import OpenAI
import os
import json
from datetime import datetime
import re
import subprocess

class GPT:
    proxy_url = "https://gpt-api.satan2333.icu/v1"

    # get current time and transform it into string
    init_time = datetime.now().strftime("%Y-%m-%d_%H-%M")
    filename = f"GPT_Response_{init_time}.json"

    def __init__(self) -> None:
        with open("api.ini", "r") as api:
            OpenAI_API = api.read()
        self.client = OpenAI(api_key=OpenAI_API, base_url=self.proxy_url)

        with open(self.filename, "w") as file:
            json.dump({}, file)
        print(f"Save to the '{self.filename}'.json file successfully")

    def save_json(self,data):
        # read raw json file 
        with open(self.filename, 'r') as file:
            data = json.load(file)

        # update the data 
        current_time = datetime.now().strftime("%Y-%m-%d_%H-%M")
        data[current_time] = {data}
        # write back the new data
        with open(self.filename, 'w') as file:
            json.dump(data, file, indent=4)
        return
    
    def ASK_GPT(self, message):                                # model for chat
        completion = self.client.chat.completions.create(
            model="gpt-3.5-turbo", messages=message
        )
        # self.save_json(completion.choices[0].message)
        return completion.choices[0].message
    
    def RTL_GPT(self, message):                                # GPT for RTLfix, prompt need to be improved
        completion = self.client.chat.completions.create(
            model="gpt-3.5-turbo",                                          # GPT 3.5 Turbo
            #max_tokens=500,
            temperature=0.2,
            messages=[
                {"role": "system", "content": "You are an expert in HDL design, especially skilled in verilog code writing, correction and explanation. You just need to update the design code part"},  
                {"role": "user", "content": message},   #"Write a hspice code for a ring consisted of"+
                {"role": "assistant", "content": "Offer just corrected Verilog design code without testbench, code only. "}
            ]
        )
        return completion.choices[0].message
    
    def Judge_GPT(self, message):                             # GPT for code-score, prompt need to be improved
        completion = self.client.chat.completions.create(
            model="gpt-3.5-turbo",
            max_tokens=300,
            temperature=0.0,
            messages=[
                {"role": "system", "content": "You are an expert in HDL design, especially skilled in verilog code writing, correction and explanation. You just need to update the design code part"},   #
                {"role": "user", "content": message},   
                {"role": "assistant", "content": "Score the Verilog code on a scale of 0 or 1, with 1 for the code is complete and workable and 0 the opposite."} #
            ]
        )
        return completion.choices[0].message


    def Get_GPT_Response():

        return

class FileProcessor:
    def __init__(self, file_path):
        self.file_path = file_path
        self.content = self.read_file()

    def read_file(self):
        with open(self.file_path, 'r', encoding='utf-8') as file:
            return file.read()

    def update_file(self, new_content):
        with open(self.file_path, 'w', encoding='utf-8') as file:
            return file.write(new_content)

    def read_line(self):
        return len(self.content.split('\n'))
    
    def code_fetch(self):
        #pattern = r"(?<=module )[\s\S]*?(?=endmodule)"
        pattern = r"(?<=```verilog\nmodule )[\s\S]*?(?=```)"

        matches=re.finditer(pattern, self.content)
        code=''
        for match in matches:
            code  = ''.join([code,'module\t',match.group()])#,'endmodule\n'
            #code = ''.join([code,match.group()]) 
        return code

    def score_fetch(self, code):
        pattern2 = r'\d+'
        score = re.findall(pattern2, code)
        return score

def modelsim(modelsim_path, design_file, testbench_file, compile_report_file, simulation_report_file):
    # Set the working directory to ModelSim's directory
    modelsim_dir = modelsim_path
    os.chdir(modelsim_dir)
    # Optionally, set MODELSIM environment variable
    os.environ['MODELSIM'] = modelsim_dir
    # ModelSim compile command with absolute paths
    compile_command = f"vlog {design_file} {testbench_file}"
    # Run the compile command and write output to compile report
    with open(compile_report_file, "w") as report_file:
        subprocess.run(compile_command, shell=True, stdout=report_file, stderr=subprocess.STDOUT)
    # ModelSim simulation command
    simulate_command = "vsim -c -do \"run -all\" tb"
    # Run the simulation command and write output to simulation report
    with open(simulation_report_file, "w") as report_file:
        subprocess.run(simulate_command, shell=True, stdout=report_file, stderr=subprocess.STDOUT)
    return
    
if __name__ == "__main__":
    message = []
    gpt_msg = []
    GPT = GPT()
    try:
        while True:
            print("\n-System: 1.Chat  2.RTL-FIX")
            user_input = input("\n-User: ").strip()
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
                modelsim_path = "D:/Modelsim/modelsim-win64-10.4-se/win64"#input("\n-User: Please input the path of the Modelsim：")
                spec_file_path = "D:/test/design spec.txt"#input("\n-User: Please input the path of the module description file：")
                design_file_path = "D:/test/design.v"#input("\n-User: Please input the path of the design file：")
                testbench_file_path = "D:/test/tb.v"#input("\n-User: Please input the path of the testbench file：")
                compile_report_path = "D:/test/compile.txt"#input("\n-User: Please input the path of the compile report：")
                simulation_report_path = "D:/test/simu.txt"#input("\n-User: Please input the path of the simulation report：")

                spec = FileProcessor(spec_file_path).read_file()

                tb = FileProcessor(testbench_file_path).read_file()


                for i in range(2):
                    des = FileProcessor(design_file_path).read_file()
                    modelsim(modelsim_path, design_file_path, testbench_file_path, compile_report_path, simulation_report_path)
                    com = FileProcessor(compile_report_path).read_file()
                    sim = FileProcessor(simulation_report_path).read_file()
                    com_nerr = com.find("Errors: 0")
                    sim_nerr = sim.find("Successfully")
                    if com_nerr != -1 and sim_nerr != -1 and des:
                        print("\n\n"+f"-System: RTL code fixed with {i} iteration(s)")
                        break
                    else:
                        mod = ''.join([spec, '\n', des, '\n', tb, '\n', com, '\n', sim])
                        FIX = GPT.RTL_GPT(mod)
                        print("\n-GPTFIXer:\n"+FIX.content)
                        filelineTemp = FileProcessor(design_file_path).read_line()
                        FileProcessor(design_file_path).update_file(FIX.content)
                        code = FileProcessor(design_file_path).code_fetch()
                        print(code)
                        FileProcessor(design_file_path).update_file(code)                                  #Extract the code from the answer
                        if code:
                           fileline = FileProcessor(design_file_path).read_line()
                           if fileline > filelineTemp*2/5+2:                                               #Avoid Answering Extreme Laziness
                               scoretext = GPT.Judge_GPT(code)
                               print("\n-GPTJUDGE:\n"+scoretext.content)
                               score = FileProcessor(design_file_path).score_fetch(scoretext.content)
                               if float(score[0]) > 0.5:
                                   print("\n-System: Move on") 
                               else:
                                   print("\n-System: Please fix the code")
                           else:
                               print("\n-System: New code is too short") 
                        else:
                            print("\n-System: No code generated")                     
                          
    except Exception as e:
        print(e)
