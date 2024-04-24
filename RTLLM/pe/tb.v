`timescale 1ns / 1ps

module test54();

    reg clk;
    reg rst;
    reg [31:0] a,b;
    wire [31:0] c;
    
    verified_pe dut(clk,rst,a,b,c);

    integer i;
    integer error=0;
    reg [31:0]num_a[0:39];
    reg [31:0]num_b[0:39];
    reg [31:0]result[0:39];


    initial begin

    a=0;
    b=0;
    clk=0;
    rst=1;
    #5;
    clk=1;
    #5;
    clk=0;
    rst=0;
    #5;
    for(i=0;i<40;i=i+1)begin
        a=num_a[i];
        b=num_b[i];
        #5;
        clk=1;
        #5;
        clk=0;
        error=(c==result[i])?error:error+1;
    end
    

    //$display("%h", c);

	if(error==0)
	begin
		$display("===========Your Design Passed===========");
        end
	else
	begin
		$display("===========Error===========");
	end
    end

initial begin
num_a[0] = 32'H7E03B4E9;
num_b[0] = 32'H051AC9D7;
result[0] = 32'HAAD1E0AF;
num_a[1] = 32'H28326024;
num_b[1] = 32'H0CDA633D;
result[1] = 32'H48A8B543;
num_a[2] = 32'H1B903C07;
num_b[2] = 32'H5F8E008F;
result[2] = 32'H931C3D2C;
num_a[3] = 32'H4E3972B1;
num_b[3] = 32'HB608E197;
result[3] = 32'HA0547493;
num_a[4] = 32'H5024F69C;
num_b[4] = 32'H4738CCAE;
result[4] = 32'HC418629B;
num_a[5] = 32'HC7FC58BA;
num_b[5] = 32'H60DEF208;
result[5] = 32'H4126FC6B;
num_a[6] = 32'H4121093A;
num_b[6] = 32'H416BC2B4;
result[6] = 32'HAA9D6D33;
num_a[7] = 32'HA5ECB2E2;
num_b[7] = 32'H39EB0A86;
result[7] = 32'H4AF5E37F;
num_a[8] = 32'HD4764B4E;
num_b[8] = 32'H8680ABF6;
result[8] = 32'HF3EF5A73;
num_a[9] = 32'H3AA7A5DD;
num_b[9] = 32'HFAF9BD87;
result[9] = 32'HCDC0FAFE;
num_a[10] = 32'HB05B4BB9;
num_b[10] = 32'H8433AE50;
result[10] = 32'H719B62CE;
num_a[11] = 32'H4D1C3F28;
num_b[11] = 32'H54CBDA35;
result[11] = 32'HAAF48616;
num_a[12] = 32'H2A5E25F0;
num_b[12] = 32'H1AA82FD6;
result[12] = 32'HA41F4CB6;
num_a[13] = 32'H8B7BA8FA;
num_b[13] = 32'H9D664FD5;
result[13] = 32'H80C40AB8;
num_a[14] = 32'H3D7DD2ED;
num_b[14] = 32'HA04B4DF6;
result[14] = 32'H5B8D0376;
num_a[15] = 32'H0C40BD9D;
num_b[15] = 32'HA95500EA;
result[15] = 32'H28DB54F8;
num_a[16] = 32'HD6B2E2FB;
num_b[16] = 32'H2E21E867;
result[16] = 32'H04E31FF5;
num_a[17] = 32'H32DCF48B;
num_b[17] = 32'H85CD1A99;
result[17] = 32'HE6166508;
num_a[18] = 32'H5FCD7414;
num_b[18] = 32'H932199D6;
result[18] = 32'H38C961C0;
num_a[19] = 32'H8BE66474;
num_b[19] = 32'HE3AB4748;
result[19] = 32'H6CEDCE60;
num_a[20] = 32'HAA72E92D;
num_b[20] = 32'H63B52712;
result[20] = 32'H2E590E8A;
num_a[21] = 32'H6455A7C8;
num_b[21] = 32'H9AD95AB5;
result[21] = 32'HC46CFEF2;
num_a[22] = 32'H3CB2C201;
num_b[22] = 32'H4C6AE260;
result[22] = 32'HF724A152;
num_a[23] = 32'HB0EC8B03;
num_b[23] = 32'HB53D9240;
result[23] = 32'H58461812;
num_a[24] = 32'HBC50136B;
num_b[24] = 32'HFE5749C4;
result[24] = 32'H1E7B78FE;
num_a[25] = 32'H6A5E0136;
num_b[25] = 32'H52010B4B;
result[25] = 32'H9F4925D0;
num_a[26] = 32'H01BE9A45;
num_b[26] = 32'H9CB6CA58;
result[26] = 32'H57969F88;
num_a[27] = 32'HAC292FBC;
num_b[27] = 32'HC11D2C86;
result[27] = 32'HADA5EBF0;
num_a[28] = 32'HC2004474;
num_b[28] = 32'H48DF7E85;
result[28] = 32'HDA869434;
num_a[29] = 32'HF348332F;
num_b[29] = 32'HCA9EC63A;
result[29] = 32'H7D7A86DA;
num_a[30] = 32'HD514C03C;
num_b[30] = 32'HBDF4C9D7;
result[30] = 32'H4207153E;
num_a[31] = 32'H1AA2D44D;
num_b[31] = 32'H07E2E7F9;
result[31] = 32'H9EF30F23;
num_a[32] = 32'H6F29985D;
num_b[32] = 32'H34B3544F;
result[32] = 32'HFFCE97D6;
num_a[33] = 32'H4F54B855;
num_b[33] = 32'H604748EA;
result[33] = 32'H56A9FD88;
num_a[34] = 32'H452C7185;
num_b[34] = 32'HFCCDFB9D;
result[34] = 32'H29BA0319;
num_a[35] = 32'HDDD68425;
num_b[35] = 32'H1C46303D;
result[35] = 32'H6CBC6FEA;
num_a[36] = 32'H81562719;
num_b[36] = 32'H851A3DCE;
result[36] = 32'HFCEADB08;
num_a[37] = 32'H947DF48A;
num_b[37] = 32'H5425ED5F;
result[37] = 32'H52FE5C3E;
num_a[38] = 32'HBD239553;
num_b[38] = 32'HA3524CF6;
result[38] = 32'H511A7E00;
num_a[39] = 32'H627521E4;
num_b[39] = 32'H06686E19;
result[39] = 32'H5FBAC544;


end
endmodule
