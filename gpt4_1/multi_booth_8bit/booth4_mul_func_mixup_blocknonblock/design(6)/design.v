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
    reg [1:0] multiplier_lsb;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rdy <= 0;
            p <= 0;
            ctr <= 0;
            multiplier <= {a, 1'b0};  // append 0 to least significant bit
            multiplicand <= {b, 8'b0};  // append 8'b0 to most significant bit
            multiplier_lsb <= 2'b00;
        end 
        else begin 
            if(ctr < 16) begin
                case (multiplier_lsb) 
                    2'b01: p = p + multiplicand;
                    2'b10: p = p - multiplicand;
                    default: ;
                endcase

                multiplier_lsb <= multiplier[1:0];
                multiplier <= {multiplier[14:0], 1'b0};
                multiplicand <= {multiplicand[15:1], 1'b0};
                ctr <= ctr + 1;
            end
            else begin
                rdy <= 1;
            end
        end
    end
endmodule
