import json
import csv

def update_csv(json_data, csv_file):
    module_names = [item['module_name'] for item in json_data["Debug_list"]]
    module_list = [item['module_list'] for item in json_data["Debug_list"]]
    # print(module_names)

    fieldname = ["Name","Is_Success","Error_type","Iterations","Total_time","Sim_time","Debug_time","Score_time","Trans_time"]
    with open(csv_file, 'w',newline="") as file:
        writer = csv.DictWriter(file, fieldnames=fieldname)
        writer.writeheader()
        for i,name in enumerate(module_names):
            # Create a CSV dictionary writer and add the student header as field names
            # Use writerows() not writerow()
            writer.writerow({"Name":name})
            writer.writerows(module_list[i])
            #写入一行空行
            writer.writerow({})

if __name__ == "__main__":
    json_file = "D:\Code\Verilog\Autodebug\Output\Output_2024-04-16_20-45.json"
    csv_file = "统计.csv"
    update_csv(json_file, csv_file)