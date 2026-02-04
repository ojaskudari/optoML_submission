module pipelined_register #(
    parameter int DATA_WIDTH = 32
) (
    input  logic                    clk,
    input  logic                    rst_n,
    
    input  logic [DATA_WIDTH-1:0]   in_data,
    input  logic                    in_valid,
    output logic                    in_ready,
    
    output logic [DATA_WIDTH-1:0]   out_data,
    output logic                    out_valid,
    input  logic                    out_ready
);

    logic [DATA_WIDTH-1:0] buffer;
    logic                  buffer_full;
    
    assign in_ready = !buffer_full || out_ready;
    assign out_data  = buffer;
    assign out_valid = buffer_full;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer      <= '0;
            buffer_full <= 1'b0;
        end else begin
            if (in_valid && in_ready) begin
                buffer      <= in_data;
                buffer_full <= 1'b1;
            end 
            else if (out_valid && out_ready) begin
                buffer_full <= 1'b0;
            end
        end
    end

endmodule
