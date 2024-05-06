`timescale 1ns/1ps
module tb();

reg [15:0] A;
reg [7:0] B;
wire [15:0] result;
wire [15:0] odd;

integer i; 
integer error = 0; 
reg [15:0] num_a[0:39];
reg [7:0] num_b[0:39];
reg [15:0] expected_result[0:39];
reg [15:0] expected_odd[0:39];

initial begin
   for (i = 0; i < 40; i = i + 1) begin
      A = num_a[i];
      B = num_b[i];

      #10; 
      error = (expected_odd[i] != odd || expected_result[i] != result) ? error+1 : error;
      // $display("A = %d, B = %d, Result = %d, odd = %d", A, B, result, odd);
      if(error!=0)begin
         $display("This is testbench input: A=16'H%h, B=8'H%h, expected_result=16'H%h, and expected_odd=16'H%h, but the actual result is result=16'H%h and odd=16'H%h; please fix the error",num_a[i],num_b[i],result[i],expected_odd[i],result,odd);
         $finish;
      end 

   end
   
   if (error == 0) begin
            $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Test completed with %d /40 failures===========", error);
    end
    
    $finish;
end

div_16bit uut (.A(A), .B(B), .result(result), .odd(odd));

initial begin
num_a[0] = 16'HF8E8;
num_b[0] = 8'HE2;
expected_result[0] = 16'H0119;
expected_odd[0] = 16'H00D6;
num_a[1] = 16'H2CD5;
num_b[1] = 8'H4B;
expected_result[1] = 16'H0099;
expected_odd[1] = 16'H0002;
num_a[2] = 16'H579F;
num_b[2] = 8'H28;
expected_result[2] = 16'H0230;
expected_odd[2] = 16'H001F;
num_a[3] = 16'H3397;
num_b[3] = 8'H02;
expected_result[3] = 16'H19CB;
expected_odd[3] = 16'H0001;
num_a[4] = 16'HD05F;
num_b[4] = 8'HA6;
expected_result[4] = 16'H0141;
expected_odd[4] = 16'H0039;
num_a[5] = 16'H4D39;
num_b[5] = 8'HEF;
expected_result[5] = 16'H0052;
expected_odd[5] = 16'H00AB;
num_a[6] = 16'H62B6;
num_b[6] = 8'H4D;
expected_result[6] = 16'H0148;
expected_odd[6] = 16'H000E;
num_a[7] = 16'H2439;
num_b[7] = 8'H87;
expected_result[7] = 16'H0044;
expected_odd[7] = 16'H005D;
num_a[8] = 16'H17D1;
num_b[8] = 8'H50;
expected_result[8] = 16'H004C;
expected_odd[8] = 16'H0011;
num_a[9] = 16'HA5EE;
num_b[9] = 8'H42;
expected_result[9] = 16'H0283;
expected_odd[9] = 16'H0028;
num_a[10] = 16'HD00F;
num_b[10] = 8'HD2;
expected_result[10] = 16'H00FD;
expected_odd[10] = 16'H0085;
num_a[11] = 16'HF396;
num_b[11] = 8'HBD;
expected_result[11] = 16'H0149;
expected_odd[11] = 16'H00B1;
num_a[12] = 16'H68A9;
num_b[12] = 8'HB8;
expected_result[12] = 16'H0091;
expected_odd[12] = 16'H0071;
num_a[13] = 16'H3E80;
num_b[13] = 8'H3A;
expected_result[13] = 16'H0113;
expected_odd[13] = 16'H0032;
num_a[14] = 16'H031A;
num_b[14] = 8'HDF;
expected_result[14] = 16'H0003;
expected_odd[14] = 16'H007D;
num_a[15] = 16'H82FB;
num_b[15] = 8'H6E;
expected_result[15] = 16'H0130;
expected_odd[15] = 16'H005B;
num_a[16] = 16'HC169;
num_b[16] = 8'HF4;
expected_result[16] = 16'H00CA;
expected_odd[16] = 16'H00E1;
num_a[17] = 16'H1E32;
num_b[17] = 8'H77;
expected_result[17] = 16'H0040;
expected_odd[17] = 16'H0072;
num_a[18] = 16'HE2AA;
num_b[18] = 8'H73;
expected_result[18] = 16'H01F8;
expected_odd[18] = 16'H0042;
num_a[19] = 16'H71DD;
num_b[19] = 8'HA0;
expected_result[19] = 16'H00B6;
expected_odd[19] = 16'H001D;
num_a[20] = 16'H43F1;
num_b[20] = 8'H53;
expected_result[20] = 16'H00D1;
expected_odd[20] = 16'H002E;
num_a[21] = 16'H4E8C;
num_b[21] = 8'H1E;
expected_result[21] = 16'H029E;
expected_odd[21] = 16'H0008;
num_a[22] = 16'H7ADD;
num_b[22] = 8'HA0;
expected_result[22] = 16'H00C4;
expected_odd[22] = 16'H005D;
num_a[23] = 16'HED76;
num_b[23] = 8'H16;
expected_result[23] = 16'H0ACB;
expected_odd[23] = 16'H0004;
num_a[24] = 16'HE70D;
num_b[24] = 8'H0C;
expected_result[24] = 16'H1341;
expected_odd[24] = 16'H0001;
num_a[25] = 16'H9314;
num_b[25] = 8'H6F;
expected_result[25] = 16'H0153;
expected_odd[25] = 16'H0017;
num_a[26] = 16'H1396;
num_b[26] = 8'H16;
expected_result[26] = 16'H00E3;
expected_odd[26] = 16'H0014;
num_a[27] = 16'H9963;
num_b[27] = 8'H61;
expected_result[27] = 16'H0194;
expected_odd[27] = 16'H004F;
num_a[28] = 16'HB328;
num_b[28] = 8'HD6;
expected_result[28] = 16'H00D6;
expected_odd[28] = 16'H0044;
num_a[29] = 16'H0E35;
num_b[29] = 8'H6F;
expected_result[29] = 16'H0020;
expected_odd[29] = 16'H0055;
num_a[30] = 16'H89C7;
num_b[30] = 8'HAE;
expected_result[30] = 16'H00CA;
expected_odd[30] = 16'H007B;
num_a[31] = 16'H2F83;
num_b[31] = 8'HC5;
expected_result[31] = 16'H003D;
expected_odd[31] = 16'H0092;
num_a[32] = 16'HBE10;
num_b[32] = 8'H7B;
expected_result[32] = 16'H018B;
expected_odd[32] = 16'H0047;
num_a[33] = 16'H8ABC;
num_b[33] = 8'H11;
expected_result[33] = 16'H0829;
expected_odd[33] = 16'H0003;
num_a[34] = 16'HF778;
num_b[34] = 8'H03;
expected_result[34] = 16'H527D;
expected_odd[34] = 16'H0001;
num_a[35] = 16'H7088;
num_b[35] = 8'H3C;
expected_result[35] = 16'H01E0;
expected_odd[35] = 16'H0008;
num_a[36] = 16'H8F07;
num_b[36] = 8'HDB;
expected_result[36] = 16'H00A7;
expected_odd[36] = 16'H002A;
num_a[37] = 16'HCD83;
num_b[37] = 8'HEB;
expected_result[37] = 16'H00DF;
expected_odd[37] = 16'H00CE;
num_a[38] = 16'HAC42;
num_b[38] = 8'H1F;
expected_result[38] = 16'H058E;
expected_odd[38] = 16'H0010;
num_a[39] = 16'H72DD;
num_b[39] = 8'H32;
expected_result[39] = 16'H024C;
expected_odd[39] = 16'H0005;

end

endmodule