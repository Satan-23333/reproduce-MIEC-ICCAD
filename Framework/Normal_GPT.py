# 初始化配置
from openai import OpenAI
import os
import json
from datetime import datetime


class GPT:
    proxy_url = "https://gpt-api.satan2333.icu/v1"
    # proxy_url = "https://api.ioii.cn/v1"

    try:
        current_dir = os.path.dirname(os.path.realpath(__file__))
    except:
        current_dir = os.getcwd()
    message = []
    user_msg = {"role": "user", "content": ""}
    gpt_msg = {"role": "assistant", "content": ""}

    def __init__(self, log_name) -> None:
        with open(self.current_dir + "\\api.ini", "r") as api:
            OpenAI_API = api.read()
        self.client = OpenAI(api_key=OpenAI_API, base_url=self.proxy_url)
        # 获取当前时间并格式化为字符串
        self.init_time = datetime.now().strftime("%Y-%m-%d_%H-%M")
        self.json_name = f"{log_name}_{self.init_time}.json"

        self.json_dir = os.path.join(self.current_dir + "\\json", self.json_name)
        self.json_content = {"time": self.init_time}

        os.makedirs(self.current_dir + "\\json", exist_ok=True)
        with open(self.json_dir, "w", encoding="UTF-8") as file:
            json.dump(self.json_content, file, indent=4)
        print(f"保存到JSON文件 '{self.json_name}'")

    def save_json(self):
        with open(self.json_dir, "w", encoding="UTF-8") as file:
            json.dump(self.json_content, file, indent=4, ensure_ascii=False)
        return

    def ASK_GPT(self, data):
        """
        - 和gpt交互,输入问题
        - 返回gpt的响应
        - 同时将输入输出存入json
        """
        self.user_msg["content"] = data
        self.message.append(self.user_msg)
        ask_time = datetime.now().strftime("%H:%M:%S")
        completion = self.client.chat.completions.create(
            model="gpt-3.5-turbo", messages=self.message
        )
        gpt_res = completion.choices[0].message
        self.gpt_msg["role"] = gpt_res.role
        self.gpt_msg["content"] = gpt_res.content
        self.message.append(self.gpt_msg)

        response_time = datetime.now().strftime("%H:%M:%S")

        self.json_content[ask_time] = [{"User": data}]
        self.json_content[response_time] = [{"GPT": gpt_res.content}]
        self.save_json()
        return self.gpt_msg["content"]

    def ASK_GPT_Single(
        self,
        temperture=0.7,
        message=[
            {
                "role": "system",
                "content": "system message",
            },  #
            {
                "role": "user",
                "content": "message",
            },  #
            {"role": "user", "content": "message"},
        ],
    ):
        """
        - 单次和gpt交互,不发送对话历史
        - 返回gpt的响应
        - 同时将输入输出存入json

        Args:
        - temperture -> float
        - message -> list
        """
        ask_time = datetime.now().strftime("%H:%M:%S")
        completion = self.client.chat.completions.create(
            model="gpt-3.5-turbo", temperature=temperture, messages=message
        )
        gpt_res = completion.choices[0].message
        response_time = datetime.now().strftime("%H:%M:%S")

        self.json_content[ask_time] = message
        self.json_content[response_time] = [{"GPT": gpt_res.content}]
        self.save_json()
        return gpt_res.content

    def Get_Code_Score(self, spec, code0, code1, temperture=0.7):
        """
        - 返回代码质量评分
        - code -> str
        """
        # scoretext = self.ASK_GPT_Single(
        #     temperture=temperture,
        #     message=[
        #         {
        #             "role": "system",
        #             "content": "You are an expert in HDL design, especially skilled in verilog code writing, correction and explanation.",
        #         },  #
        #         {
        #             "role": "user",
        #             "content": "Give a number to score the code quality, in range of {0, 100}. A number needed only!!! For example, '100' for the code which is correct, '0' is the opposite.Values in the middle represent imperfect parts of the code",
        #         },  #
        #         {"role": "user", "content": code},
        #     ],
        # )
        scoretext = self.ASK_GPT_Single(
            message=[
                {
                    "role": "system",
                    "content": """You are an expert in HDL design, especially skilled in verilog code writing, correction and explanation.
                    The user will provide you with a designed Spec (design description), as well as an original code and a modified code.
                    Please rate these two codes according to syntax and functionality, ranging from 0 to 100.
                    Only the total score of the two is given, no introduction is needed
                    Answer in the following format:
original code: (total score)
modified code: (total score)""",
                },  #
                {
                    "role": "user",
                    "content": f"The Spec(design description) is\n\n{spec}\n\nThe original code is\n\n{code0}\n\nThe modified code is\n\n{code1}",
                },  #
            ],
        )
        return scoretext

    def History(self, num=-1):
        """
        - 返回第num个响应,包括输入
        - 示例:
        self.History() -> 你好！有什么我可以帮助你的吗？
        """
        last_key = list(self.json_content)[num]
        last_value = self.json_content[last_key]
        Response = last_value[0]
        key = list(Response)[-1]
        return Response[key]

    def ReGenerate_Response(self, num=1):
        """
        - 重新生成num个回答
        - 返回gpt的响应
        - num -> int
        """
        for i in range(2 * num - 1):
            last_key = list(self.json_content)[-1]
            del self.json_content[last_key]
        # 获取上次的问题
        Q = self.History()
        last_key = list(self.json_content)[-1]
        del self.json_content[last_key]
        return self.ASK_GPT(Q)


if __name__ == "__main__":
    # message = []
    # gpt_msg = []
    GPT = GPT("test")
    try:
        while True:
            user_input = input("\n-User: ").strip()
            if user_input == "exit" or user_input == "退出":
                break
            gpt_res = GPT.ASK_GPT(user_input)
            print("\n-GPT: " + gpt_res)
            # print(GPT.History(-2))
    except Exception as e:
        print(e)

    # print(GPT.ReGenerate_Response())
    os.system("pause")
