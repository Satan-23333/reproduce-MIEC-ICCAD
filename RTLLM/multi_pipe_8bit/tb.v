`timescale 1ns/1ns
`define clk_period 20
module tb_multi_pipe();
 
     reg [7:0] mul_a;
     reg [7:0] mul_b;
     reg mul_en_in;
 
     reg clk;
     reg rst_n;
 
     wire mul_en_out;
     wire [15:0] mul_out;

 
 verified_multi_pipe_8bit u1(
          .clk(clk),      
          .rst_n(rst_n),       
          .mul_a(mul_a),       
          .mul_b(mul_b),
          .mul_en_in(mul_en_in),       
           
          .mul_en_out(mul_en_out),
          .mul_out(mul_out)    
);
 
 
 
initial clk = 1;
always # 10 clk = ~clk; 
integer error = 0;
integer i; 


reg [7:0]num_a[0:39];
reg [7:0]num_b[0:39];
reg [15:0]result[0:39];
 
initial begin
     rst_n = 0;
     mul_a = 0;
     mul_b = 0;
     mul_en_in = 0;
 
     #(`clk_period*200+1);
 
     rst_n = 1;
     
     #(`clk_period*10);
 
     mul_a = 'd35;
     mul_b = 'd20;
     mul_en_in = 'd1;
     for (i = 0; i < 40; i = i + 1) begin
          mul_en_in = 0;
          #(`clk_period*20);
          rst_n = 1;
          #(`clk_period*10);
          mul_a = num_a[i];
          mul_b = num_b[i];

          mul_en_in = 'd1;
          #(`clk_period);

          #(`clk_period);
          error = ((mul_en_out==1) && (mul_out == result[i])) ? error+1 : error;
          while (mul_en_out == 0) begin
                @(posedge clk); // Wait for one clock cycle
          end
          // //========it can be changed depending on your pipelining processing latency
          // #(`clk_period*4);
          // //========it can be changed depending on your pipelining processing latency
          error = (mul_out !=  result[i]) ? error+1 : error;
          // $display("mul_a = %d, mul_b = %d, mul_out = %d, expected = %d", mul_a, mul_b, mul_out, expected_product);
     end

     if (error == 0) begin
            $display("===========Your Design Passed===========");
     end
     else begin
     $display("===========Test completed with %d /100 failures===========", error);
     end
    
     $finish; 
   
end

initial begin
num_a[0] = 8'H69;
num_b[0] = 8'H5E;
result[0] = 16'H268E;
num_a[1] = 8'H85;
num_b[1] = 8'H9E;
result[1] = 16'H5216;
num_a[2] = 8'H10;
num_b[2] = 8'H58;
result[2] = 16'H0580;
num_a[3] = 8'H74;
num_b[3] = 8'H6F;
result[3] = 16'H324C;
num_a[4] = 8'HF7;
num_b[4] = 8'HAA;
result[4] = 16'HA406;
num_a[5] = 8'H61;
num_b[5] = 8'H57;
result[5] = 16'H20F7;
num_a[6] = 8'H3F;
num_b[6] = 8'H51;
result[6] = 16'H13EF;
num_a[7] = 8'H36;
num_b[7] = 8'H64;
result[7] = 16'H1518;
num_a[8] = 8'H21;
num_b[8] = 8'H12;
result[8] = 16'H0252;
num_a[9] = 8'H13;
num_b[9] = 8'HA7;
result[9] = 16'H0C65;
num_a[10] = 8'HE4;
num_b[10] = 8'H18;
result[10] = 16'H1560;
num_a[11] = 8'H1E;
num_b[11] = 8'H67;
result[11] = 16'H0C12;
num_a[12] = 8'H2B;
num_b[12] = 8'HB5;
result[12] = 16'H1E67;
num_a[13] = 8'H95;
num_b[13] = 8'H46;
result[13] = 16'H28BE;
num_a[14] = 8'H23;
num_b[14] = 8'HC5;
result[14] = 16'H1AEF;
num_a[15] = 8'H92;
num_b[15] = 8'H91;
result[15] = 16'H52B2;
num_a[16] = 8'H3B;
num_b[16] = 8'HC8;
result[16] = 16'H2E18;
num_a[17] = 8'H4A;
num_b[17] = 8'HE7;
result[17] = 16'H42C6;
num_a[18] = 8'H59;
num_b[18] = 8'H63;
result[18] = 16'H226B;
num_a[19] = 8'HE7;
num_b[19] = 8'H31;
result[19] = 16'H2C37;
num_a[20] = 8'H75;
num_b[20] = 8'H46;
result[20] = 16'H1FFE;
num_a[21] = 8'H33;
num_b[21] = 8'HFA;
result[21] = 16'H31CE;
num_a[22] = 8'HA7;
num_b[22] = 8'H03;
result[22] = 16'H01F5;
num_a[23] = 8'H64;
num_b[23] = 8'H88;
result[23] = 16'H3520;
num_a[24] = 8'H88;
num_b[24] = 8'H19;
result[24] = 16'H0D48;
num_a[25] = 8'HEA;
num_b[25] = 8'H71;
result[25] = 16'H674A;
num_a[26] = 8'HDF;
num_b[26] = 8'H7A;
result[26] = 16'H6A46;
num_a[27] = 8'HF1;
num_b[27] = 8'HAF;
result[27] = 16'HA4BF;
num_a[28] = 8'H42;
num_b[28] = 8'HCF;
result[28] = 16'H355E;
num_a[29] = 8'H31;
num_b[29] = 8'HBB;
result[29] = 16'H23CB;
num_a[30] = 8'HBC;
num_b[30] = 8'HBD;
result[30] = 16'H8ACC;
num_a[31] = 8'HDC;
num_b[31] = 8'H36;
result[31] = 16'H2E68;
num_a[32] = 8'H5C;
num_b[32] = 8'H8C;
result[32] = 16'H3250;
num_a[33] = 8'HE6;
num_b[33] = 8'H1D;
result[33] = 16'H1A0E;
num_a[34] = 8'H91;
num_b[34] = 8'HAD;
result[34] = 16'H61FD;
num_a[35] = 8'HEC;
num_b[35] = 8'H15;
result[35] = 16'H135C;
num_a[36] = 8'HE9;
num_b[36] = 8'H6C;
result[36] = 16'H624C;
num_a[37] = 8'H93;
num_b[37] = 8'H50;
result[37] = 16'H2DF0;
num_a[38] = 8'H78;
num_b[38] = 8'HEE;
result[38] = 16'H6F90;
num_a[39] = 8'H2A;
num_b[39] = 8'H40;
result[39] = 16'H0A80;
     
end
 
endmodule 