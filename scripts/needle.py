import subprocess
import random
import os
from pathlib import Path
import re 
import argparse

# bug patterns are defined here
# NOTE:
#  1. `src` and `dst` will be concatenated to form a substitution command for `sed`
#  2. the first character of `src` will be considered as the seperator for the substitution command
#  3. pay attention to the escaped sequence in python string
#  4. Example: ['/\(i *\)++', '\\1--'] will form the following command
#                     s/\(i *\)++/\1--/
#  5. threshold means the max times we can insert this bugtype in each file

buglist = [  # TODO: add more bug patterns
  #   src                           dst   threshold
  ['/reg'                        , 'wire'       , 10],
  ['/wire'                       , 'reg'        , 10],
  ['/posedge'                    , 'negedge'    , 5], 
  ['/\+ 1'                       , '\\-\ 1'     , 2], 
  ['/\- 1'                       , '\\-\ 2'     , 2], 
  ['/always @(posedge clk'       , 'always\ @(posedge\ clk', 5],
  ['/<='                         , '= '         , 2],
  ['/\ ='                        , '<='         , 5],
  ['/\&'                         , '&&'         , 5],
  ['/|'                          , '||'         , 5],
  ['/\&&'                        , '&'          , 5],
  ['/||'                         , '|'          , 5],
  ['/\&'                         , '|'          , 5],
  ['/\|'                         , '&'          , 5],
  ['/=='                         , '!='         , 2],
  ['/!='                         , '=='         , 2],
  ['/\ >\ '                      , '\ <\ '      , 2],
  ['/\ <\ '                      , '\ >\ '      , 2],
  ['/data'                       , 'addr'       , 2],
  ['/addr'                       , 'data'       , 2],
  ['/input'                      , 'output'     , 2],
  ['/output'                     , 'input'      , 2]
]

#===========================================
# common functions

def shell(cmd):   # execute the shell command and return the output as a string
    output = subprocess.Popen("bash -c \"" + cmd + "\"", stdout = subprocess.PIPE, shell = True).communicate()
    return output[0].decode('UTF-8')

def shellv(cmd):  # return array of lines
    res = shell(cmd).split('\n')
    if res[-1] == '':
        res = res[:-1]
    return res


#===========================================
# check project

# if os.getenv('RTL_HOME') == None:
#     print("Error: RTL_HOME is not set!")
#     exit(-1)

parser = argparse.ArgumentParser(description="Bug Needle: Semi-automated bug needle tool")
parser.add_argument("-r", "--rtl_dir", 
                        type=str,
                        help="the input file directory")
parser.add_argument("-o", "--output_dir",
                        type=str,
                        help="the output file directory")
parser.add_argument("-m", "--make_dataset",
                        action="store_true",
                        help="whether to write .tsv file")
args = parser.parse_args()

# RTL_HOME = Path(os.getenv('rtl_dir'))
# ERRRO_HOME = Path(os.getenv('output_dir'))
# RTL_HOME    = "/home/shiroha/LLM/Verilog-Auto-Debug/RTLLM"
# ERRRO_HOME  = "/home/shiroha/LLM/Verilog-Auto-Debug/ErrorSet/Errordata_generate"


# print("RTL_HOME=" + str(RTL_HOME))

def check_path(path):
    if not path.exists():
        print("Error: " + str(path) + " does not exist!")
        exit(-1)

#===========================================
# compute filelist

tb_filelist   = shellv("find " + str(args.rtl_dir) + "/" + " -name '*.v' | grep tb.v")

v_filelist    = shellv("find " + str(args.rtl_dir) + "/" + " -name '*.v' | grep -vE 'tb.v|testbench.v' ")

# print(v_filelist)

for f in v_filelist:
    check_path(Path(f))
    filename = shell("basename " + f +  " | cut -d'.' -f1")
    filename = re.sub(r'[\n\r]+', '', filename)   # 使用 re.sub 替换文件名中的换行符
    cp_dst_dir = os.path.join(str(args.output_dir), filename)
    shell("mkdir -p " + cp_dst_dir)
    cp_dst_file = os.path.join(cp_dst_dir, filename + '.v')
    shell("cp '" + f + "' '" + cp_dst_file + "'")
    # print(f)


e_filelist = shellv("find " + str(args.output_dir) + "/"+ " -name '*.v' ")



#==========================================
# init .tsv file
tsv_file_path = os.path.join(args.output_dir, 'dataser.tsv') # TSV文件的路径

with open(tsv_file_path, 'w', encoding='utf-8') as tsv_file:
    # 写入标题行（如果有）
    header = "filename\tbugType\tline\tdescription\n"  
    tsv_file.write(header)


#===========================================
# traverse every file and every bug

def rand_element(array):
    i = random.randint(0, len(array) - 1)
    return array[i]

def sed_str(bug):
    seperator = bug[0][0]
    return bug[0] + bug[0][0] + bug[1] + bug[0][0]

filename = None
bug = None

for f in e_filelist:
    check_path(Path(f))
    filename = shell("basename " + f +  "| cut -d'.' -f1")
    filename = re.sub(r'[\n\r]+', '', filename)   # 使用 re.sub 替换文件名中的换行符
    print("Insert bug in " + str(filename))

    for bugtype in range(len(buglist)):
        bug   = buglist[bugtype]
        regex = bug[0][1:]
        grep_cmd = "grep -n '" +  regex + "' " + f
        # print(grep_cmd)
        grep_results = shellv(grep_cmd)  # 寻找所有有指定元素的行
    
        if grep_results == []:
            continue                # 没找着就跳过，寻找下一个类型的bugtype

        threshold = bug[2]
        for idx in range(len(grep_results)): 
            if (idx == threshold): break
            line = grep_results[idx].split(':')[0] 
            generate_file = os.path.join(os.path.dirname(f), filename + '_bugtype' + str(bugtype) + '_line' + line + '.v')
            # print(generate_file)
            shell("cp " + f + " " + generate_file) 
            sed_cmd = "sed -i '" + line + "s" + sed_str(bug) + "' " + generate_file  # 创建文件并写入bug
            # -i 选项指示 sed 直接修改文件，而不是输出修改到标准输出 -e 输出到stdout
            
            print(sed_cmd)
            if args.make_dataset != None:
                shell(sed_cmd)
                description = re.sub(r'[\n\r]+', '', shell("diff "  + generate_file + ' ' + os.path.join(os.path.dirname(f), filename + '.v'))) # 使用 re.sub 替换文件名中的换行符
                tsv_line = filename + "\t" + str(bugtype) + "\t" + line + "\t" + description +"\n"
                
                with open(tsv_file_path, 'a', encoding='utf-8') as tsv_file: # 向tsv写入信息
                    tsv_file.write(tsv_line)
            
            else: shellv(sed_cmd)

print("Bug insert finish!")