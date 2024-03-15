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
initial
begin
#(PERIOD*1+0.01);
#(PERIOD)valid_in = 1;data_in = 8'HFE;
#(PERIOD)data_in = 8'H62;
#(PERIOD)data_in = 8'H29;
#(PERIOD)data_in = 8'H8B;
result[0] = 10'H214;
#(PERIOD)valid_in = 1;data_in = 8'HBE;
#(PERIOD)data_in = 8'HAB;
#(PERIOD)data_in = 8'H84;
#(PERIOD)data_in = 8'H0E;
result[1] = 10'H1FB;
#(PERIOD)valid_in = 1;data_in = 8'H2E;
#(PERIOD)data_in = 8'H98;
#(PERIOD)data_in = 8'H56;
#(PERIOD)data_in = 8'H5F;
result[2] = 10'H17B;
#(PERIOD)valid_in = 1;data_in = 8'H67;
#(PERIOD)data_in = 8'H86;
#(PERIOD)data_in = 8'H49;
#(PERIOD)data_in = 8'H98;
result[3] = 10'H1CE;
#(PERIOD)valid_in = 1;data_in = 8'HBA;
#(PERIOD)data_in = 8'H78;
#(PERIOD)data_in = 8'H62;
#(PERIOD)data_in = 8'H9D;
result[4] = 10'H231;
#(PERIOD)valid_in = 1;data_in = 8'H79;
#(PERIOD)data_in = 8'H7C;
#(PERIOD)data_in = 8'HF8;
#(PERIOD)data_in = 8'H0C;
result[5] = 10'H1F9;
#(PERIOD)valid_in = 1;data_in = 8'H17;
#(PERIOD)data_in = 8'HDB;
#(PERIOD)data_in = 8'H83;
#(PERIOD)data_in = 8'H09;
result[6] = 10'H17E;
#(PERIOD)valid_in = 1;data_in = 8'H3E;
#(PERIOD)data_in = 8'HF9;
#(PERIOD)data_in = 8'HE2;
#(PERIOD)data_in = 8'H84;
result[7] = 10'H29D;
#(PERIOD)valid_in = 1;data_in = 8'HBB;
#(PERIOD)data_in = 8'HD6;
#(PERIOD)data_in = 8'H4D;
#(PERIOD)data_in = 8'H6A;
result[8] = 10'H248;
#(PERIOD)valid_in = 1;data_in = 8'HC3;
#(PERIOD)data_in = 8'H2A;
#(PERIOD)data_in = 8'HA5;
#(PERIOD)data_in = 8'H7D;
result[9] = 10'H20F;
#(PERIOD)valid_in = 1;data_in = 8'H69;
#(PERIOD)data_in = 8'H98;
#(PERIOD)data_in = 8'H46;
#(PERIOD)data_in = 8'H5A;
result[10] = 10'H1A1;
#(PERIOD)valid_in = 1;data_in = 8'HAA;
#(PERIOD)data_in = 8'HB8;
#(PERIOD)data_in = 8'HA9;
#(PERIOD)data_in = 8'H8B;
result[11] = 10'H296;
#(PERIOD)valid_in = 1;data_in = 8'HAD;
#(PERIOD)data_in = 8'H5B;
#(PERIOD)data_in = 8'H01;
#(PERIOD)data_in = 8'HD3;
result[12] = 10'H1DC;
#(PERIOD)valid_in = 1;data_in = 8'H6E;
#(PERIOD)data_in = 8'H51;
#(PERIOD)data_in = 8'H86;
#(PERIOD)data_in = 8'HD2;
result[13] = 10'H217;
#(PERIOD)valid_in = 1;data_in = 8'HC0;
#(PERIOD)data_in = 8'HA9;
#(PERIOD)data_in = 8'H91;
#(PERIOD)data_in = 8'H1B;
result[14] = 10'H215;
#(PERIOD)valid_in = 1;data_in = 8'H0F;
#(PERIOD)data_in = 8'H0C;
#(PERIOD)data_in = 8'HF5;
#(PERIOD)data_in = 8'HB4;
result[15] = 10'H1C4;
#(PERIOD)valid_in = 1;data_in = 8'H7D;
#(PERIOD)data_in = 8'H38;
#(PERIOD)data_in = 8'H51;
#(PERIOD)data_in = 8'H46;
result[16] = 10'H14C;
#(PERIOD)valid_in = 1;data_in = 8'HFB;
#(PERIOD)data_in = 8'H1D;
#(PERIOD)data_in = 8'HD8;
#(PERIOD)data_in = 8'H89;
result[17] = 10'H279;
#(PERIOD)valid_in = 1;data_in = 8'HE4;
#(PERIOD)data_in = 8'HDE;
#(PERIOD)data_in = 8'H5C;
#(PERIOD)data_in = 8'HAA;
result[18] = 10'H2C8;
#(PERIOD)valid_in = 1;data_in = 8'H30;
#(PERIOD)data_in = 8'H6F;
#(PERIOD)data_in = 8'H71;
#(PERIOD)data_in = 8'H8C;
result[19] = 10'H19C;
#(PERIOD)valid_in = 1;data_in = 8'H82;
#(PERIOD)data_in = 8'H12;
#(PERIOD)data_in = 8'H4D;
#(PERIOD)data_in = 8'H2F;
result[20] = 10'H110;
#(PERIOD)valid_in = 1;data_in = 8'H33;
#(PERIOD)data_in = 8'H93;
#(PERIOD)data_in = 8'HEE;
#(PERIOD)data_in = 8'HCA;
result[21] = 10'H27E;
#(PERIOD)valid_in = 1;data_in = 8'H09;
#(PERIOD)data_in = 8'HBE;
#(PERIOD)data_in = 8'HA9;
#(PERIOD)data_in = 8'HC9;
result[22] = 10'H239;
#(PERIOD)valid_in = 1;data_in = 8'HE6;
#(PERIOD)data_in = 8'H1D;
#(PERIOD)data_in = 8'HCF;
#(PERIOD)data_in = 8'HF6;
result[23] = 10'H2C8;
#(PERIOD)valid_in = 1;data_in = 8'HE7;
#(PERIOD)data_in = 8'H96;
#(PERIOD)data_in = 8'H1C;
#(PERIOD)data_in = 8'HA3;
result[24] = 10'H23C;
#(PERIOD)valid_in = 1;data_in = 8'H5C;
#(PERIOD)data_in = 8'HB4;
#(PERIOD)data_in = 8'HF3;
#(PERIOD)data_in = 8'H28;
result[25] = 10'H22B;
#(PERIOD)valid_in = 1;data_in = 8'HEF;
#(PERIOD)data_in = 8'H63;
#(PERIOD)data_in = 8'HC9;
#(PERIOD)data_in = 8'H54;
result[26] = 10'H26F;
#(PERIOD)valid_in = 1;data_in = 8'H65;
#(PERIOD)data_in = 8'HD3;
#(PERIOD)data_in = 8'HB3;
#(PERIOD)data_in = 8'H4A;
result[27] = 10'H235;
#(PERIOD)valid_in = 1;data_in = 8'H9D;
#(PERIOD)data_in = 8'H1B;
#(PERIOD)data_in = 8'HA1;
#(PERIOD)data_in = 8'HB3;
result[28] = 10'H20C;
#(PERIOD)valid_in = 1;data_in = 8'HBE;
#(PERIOD)data_in = 8'HA6;
#(PERIOD)data_in = 8'H53;
#(PERIOD)data_in = 8'HD5;
result[29] = 10'H28C;
#(PERIOD)valid_in = 1;data_in = 8'HFD;
#(PERIOD)data_in = 8'H99;
#(PERIOD)data_in = 8'H71;
#(PERIOD)data_in = 8'H66;
result[30] = 10'H26D;
#(PERIOD)valid_in = 1;data_in = 8'H9E;
#(PERIOD)data_in = 8'HA6;
#(PERIOD)data_in = 8'HCF;
#(PERIOD)data_in = 8'H03;
result[31] = 10'H216;
#(PERIOD)valid_in = 1;data_in = 8'H6F;
#(PERIOD)data_in = 8'HB3;
#(PERIOD)data_in = 8'H23;
#(PERIOD)data_in = 8'H92;
result[32] = 10'H1D7;
#(PERIOD)valid_in = 1;data_in = 8'H32;
#(PERIOD)data_in = 8'H95;
#(PERIOD)data_in = 8'HF5;
#(PERIOD)data_in = 8'HFE;
result[33] = 10'H2BA;
#(PERIOD)valid_in = 1;data_in = 8'HA1;
#(PERIOD)data_in = 8'HD5;
#(PERIOD)data_in = 8'HCD;
#(PERIOD)data_in = 8'H12;
result[34] = 10'H255;
#(PERIOD)valid_in = 1;data_in = 8'HCC;
#(PERIOD)data_in = 8'H4E;
#(PERIOD)data_in = 8'HD4;
#(PERIOD)data_in = 8'HB5;
result[35] = 10'H2A3;
#(PERIOD)valid_in = 1;data_in = 8'HC1;
#(PERIOD)data_in = 8'H3F;
#(PERIOD)data_in = 8'HE1;
#(PERIOD)data_in = 8'HBB;
result[36] = 10'H29C;
#(PERIOD)valid_in = 1;data_in = 8'HEF;
#(PERIOD)data_in = 8'H39;
#(PERIOD)data_in = 8'H4C;
#(PERIOD)data_in = 8'H5D;
result[37] = 10'H1D1;
#(PERIOD)valid_in = 1;data_in = 8'HF4;
#(PERIOD)data_in = 8'H68;
#(PERIOD)data_in = 8'H4E;
#(PERIOD)data_in = 8'HBF;
result[38] = 10'H269;
#(PERIOD)valid_in = 1;data_in = 8'H8F;
#(PERIOD)data_in = 8'H29;
#(PERIOD)data_in = 8'HD6;
#(PERIOD)data_in = 8'HD2;
result[39] = 10'H260;
#(PERIOD*2);

    $finish;
end

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


endmodule
