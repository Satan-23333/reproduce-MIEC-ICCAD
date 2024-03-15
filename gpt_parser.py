import os
import re
import win32gui
import win32con
import time
import random
from time import sleep
import subprocess
from selenium.webdriver.remote.webdriver import By
from selenium import webdriver
import undetected_chromedriver as uc
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import ElementClickInterceptedException, NoSuchElementException, TimeoutException
from selenium.webdriver.chrome.options import Options
import tkinter
import tkinter.filedialog

#修改文件名称
def rename_file(file_dir:str,old_name:str,new_name:str) -> None:  
    os.chdir(file_dir) #更改当前路径
    #filelist = os.listdir(file_dir)  # 该文件夹下所有的文件（包括文件夹）
    os.rename(old_name,new_name) #重命名


#调用modelsim编译，但仿真有问题，需要改
def auto_modelsim(modelsim_dir:str,design_file:str,testbench_file:str,compile_report_file:str,simulation_report_file:str) -> None:
    os.chdir(modelsim_dir)
    os.environ['MODELSIM'] = modelsim_dir
    compile_command = f"vlog {design_file} {testbench_file}"
    # Run the compile command and write output to compile report
    with open(compile_report_file, "w") as report_file:
        subprocess.run(compile_command, shell=True, stdout=report_file, stderr=subprocess.STDOUT)

    # # ModelSim simulation command
    # simulate_command = "vsim -c -do \"run -all\" tb"

    # # Run the simulation command and write output to simulation report
    # with open(simulation_report_file, "w") as report_file:
    #     subprocess.run(simulate_command, shell=True, stdout=report_file, stderr=subprocess.STDOUT)


#获取报告中Errors数目，
def error_num(report_file:str)-> int :
    file=open(report_file,'r')     
    file_contents=file.readlines()   #按行读取全部内容

    for content in file_contents:     #逐行读取
        if  "Errors: " in content:     
            result =int(re.findall(".*Errors: (.*),.*",content)[0])
    return result



