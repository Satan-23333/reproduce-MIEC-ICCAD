# Bug Needle: 半自动化Bug注射器

## Quick Start

执行以下命令注入bug
```bash
python ./scripts/needle.py --rtl_dir="/path/to/golden_code_dir" --output_dir="/path/to/output_dir"
```

可通过定义环境变量`make_dataset`来生成对应的tsv文件, 供训练或测试使用. 如
```bash
python ./scripts/needle.py --rtl_dir="/path/to/golden_code_dir" --output_dir="/path/to/output_dir" --make_dataset
```

如果你循环执行n遍，将会得到一堆排列组合。。。

## 生成的Dateset组成
对于每个.v文件（如verified_RAM.v）会生成一个对应文件夹（verified_RAM），里面会存放

- 标准文件：verified_RAM.v
- 各种注入bug的error文件：verified_RAM_bugtype{bugtype}_line{line}.v
  - bugtype表示bug的注入类型，line表示注入bug的行数
  在上层目录生成一个总的tsv文件用于记录数据集信息，tsv文件格式规定：

filename            | bugType | line  | description
------------------  | -----   | ----- | ------------
verified_multi_16bit_bugtype0_line36       | 0       | 12    |    12c12< reg [15:0] areg;    // Multiplicand a register.---> wire [15:0] areg;    // Multiplicand a register.
verified_multi_16bit_bugtype0_line36       | 1       | 13    |    13c13< reg [15:0] breg;    // Multiplier b register.---> wire [15:0] breg;    // Multiplier b register.    
verified_multi_16bit_bugtype0_line36 | 1       | 21    |    21c21,22< always @(posedge clk or negedge rst_n)---> always @(> edge clk or negedge rst_n)      


TODO:
* 添加更多bug规则(欢迎大家贡献!)
* 一些更灵活的注入
* 实现设置注射BugType的比例
* 一个文件注入多个bug
