`timescale  1ns / 1ps

module tb;


parameter PERIOD  = 10;
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [7:0]  data_in                       = 0 ;
reg   valid_in                             = 0 ;

wire  valid_out                              ;
wire  [9:0]  data_out                       ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

accu  uut (
    .clk                     ( clk             ),
    .rst_n                   ( rst_n           ),
    .data_in                 ( data_in   [7:0] ),
    .valid_in                ( valid_in        ),

    .valid_out               ( valid_out       ),
    .data_out                ( data_out  [9:0] )
);
reg [9:0] result [0:39];
reg [7:0] num1[0:39];
reg [7:0] num2[0:39];
reg [7:0] num3[0:39];
reg [7:0] num4[0:39];
integer i;
integer casenum = 0;
integer error = 0;

initial
begin
    for (i = 0; i < 163; i = i + 1) begin
        #((PERIOD) * 1);         
        if (valid_out) begin
            error = (data_out == result[casenum]) ? error : error + 1;
            casenum = casenum + 1;
        end
        if(error!=0)begin
            $display("This is testbench input: data_in_1 =8'H%h, data_in_2 = 8'H%h, data_in_3 = 8'H%h, data_in_4 = 8'H%h, and expected_result=10'H%h, but the result is data_out=10'H%h; please fix the error",num1[casenum-1],num2[casenum-1],num3[casenum-1],num4[casenum-1],result[casenum-1],data_out);
            $finish;
        end          
    end
    if(error==0&&casenum==40)
	begin
		$display("===========Your Design Passed===========");
        end
	else
	begin
		$display("===========Test completed with %d /40failures===========", error);
	end
    $finish;
end
initial
begin
#(PERIOD*1+0.01);
#(PERIOD)valid_in = 1;data_in = num1[0];
#(PERIOD)data_in = num2[0];
#(PERIOD)data_in = num3[0];
#(PERIOD)data_in = num4[0];
#(PERIOD)valid_in = 1;data_in = num1[1];
#(PERIOD)data_in = num2[1];
#(PERIOD)data_in = num3[1];
#(PERIOD)data_in = num4[1];
#(PERIOD)valid_in = 1;data_in = num1[2];
#(PERIOD)data_in = num2[2];
#(PERIOD)data_in = num3[2];
#(PERIOD)data_in = num4[2];
#(PERIOD)valid_in = 1;data_in = num1[3];
#(PERIOD)data_in = num2[3];
#(PERIOD)data_in = num3[3];
#(PERIOD)data_in = num4[3];
#(PERIOD)valid_in = 1;data_in = num1[4];
#(PERIOD)data_in = num2[4];
#(PERIOD)data_in = num3[4];
#(PERIOD)data_in = num4[4];
#(PERIOD)valid_in = 1;data_in = num1[5];
#(PERIOD)data_in = num2[5];
#(PERIOD)data_in = num3[5];
#(PERIOD)data_in = num4[5];
#(PERIOD)valid_in = 1;data_in = num1[6];
#(PERIOD)data_in = num2[6];
#(PERIOD)data_in = num3[6];
#(PERIOD)data_in = num4[6];
#(PERIOD)valid_in = 1;data_in = num1[7];
#(PERIOD)data_in = num2[7];
#(PERIOD)data_in = num3[7];
#(PERIOD)data_in = num4[7];
#(PERIOD)valid_in = 1;data_in = num1[8];
#(PERIOD)data_in = num2[8];
#(PERIOD)data_in = num3[8];
#(PERIOD)data_in = num4[8];
#(PERIOD)valid_in = 1;data_in = num1[9];
#(PERIOD)data_in = num2[9];
#(PERIOD)data_in = num3[9];
#(PERIOD)data_in = num4[9];
#(PERIOD)valid_in = 1;data_in = num1[10];
#(PERIOD)data_in = num2[10];
#(PERIOD)data_in = num3[10];
#(PERIOD)data_in = num4[10];
#(PERIOD)valid_in = 1;data_in = num1[11];
#(PERIOD)data_in = num2[11];
#(PERIOD)data_in = num3[11];
#(PERIOD)data_in = num4[11];
#(PERIOD)valid_in = 1;data_in = num1[12];
#(PERIOD)data_in = num2[12];
#(PERIOD)data_in = num3[12];
#(PERIOD)data_in = num4[12];
#(PERIOD)valid_in = 1;data_in = num1[13];
#(PERIOD)data_in = num2[13];
#(PERIOD)data_in = num3[13];
#(PERIOD)data_in = num4[13];
#(PERIOD)valid_in = 1;data_in = num1[14];
#(PERIOD)data_in = num2[14];
#(PERIOD)data_in = num3[14];
#(PERIOD)data_in = num4[14];
#(PERIOD)valid_in = 1;data_in = num1[15];
#(PERIOD)data_in = num2[15];
#(PERIOD)data_in = num3[15];
#(PERIOD)data_in = num4[15];
#(PERIOD)valid_in = 1;data_in = num1[16];
#(PERIOD)data_in = num2[16];
#(PERIOD)data_in = num3[16];
#(PERIOD)data_in = num4[16];
#(PERIOD)valid_in = 1;data_in = num1[17];
#(PERIOD)data_in = num2[17];
#(PERIOD)data_in = num3[17];
#(PERIOD)data_in = num4[17];
#(PERIOD)valid_in = 1;data_in = num1[18];
#(PERIOD)data_in = num2[18];
#(PERIOD)data_in = num3[18];
#(PERIOD)data_in = num4[18];
#(PERIOD)valid_in = 1;data_in = num1[19];
#(PERIOD)data_in = num2[19];
#(PERIOD)data_in = num3[19];
#(PERIOD)data_in = num4[19];
#(PERIOD)valid_in = 1;data_in = num1[20];
#(PERIOD)data_in = num2[20];
#(PERIOD)data_in = num3[20];
#(PERIOD)data_in = num4[20];
#(PERIOD)valid_in = 1;data_in = num1[21];
#(PERIOD)data_in = num2[21];
#(PERIOD)data_in = num3[21];
#(PERIOD)data_in = num4[21];
#(PERIOD)valid_in = 1;data_in = num1[22];
#(PERIOD)data_in = num2[22];
#(PERIOD)data_in = num3[22];
#(PERIOD)data_in = num4[22];
#(PERIOD)valid_in = 1;data_in = num1[23];
#(PERIOD)data_in = num2[23];
#(PERIOD)data_in = num3[23];
#(PERIOD)data_in = num4[23];
#(PERIOD)valid_in = 1;data_in = num1[24];
#(PERIOD)data_in = num2[24];
#(PERIOD)data_in = num3[24];
#(PERIOD)data_in = num4[24];
#(PERIOD)valid_in = 1;data_in = num1[25];
#(PERIOD)data_in = num2[25];
#(PERIOD)data_in = num3[25];
#(PERIOD)data_in = num4[25];
#(PERIOD)valid_in = 1;data_in = num1[26];
#(PERIOD)data_in = num2[26];
#(PERIOD)data_in = num3[26];
#(PERIOD)data_in = num4[26];
#(PERIOD)valid_in = 1;data_in = num1[27];
#(PERIOD)data_in = num2[27];
#(PERIOD)data_in = num3[27];
#(PERIOD)data_in = num4[27];
#(PERIOD)valid_in = 1;data_in = num1[28];
#(PERIOD)data_in = num2[28];
#(PERIOD)data_in = num3[28];
#(PERIOD)data_in = num4[28];
#(PERIOD)valid_in = 1;data_in = num1[29];
#(PERIOD)data_in = num2[29];
#(PERIOD)data_in = num3[29];
#(PERIOD)data_in = num4[29];
#(PERIOD)valid_in = 1;data_in = num1[30];
#(PERIOD)data_in = num2[30];
#(PERIOD)data_in = num3[30];
#(PERIOD)data_in = num4[30];
#(PERIOD)valid_in = 1;data_in = num1[31];
#(PERIOD)data_in = num2[31];
#(PERIOD)data_in = num3[31];
#(PERIOD)data_in = num4[31];
#(PERIOD)valid_in = 1;data_in = num1[32];
#(PERIOD)data_in = num2[32];
#(PERIOD)data_in = num3[32];
#(PERIOD)data_in = num4[32];
#(PERIOD)valid_in = 1;data_in = num1[33];
#(PERIOD)data_in = num2[33];
#(PERIOD)data_in = num3[33];
#(PERIOD)data_in = num4[33];
#(PERIOD)valid_in = 1;data_in = num1[34];
#(PERIOD)data_in = num2[34];
#(PERIOD)data_in = num3[34];
#(PERIOD)data_in = num4[34];
#(PERIOD)valid_in = 1;data_in = num1[35];
#(PERIOD)data_in = num2[35];
#(PERIOD)data_in = num3[35];
#(PERIOD)data_in = num4[35];
#(PERIOD)valid_in = 1;data_in = num1[36];
#(PERIOD)data_in = num2[36];
#(PERIOD)data_in = num3[36];
#(PERIOD)data_in = num4[36];
#(PERIOD)valid_in = 1;data_in = num1[37];
#(PERIOD)data_in = num2[37];
#(PERIOD)data_in = num3[37];
#(PERIOD)data_in = num4[37];
#(PERIOD)valid_in = 1;data_in = num1[38];
#(PERIOD)data_in = num2[38];
#(PERIOD)data_in = num3[38];
#(PERIOD)data_in = num4[38];
#(PERIOD)valid_in = 1;data_in = num1[39];
#(PERIOD)data_in = num2[39];
#(PERIOD)data_in = num3[39];
#(PERIOD)data_in = num4[39];
#(PERIOD*2);


    $finish;
end

initial begin
num1[0] = 8'H30;
num2[0] = 8'H2B;
num3[0] = 8'HDA;
num4[0] = 8'H11;
result[0] = 10'H146;
num1[1] = 8'H96;
num2[1] = 8'H73;
num3[1] = 8'HD5;
num4[1] = 8'H8C;
result[1] = 10'H26A;
num1[2] = 8'H4E;
num2[2] = 8'HCF;
num3[2] = 8'H8D;
num4[2] = 8'H9F;
result[2] = 10'H249;
num1[3] = 8'H95;
num2[3] = 8'HF4;
num3[3] = 8'H3D;
num4[3] = 8'HA2;
result[3] = 10'H268;
num1[4] = 8'H01;
num2[4] = 8'HC7;
num3[4] = 8'HCF;
num4[4] = 8'H8D;
result[4] = 10'H224;
num1[5] = 8'HCD;
num2[5] = 8'HAE;
num3[5] = 8'H24;
num4[5] = 8'H6B;
result[5] = 10'H20A;
num1[6] = 8'HDB;
num2[6] = 8'H85;
num3[6] = 8'H5C;
num4[6] = 8'HB4;
result[6] = 10'H270;
num1[7] = 8'HF3;
num2[7] = 8'HCE;
num3[7] = 8'H0E;
num4[7] = 8'H96;
result[7] = 10'H265;
num1[8] = 8'H35;
num2[8] = 8'H9D;
num3[8] = 8'HBF;
num4[8] = 8'H1E;
result[8] = 10'H1AF;
num1[9] = 8'H30;
num2[9] = 8'H45;
num3[9] = 8'HA1;
num4[9] = 8'HC3;
result[9] = 10'H1D9;
num1[10] = 8'H63;
num2[10] = 8'H09;
num3[10] = 8'HBF;
num4[10] = 8'H7C;
result[10] = 10'H1A7;
num1[11] = 8'HC6;
num2[11] = 8'HE0;
num3[11] = 8'HB1;
num4[11] = 8'H6C;
result[11] = 10'H2C3;
num1[12] = 8'H96;
num2[12] = 8'HC4;
num3[12] = 8'H19;
num4[12] = 8'HA0;
result[12] = 10'H213;
num1[13] = 8'H19;
num2[13] = 8'H61;
num3[13] = 8'H8B;
num4[13] = 8'H10;
result[13] = 10'H115;
num1[14] = 8'H35;
num2[14] = 8'HD2;
num3[14] = 8'H3E;
num4[14] = 8'HD4;
result[14] = 10'H219;
num1[15] = 8'HD4;
num2[15] = 8'H44;
num3[15] = 8'HD0;
num4[15] = 8'H7B;
result[15] = 10'H263;
num1[16] = 8'H62;
num2[16] = 8'HE1;
num3[16] = 8'HDC;
num4[16] = 8'HAA;
result[16] = 10'H2C9;
num1[17] = 8'H1B;
num2[17] = 8'HAD;
num3[17] = 8'H97;
num4[17] = 8'HC2;
result[17] = 10'H221;
num1[18] = 8'HF9;
num2[18] = 8'H6A;
num3[18] = 8'H22;
num4[18] = 8'H5E;
result[18] = 10'H1E3;
num1[19] = 8'H8B;
num2[19] = 8'H1B;
num3[19] = 8'HD7;
num4[19] = 8'H70;
result[19] = 10'H1ED;
num1[20] = 8'H3C;
num2[20] = 8'HF3;
num3[20] = 8'H3A;
num4[20] = 8'H6F;
result[20] = 10'H1D8;
num1[21] = 8'H62;
num2[21] = 8'HEE;
num3[21] = 8'H83;
num4[21] = 8'H37;
result[21] = 10'H20A;
num1[22] = 8'H0A;
num2[22] = 8'H61;
num3[22] = 8'H66;
num4[22] = 8'HE0;
result[22] = 10'H1B1;
num1[23] = 8'HBD;
num2[23] = 8'H15;
num3[23] = 8'H67;
num4[23] = 8'HC2;
result[23] = 10'H1FB;
num1[24] = 8'HC2;
num2[24] = 8'H7E;
num3[24] = 8'HC2;
num4[24] = 8'H2E;
result[24] = 10'H230;
num1[25] = 8'H06;
num2[25] = 8'H1C;
num3[25] = 8'HFA;
num4[25] = 8'H5E;
result[25] = 10'H17A;
num1[26] = 8'H6A;
num2[26] = 8'H58;
num3[26] = 8'H25;
num4[26] = 8'H2A;
result[26] = 10'H111;
num1[27] = 8'H6E;
num2[27] = 8'HED;
num3[27] = 8'H81;
num4[27] = 8'H11;
result[27] = 10'H1ED;
num1[28] = 8'H90;
num2[28] = 8'H1D;
num3[28] = 8'HD3;
num4[28] = 8'HB7;
result[28] = 10'H237;
num1[29] = 8'HF5;
num2[29] = 8'H1A;
num3[29] = 8'H0E;
num4[29] = 8'HC8;
result[29] = 10'H1E5;
num1[30] = 8'H00;
num2[30] = 8'HAC;
num3[30] = 8'HA5;
num4[30] = 8'H72;
result[30] = 10'H1C3;
num1[31] = 8'H93;
num2[31] = 8'HA0;
num3[31] = 8'HA3;
num4[31] = 8'H94;
result[31] = 10'H26A;
num1[32] = 8'H55;
num2[32] = 8'H14;
num3[32] = 8'HA3;
num4[32] = 8'H81;
result[32] = 10'H18D;
num1[33] = 8'H1F;
num2[33] = 8'H2D;
num3[33] = 8'H61;
num4[33] = 8'HCD;
result[33] = 10'H17A;
num1[34] = 8'H7E;
num2[34] = 8'H0F;
num3[34] = 8'H88;
num4[34] = 8'HBD;
result[34] = 10'H1D2;
num1[35] = 8'HC6;
num2[35] = 8'H00;
num3[35] = 8'H37;
num4[35] = 8'HA3;
result[35] = 10'H1A0;
num1[36] = 8'H2F;
num2[36] = 8'H60;
num3[36] = 8'HB7;
num4[36] = 8'H98;
result[36] = 10'H1DE;
num1[37] = 8'H56;
num2[37] = 8'H73;
num3[37] = 8'HD9;
num4[37] = 8'HE2;
result[37] = 10'H284;
num1[38] = 8'H8F;
num2[38] = 8'HB7;
num3[38] = 8'H28;
num4[38] = 8'H2D;
result[38] = 10'H19B;
num1[39] = 8'H8E;
num2[39] = 8'HC1;
num3[39] = 8'H5F;
num4[39] = 8'H22;
result[39] = 10'H1D0;
    
end


endmodule
