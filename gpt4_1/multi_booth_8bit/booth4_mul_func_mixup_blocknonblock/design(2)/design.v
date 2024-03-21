module	multi_booth_8bit (
    input wire clk, 
    input wire reset, 
    input wire [7:0] a, 
    input wire [7:0] b, 
    output wire [15:0] p, 
    output wire rdy
);
    reg [15:0] multiplier;
    reg [15:0] multiplicand;
    reg [4:0] ctr;
    reg [15:0] product;
    reg rdy_tmp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rdy_tmp <= 0;
            product <= 0;
            ctr <= 0;
            multiplier <= {8{a[7]}, a};
            multiplicand <= {8{b[7]}, b};
        end 
        else begin 
            if(ctr < 16) begin
                product = product + (multiplier[0] ? multiplicand : 16'h0);
                multiplier = {multiplier[15:1], multiplier[15]};
                multiplicand = multiplicand << 1;
                ctr = ctr + 1;
            end
            else begin
                rdy_tmp <= 1;
            end
        end
    end

    assign p = product;
    assign rdy = rdy_tmp;
endmodule
