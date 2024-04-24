`timescale 1ns / 1ps

module tb();

    reg [31:0] a;
    reg [31:0] b;
    reg [5:0] aluc;
    wire [31:0] r;
    wire zero;
    wire carry;
    wire negative;
    wire overflow;
    wire flag;
    reg[4:0]cnt;
    
    alu uut(a,b,aluc,r,zero,carry,negative,overflow,flag);

    parameter ADD = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND = 6'b100100;
    parameter OR = 6'b100101;
    parameter XOR = 6'b100110;
    parameter NOR = 6'b100111;
    parameter SLT = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL = 6'b000000;
    parameter SRL = 6'b000010;
    parameter SRA = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter JR = 6'b001000;
    parameter LUI = 6'b001111;

    reg[5:0]opcodes[0:31];
    reg[31:0]data[0:31];
    reg error=0;
    integer file_open;
    initial begin

    opcodes[0]=ADD;
    opcodes[1]=ADDU;
    opcodes[2]=SUB;
    opcodes[3]=SUBU;
    opcodes[4]=AND;
    opcodes[5]=OR;
    opcodes[6]=XOR;
    opcodes[7]=NOR;
    opcodes[8]=SLT;
    opcodes[9]=SLTU;
    opcodes[10]=SLL;
    opcodes[11]=SRL;
    opcodes[12]=SRA;
    opcodes[13]=SLLV;
    opcodes[14]=SRLV;
    opcodes[15]=SRAV;
    //opcodes[16]=JR;
    opcodes[16]=LUI;
    a=32'h0000001c;
    b=32'h00000021;
    #5;

    cnt = 0;

    
    for(cnt=0;cnt<17;cnt=cnt+1)
        begin
        #5;
        aluc=opcodes[cnt];
        #5;
        error=error|(data[cnt]!=r);
        if(error!=0)begin
            $display("This is testbench: a=32'h0000001c, b=32'h00000021, aluc=6'b%b, the expected result is 32'h%h, but the actual result is 32'h%h, please fix the error",aluc,data[cnt],r);
            $finish;
        end
    end

	if(error==0)
	begin
		$display("===========Your Design Passed===========");
        end
	else
	begin
		$display("===========Error===========");
	end
    $finish;
    end
    initial begin
data[0]=32'h0000003d;
data[1]=32'h0000003d;
data[2]=32'hfffffffb;
data[3]=32'hfffffffb;
data[4]=32'h00000000;
data[5]=32'h0000003d;
data[6]=32'h0000003d;
data[7]=32'hffffffc2;
data[8]=32'h00000001;
data[9]=32'h00000001;
data[10]=32'h10000000;
data[11]=32'h00000000;
data[12]=32'h00000000;
data[13]=32'h10000000;
data[14]=32'h00000000;
data[15]=32'h00000000;
data[16]=32'h001c0000;
    end
endmodule
