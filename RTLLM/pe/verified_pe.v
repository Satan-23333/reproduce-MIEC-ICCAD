module verified_pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);

reg [31:0] d;

always@(posedge clk or posedge rst)
begin

  if(rst)
  begin
    d <= 0;
  end

  else
  begin
    d <= d + a*b;
  end

end
assign c=d;

endmodule