accu_function_missing_not_logic
assign ready_add = valid_out | valid_in;缺少非逻辑未被检测出

accu_function_wrong_cnt
多次出现数据回滚，gpt4偷懒  需要将gpt4退出原因返回 

accu_syntax_undefined_variable
assign给未定义的wire类型赋值，属于隐性赋值，verilog允许 