class gptParser:

    OPENAI_URL = "https://chat.openai.com/"

    def __init__(self, wait: int = 60) -> None:
        """Initialize AutoBot.

        Args:
            headless (bool, optional): headless. Defaults to True.
            wait (int, optional): implicitly_wait_time
        """
        self.implicitly_wait_time = wait
        self.driver = self.get_driver(self.implicitly_wait_time)
        self.driver.get(gptParser.OPENAI_URL)



    # def __init__(self,
    #              driver,
    #              gpt_url: str = 'https://chat.openai.com/'):
    #     """ ChatGPT parser
    #     Args:
    #         driver_path (str, optional): The path of the chromedriver.
    #         gpt_url (str, optional): The url of ChatGPT.
    #     """
    #     # Start a webdriver instance and open ChatGPT
    #     self.driver = driver
    #     self.driver.get(gpt_url)

    @staticmethod
    def get_driver(wait_time: int=60) -> uc.Chrome:
        """Set driver.

        Args:
            headless (bool): headless
            wait_time (int): implicitly_wait_time
        """
        option = Options()
        option.add_experimental_option("debuggerAddress", "127.0.0.1:9527")
        driver = webdriver.Chrome(options=option)
        # options.add_argument('--no-sandbox')
    
        # options.add_argument('--disable-dev-shm-usage')

        # wait for the page to load
        driver.implicitly_wait(wait_time)
        return driver

    # def get_driver(driver_path: str = None):
    #     # return uc.Chrome() if driver_path is None else uc.Chrome(driver_path)    


    def __call__(self, query: str):
        # Find the input field and send a question
        input_field = self.driver.find_element(
            By.TAG_NAME, 'textarea')
        input_field.send_keys(query)
        input_field.send_keys(Keys.RETURN)

    def read_respond(self):
        try:
            response = self.driver.find_elements(By.TAG_NAME, 'p')[-2].text
            return response
        except:
            return None


    #自动登录    
    def auto_login(self,username:str,password:str) -> None:
        self.driver.implicitly_wait(10)
        sleep(5)
        self.driver.find_element(By.CSS_SELECTOR, "[data-testid='login-button']").click()
        username_field=self.driver.find_element(By.NAME, "username")
        username_field.send_keys(username)#账号
        self.driver.find_element(By.CLASS_NAME,"_button-login-id").click()
        # continue_button=self.driver.find_element(By.NAME,"action")
        # continue_button.click()
        #self.driver.find_element_by_xpath("//div/main/section/div/div/div/div[1]/div/form/div[2]/button")

        # self.driver.implicitly_wait(10)
        # sleep(1)
        password_field=self.driver.find_element(By.NAME, "password")
        password_field.send_keys(password)#密码
        sleep(1)
        WebDriverWait(self.driver, 10).until(
            EC.visibility_of_element_located((By.CLASS_NAME,"_button-login-password")),
            # EC.presence_of_element_located((By.XPATH, '//div[contains(@class, "result-streaming")]')),
        )

        # self.driver.implicitly_wait(10)
        self.driver.find_element(By.CLASS_NAME,"_button-login-password").click()

    #选择gpts新建对话
    def set_gpts(self) -> None:
        sleep(1)
        self.driver.find_element(By.LINK_TEXT,"Verilog Auto Debug").click()

    #上传文件
    def upload_files(self,docs:str) -> None:
        self.driver.find_element(By.CSS_SELECTOR, "[aria-label='Attach files']").click()    
        sleep(3)
        # upload = self.driver.find_element_by_id('file')
        # upload.send_keys('d:\\test\\multiply.v''d:\\test\\testbench.v''d:\\test\\vcompile.txt')  # send_keys
       
        # win32gui
        dialog = win32gui.FindWindow('#32770', '打开')  # 对话框
        ComboBoxEx32 = win32gui.FindWindowEx(dialog, 0, 'ComboBoxEx32', None)
        ComboBox = win32gui.FindWindowEx(ComboBoxEx32, 0, 'ComboBox', None)
        Edit = win32gui.FindWindowEx(ComboBox, 0, 'Edit', None)  # 上面三句依次寻找对象，直到找到输入框Edit对象的句柄
        button = win32gui.FindWindowEx(dialog, 0, 'Button', None)  # 确定按钮Button

        win32gui.SendMessage(Edit, win32con.WM_SETTEXT, None, docs)  # 往输入框输入绝对地址
        win32gui.SendMessage(dialog, win32con.WM_COMMAND, 1, button)  # 按button

        sleep(10)
        self.driver.find_element(By.CSS_SELECTOR, "[data-testid='send-button']").click()

    def download_files(self) -> None:
        self.driver.implicitly_wait(120)

        time.sleep(random.uniform(1, 5))
        self.driver.find_elements(By.CSS_SELECTOR, "[target='_new'][class='cursor-pointer']")[0].click()
        self.driver.implicitly_wait(10)

        # self.driver.find_elements(By.CSS_SELECTOR, "[target='_new']")[1].click()  
        
        # tkinter.filedialog.asksaveasfilename(title='Python tkinter',
        #                                      initialdir=r'D:\\test',
        #                                      initialfile='vcompile.txt')
        
        # dialog = win32gui.FindWindow('#32770', '另存为')
        # # ComboBoxEx32 = win32gui.FindWindowEx(dialog, 0, 'ComboBoxEx32', None)
        # # ComboBox = win32gui.FindWindowEx(ComboBoxEx32, 0, 'ComboBox', None)
        # # Edit = win32gui.FindWindowEx(ComboBox, 0, 'Edit', None)  # 上面三句依次寻找对象，直到找到输入框Edit对象的句柄
        # button = win32gui.FindWindowEx(dialog, 0, 'Button', None)  # 确定按钮Button

        # # win32gui.SendMessage(Edit, win32con.WM_SETTEXT, None, doc_address)  # 往输入框输入绝对地址
        # win32gui.SendMessage(dialog, win32con.WM_COMMAND, 1, button)  # 按button

    #给gpt发消息
    def send_prompt(self, prompt: str) -> None:
        """Send prompt.

        Args:
            prompt (str): Send prompt to ChatGPT
        """
        # self.driver.implicitly_wait(10)
        sleep(5)
        textarea = self.driver.find_element(By.CSS_SELECTOR, "textarea")
        textarea.clear()
        textarea.send_keys(prompt)
        time.sleep(random.uniform(1, 5))
        self.driver.find_element(By.CSS_SELECTOR, "[data-testid='send-button']").click()


    #获取gpt的输出内容
    def get_gpt_response(self, timeout: int = 60) -> list[str]:
        """Get GPT response.

        Args:
            timeout (int, optional): Timeout. Defaults to 60.
        """
        # Temporarily disable implicit wait
        self.driver.implicitly_wait(0)

        try:
            # Check if the element that is being output exists
            WebDriverWait(self.driver, 300).until(
                EC.visibility_of_element_located((By.CSS_SELECTOR, "[data-testid='send-button']")),
                # EC.presence_of_element_located((By.XPATH, '//div[contains(@class, "result-streaming")]')),
            )

            # If it exists, wait until the output is finished
            WebDriverWait(self.driver, timeout).until(
                EC.visibility_of_element_located((By.CSS_SELECTOR, "[data-testid='send-button']")),
                # EC.invisibility_of_element_located((By.XPATH, '//div[contains(@class, "result-streaming")]')),
            )
        except TimeoutException:
            # If the element doesn't exist, continue to get the text
            print("0")
            pass
        finally:
            # Re-enable implicit wait
            print("1")
            self.driver.implicitly_wait(10)

        # Get the element after the output is finished
        gpt_elements = self.driver.find_elements(
            By.XPATH,
            '//div[contains(@class, "markdown")]',
        )
        return [gpt_element.text for gpt_element in gpt_elements]



    # def get_gpt_message(self):
    #     """
    #     获取gpt输出，直到生成完成

    #     Returns:
    #         _type_: _description_
    #     """
    #     message = ''
    #     end = '\n00000000'
    #     self.driver.implicitly_wait(0)
    #     t = True
    #     while(not message.endswith(end) or t):
    #         try:
    #             message = self.get_gpt_response()[-1]
    #             t = self.driver.find_element(By.CSS_SELECTOR, "[data-testid='send-button']").is_enabled()
    #         except:
    #             pass
    #     self.driver.implicitly_wait(10)
    #     return message
    
    def regenerate_answer(self) -> None:
        """
        （未完成）检测重新生成按钮来重新生成回答，需要修改
        """
        self.driver.find_elements(By.CLASS_NAME, "rounded-md")[-1].click()

    #退出程序
    def quit(self):
        self.driver.quit()