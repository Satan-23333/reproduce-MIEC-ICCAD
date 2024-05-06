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
        print()

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
    proxy_url = "https://api.openai.com/v1"
    try:
        current_dir = os.path.dirname(os.path.realpath(__file__))
    except:
        current_dir = os.getcwd()
    message = []
    user_msg = {"role": "user", "content": ""}
    gpt_msg = {"role": "assistant", "content": ""}
    thread_id = ""
    ASSISTANT_ID = ""

    def __init__(self, log_name, ASSISTANT_ID="asst_cJrrHWwpW3r6BOCK3AVH7vSS") -> None:
        with open(self.current_dir + "\\api.ini", "r") as api:
            OpenAI_API = api.read()
        self.client = OpenAI(api_key=OpenAI_API, base_url=self.proxy_url)
        self.thread = self.client.beta.threads.create()
        self.thread_id = self.thread.id
        self.ASSISTANT_ID = ASSISTANT_ID

        self.init_time = datetime.now().strftime("%Y-%m-%d_%H-%M")
        self.json_name = f"{log_name}_{self.init_time}.json"

        self.json_dir = os.path.join(self.current_dir + "\\json", self.json_name)
        self.json_content = {"time": self.init_time}

        os.makedirs(self.current_dir + "\\json", exist_ok=True)
        with open(self.json_dir, "w", encoding="UTF-8") as file:
            json.dump(self.json_content, file, indent=4)
        print(f"Save to json: '{self.json_name}'")

    def save_json(self) -> None:
        with open(self.json_dir, "w", encoding="UTF-8") as file:
            json.dump(self.json_content, file, indent=4, ensure_ascii=False)
        return

    def ASK_GPTs(self, data, stream=True) -> str:
        ask_start_time = time.time()
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
                event_handler=EventHandler(),
            ) as stream:
                stream.until_done()
        else:
            run = self.client.beta.threads.runs.create(
                thread_id=self.thread_id,
                assistant_id=self.ASSISTANT_ID,
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
        ask_end_time = time.time()
        return self.gpt_msg["content"], ask_end_time - ask_start_time

    def History(self, num=-1) -> str:
        last_key = list(self.json_content)[num]
        last_value = self.json_content[last_key]
        Response = last_value[0]
        key = list(Response)[-1]
        return Response[key]


if __name__ == "__main__":
    # message = []
    # gpt_msg = []
    GPTS = GPTS("gpts")
    try:
        while True:
            user_input = input("\n-User: ").strip()
            if user_input == "exit":
                break
            gpt_res = GPTS.ASK_GPTs(user_input, stream=True)
            print("\n-GPT: " + gpt_res)
    except Exception as e:
        print(e)

    os.system("pause")
