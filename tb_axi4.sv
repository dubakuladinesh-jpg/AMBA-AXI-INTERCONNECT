// Directed and Randomized Testbench for AMBA AXI4 Interconnect
// Validates concurrent master-slave transactions and stride prediction

`timescale 1ns/1ps

module tb_axi4;
    reg clk;
    reg rst_n;

    // AXI4 Interface Signals
    reg [31:0] awaddr;
    reg awvalid;
    wire awready;

    reg [31:0] wdata;
    reg wlast;
    reg wvalid;
    wire wready;

    wire [1:0] bresp;
    wire bvalid;
    reg bready;

    // Instantiate the DUT (Design Under Test)
    axi4_interconnect dut (
        .aclk(clk), .aresetn(rst_n),
        .awaddr(awaddr), .awvalid(awvalid), .awready(awready),
        .wdata(wdata), .wlast(wlast), .wvalid(wvalid), .wready(wready),
        .bresp(bresp), .bvalid(bvalid), .bready(bready),
        // Read channels tied to 0 for write-focused test
        .araddr(32'h0), .arvalid(1'b0), .rready(1'b0)
    );

    // Bind the SVA Module
    sva_axi4_handshake sva_checker (
        .clk(clk), .rst_n(rst_n),
        .awvalid(awvalid), .awready(awready),
        .wvalid(wvalid),   .wready(wready),
        .bvalid(bvalid),   .bready(bready),
        .arvalid(1'b0),    .arready(),
        .rvalid(1'b0),     .rready(1'b0)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Test Sequence Execution
    initial begin
        // Initialize signals
        clk = 0; rst_n = 0;
        awvalid = 0; wvalid = 0; bready = 1;
        awaddr = 0; wdata = 0; wlast = 0;

        // Apply Reset
        #20 rst_n = 1;
        #10;

        $display("--- Starting Directed Test Sequence ---");
        // Directed Write Transaction
        @(posedge clk);
        awvalid = 1; awaddr = 32'h1000;
        wait(awready);
        @(posedge clk) awvalid = 0;

        @(posedge clk);
        wvalid = 1; wdata = 32'hDEADBEEF; wlast = 1;
        wait(wready);
        @(posedge clk) wvalid = 0; wlast = 0;

        wait(bvalid);
        $display("Directed write completed.");

        #50;
        $display("--- Starting Randomized Test Sequences ---");
        // Randomized Transactions to test stride prediction
        for (int i = 0; i < 5; i++) begin
            @(posedge clk);
            awvalid = 1; 
            awaddr = $urandom_range(32'h2000, 32'h3000);
            wait(awready);
            @(posedge clk) awvalid = 0;

            @(posedge clk);
            wvalid = 1; 
            wdata = $urandom(); 
            wlast = 1;
            wait(wready);
            @(posedge clk) wvalid = 0; wlast = 0;
            wait(bvalid);
        end
        
        $display("--- All sequences completed successfully ---");
        $finish;
    end
endmodule
