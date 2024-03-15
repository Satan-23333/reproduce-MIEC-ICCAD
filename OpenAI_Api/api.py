# 初始化配置
from openai import OpenAI
import os
import json
from datetime import datetime


class GPT:
    proxy_url = "https://gpt-api.satan2333.icu/v1"

    # 获取当前时间并格式化为字符串
    init_time = datetime.now().strftime("%Y-%m-%d_%H-%M")
    json_name = f"GPT_Response_{init_time}.json"
    current_file = __file__  # 获取当前脚本文件名（包括后缀）
    current_dir = os.path.dirname(current_file)  # 获取当前目录路径
    json_dir = os.path.join(current_dir, json_name)
    json_content = {"time": init_time}

    message = []
    user_msg = {"role": "user", "content": ""}
    gpt_msg = {"role": "assistant", "content": ""}

    def __init__(self) -> None:
        with open(self.current_dir + "\\api.ini", "r") as api:
            OpenAI_API = api.read()
        self.client = OpenAI(api_key=OpenAI_API, base_url=self.proxy_url)

        with open(self.json_dir, "w", encoding="UTF-8") as file:
            json.dump(self.json_content, file, indent=4)
        print(f"保存到JSON文件 '{self.json_name}'")

    def save_json(self):
        # 读取原始JSON文件内容
        # with open(self.json_dir, "r") as file:
        #     content = json.load(file)

        # # 将新数据合并或更新到原始数据中
        # current_time = datetime.now().strftime("%H:%M:%S")
        # content[current_time] = [{"Role": data.role, "Content": data.content}]
        # 将更新后的数据写回文件
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
        # self.save_json(completion.choices[0].message)
        return self.gpt_msg["content"]

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
    GPT = GPT()
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
