################################################################################
# Raven SoC project configuration for the ICC2 Reference Methodology
################################################################################

# Design
set DESIGN_NAME "raven_soc"
set INIT_DESIGN_INPUT "ASCII"
set VERILOG_NETLIST_FILES "../inputs/raven_soc_synth.v"

# Raven project-specific setup files
set TCL_FLOORPLAN_FILE "raven_floorplan.tcl"
set TCL_MCMM_SETUP_FILE "raven_mcmm_setup.tcl"
set TCL_PARASITIC_SETUP_FILE "raven_parasitic_setup.tcl"

# Output locations
set OUTPUTS_DIR "./outputs_icc2"
set REPORTS_DIR "./rpts_icc2"

# In-design physical verification
set ICV_IN_DESIGN_DRC true
set ICV_IN_DESIGN_ADR false
set ICV_IN_DESIGN_METAL_FILL false

# Technology, reference-library, and foundry verification inputs are intentionally
# not defined here. They must be configured separately using properly licensed
# PDK and standard-cell collateral.

# Project-specific chip-finish hook
set TCL_USER_CHIP_FINISH_PRE_SCRIPT "chip_finish_pre_script.tcl"
