import os
import file 
import autodebug
# folder path
dir_path = "d:/seu/Chatgpt-api"
error_path = "d:/seu/ErrorSet/RTLLM"

spec_name = "design_description.txt"
tb_name = "tb.v"
max_i=10

# initialize
dir_list = []
file_list = []
 
for root, dirs, files in os.walk(error_path):
        # root 表示当前正在访问的文件夹路径
        # dirs 表示该文件夹下的子目录名list
        # files 表示该文件夹下的文件list
        dir_list = dirs
        break

for i in range(len(dir_list)):
    file_path=error_path+'/'+dir_list[i]
    # Iterate directory
    for path in os.listdir(file_path):
        # check if current path is a file
        if os.path.isfile(os.path.join(file_path, path)) and path!=spec_name and path!=tb_name:
            file_name,extention=os.path.splitext(path)
            design_path = file_path+'/'+file_name+'/design'
            file.file_copy(file_path,design_path,path)
            file.file_rename(design_path,path,"design.v")
            file.file_copy(file_path,design_path,tb_name)
            file.file_copy(file_path,design_path,spec_name)
            file.folder_copy(design_path,dir_path+'/design')
            autodebug.autodebug(max_i,dir_path)
            file.debug_done(dir_path,design_path,max_i)
            # break
