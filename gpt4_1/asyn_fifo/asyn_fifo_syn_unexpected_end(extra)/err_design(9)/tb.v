`timescale 1ns/1ns

module tb;

  reg wclk, rclk, wrstn, rrstn, winc, rinc;
  reg [7:0] wdata;
  wire wfull, rempty;
  wire [7:0] rdata;
  
  asyn_fifo #(.WIDTH(8), .DEPTH(16)) uut (
    .wclk(wclk),
    .rclk(rclk),
    .wrstn(wrstn),
    .rrstn(rrstn),
    .winc(winc),
    .rinc(rinc),
    .wdata(wdata),
    .wfull(wfull),
    .rempty(rempty),
    .rdata(rdata)
  );
  
  always #5 wclk = ~wclk;
  always #10 rclk = ~rclk;
  
  initial begin
    wclk = 0;
    rclk = 0;
    wrstn = 0;
    rrstn = 0;
    winc = 0;
    rinc = 0;
    wdata = 0;
  end

  // Apply reset and initialize FIFO
  initial begin
    wrstn = 0;
    rrstn = 0;
    #20;
    wrstn = 1;
    rrstn = 1;
    #10;
    winc = 1; // Enable write
    wdata = 8'hAA; // Write data
    #10;
    winc = 0; // Disable write
    #500;
    rinc = 1;
    #500;
    #10;
    $finish;
  end

  reg[31:0]data1[0:50];
  reg[31:0]data2[0:50];
  reg[7:0]data3[0:50];
  integer i = 0;
  integer error =0;

  initial begin
    #550;
    // outfile1 = $fopen("wfull.txt", "w");
    // outfile2 = $fopen("rempty.txt", "w");
    // outfile3 = $fopen("tdata.txt", "w");
    for(i=0;i<48;i=i+1) begin
      #10;
      // $fwrite(outfile1, "%h\n", wfull);
      // $fwrite(outfile2, "%h\n", rempty);
      // $fwrite(outfile3, "%h\n", rdata);
      error = (wfull==data1[i] && rempty == data2[i] && rdata ==data3[i]) ? error:error+1;
      if(error!==0)begin
        $display("This is testbench: expected result is wfull=32'H%h, rempty=32'H%h, rdata=8'H%h, but the actual result is wfull=32'H%h, rempty=32'H%h, rdata=8'H%h; please fix the error",data1[i],data2[i],data3[i],wfull,rempty,rdata);
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

    // $fclose(outfile1);
    // $fclose(outfile2);
    // $fclose(outfile3);
  end
  // Display FIFO status
  // always @(posedge wclk) begin
  //   $display("wfull=%d, rempty=%d, rdata=%h", wfull, rempty, rdata);
  // end

  initial begin
  repeat (17) begin
    #20;
    if (wfull) begin
      // $display("FIFO is full (wfull=1) at depth %d", $time);
    end
    winc = 1; // Enable write
    wdata = wdata + 1; // Write data
    #10;
    winc = 0; // Disable write
  end
  end
  initial begin
data1[0] = 1;
data1[1] = 1;
data1[2] = 1;
data1[3] = 0;
data1[4] = 0;
data1[5] = 0;
data1[6] = 0;
data1[7] = 0;
data1[8] = 0;
data1[9] = 0;
data1[10] = 0;
data1[11] = 0;
data1[12] = 0;
data1[13] = 0;
data1[14] = 0;
data1[15] = 0;
data1[16] = 0;
data1[17] = 0;
data1[18] = 0;
data1[19] = 0;
data1[20] = 0;
data1[21] = 0;
data1[22] = 0;
data1[23] = 0;
data1[24] = 0;
data1[25] = 0;
data1[26] = 0;
data1[27] = 0;
data1[28] = 0;
data1[29] = 0;
data1[30] = 0;
data1[31] = 0;
data1[32] = 0;
data1[33] = 0;
data1[34] = 0;
data1[35] = 0;
data1[36] = 0;
data1[37] = 0;
data1[38] = 0;
data1[39] = 0;
data1[40] = 0;
data1[41] = 0;
data1[42] = 0;
data1[43] = 0;
data1[44] = 0;
data1[45] = 0;
data1[46] = 0;
data1[47] = 0;
data1[0] = 1;
data1[1] = 1;
data1[2] = 1;
data1[3] = 0;
data1[4] = 0;
data1[5] = 0;
data1[6] = 0;
data1[7] = 0;
data1[8] = 0;
data1[9] = 0;
data1[10] = 0;
data1[11] = 0;
data1[12] = 0;
data1[13] = 0;
data1[14] = 0;
data1[15] = 0;
data1[16] = 0;
data1[17] = 0;
data1[18] = 0;
data1[19] = 0;
data1[20] = 0;
data1[21] = 0;
data1[22] = 0;
data1[23] = 0;
data1[24] = 0;
data1[25] = 0;
data1[26] = 0;
data1[27] = 0;
data1[28] = 0;
data1[29] = 0;
data1[30] = 0;
data1[31] = 0;
data1[32] = 0;
data1[33] = 0;
data1[34] = 0;
data1[35] = 0;
data1[36] = 0;
data1[37] = 0;
data1[38] = 0;
data1[39] = 0;
data1[40] = 0;
data1[41] = 0;
data1[42] = 0;
data1[43] = 0;
data1[44] = 0;
data1[45] = 0;
data1[46] = 0;
data1[47] = 0;
data2[0] = 0;
data2[1] = 0;
data2[2] = 0;
data2[3] = 0;
data2[4] = 0;
data2[5] = 0;
data2[6] = 0;
data2[7] = 0;
data2[8] = 0;
data2[9] = 0;
data2[10] = 0;
data2[11] = 0;
data2[12] = 0;
data2[13] = 0;
data2[14] = 0;
data2[15] = 0;
data2[16] = 0;
data2[17] = 0;
data2[18] = 0;
data2[19] = 0;
data2[20] = 0;
data2[21] = 0;
data2[22] = 0;
data2[23] = 0;
data2[24] = 0;
data2[25] = 0;
data2[26] = 0;
data2[27] = 0;
data2[28] = 0;
data2[29] = 0;
data2[30] = 0;
data2[31] = 0;
data2[32] = 1;
data2[33] = 1;
data2[34] = 0;
data2[35] = 0;
data2[36] = 0;
data2[37] = 0;
data2[38] = 0;
data2[39] = 0;
data2[40] = 0;
data2[41] = 0;
data2[42] = 0;
data2[43] = 0;
data2[44] = 0;
data2[45] = 0;
data2[46] = 0;
data2[47] = 0;
data3[0]=8'h01;
data3[1]=8'h01;
data3[2]=8'hab;
data3[3]=8'hab;
data3[4]=8'hac;
data3[5]=8'hac;
data3[6]=8'had;
data3[7]=8'had;
data3[8]=8'hae;
data3[9]=8'hae;
data3[10]=8'haf;
data3[11]=8'haf;
data3[12]=8'hb0;
data3[13]=8'hb0;
data3[14]=8'hb1;
data3[15]=8'hb1;
data3[16]=8'hb2;
data3[17]=8'hb2;
data3[18]=8'hb3;
data3[19]=8'hb3;
data3[20]=8'hb4;
data3[21]=8'hb4;
data3[22]=8'hb5;
data3[23]=8'hb5;
data3[24]=8'hb6;
data3[25]=8'hb6;
data3[26]=8'hb7;
data3[27]=8'hb7;
data3[28]=8'hb8;
data3[29]=8'hb8;
data3[30]=8'hb9;
data3[31]=8'hb9;
data3[32]=8'h01;
data3[33]=8'h01;
data3[34]=8'h01;
data3[35]=8'h01;
data3[36]=8'hab;
data3[37]=8'hab;
data3[38]=8'hac;
data3[39]=8'hac;
data3[40]=8'had;
data3[41]=8'had;
data3[42]=8'hae;
data3[43]=8'hae;
data3[44]=8'haf;
data3[45]=8'haf;
data3[46]=8'hb0;
data3[47]=8'hb0;
  end
  
endmodule