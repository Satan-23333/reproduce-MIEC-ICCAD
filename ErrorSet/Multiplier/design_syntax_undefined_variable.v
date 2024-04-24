`timescale 1ns / 1ps

module multiply(             
    input         clk,        // 时钟
    input         mult_begin, // 乘法开始信号
    input  [31:0] mult_op1,   // 乘法源操作数1
    input  [31:0] mult_op2,   // 乘法源操作数2
    output [63:0] product,    // 乘积
    output        mult_end   // 乘法结束信号
);
    //乘法正在运算信号和结束信号
    reg mult_vaild;
    reg  [31:0] multiplier;

    assign mult_end = mult_valid & ~(|multiplier); //乘法结束信号：乘数全0
    always @(posedge clk)   
    begin
        // if (!mult_begin || mult_end)    //如果没有开始或者已经结束了
        if (multiplier == 32'd0)
        begin
            mult_valid <= 1'b0;     //mult_valid 赋值成0，说明现在没有进行有效的乘法运算
        end
        else
        begin
            mult_valid <= 1'b1;
       //     test <= 1'b1;
        end
    end

    //两个源操作取绝对值，正数的绝对值为其本身，负数的绝对值为取反加1
    wire        op1_sign;      //操作数1的符号位
    wire        op2_sign;      //操作数2的符号位
    wire [31:0] op1_absolute;  //操作数1的绝对值
    wire [31:0] op2_absolute;  //操作数2的绝对值
    assign op1_sign = mult_op1[31];
    assign op2_sign = mult_op2[31];
    assign op1_absolute = op1_sign ? (~mult_op1+1) : mult_op1;
    assign op2_absolute = op2_sign ? (~mult_op2+1) : mult_op2;
    //加载被乘数，运算时每次左移一位
    reg  [63:0] multiplicand;
    always @ (posedge clk)  
    begin
        if (mult_valid)
        begin    // 如果正在进行乘法，则被乘数每时钟左移一位
            multiplicand <= {multiplicand[62:0],1'b0};  //被乘数x每次左移一位。
        end
        else if (mult_begin) 
        begin   // 乘法开始，加载被乘数，为乘数1的绝对值
            multiplicand <= {32'd0,op1_absolute};
        end
    end

    //加载乘数，运算时每次右移一位，相当于y
    
    always @ (posedge clk) 
    begin
    if(mult_valid)
    begin       //如果正在进行乘法，则乘数每时钟右移一位
         multiplier <= {1'b0,multiplier[31:1]}; //相当于乘数y右移一位
    end
    else if(mult_begin)
    begin   //乘法开始，加载乘数，为乘数2的绝对值
        multiplier <= op2_absolute;
        end
    end
    // 部分积：乘数末位为1，由被乘数左移得到；乘数末位为0，部分积为0
    wire [63:0] partial_product;
    assign partial_product = multiplier[0] ? multiplicand:64'd0;        //若此时y的最低位为1，则把x赋值给部分积partial_product，否则把0赋值给partial_product
    
    //累加器
    reg [63:0] product_temp;		//临时结果
    always @ (posedge clk)  //
    begin
        if (mult_valid)
        begin
            product_temp <= product_temp + partial_product;
        end      
        else if (mult_begin)
        begin
        product_temp <= 64'd0;
        end
     end
     
    //乘法结果的符号位和乘法结果
    reg product_sign;	//乘积结果的符号
    always @ (posedge clk)  
    begin
        if (mult_valid)
        begin
              product_sign <= op1_sign ^ op2_sign;
        end
    end 
    //若乘法结果为负数，则需要对结果取反+1
    
    assign product = product_sign ? (~product_temp+1) : product_temp;
endmodule
