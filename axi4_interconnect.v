// AMBA AXI4 Interconnect with Stride Prediction
// Optimized for Linear (+48) and 2D Tensor (+648) accesses

module axi4_interconnect (
    input wire aclk,
    input wire aresetn,

    // AXI4 Write Address Channel (AW)
    input wire [31:0] awaddr,
    input wire awvalid,
    output reg awready,

    // AXI4 Write Data Channel (W)
    input wire [31:0] wdata,
    input wire wlast,
    input wire wvalid,
    output reg wready,

    // AXI4 Write Response Channel (B)
    output reg [1:0] bresp,
    output reg bvalid,
    input wire bready,

    // AXI4 Read Address Channel (AR)
    input wire [31:0] araddr,
    input wire arvalid,
    output reg arready,

    // AXI4 Read Data Channel (R)
    output reg [31:0] rdata,
    output reg rlast,
    output reg rvalid,
    input wire rready
);

    // Stride Prediction States & Logic
    localparam STRIDE_LINEAR = 32'd48;
    localparam STRIDE_TENSOR = 32'd648;
    
    reg [31:0] next_predicted_addr;
    reg prediction_hit;

    // Simple Handshake & Prediction Logic
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            awready <= 1'b0;
            wready  <= 1'b0;
            bvalid  <= 1'b0;
            arready <= 1'b0;
            rvalid  <= 1'b0;
            next_predicted_addr <= 32'd0;
        end else begin
            // Write Address Handshake & Stride Prediction
            if (awvalid && !awready) begin
                awready <= 1'b1;
                // Predict next address based on tensor stride
                next_predicted_addr <= awaddr + STRIDE_TENSOR;
            end else begin
                awready <= 1'b0;
            end

            // Write Data Handshake
            if (wvalid && !wready) begin
                wready <= 1'b1;
            end else begin
                wready <= 1'b0;
            end

            // Write Response
            if (wvalid && wready && wlast) begin
                bvalid <= 1'b1;
                bresp  <= 2'b00; // OKAY
            end else if (bvalid && bready) begin
                bvalid <= 1'b0;
            end
        end
    end
endmodule
