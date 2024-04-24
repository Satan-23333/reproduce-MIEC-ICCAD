`timescale 1ns/1ns

module tb();

parameter DATAWIDTH = 8;

reg  clk;
reg  rstn;       
reg  en;    
wire ready; 
wire vld_out;    
reg  [DATAWIDTH-1:0]    dividend; 
reg  [DATAWIDTH-1:0]    divisor;
wire [DATAWIDTH-1:0]    quotient;
wire [DATAWIDTH-1:0]    remainder;

radix2_div #(
    .DATAWIDTH                     ( DATAWIDTH  ))
     uut(
            .clk                   ( clk        ),
            .rstn                  ( rstn       ),
            .en                    ( en         ),
            .ready                 ( ready      ),
            .dividend              ( dividend   ),
            .divisor               ( divisor    ),
            .quotient              ( quotient   ),
            .remainder             ( remainder  ),
            .vld_out               ( vld_out    )
);

always #1 clk = ~clk;

integer i,cnt;
integer error = 0;

reg  [DATAWIDTH-1:0]    num_a[0:39]; 
reg  [DATAWIDTH-1:0]    num_b[0:39];
reg  [DATAWIDTH-1:0]    expected_result[0:39];
reg  [DATAWIDTH-1:0]    expected_odd[0:39];

initial begin
  clk = 1;
  rstn = 1;
  en = 0;
  #2 rstn = 0; 
  #2 rstn = 1;
  for(i=0; i<40; i=i+1) begin
    en = 1;
    dividend = num_a[i];
    divisor = num_b[i];
    #40;
  end

  if (error == 0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Test completed with %d /40failures===========", error);
    end
$finish;
end

always@(posedge vld_out)begin
  error = (quotient != expected_result[i]) || (remainder != expected_odd[i]) ? error + 1 : error;
  if(error!=0)begin
    $display("This is testbench: dividend=8'H%h, divisor=8'H%h, expected_quotient=8'H%h, expected_remainder=8'H%h; but the actual quotient=8'H%h, remainder=8'H%h. Please fix the error!",num_a[i],num_b[i],expected_result[i],expected_odd[i],quotient,remainder);
    $finish;
  end
end

initial begin
num_a[0] = 8'H1A;
num_b[0] = 8'H14;
expected_result[0] = 8'H01;
expected_odd[0] = 8'H06;
num_a[1] = 8'HA2;
num_b[1] = 8'H02;
expected_result[1] = 8'H51;
expected_odd[1] = 8'H00;
num_a[2] = 8'H71;
num_b[2] = 8'H10;
expected_result[2] = 8'H07;
expected_odd[2] = 8'H01;
num_a[3] = 8'H82;
num_b[3] = 8'H35;
expected_result[3] = 8'H02;
expected_odd[3] = 8'H18;
num_a[4] = 8'H86;
num_b[4] = 8'H4C;
expected_result[4] = 8'H01;
expected_odd[4] = 8'H3A;
num_a[5] = 8'HAC;
num_b[5] = 8'H84;
expected_result[5] = 8'H01;
expected_odd[5] = 8'H28;
num_a[6] = 8'H1F;
num_b[6] = 8'H03;
expected_result[6] = 8'H0A;
expected_odd[6] = 8'H01;
num_a[7] = 8'H88;
num_b[7] = 8'H19;
expected_result[7] = 8'H05;
expected_odd[7] = 8'H0B;
num_a[8] = 8'H70;
num_b[8] = 8'H01;
expected_result[8] = 8'H70;
expected_odd[8] = 8'H00;
num_a[9] = 8'HE0;
num_b[9] = 8'HA7;
expected_result[9] = 8'H01;
expected_odd[9] = 8'H39;
num_a[10] = 8'H7A;
num_b[10] = 8'H04;
expected_result[10] = 8'H1E;
expected_odd[10] = 8'H02;
num_a[11] = 8'HCA;
num_b[11] = 8'HC0;
expected_result[11] = 8'H01;
expected_odd[11] = 8'H0A;
num_a[12] = 8'HCA;
num_b[12] = 8'H58;
expected_result[12] = 8'H02;
expected_odd[12] = 8'H1A;
num_a[13] = 8'HAC;
num_b[13] = 8'H4E;
expected_result[13] = 8'H02;
expected_odd[13] = 8'H10;
num_a[14] = 8'H74;
num_b[14] = 8'H6E;
expected_result[14] = 8'H01;
expected_odd[14] = 8'H06;
num_a[15] = 8'H91;
num_b[15] = 8'H72;
expected_result[15] = 8'H01;
expected_odd[15] = 8'H1F;
num_a[16] = 8'H2D;
num_b[16] = 8'H28;
expected_result[16] = 8'H01;
expected_odd[16] = 8'H05;
num_a[17] = 8'HA5;
num_b[17] = 8'H47;
expected_result[17] = 8'H02;
expected_odd[17] = 8'H17;
num_a[18] = 8'H98;
num_b[18] = 8'H3F;
expected_result[18] = 8'H02;
expected_odd[18] = 8'H1A;
num_a[19] = 8'H75;
num_b[19] = 8'H47;
expected_result[19] = 8'H01;
expected_odd[19] = 8'H2E;
num_a[20] = 8'HE3;
num_b[20] = 8'HCF;
expected_result[20] = 8'H01;
expected_odd[20] = 8'H14;
num_a[21] = 8'H5E;
num_b[21] = 8'H4A;
expected_result[21] = 8'H01;
expected_odd[21] = 8'H14;
num_a[22] = 8'HCF;
num_b[22] = 8'H2A;
expected_result[22] = 8'H04;
expected_odd[22] = 8'H27;
num_a[23] = 8'HAA;
num_b[23] = 8'HA6;
expected_result[23] = 8'H01;
expected_odd[23] = 8'H04;
num_a[24] = 8'HF4;
num_b[24] = 8'H31;
expected_result[24] = 8'H04;
expected_odd[24] = 8'H30;
num_a[25] = 8'HE6;
num_b[25] = 8'H3D;
expected_result[25] = 8'H03;
expected_odd[25] = 8'H2F;
num_a[26] = 8'HA8;
num_b[26] = 8'H8D;
expected_result[26] = 8'H01;
expected_odd[26] = 8'H1B;
num_a[27] = 8'H9D;
num_b[27] = 8'H74;
expected_result[27] = 8'H01;
expected_odd[27] = 8'H29;
num_a[28] = 8'H5E;
num_b[28] = 8'H2F;
expected_result[28] = 8'H02;
expected_odd[28] = 8'H00;
num_a[29] = 8'HC2;
num_b[29] = 8'H0B;
expected_result[29] = 8'H11;
expected_odd[29] = 8'H07;
num_a[30] = 8'HCF;
num_b[30] = 8'H5B;
expected_result[30] = 8'H02;
expected_odd[30] = 8'H19;
num_a[31] = 8'H98;
num_b[31] = 8'H5D;
expected_result[31] = 8'H01;
expected_odd[31] = 8'H3B;
num_a[32] = 8'HEE;
num_b[32] = 8'HBD;
expected_result[32] = 8'H01;
expected_odd[32] = 8'H31;
num_a[33] = 8'H83;
num_b[33] = 8'H10;
expected_result[33] = 8'H08;
expected_odd[33] = 8'H03;
num_a[34] = 8'H7D;
num_b[34] = 8'H4F;
expected_result[34] = 8'H01;
expected_odd[34] = 8'H2E;
num_a[35] = 8'H69;
num_b[35] = 8'H1F;
expected_result[35] = 8'H03;
expected_odd[35] = 8'H0C;
num_a[36] = 8'H31;
num_b[36] = 8'H31;
expected_result[36] = 8'H01;
expected_odd[36] = 8'H00;
num_a[37] = 8'HC9;
num_b[37] = 8'H57;
expected_result[37] = 8'H02;
expected_odd[37] = 8'H1B;
num_a[38] = 8'H84;
num_b[38] = 8'H0C;
expected_result[38] = 8'H0B;
expected_odd[38] = 8'H00;
num_a[39] = 8'HA8;
num_b[39] = 8'H07;
expected_result[39] = 8'H18;
expected_odd[39] = 8'H00;
  
end

endmodule


