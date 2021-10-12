# User config
set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) wb_openram_sky130_1kB

# Change if needed
## set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]
set ::env(VERILOG_FILES) "$::env(DESIGN_DIR)/wb_openram_sky130_1kB/src/wb_openram_sky130_1kB.v"    


# Fill this
set ::env(CLOCK_PERIOD) "10"
set ::env(CLOCK_PORT) "wb_clk_i"

# define number of IO pads
set ::env(SYNTH_DEFINES) "MPRJ_IO_PADS=38"

## Internal Macros
### Macro Placement
## set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(DESIGN_DIR)/$::env(DESIGN_NAME)/src/sky130_sram_1kbyte_1rw1r_32x256_8.v"

set ::env(EXTRA_LEFS) "\
	$::env(DESIGN_DIR)/$::env(DESIGN_NAME)/lef/sky130_sram_1kbyte_1rw1r_32x256_8.lef"

set ::env(EXTRA_GDS_FILES) "\
	$::env(DESIGN_DIR)/$::env(DESIGN_NAME)/gds/sky130_sram_1kbyte_1rw1r_32x256_8.gds"

# macro needs to work inside Caravel, so can't be core and can't use metal 5
set ::env(DESIGN_IS_CORE) 0
set ::env(GLB_RT_MAXLAYER) 5

# define power straps so the macro works inside Caravel's PDN
set ::env(VDD_NETS) [list {vccd1} {vccd2} {vdda1} {vdda2}]
set ::env(GND_NETS) [list {vssd1} {vssd2} {vssa1} {vssa2}]

# regular pin order seems to help with aggregating all the macros for the group project
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

# turn off CVC as we have multiple power domains
set ::env(RUN_CVC) 0
