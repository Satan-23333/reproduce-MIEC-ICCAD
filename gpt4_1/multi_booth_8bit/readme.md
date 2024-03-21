booth4_mul_func_improper_senlist
rst posedge->negedge tb未检测

booth4_mul_func_logical_error2
multiplier <= {a,{8{a[7]}}};这里反了  第一次改成multiplier <= {8{a[7]},a};缺少一组{}但后面无法改正

booth4_mul_func_mixup_blocknonblock
阻塞赋值与非阻塞赋值 第一次修改中改出了阻塞赋值与非阻塞赋值，但做了额外的修改

booth4_mul_syn_nonprintable
出现中文标点，第一次标点处已改正 但multiplier <= {8{a[7]},a};缺少一组{}后面无法改正