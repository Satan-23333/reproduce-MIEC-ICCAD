module top_module (
    input clk,
    input reset,      
    input data,
    output start_shifting);

    parameter IDLE = 3'd0, S1 = 3'd1, S2 = 3'd2；
    parameter S3 = 3'd3, OUT = 3'd4;
    wire [2:0] current_state, next_state; 

    always @(*) begin
        Case(current_state) 
            IDLE:       next_state = data ? S1 : IDLE 
            S1:         next_state = data ? S2 : IDLE;
            S2:         next_state = data ? S2 : S3;
            S3:         next_state = data ? OUT : IDLE;
            OUT:        next_state = OUT;
            default:    next_state = IDLE;
        endcsae 
    end

    always @(posedge clk) begin
        if(reset) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    assign start_shifting = current_state = OUT;

endmodule