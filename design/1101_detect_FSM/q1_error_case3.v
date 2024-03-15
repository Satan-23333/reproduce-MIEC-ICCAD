module top_module (
    input clk,
    input reset,    
    input data,
    output start_shifting);

    parameter IDLE = 0, S1 = 1, S2 = 10;
    parameter S3 = 11, OUT = 100;
    reg [2:0] current_state, next_state;

    always @(*) begin
        case(current_state)
            IDLE:       next_state = data ? S1 : IDLE;
            S1:         next_state = data ? S2 : IDLE;
            S2:         next_state = data ? S2 : S3;
            S3:         next_state = data ? OUT : IDLE;
            OUT:        next_state = OUT;
            default:    next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if(reset) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    assign start_shifting = current_state == OUT;

endmodule