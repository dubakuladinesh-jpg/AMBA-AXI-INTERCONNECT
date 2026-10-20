// SystemVerilog Assertions (SVA) for AMBA AXI4 Protocol Compliance
// Validates deadlock-free multi-channel handshakes (AW, W, B, AR, R)

module sva_axi4_handshake (
    input wire clk,
    input wire rst_n,
    
    // Write Channels
    input wire awvalid, input wire awready,
    input wire wvalid,  input wire wready,
    input wire bvalid,  input wire bready,
    
    // Read Channels
    input wire arvalid, input wire arready,
    input wire rvalid,  input wire rready
);

    // Property: Once VALID goes high, it must remain high until READY goes high
    property p_valid_holds_until_ready (valid, ready);
        @(posedge clk) disable iff (!rst_n)
        valid && !ready |=> valid;
    endproperty

    // Check AW Channel Handshake
    assert_aw_handshake: assert property (p_valid_holds_until_ready(awvalid, awready))
        else $error("SVA VIOLATION: AWVALID dropped before AWREADY asserted!");

    // Check W Channel Handshake
    assert_w_handshake: assert property (p_valid_holds_until_ready(wvalid, wready))
        else $error("SVA VIOLATION: WVALID dropped before WREADY asserted!");

    // Check B Channel Handshake
    assert_b_handshake: assert property (p_valid_holds_until_ready(bvalid, bready))
        else $error("SVA VIOLATION: BVALID dropped before BREADY asserted!");

    // Check AR Channel Handshake
    assert_ar_handshake: assert property (p_valid_holds_until_ready(arvalid, arready))
        else $error("SVA VIOLATION: ARVALID dropped before ARREADY asserted!");

    // Check R Channel Handshake
    assert_r_handshake: assert property (p_valid_holds_until_ready(rvalid, rready))
        else $error("SVA VIOLATION: RVALID dropped before RREADY asserted!");

endmodule
