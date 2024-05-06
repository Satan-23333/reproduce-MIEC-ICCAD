`timescale 1ns/1ns
`define width 8

module tb () ;
    reg signed [`width-1:0] a, b;
    reg             clk, reset;

    wire signed [2*`width-1:0] p;
    wire           rdy;

    integer total, err;
    integer i;

    reg [7:0]num_a[0:39];
    reg [7:0]num_b[0:39];
    reg [15:0]result[0:39];

    multi_booth_8bit uut( .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .p(p),
        .rdy(rdy));

    // Set up 10ns clock
    always #5 clk = ~clk;

    initial begin
        clk = 1;
        total = 0;
        err = 0;


        // Sequences of values pumped through DUT 
        for (i=0; i<40; i=i+1) begin
            // Set the inputs
            a = num_a[i];
            b = num_b[i];
            // Reset the DUT for one clock cycle
            reset = 1;
            @(posedge clk);
            // Remove reset 
            #1 reset = 0;


            while (rdy == 0) begin
                @(posedge clk); // Wait for one clock cycle
            end
            if (p == result[i] || i==0) begin
                // $display($time, " Passed %d * %d = %d", a, b, p);
            end else begin
                // $display($time, " Fail %d * %d: %d instead of %d", a, b, p, ans);
                err = err + 1;
                $display("This is testbench input: a=8'H%h, b=8'H%h, and expected_result=16'H%h, but the result is p=16'H%h; please fix the error",num_a[i],num_b[i],result[i],p);
                $finish;
            end
            total = total + 1;
        end
        if (err > 0) begin
            $display("=========== Failed ===========");
        end else begin
            $display("===========Your Design Passed===========");
        end
        

        $finish;
    end
    
    initial begin
num_a[0] = 8'H66;
num_b[0] = 8'H1E;
result[0] = 16'H0BF4;
num_a[1] = 8'H1F;
num_b[1] = 8'H6C;
result[1] = 16'H0D14;
num_a[2] = 8'H4C;
num_b[2] = 8'H04;
result[2] = 16'H0130;
num_a[3] = 8'H56;
num_b[3] = 8'H7D;
result[3] = 16'H29FE;
num_a[4] = 8'H79;
num_b[4] = 8'H73;
result[4] = 16'H365B;
num_a[5] = 8'H58;
num_b[5] = 8'H62;
result[5] = 16'H21B0;
num_a[6] = 8'H77;
num_b[6] = 8'H2D;
result[6] = 16'H14EB;
num_a[7] = 8'H51;
num_b[7] = 8'H39;
result[7] = 16'H1209;
num_a[8] = 8'H21;
num_b[8] = 8'H5F;
result[8] = 16'H0C3F;
num_a[9] = 8'H0C;
num_b[9] = 8'H31;
result[9] = 16'H024C;
num_a[10] = 8'HB9;
num_b[10] = 8'HA1;
result[10] = 16'H1A59;
num_a[11] = 8'HDF;
num_b[11] = 8'HB9;
result[11] = 16'H0927;
num_a[12] = 8'HBD;
num_b[12] = 8'HF6;
result[12] = 16'H029E;
num_a[13] = 8'HE7;
num_b[13] = 8'HD9;
result[13] = 16'H03CF;
num_a[14] = 8'H93;
num_b[14] = 8'HC1;
result[14] = 16'H1AD3;
num_a[15] = 8'HA2;
num_b[15] = 8'HAB;
result[15] = 16'H1F36;
num_a[16] = 8'HF5;
num_b[16] = 8'HB0;
result[16] = 16'H0370;
num_a[17] = 8'HB5;
num_b[17] = 8'HB3;
result[17] = 16'H168F;
num_a[18] = 8'H81;
num_b[18] = 8'H89;
result[18] = 16'H3B09;
num_a[19] = 8'HFE;
num_b[19] = 8'HBC;
result[19] = 16'H0088;
num_a[20] = 8'H29;
num_b[20] = 8'H99;
result[20] = 16'HEF81;
num_a[21] = 8'H26;
num_b[21] = 8'HF0;
result[21] = 16'HFDA0;
num_a[22] = 8'H62;
num_b[22] = 8'H97;
result[22] = 16'HD7CE;
num_a[23] = 8'H2F;
num_b[23] = 8'H97;
result[23] = 16'HECB9;
num_a[24] = 8'H65;
num_b[24] = 8'HE6;
result[24] = 16'HF5BE;
num_a[25] = 8'H24;
num_b[25] = 8'HDE;
result[25] = 16'HFB38;
num_a[26] = 8'H61;
num_b[26] = 8'H8C;
result[26] = 16'HD40C;
num_a[27] = 8'H1C;
num_b[27] = 8'H96;
result[27] = 16'HF468;
num_a[28] = 8'H45;
num_b[28] = 8'HF8;
result[28] = 16'HFDD8;
num_a[29] = 8'H2C;
num_b[29] = 8'HF7;
result[29] = 16'HFE74;
num_a[30] = 8'H00;
num_b[30] = 8'H7D;
result[30] = 16'H0000;
num_a[31] = 8'H00;
num_b[31] = 8'H46;
result[31] = 16'H0000;
num_a[32] = 8'H00;
num_b[32] = 8'HE8;
result[32] = 16'H0000;
num_a[33] = 8'H00;
num_b[33] = 8'H03;
result[33] = 16'H0000;
num_a[34] = 8'H00;
num_b[34] = 8'H30;
result[34] = 16'H0000;
num_a[35] = 8'H00;
num_b[35] = 8'H87;
result[35] = 16'H0000;
num_a[36] = 8'H00;
num_b[36] = 8'HAF;
result[36] = 16'H0000;
num_a[37] = 8'H00;
num_b[37] = 8'HF7;
result[37] = 16'H0000;
num_a[38] = 8'H00;
num_b[38] = 8'HB3;
result[38] = 16'H0000;
num_a[39] = 8'H00;
num_b[39] = 8'HCD;
result[39] = 16'H0000;    
    
    end

endmodule