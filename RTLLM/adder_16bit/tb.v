`timescale 1ns/1ps

module add16_tb();

    reg [15:0] a;
    reg [15:0] b;
    reg Cin;

    wire [15:0] y;
    wire Co;


    integer i;
    integer error = 0;

    reg [15:0]num_a[0:39];
    reg [15:0]num_b[0:39];
    reg [16:0]result[0:39];
    initial begin
num_a[0] = 16'H71AB;
num_b[0] = 16'HFCA0;
result[0] = 17'H16E4B;
num_a[1] = 16'HAD71;
num_b[1] = 16'H34E9;
result[1] = 17'H0E25A;
num_a[2] = 16'H0E03;
num_b[2] = 16'H068F;
result[2] = 17'H01492;
num_a[3] = 16'H96D5;
num_b[3] = 16'H8C97;
result[3] = 17'H1236C;
num_a[4] = 16'HBB66;
num_b[4] = 16'H7A69;
result[4] = 17'H135CF;
num_a[5] = 16'HFC67;
num_b[5] = 16'HB8C5;
result[5] = 17'H1B52C;
num_a[6] = 16'H87DA;
num_b[6] = 16'H28AA;
result[6] = 17'H0B084;
num_a[7] = 16'H0C6A;
num_b[7] = 16'H1EC5;
result[7] = 17'H02B2F;
num_a[8] = 16'H0947;
num_b[8] = 16'H05F1;
result[8] = 17'H00F38;
num_a[9] = 16'H1CBA;
num_b[9] = 16'HF71A;
result[9] = 17'H113D4;
num_a[10] = 16'H488F;
num_b[10] = 16'H0E2C;
result[10] = 17'H056BB;
num_a[11] = 16'H7857;
num_b[11] = 16'HD0A5;
result[11] = 17'H148FC;
num_a[12] = 16'HCC6B;
num_b[12] = 16'HEEB4;
result[12] = 17'H1BB1F;
num_a[13] = 16'H7417;
num_b[13] = 16'HABE9;
result[13] = 17'H12000;
num_a[14] = 16'H762C;
num_b[14] = 16'HFD0F;
result[14] = 17'H1733B;
num_a[15] = 16'H4E48;
num_b[15] = 16'H8F84;
result[15] = 17'H0DDCC;
num_a[16] = 16'H5984;
num_b[16] = 16'H71C1;
result[16] = 17'H0CB45;
num_a[17] = 16'H2EC2;
num_b[17] = 16'HB349;
result[17] = 17'H0E20B;
num_a[18] = 16'HC488;
num_b[18] = 16'HDFBA;
result[18] = 17'H1A442;
num_a[19] = 16'HDB55;
num_b[19] = 16'H60C6;
result[19] = 17'H13C1B;
num_a[20] = 16'HF7D2;
num_b[20] = 16'H1018;
result[20] = 17'H107EA;
num_a[21] = 16'HD9B0;
num_b[21] = 16'H30FF;
result[21] = 17'H10AAF;
num_a[22] = 16'H7936;
num_b[22] = 16'H3DC1;
result[22] = 17'H0B6F7;
num_a[23] = 16'HE4E9;
num_b[23] = 16'HBE29;
result[23] = 17'H1A312;
num_a[24] = 16'H8085;
num_b[24] = 16'H934A;
result[24] = 17'H113CF;
num_a[25] = 16'H8BEC;
num_b[25] = 16'H25CB;
result[25] = 17'H0B1B7;
num_a[26] = 16'H8D4D;
num_b[26] = 16'HB92B;
result[26] = 17'H14678;
num_a[27] = 16'HE6C8;
num_b[27] = 16'H3DB8;
result[27] = 17'H12480;
num_a[28] = 16'HA506;
num_b[28] = 16'H7D04;
result[28] = 17'H1220A;
num_a[29] = 16'HFA82;
num_b[29] = 16'H75CE;
result[29] = 17'H17050;
num_a[30] = 16'H68C8;
num_b[30] = 16'H234C;
result[30] = 17'H08C14;
num_a[31] = 16'H205E;
num_b[31] = 16'HD6C6;
result[31] = 17'H0F724;
num_a[32] = 16'HF24E;
num_b[32] = 16'HDB20;
result[32] = 17'H1CD6E;
num_a[33] = 16'H4B33;
num_b[33] = 16'H0D82;
result[33] = 17'H058B5;
num_a[34] = 16'H31EF;
num_b[34] = 16'HB6B1;
result[34] = 17'H0E8A0;
num_a[35] = 16'H1776;
num_b[35] = 16'H3F39;
result[35] = 17'H056AF;
num_a[36] = 16'H544E;
num_b[36] = 16'HF731;
result[36] = 17'H14B7F;
num_a[37] = 16'H7155;
num_b[37] = 16'H2AC5;
result[37] = 17'H09C1A;
num_a[38] = 16'HF826;
num_b[38] = 16'H67B8;
result[38] = 17'H15FDE;
num_a[39] = 16'H541E;
num_b[39] = 16'HD56F;
result[39] = 17'H1298D;

    end

    initial begin
        for (i = 0; i < 40; i = i + 1) begin
            a = num_a[i];
            b = num_b[i];
            Cin = 0;

            #10;
            error = ({Co,y}!==result[i]) ? error + 1 : error;
        end

        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end
        else begin
            $display("===========Test completed with %d / 100 failures===========", error);
        end
    end

    verified_adder_16bit uut (
        .a(a),
        .b(b),
        .Cin(Cin),

        .y(y),
        .Co(Co)
    );

endmodule