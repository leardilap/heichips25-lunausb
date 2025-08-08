// SPDX-FileCopyrightText: © 2025 Luis Ardila, Brian Pachideh, Francisco Sayas
// SPDX-License-Identifier: Apache-2.0

// Adapted from the Tiny Tapeout template

`default_nettype none

module heichips25_template (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n,     // reset_n - low to reset
    // usb pins for putting into pads directly
    output wire tx_en_o,  
    input wire dp_rx_i,
    output wire dp_tx_o,
    input wire dn_rx_i,
    output wire dn_tx_o
);
    // List all unused inputs to prevent warnings
    
    // Instantiate the usb_cdc module from ulixxe as a Fomu device
    usb_cdc #(.VENDORID(16'h1209),
        .PRODUCTID(16'h5BF0),
        .IN_BULK_MAXPACKETSIZE('d8),
        .OUT_BULK_MAXPACKETSIZE('d8),
        .BIT_SAMPLES('d4),
        .USE_APP_CLK(0),
        .APP_CLK_FREQ(48))  // 48MHz
    u_usb_cdc (.frame_o({uio_out[7:5],uio_oe[7:0]}),
        .configured_o(uio_out [4]),
        .app_clk_i(clk),
        .clk_i(clk),
        .rstn_i(rst_n),
        .out_ready_i(uio_out[3]),
        .in_data_i(ui_in),
        .in_valid_i(uio_in[0]),
        .out_data_o(uo_out),
        .out_valid_o(uio_out[0]),
        .in_ready_o(uio_out[1]),
        .dp_pu_o(uio_out[2]),
        .tx_en_o(tx_en_o),
        .dp_rx_i(dp_rx_i),
        .dp_tx_o(dp_tx_o),
        .dn_rx_i(dn_rx_i),
        .dn_tx_o(dn_tx_o));




endmodule
