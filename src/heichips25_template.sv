// SPDX-FileCopyrightText: © 2025 XXX Authors
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
   
   
    // Instantiate the usb_cdc module
	  usb_cdc #(
	    .VENDORID(16'h1234), // Example Vendor ID (16 bits)
	    .PRODUCTID(16'h5678), // Example Product ID (16 bits)
	    .CHANNELS(2),         // Example number of channels
	    .IN_BULK_MAXPACKETSIZE(8), // Example max packet size for IN bulk endpoint (8 bits)
	    .OUT_BULK_MAXPACKETSIZE(8), // Example max packet size for OUT bulk endpoint (8 bits)
	    .BIT_SAMPLES(4),      // Example bit samples (4x of 12MHz)
	    .USE_APP_CLK(0),      // Disable app_clk (1 bit)
	    .APP_CLK_FREQ(12)     // Set app_clk frequency to 12 MHz (12 bits)
	  ) usb_cdc_inst (
	    // Inputs
	    .clk_i(clk),                   // Input, 1 bit
	    .rstn_i(rst_n),                 // Input, 1 bit
	    .app_clk_i(),           // Input, 1 bit
	    .in_data_i(ui_in),           // Input, 8*CHANNELS bits
	    .in_valid_i(uio_in[0]),         // Input, CHANNELS bits
	    .out_ready_i(uio_in[1]),       // Input, CHANNELS bits
	    
	    
	    // Outputs
	    .out_data_o(uo_out),         // Output, 8*CHANNELS bits
	    .out_valid_o(uio_out[2]),       // Output, CHANNELS bits
	    .in_ready_o(uio_out[3]),         // Output, CHANNELS bits
	    .frame_o({unused, uio_out[6:5], uio_oe[7:0]}),               // Output, 11 bits
	    .configured_o(uio_out[4]),     // Output, 1 bit
	    
	    // usb signals
	    .dp_pu_o(uio_out[7]),            // Output, 1 bit
	    .tx_en_o(tx_en_o),               // Output, 1 bit
	    
	    .dp_rx_i(dp_rx_i),               // Input, 1 bit
            .dp_tx_o(dp_tx_o),               // Output, 1 bit
            
	    .dn_rx_i(dn_rx_i),               // Input, 1 bit
	    .dn_tx_o(dn_tx_o)                // Output, 1 bit
	  );

 




endmodule
