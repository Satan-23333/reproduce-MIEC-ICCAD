import os
import shutil
import re


def folder_copy(src_path: str, dir_path: str) -> None:
    source_path = os.path.abspath(src_path)
    target_path = os.path.abspath(dir_path)

    if not os.path.exists(target_path):
        os.makedirs(target_path, mode=0o777)
    if os.path.exists(source_path):
        shutil.rmtree(target_path)
    shutil.copytree(source_path, target_path)


def folder_rename(file_dir: str, old_name: str, new_name: str) -> None:
    old_path = file_dir + "/" + old_name
    new_path = file_dir + "/" + new_name
    shutil.move(old_path, new_path)


def file_rename(file_dir: str, old_name: str, new_name: str) -> None:
    source_path = file_dir + "/" + old_name
    target_path = file_dir + "/" + new_name
    if os.path.exists(target_path):
        os.remove(target_path)
    os.rename(source_path, target_path)


def file_move(src_path: str, dir_path: str, file_name: str) -> None:
    if not os.path.exists(dir_path):
        os.makedirs(dir_path, mode=0o777)
    if os.path.exists(dir_path + "/" + file_name):
        os.remove(dir_path + "/" + file_name)
    shutil.move(src_path + "/" + file_name, dir_path + "/" + file_name)


def file_copy(src_path: str, dir_path: str, file_name: str) -> None:
    if not os.path.exists(dir_path):
        os.makedirs(dir_path, mode=0o777)
    if os.path.exists(dir_path + "/" + file_name):
        os.remove(dir_path + "/" + file_name)
    shutil.copy(src_path + "/" + file_name, dir_path + "/" + file_name)


def redo(download_path: str, i):
    folder_rename(download_path, "design", "err_design(" + str(i) + ")")
    src_path = download_path + "/design(" + str(i) + ")"
    dir_path = download_path + "/design"
    folder_copy(src_path, dir_path)


def folder_move(src_path: str, dir_path: str, folder_name: str) -> None:
    source_path = src_path + "/" + folder_name
    target_path = dir_path + "/" + folder_name

    if not os.path.exists(target_path):
        os.makedirs(target_path, mode=0o777)
    if os.path.exists(source_path):
        shutil.rmtree(target_path)
    shutil.copytree(source_path, target_path)
    shutil.rmtree(source_path)


def debug_done(src_path: str, dir_path: str, max_i):
    folder_move(src_path, dir_path, "design")
    for j in range(max_i):
        target_path = src_path + "/design(" + str(j) + ")"
        if os.path.exists(target_path):
            folder_move(src_path, dir_path, "design(" + str(j) + ")")
        target_path = src_path + "/err_design(" + str(j) + ")"
        if os.path.exists(target_path):
            folder_move(src_path, dir_path, "err_design(" + str(j) + ")")


def modelsim_done(dir_path: str):
    target_path = dir_path + "/vsim.wlf"
    if os.path.exists(target_path):
        os.remove(target_path)
    target_path = dir_path + "/modelsim.ini"
    if os.path.exists(target_path):
        os.remove(target_path)
    target_path = dir_path + "/lib"
    if os.path.exists(target_path):
        shutil.rmtree(target_path)
    target_path = dir_path + "/transcript"
    if os.path.exists(target_path):
        os.remove(target_path)


def find_until_no_target(text):
    pattern = r"[\s\S]*?(?<=module)|[\s\S]*$"
    matches = re.findall(pattern, text)

    return matches[-2] if matches else ""


def code_fetch(text):
    pattern = r"```verilog(.*?)```"
    matches = re.findall(pattern, text, re.DOTALL | re.IGNORECASE)
    code = ""
    for match in matches:
        code += match
    return code


def score_fetch(code):
    pattern2 = r"\d+"
    score_txt = re.findall(pattern2, code)
    score = list(map(int, score_txt))
    return score


def collect_design(path, ignore=["tb", "testbench"]):
    design_files = []
    files = os.listdir(path)
    for file in files:
        if ignore and any(i.lower() in file.lower() for i in ignore):
            continue
        if os.path.splitext(file)[1] == ".v":
            design_files.append(file)
    return design_files


def collect_dirname(path):
    dirnames = []
    files = os.listdir(path)
    for file in files:
        if os.path.isdir(os.path.join(path, file)):
            dirnames.append(file)
    return dirnames
