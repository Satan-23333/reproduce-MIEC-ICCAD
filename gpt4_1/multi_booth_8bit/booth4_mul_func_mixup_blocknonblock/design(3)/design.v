module	multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);
    reg [15:0] multiplier;
    reg [15:0] multiplicand;
    reg [4:0] ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rdy <= 0;
            p <= 0;
            ctr <= 0;
            multiplier <= {a[7], a, 8'b0};
            multiplicand <= {b[7], b, 8'b0};
        end 
        else begin 
            if(ctr < 16) begin
                p = p + (multiplier[0] ? multiplicand : 16'h0);
                multiplier = {multiplier[15:1], multiplier[15]};
                multiplicand = multiplicand << 1;
                ctr = ctr + 1;
            end
            else begin
                rdy <= 1;
            end
        end
    end
endmodule
