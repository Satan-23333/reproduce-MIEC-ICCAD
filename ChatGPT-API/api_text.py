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
            model="gpt-4-0125-preview",                                          # GPT 3.5 Turbo
            #max_tokens=500,
            temperature=0.2,
            messages=[
                {"role": "system", "content": "You are an expert in HDL design, especially skilled in verilog code writing, correction and explanation. You just need to update the design code part"},  
                {"role": "user", "content": message},   #"Write a hspice code for a ring consisted of"+
                {"role": "assistant", "content": "Offer just corrected Verilog design code without testbench, no explanation. "}
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
                {"role": "assistant", "content": "Score the code quality, in range of {0, 1}. A number needed only!!! For example, '1' for the code which is complete, '0' the opposite."} #
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
        pattern = r"(?<=module )[\s\S]*?(?=endmodule)"
        matches=re.finditer(pattern, self.content)
        code=''
        for match in matches:
            #print(match.group())
            code  = ''.join([code,'module\t',match.group(),'endmodule\n'])
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
def modelsim(bat_path):
    os.system(bat_path)
def error_detect(report_file:str,msg:str)-> int :
    file=open(report_file,'r')     
    file_contents=file.readlines()   #按行读取全部内容
    result = 0
    for content in file_contents:     #逐行读取
        if msg in content:     
            result = 1
    return result
