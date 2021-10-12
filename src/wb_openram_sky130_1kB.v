// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module wb_openram_sky130_1kB 
(
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o
);

parameter BASE_ADDR = 32'h3000_0000;
parameter ADDR_MASK = 32'hffff_ff00;

wire sram_cs;
assign sram_cs = !(wbs_stb_i && wbs_cyc_i && ((wbs_adr_i & ADDR_MASK) == BASE_ADDR)) || wb_rst_i;

reg sram_ack;
always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
        sram_ack <= 0;
    end else begin
        sram_ack <= !sram_cs;
    end
end

sky130_sram_1kbyte_1rw1r_32x256_8 SRAM_32x256
     (
     `ifdef USE_POWER_PINS
      .vccd1(vccd1),
      .vssd1(vssd1),
      `endif
      // Port 0: RW
      .clk0   (wb_clk_i),
      .csb0   (sram_cs),
      .web0   (~wbs_we_i),
      .wmask0 (wbs_sel_i),
      .addr0  (wbs_adr_i[7:0]),
      .din0   (wbs_dat_i),
      .dout0  (wbs_dat_o),
      // Port 1: R
      .clk1   (1'b0),
      .csb1   (1'b1),
      .addr1  (8'h00)
//      .dout1  ()
      );
      
assign wbs_ack_o = sram_ack;

endmodule	// wb_openram_sky130_1kB

`default_nettype wire
