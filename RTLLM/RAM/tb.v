`timescale 1ns/1ns

module tb_RAM;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in simulation time units
    
    // Inputs
    reg clk;
    reg rst_n;
    reg write_en;
    reg [7:0] write_addr;
    reg [5:0] write_data;
    reg read_en;
    reg [7:0] read_addr;
    
    // Outputs
    wire [5:0] read_data;

    // Instantiate the module
    verified_RAM uut (
        .clk(clk),
        .rst_n(rst_n),
        .write_en(write_en),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_en(read_en),
        .read_addr(read_addr),
        .read_data(read_data)
    );
    
    // Clock generation
    always #((CLK_PERIOD)/2) clk = ~clk;

    integer error = 0;
    integer i;
    reg [5:0]data[0:39];
    // Initial block for stimulus generation
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 1;
        for (i=0; i<40; i=i+1) begin
            write_en = 0;
            write_addr = 0;
            write_data = 0;
            read_en = 0;
            read_addr = 0;
            // Wait for a few clock cycles
            #((CLK_PERIOD) * 5);
            // Release reset
            rst_n = 0;
            #((CLK_PERIOD) * 2);
            rst_n = 1;
            // Write operation
            write_en = 1;
            write_addr = 3'b000;
            write_data = data[i];
            #((CLK_PERIOD) * 1);
            write_en = 0;
            #((CLK_PERIOD) * 1);
            
            // Read operation
            read_en = 1;
            read_addr = 3'b000;
            #((CLK_PERIOD) * 1);
            // $display("read_data = %b", read_data); 
            error = (read_data == write_data) ? error : error+1;
            read_en = 0;
            #((CLK_PERIOD) * 1);
            // $display("read_data = %b", read_data); 
            error = (read_data == 0) ? error : error+1;
        end
        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end
        else begin
        $display("===========Error===========", error);
        end
        // Finish simulation
        $finish;
    end
initial begin
data[0] = 6'b010101;
data[1] = 6'b101111;
data[2] = 6'b010010;
data[3] = 6'b010111;
data[4] = 6'b000010;
data[5] = 6'b110001;
data[6] = 6'b100101;
data[7] = 6'b010111;
data[8] = 6'b100001;
data[9] = 6'b000000;
data[10] = 6'b001101;
data[11] = 6'b100111;
data[12] = 6'b101011;
data[13] = 6'b001011;
data[14] = 6'b101110;
data[15] = 6'b101101;
data[16] = 6'b001001;
data[17] = 6'b010110;
data[18] = 6'b001110;
data[19] = 6'b100010;
data[20] = 6'b010010;
data[21] = 6'b111001;
data[22] = 6'b010110;
data[23] = 6'b100011;
data[24] = 6'b101000;
data[25] = 6'b001001;
data[26] = 6'b101000;
data[27] = 6'b011011;
data[28] = 6'b010010;
data[29] = 6'b010011;
data[30] = 6'b001000;
data[31] = 6'b011111;
data[32] = 6'b101011;
data[33] = 6'b011101;
data[34] = 6'b000011;
data[35] = 6'b101111;
data[36] = 6'b000001;
data[37] = 6'b101001;
data[38] = 6'b101100;
data[39] = 6'b001001;
    
end
endmodule
