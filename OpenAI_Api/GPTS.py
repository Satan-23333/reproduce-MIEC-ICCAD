from openai import OpenAI
import os
import json
import time
from datetime import datetime
from typing_extensions import override
from openai import AssistantEventHandler


class EventHandler(AssistantEventHandler):
    @override
    def on_text_created(self, text) -> None:
        print(f"\t\nGPTS > ", end="", flush=True)

    @override
    def on_text_delta(self, delta, snapshot):
        print(delta.value, end="", flush=True)

    def on_tool_call_created(self, tool_call):
        print(f"\t\nGPTS > {tool_call.type}\n", flush=True)

    def on_tool_call_delta(self, delta, snapshot):
        if delta.type == "code_interpreter":
            if delta.code_interpreter.input:
                print(delta.code_interpreter.input, end="", flush=True)
            if delta.code_interpreter.outputs:
                print(f"\t\n\noutput >", flush=True)
                for output in delta.code_interpreter.outputs:
                    if output.type == "logs":
                        print(f"\t\n{output.logs}", flush=True)


class GPTS:
    proxy_url = "https://gpt-api.satan2333.icu/v1"

    # 获取当前时间并格式化为字符串
    init_time = datetime.now().strftime("%Y-%m-%d_%H-%M")
    json_name = f"GPTS_{init_time}.json"
    try:
        current_dir = os.path.dirname(os.path.realpath(__file__))
    except:
        current_dir = os.getcwd()
    json_dir = os.path.join(current_dir, json_name)
    json_content = {"time": init_time}

    message = []
    user_msg = {"role": "user", "content": ""}
    gpt_msg = {"role": "assistant", "content": ""}
    thread_id = ""
    ASSISTANT_ID = ""

    def __init__(self, ASSISTANT_ID="asst_cJrrHWwpW3r6BOCK3AVH7vSS") -> None:
        with open(self.current_dir + "\\api.ini", "r") as api:
            OpenAI_API = api.read()
        self.client = OpenAI(api_key=OpenAI_API, base_url=self.proxy_url)
        self.thread = self.client.beta.threads.create()
        self.thread_id = self.thread.id
        self.ASSISTANT_ID = ASSISTANT_ID
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

    def ASK_GPT(self, data, stream=True):
        """和GPTS交互,输入问题,返回GPTS的响应,同时将输入输出存入json

        Args:
            data (str): 输入问题
            stream (bool, optional): 是否开启实时流式输出. Defaults to True.

        Returns:
            str: gpt的响应
        """
        self.user_msg["content"] = data
        self.message.append(self.user_msg)
        ask_time = datetime.now().strftime("%H:%M:%S")
        message = self.client.beta.threads.messages.create(
            thread_id=self.thread_id,
            role="user",
            content=data,
        )
        if stream == True:
            with self.client.beta.threads.runs.create_and_stream(
                thread_id=self.thread_id,
                assistant_id=self.ASSISTANT_ID,
                # instructions="Please address the user as Jane Doe. The user has a premium account.",
                event_handler=EventHandler(),
            ) as stream:
                stream.until_done()
        else:
            run = self.client.beta.threads.runs.create(
                thread_id=self.thread_id,
                assistant_id=self.ASSISTANT_ID,
                instructions="Please address the user as Jane Doe. The user has a premium account.",
            )
            while run.status in ["queued", "in_progress", "cancelling"]:
                time.sleep(1)  # Wait for 1 second
                run = self.client.beta.threads.runs.retrieve(
                    thread_id=self.thread_id, run_id=run.id
                )

        gpt_res = (
            self.client.beta.threads.messages.list(thread_id=self.thread_id)
            .data[0]
            .content[0]
            .text.value
        )
        self.gpt_msg["content"] = gpt_res
        self.message.append(self.gpt_msg)

        response_time = datetime.now().strftime("%H:%M:%S")

        self.json_content[ask_time] = [{"User": data}]
        self.json_content[response_time] = [{"GPTS": gpt_res}]
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

    # def ReGenerate_Response(self, num=1):
    #     """
    #     - 重新生成num个回答
    #     - 返回gpt的响应
    #     - num -> int
    #     """
    #     for i in range(2 * num - 1):
    #         last_key = list(self.json_content)[-1]
    #         del self.json_content[last_key]
    #     # 获取上次的问题
    #     Q = self.History()
    #     last_key = list(self.json_content)[-1]
    #     del self.json_content[last_key]
    #     return self.ASK_GPT(Q)


if __name__ == "__main__":
    # message = []
    # gpt_msg = []
    GPTS = GPTS()
    try:
        while True:
            user_input = input("\n-User: ").strip()
            if user_input == "exit" or user_input == "退出":
                break
            gpt_res = GPTS.ASK_GPT(user_input, stream=True)
            # print("\n-GPT: " + gpt_res)
            # print(GPT.History(-2))
    except Exception as e:
        print(e)

    # print(GPT.ReGenerate_Response())
    os.system("pause")
