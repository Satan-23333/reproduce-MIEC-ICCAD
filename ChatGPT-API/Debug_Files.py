import os


# 待处理的设计文件类
class DEBUG_FILES:
    Design = ""
    Design_Content = ""
    Spec = ""
    Spec_Content = ""
    Testbench = ""
    Testbench_Content = ""
    Compile_File = "vcompile.txt"
    Simulation_File = "vsim.txt"
    Origin_design_path = ""

    def __init__(self, Config_data):
        self.Design = Config_data.get("Design_File")
        self.Spec = Config_data.get("Spec_File")
        self.Testbench = Config_data.get("Testbench_File")
        self.Origin_design_path = Config_data.get("Origin_design_path")
        print(os.getcwd())
        with open(
            self.Origin_design_path + "\\" + self.Design, "r", encoding="utf-8"
        ) as file:
            self.Design_Content = file.read()
        with open(
            self.Origin_design_path + "\\" + self.Spec, "r", encoding="utf-8"
        ) as file:
            self.Spec_Content = file.read()
        with open(
            self.Origin_design_path + "\\" + self.Testbench, "r", encoding="utf-8"
        ) as file:
            self.Testbench_Content = file.read()

    def Get_Design_Content(self):
        return self.Design_Content

    def Get_Spec_Content(self):
        return self.Spec_Content

    def Get_Testbench_Content(self):
        return self.Testbench_Content

    def Get_Compile_Report(self, work_path):
        file_path = os.path.join(work_path, self.Compile_File)
        if not os.path.exists(file_path):
            return None
        with open(file_path, "r", encoding="utf-8") as file:
            return file.read()

    def Get_Simulation_Report(self, work_path):
        file_path = os.path.join(work_path, self.Simulation_File)
        if not os.path.exists(file_path):
            return None
        with open(file_path, "r", encoding="utf-8") as file:
            return file.read()

    def Create_Testbench(self, work_path):
        file_path = os.path.join(work_path, self.Testbench)
        with open(file_path, "w", encoding="utf-8") as file:
            file.write(self.Testbench_Content)
    
    def Create_Design(self, work_path):
        file_path = os.path.join(work_path, self.Design)
        with open(file_path, "w", encoding="utf-8") as file:
            file.write(self.Design_Content)

    def Update_Design_Content(self, new_content):
        self.Design_Content = new_content

    def Rollback_Design_Content(self, work_path):
        file_path = os.path.join(work_path, self.Design)
        with open(file_path, "r", encoding="utf-8") as file:
            self.Design_Content = file.read()