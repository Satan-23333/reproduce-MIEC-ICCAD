`timescale 1ns / 1ps

module tb;
  
  reg [7:0] a;
  reg [7:0] b;
  reg cin;
  wire [7:0] sum;
  wire cout;
  
  integer i; // Declare the loop variable here
  integer fail_count;
  integer error = 0;
  
  // Instantiate the module
  adder_8bit uut (
    .a(a), 
    .b(b), 
    .cin(cin), 
    .sum(sum), 
    .cout(cout)
  );
  reg [7:0]num_a[0:39];
  reg [7:0]num_b[0:39];
  reg num_cin[0:39];
  reg [8:0]result[0:39];
  
    initial begin
num_a[0] = 8'H95;
num_b[0] = 8'HE3;
num_cin[0] = 1'b1;
result[0] = 9'H179;
num_a[1] = 8'H96;
num_b[1] = 8'HC1;
num_cin[1] = 1'b1;
result[1] = 9'H158;
num_a[2] = 8'HB2;
num_b[2] = 8'H0C;
num_cin[2] = 1'b1;
result[2] = 9'H0BF;
num_a[3] = 8'H37;
num_b[3] = 8'HF6;
num_cin[3] = 1'b1;
result[3] = 9'H12E;
num_a[4] = 8'H49;
num_b[4] = 8'H95;
num_cin[4] = 1'b0;
result[4] = 9'H0DE;
num_a[5] = 8'H3B;
num_b[5] = 8'H38;
num_cin[5] = 1'b1;
result[5] = 9'H074;
num_a[6] = 8'HD7;
num_b[6] = 8'H98;
num_cin[6] = 1'b1;
result[6] = 9'H170;
num_a[7] = 8'HFE;
num_b[7] = 8'HA3;
num_cin[7] = 1'b1;
result[7] = 9'H1A2;
num_a[8] = 8'H1B;
num_b[8] = 8'H6D;
num_cin[8] = 1'b1;
result[8] = 9'H089;
num_a[9] = 8'H4F;
num_b[9] = 8'H9F;
num_cin[9] = 1'b0;
result[9] = 9'H0EE;
num_a[10] = 8'HA7;
num_b[10] = 8'H44;
num_cin[10] = 1'b0;
result[10] = 9'H0EB;
num_a[11] = 8'H1F;
num_b[11] = 8'H94;
num_cin[11] = 1'b0;
result[11] = 9'H0B3;
num_a[12] = 8'H12;
num_b[12] = 8'HD1;
num_cin[12] = 1'b1;
result[12] = 9'H0E4;
num_a[13] = 8'HDC;
num_b[13] = 8'H77;
num_cin[13] = 1'b1;
result[13] = 9'H154;
num_a[14] = 8'HEE;
num_b[14] = 8'HD7;
num_cin[14] = 1'b1;
result[14] = 9'H1C6;
num_a[15] = 8'HAB;
num_b[15] = 8'HA2;
num_cin[15] = 1'b1;
result[15] = 9'H14E;
num_a[16] = 8'HEF;
num_b[16] = 8'H2B;
num_cin[16] = 1'b0;
result[16] = 9'H11A;
num_a[17] = 8'HCF;
num_b[17] = 8'HE8;
num_cin[17] = 1'b1;
result[17] = 9'H1B8;
num_a[18] = 8'H71;
num_b[18] = 8'HA4;
num_cin[18] = 1'b0;
result[18] = 9'H115;
num_a[19] = 8'H42;
num_b[19] = 8'H2A;
num_cin[19] = 1'b1;
result[19] = 9'H06D;
num_a[20] = 8'HF6;
num_b[20] = 8'H0D;
num_cin[20] = 1'b0;
result[20] = 9'H103;
num_a[21] = 8'H8F;
num_b[21] = 8'H00;
num_cin[21] = 1'b1;
result[21] = 9'H090;
num_a[22] = 8'HBF;
num_b[22] = 8'HA8;
num_cin[22] = 1'b0;
result[22] = 9'H167;
num_a[23] = 8'HB7;
num_b[23] = 8'H68;
num_cin[23] = 1'b1;
result[23] = 9'H120;
num_a[24] = 8'H47;
num_b[24] = 8'H0E;
num_cin[24] = 1'b1;
result[24] = 9'H056;
num_a[25] = 8'H2D;
num_b[25] = 8'H4A;
num_cin[25] = 1'b0;
result[25] = 9'H077;
num_a[26] = 8'H29;
num_b[26] = 8'HD3;
num_cin[26] = 1'b1;
result[26] = 9'H0FD;
num_a[27] = 8'H75;
num_b[27] = 8'H64;
num_cin[27] = 1'b1;
result[27] = 9'H0DA;
num_a[28] = 8'H7C;
num_b[28] = 8'HB0;
num_cin[28] = 1'b1;
result[28] = 9'H12D;
num_a[29] = 8'HB0;
num_b[29] = 8'H9C;
num_cin[29] = 1'b1;
result[29] = 9'H14D;
num_a[30] = 8'HBD;
num_b[30] = 8'H4A;
num_cin[30] = 1'b1;
result[30] = 9'H108;
num_a[31] = 8'H1E;
num_b[31] = 8'HB1;
num_cin[31] = 1'b0;
result[31] = 9'H0CF;
num_a[32] = 8'HE5;
num_b[32] = 8'H37;
num_cin[32] = 1'b1;
result[32] = 9'H11D;
num_a[33] = 8'H3F;
num_b[33] = 8'H03;
num_cin[33] = 1'b1;
result[33] = 9'H043;
num_a[34] = 8'H05;
num_b[34] = 8'H84;
num_cin[34] = 1'b0;
result[34] = 9'H089;
num_a[35] = 8'H2F;
num_b[35] = 8'HD0;
num_cin[35] = 1'b1;
result[35] = 9'H100;
num_a[36] = 8'HB4;
num_b[36] = 8'H17;
num_cin[36] = 1'b0;
result[36] = 9'H0CB;
num_a[37] = 8'H44;
num_b[37] = 8'HC7;
num_cin[37] = 1'b0;
result[37] = 9'H10B;
num_a[38] = 8'H47;
num_b[38] = 8'HF6;
num_cin[38] = 1'b0;
result[38] = 9'H13D;
num_a[39] = 8'HD1;
num_b[39] = 8'HF0;
num_cin[39] = 1'b0;
result[39] = 9'H1C1;

    end


  // Randomize inputs and check output
  initial begin
    for (i = 0; i < 40; i = i + 1) begin
        a = num_a[i];
        b = num_b[i];
        cin = num_cin[i];
        #10;
        error = ({cout,sum} !== result[i]) ? error+1 : error; 
    end
    if (error == 0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
      $display("===========Test completed with %d /40failures===========", error);
    end

  end

endmodule