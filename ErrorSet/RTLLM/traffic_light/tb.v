`timescale 1ns/1ns

module tb;
  
  reg clk;
  reg rst_n;
  reg pass_request;
  wire [7:0] clock;
  wire red;
  wire yellow;
  wire green;
  integer i;
  // Instantiate the module
  traffic_light uut (
    .clk(clk), 
    .rst_n(rst_n),
    .pass_request(pass_request), 
    .clock(clock), 
    .red(red),
    .yellow(yellow),
    .green(green)
  );
  
  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  integer error = 0;
  integer clock_cnt;
  // Test sequence
  initial begin
    clk = 0; // Initialize clock
    rst_n = 1; // De-assert reset
    pass_request = 0; // No pass request initially

    // Perform reset
    rst_n = 0;
    #10;
    error = (clock==10)&&(red===0)&&(yellow===0)&&(green===0) ?error :error+1;
    if(error!=0)begin
      $display("This is testbench: the expected result clock=10, red=0, yellow=0, green=0; but the actual result clock=%d, red=%d, yellow=%d, green=%d",clock,red,yellow,green);
      $finish;
    end
    rst_n = 1;
    #30;
    
    // test redt
    error = (clock==10)&&(red==1)&&(yellow==0)&&(green==0) ?error :error+1;
    if(error!=0)begin
      $display("This is testbench: the expected result clock=10, red=1, yellow=0, green=0; but the actual result clock=%d, red=%d, yellow=%d, green=%d",clock,red,yellow,green);
      $finish;
    end
    #100;
    // test green
    error = (clock==60)&&(red==0)&&(yellow==0)&&(green==1) ?error :error+1;
    if(error!=0)begin
      $display("This is testbench: the expected result clock=60, red=0, yellow=0, green=1; but the actual result clock=%d, red=%d, yellow=%d, green=%d",clock,red,yellow,green);
      $finish;
    end
    #600;
    // test yellow
    error = (clock==5)&&(red==0)&&(yellow==1)&&(green==0) ?error :error+1;
    if(error!=0)begin
      $display("This is testbench: the expected result clock=5, red=0, yellow=1, green=0; but the actual result clock=%d, red=%d, yellow=%d, green=%d",clock,red,yellow,green);
      $finish;
    end
    #150;
    clock_cnt = clock;
    error = (clock==60)&&(red==0)&&(yellow==0)&&(green==1) ?error :error+1;
    if(error!=0)begin
      $display("This is testbench: the expected result clock=60, red=0, yellow=0, green=1; but the actual result clock=%d, red=%d, yellow=%d, green=%d",clock,red,yellow,green);
      $finish;
    end
    // test pass_request
    #30;
    error = (clock!=(clock_cnt+3)) ?error :error+1;
    error = (clock==57)&&(red==0)&&(yellow==0)&&(green==1) ?error :error+1;
    if(error!=0)begin
      $display("This is testbench: the expected result clock=57, red=0, yellow=0, green=1; but the actual result clock=%d, red=%d, yellow=%d, green=%d",clock,red,yellow,green);
      $finish;
    end
    pass_request = 1;
    #10;
    error = (clock==10)&&(red==0)&&(yellow==0)&&(green==1) ?error :error+1;
    if(error!=0)begin
      $display("This is testbench: the expected result clock=10, red=0, yellow=0, green=1; but the actual result clock=%d, red=%d, yellow=%d, green=%d",clock,red,yellow,green);
      $finish;
    end
    if (error == 0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Test completed with %d /7failures===========", error);
    end

    $finish; // End of test
  end

endmodule
