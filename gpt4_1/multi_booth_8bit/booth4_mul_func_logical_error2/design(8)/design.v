module	multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output reg [15:0] p;
   output reg rdy;
   
   reg [15:0] multiplier;
   reg [15:0] multiplicand;
   reg [4:0] ctr;
   
   always @(posedge clk or posedge reset) begin
      if (reset) 
      begin
         rdy     <= 0;
         p       <= 0;
         ctr     <= 0;
         multiplier <= {a[7] ? 8'hFF : 8'h00, a};
         multiplicand <= {b[7] ? 8'hFF : 8'h00, b};
      end 
      else 
      begin 
         if(ctr < 16) 
         begin
            if (multiplier[0] == 1'b1)
            begin
               p <= p + multiplicand;
            end
            if (multiplier[1] == 1'b1)
            begin
               p <= p - multiplicand;
            end
            p <= p >> 1;
            multiplier <= multiplier >> 1;
            ctr <= ctr + 1;
         end
         else 
         begin
            rdy <= 1;
         end
      end
   end 
endmodule
