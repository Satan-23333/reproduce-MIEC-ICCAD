`timescale 1ns/1ns  // Defines the simulation time unit and resolution.

module accu(
    input               clk         ,   // Clock input
    input               rst_n       ,   // Active low reset
    input       [7:0]   data_in     ,   // 8-bit input data
    input               valid_in    ,   // Input valid signal

    output  reg         valid_out   ,   // Output valid signal
    output  reg [9:0]   data_out      // 10-bit output data (accumulated result)
);

   reg [1:0] count;                // 2-bit counter for managing accumulation cycles
   wire add_cnt;                   // Signal to control when to add to the accumulator
   wire ready_dd;                 // Signal indicating readiness to add to the accumulator
   wire end_cnt;                   // Signal indicating the end of accumulation cycle
   reg [9:0]   data_out_reg;       // Internal register to hold the intermediate accumulated value

   // Logic to manage the accumulation process
   assign add_cnt = ready_add;
   assign end_cnt = ready_add && (count == 'd3);  // End condition of accumulation cycle
   
   // Counter logic to keep track of the accumulation cycles
   always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           count <= 0;
       end
       else if (end_cnt) begin
           count <= 0;
       end
       else if (add_cnt) begin
           count <= count + 1;
       end
   end

   // Accumulation logic to update the intermediate accumulated value
   always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           data_out_reg <= 0;
       end
       else if (add_cnt && count == 0) begin
           data_out_reg <= data_in;
       end
       else if (add_cnt) begin
           data_out_reg <= data_out_reg + data_in;
       end
   end

   // Output logic to update the final accumulated result
   always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           data_out <= 0;
       end
       else if (add_cnt && count == 0) begin
           data_out <= data_in;
       end
       else if (add_cnt) begin
           data_out <= data_out + data_in;
       end
   end

   // Logic to determine when to add to the accumulator
   assign ready_add = !valid_out | valid_in;

   // Logic to manage the output valid signal
   always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           valid_out <= 0;
       end
       else if (end_cnt) begin
           valid_out <= 1;
       end
       else begin
           valid_out <= 0;
       end
   end  

endmodule

