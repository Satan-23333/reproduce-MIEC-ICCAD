`timescale 1ns/1ns
module tb();
    reg rst,valid_in;
	reg clk=1;
	reg[7:0] data_in;
	wire valid_out;
	wire [15:0] data_out;

width_8to16 uut(
	.clk (clk),   
	.rst_n(rst),
	.valid_in(valid_in),
	.data_in(data_in),
	.valid_out(valid_out),
	.data_out(data_out)
);
	always #5 clk = ~clk;  
integer i;
integer error = 0;
reg [7:0]num_a[0:39];
reg [7:0]num_b[0:39];
reg [15:0]result[0:39];
initial 
begin
	rst=0;valid_in=0;
 	#10 rst=1;
	
	for(i=0;i<40;i=i+1)begin
		#10 valid_in=1;data_in=num_a[i];
		#10 valid_in=0;
		#10 valid_in=1;data_in=num_b[i];
		#10 valid_in=0;
		error = (data_out == result[i] && valid_out ==1 )? error : error+1;
		if(error!=0)begin
            $display("This is testbench input: data_in_1=8'H%h, data_in_2=8'H%h, and expected_result=16'H%h, but the result is data_out=16'H%h; please fix the error",num_a[i],num_b[i],result[i],data_out);
            $finish;
        end 
	end
	

	if (error == 0) begin
		$display("===========Your Design Passed===========");
	end
	else begin
	$display("===========Test completed with %d / 40 failures===========", error);
	end

	$finish;
end  

initial begin
num_a[0] = 8'H2D;
num_b[0] = 8'H61;
result[0] = 16'H2D61;
num_a[1] = 8'HDA;
num_b[1] = 8'H16;
result[1] = 16'HDA16;
num_a[2] = 8'H5A;
num_b[2] = 8'HDB;
result[2] = 16'H5ADB;
num_a[3] = 8'H68;
num_b[3] = 8'H77;
result[3] = 16'H6877;
num_a[4] = 8'HF7;
num_b[4] = 8'HD5;
result[4] = 16'HF7D5;
num_a[5] = 8'HA0;
num_b[5] = 8'H4C;
result[5] = 16'HA04C;
num_a[6] = 8'H6B;
num_b[6] = 8'HAB;
result[6] = 16'H6BAB;
num_a[7] = 8'HDE;
num_b[7] = 8'H65;
result[7] = 16'HDE65;
num_a[8] = 8'HC1;
num_b[8] = 8'HF5;
result[8] = 16'HC1F5;
num_a[9] = 8'H35;
num_b[9] = 8'HC3;
result[9] = 16'H35C3;
num_a[10] = 8'HB1;
num_b[10] = 8'H40;
result[10] = 16'HB140;
num_a[11] = 8'HEA;
num_b[11] = 8'H56;
result[11] = 16'HEA56;
num_a[12] = 8'H4C;
num_b[12] = 8'H56;
result[12] = 16'H4C56;
num_a[13] = 8'HF0;
num_b[13] = 8'HC9;
result[13] = 16'HF0C9;
num_a[14] = 8'H6C;
num_b[14] = 8'H76;
result[14] = 16'H6C76;
num_a[15] = 8'HC4;
num_b[15] = 8'HF4;
result[15] = 16'HC4F4;
num_a[16] = 8'H8F;
num_b[16] = 8'HA8;
result[16] = 16'H8FA8;
num_a[17] = 8'H90;
num_b[17] = 8'H61;
result[17] = 16'H9061;
num_a[18] = 8'H60;
num_b[18] = 8'H7E;
result[18] = 16'H607E;
num_a[19] = 8'HC2;
num_b[19] = 8'H1B;
result[19] = 16'HC21B;
num_a[20] = 8'HC9;
num_b[20] = 8'HC0;
result[20] = 16'HC9C0;
num_a[21] = 8'HB5;
num_b[21] = 8'H62;
result[21] = 16'HB562;
num_a[22] = 8'H44;
num_b[22] = 8'H0C;
result[22] = 16'H440C;
num_a[23] = 8'H3E;
num_b[23] = 8'H81;
result[23] = 16'H3E81;
num_a[24] = 8'H9A;
num_b[24] = 8'HA1;
result[24] = 16'H9AA1;
num_a[25] = 8'HBD;
num_b[25] = 8'H65;
result[25] = 16'HBD65;
num_a[26] = 8'H4E;
num_b[26] = 8'HD6;
result[26] = 16'H4ED6;
num_a[27] = 8'H25;
num_b[27] = 8'HC9;
result[27] = 16'H25C9;
num_a[28] = 8'H09;
num_b[28] = 8'HA6;
result[28] = 16'H09A6;
num_a[29] = 8'H51;
num_b[29] = 8'HE4;
result[29] = 16'H51E4;
num_a[30] = 8'H13;
num_b[30] = 8'H5C;
result[30] = 16'H135C;
num_a[31] = 8'H40;
num_b[31] = 8'HBA;
result[31] = 16'H40BA;
num_a[32] = 8'H03;
num_b[32] = 8'HD5;
result[32] = 16'H03D5;
num_a[33] = 8'H32;
num_b[33] = 8'H58;
result[33] = 16'H3258;
num_a[34] = 8'H2E;
num_b[34] = 8'H9C;
result[34] = 16'H2E9C;
num_a[35] = 8'H5C;
num_b[35] = 8'H48;
result[35] = 16'H5C48;
num_a[36] = 8'H3F;
num_b[36] = 8'H3C;
result[36] = 16'H3F3C;
num_a[37] = 8'H45;
num_b[37] = 8'H91;
result[37] = 16'H4591;
num_a[38] = 8'HD1;
num_b[38] = 8'HE2;
result[38] = 16'HD1E2;
num_a[39] = 8'HC3;
num_b[39] = 8'H0A;
result[39] = 16'HC30A;

end

endmodule