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
    reg multiplier_lsb;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rdy <= 0;
            p <= 0;
            ctr <= 0;
            multiplier <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            multiplier_lsb <= 0;
        end 
        else begin 
            if(ctr < 16) begin
                if (multiplier[0] == 1 && multiplier_lsb == 0) begin
                    p = p + multiplicand;
                end
                if (multiplier[0] == 0 && multiplier_lsb == 1) begin
                    p = p - multiplicand;
                end
                multiplier_lsb <= multiplier[0];
                multiplier <= {multiplier[0], multiplier[15:1]};
                multiplicand <= {multiplicand[14:0], 0};
                ctr <= ctr + 1;
            end
            else begin
                rdy <= 1;
            end
        end
    end
endmodule
