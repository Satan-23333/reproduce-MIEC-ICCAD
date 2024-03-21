module	declaration, you have defined the reset signal as 'reset' but in the always block you're referring it as 'rst'. Therefore, you just need to replace 'rst' with 'reset' in the always block. 

Here is the corrected Verilog design code:

```verilog
`timescale 1ns / 1ps

module multi_booth_8bit (p, rdy, clk, reset, a, b);
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
    p   <= 0;
    ctr     <= 0;
    multiplier <= {{8{a[7]}}, a};
    multiplicand <= {{8{b[7]}}, b};
    end 
    else 
    begin 
      if(ctr < 16) 
          begin
          multiplicand <= multiplicand << 1;
            if (multiplier[ctr] == 1)
            begin
                p <= p + multiplicand;
            end
            ctr <= ctr + 1;
          end
       else 
           begin
           rdy <= 1;
           end
    end
  end //End of always block
    
endmodule
