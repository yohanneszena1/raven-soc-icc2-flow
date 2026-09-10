# Top module to synthesize
set DESIGN raven_soc

# Project folders
set RTL_DIR rtl
set UPSTREAM_RTL_DIR ../simulation/raven_soc
set REPORT_DIR reports
set OUTPUT_DIR outputs
set WORK_DIR work

# Create generated-output directories if they do not already exist
file mkdir $REPORT_DIR
file mkdir $OUTPUT_DIR
file mkdir $WORK_DIR

# Standard-cell library must be supplied externally.
# No PDK or standard-cell library files are included in this repository.
if {![info exists ::env(RAVEN_TARGET_DB)]} {
    error "Set RAVEN_TARGET_DB to the path of a compatible standard-cell .db library."
}
set TARGET_DB $::env(RAVEN_TARGET_DB)

# Let Design Compiler find included RTL files
set search_path [list . $RTL_DIR $UPSTREAM_RTL_DIR]

# Standard-cell libraries used for synthesis and linking
set target_library [list $TARGET_DB]
set link_library [concat * $target_library]

# Generate Formality guidance file during synthesis
set_svf $OUTPUT_DIR/${DESIGN}.svf

# Local Design Compiler work library
define_design_lib WORK -path $WORK_DIR

# Read and elaborate the Raven SoC RTL
analyze -format verilog $RTL_DIR/raven_soc_dc.v
elaborate $DESIGN

# Set raven_soc as the active design
current_design $DESIGN

# Resolve references and check for design issues before synthesis
link
check_design

# Main Raven SoC clock: 100 MHz
create_clock -name pll_clk -period 10.000 [get_ports pll_clk]

# External clock: 25 MHz
create_clock -name ext_clk -period 40.000 [get_ports ext_clk]

# Basic clock margin
set_clock_uncertainty 0.2 [get_clocks pll_clk]
set_clock_uncertainty 0.2 [get_clocks ext_clk]

# Basic placeholder input/output delays
set_input_delay 1.0 -clock pll_clk [remove_from_collection [all_inputs] [get_ports {pll_clk ext_clk}]]
set_output_delay 1.0 -clock pll_clk [all_outputs]

# Optimize for minimum area while meeting timing
set_max_area 0

# Run synthesis
compile_ultra

# Generate synthesis reports
report_qor > $REPORT_DIR/${DESIGN}_qor.rpt
report_area > $REPORT_DIR/${DESIGN}_area.rpt
report_timing -max_paths 20 > $REPORT_DIR/${DESIGN}_timing.rpt
report_power > $REPORT_DIR/${DESIGN}_power.rpt
check_design > $REPORT_DIR/${DESIGN}_check_design.rpt

# Write synthesized outputs
write -format verilog -hierarchy -output $OUTPUT_DIR/${DESIGN}_synth.v
write -format ddc -hierarchy -output $OUTPUT_DIR/${DESIGN}.ddc
write_sdc $OUTPUT_DIR/${DESIGN}.sdc

set_svf -off

exit
