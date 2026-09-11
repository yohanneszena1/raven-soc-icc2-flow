################################################################################
# Raven SoC MCMM setup
# Single functional mode, single nominal corner, single setup/hold scenario
################################################################################

# Remove any existing RM/default modes, corners, and scenarios
remove_modes -all
remove_corners -all
remove_scenarios -all

# Define one mode, one corner, and one scenario
set mode_func "func"
set corner_nominal "nominal"
set scenario_nominal "${mode_func}::${corner_nominal}"

# Create the mode/corner/scenario objects inside ICC2
create_mode $mode_func
create_corner $corner_nominal
create_scenario -name $scenario_nominal -mode $mode_func -corner $corner_nominal

# Make this scenario active/current before reading constraints
current_mode $mode_func
current_corner $corner_nominal
current_scenario $scenario_nominal

# Read timing constraints generated from Design Compiler
read_sdc ../inputs/raven_soc.sdc

# Use the nominal TLUPlus parasitic model for both early and late estimates
# The "nominal" parasitic model is created in raven_parasitic_setup.tcl
set_parasitic_parameters -late_spec nominal -early_spec nominal

# Enable setup, hold, power, transition, and capacitance checks for this scenario
set_scenario_status $scenario_nominal \
    -none \
    -setup true \
    -hold true \
    -leakage_power true \
    -dynamic_power true \
    -max_transition true \
    -max_capacitance true \
    -min_capacitance true \
    -active true

# Write a scenario report after setup
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}/${INIT_DESIGN_BLOCK_NAME}.report_scenarios.rpt {report_scenarios}
