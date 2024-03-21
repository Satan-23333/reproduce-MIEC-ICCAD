module	accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in    ,
    
    output  reg         valid_out   ,
    output  reg [9:0]   data_out
);

reg [1:0] count;
reg [9:0] data_out_reg;

// count and valid_out
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
       count = 2'b00;
       valid_out = 1'b0;
    end
    else if(valid_in) begin
        if(count == 2'b11) begin
            count = 2'b00;
            valid_out = 1'b1;
        end
        else begin
            count = count + 1;
            valid_out = 1'b0;
        end
    end
    else begin
        valid_out = 1'b0;
    end
end

// data_out_reg and data_out
always @(posedge clk or negedge rst_n) begin
   if(!rst_n) begin
     data_out_reg = 0;
   end
   else if(valid_in) begin
       if(count == 2'b00) begin
           data_out_reg = data_in;
       end
       else begin
           data_out_reg = data_out_reg + data_in;
       end
   end
   data_out = data_out_reg;
end

endmodule
