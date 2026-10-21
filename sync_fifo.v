`timescale 1ns/1ps
// Synchronous FIFO
// - Single clock domain
// - Parameterizable depth (must be power of 2) and data width
// - Reports full and empty status

module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16,             // must be power of 2
    parameter ADDR_WIDTH = 4               // log2(DEPTH)
)(
    input  wire                  clk,
    input  wire                  rst_n,    // active-low reset

    // Write side
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output wire                  full,

    // Read side
    input  wire                  rd_en,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire                  empty
);

    // Memory
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Pointers and counter
    reg [ADDR_WIDTH:0] wr_ptr;             // one extra bit to distinguish full vs empty
    reg [ADDR_WIDTH:0] rd_ptr;

    // Full and empty flags
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);
    assign empty = (wr_ptr == rd_ptr);

    // Write logic
    always @(posedge clk) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // Read logic
    always @(posedge clk) begin
        if (!rst_n) begin
            rd_ptr <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    // Read data is combinational (show the value at the read pointer)
    assign rd_data = mem[rd_ptr[ADDR_WIDTH-1:0]];

endmodule