################################################################################
# Raven SoC minimal floorplan for ICC2 init_design
################################################################################

puts "RM-info: Starting Raven SoC floorplan setup"

# Allow ICC2 to determine the appropriate site definition from the
# externally supplied technology/library setup.
set SITE_DEFAULT ""

# Basic utilization target for initial block-level floorplan
set INITIALIZE_FLOORPLAN_UTIL "0.55"

# Die-to-core spacing in microns
set INITIALIZE_FLOORPLAN_CORE_OFFSET "10 10"

# No explicit width, height, boundary, or area is forced here
set INITIALIZE_FLOORPLAN_WIDTH ""
set INITIALIZE_FLOORPLAN_HEIGHT ""
set INITIALIZE_FLOORPLAN_BOUNDARY ""
set INITIALIZE_FLOORPLAN_AREA ""
set INITIALIZE_FLOORPLAN_CUSTOM_OPTIONS ""

# Use the ICC2 Reference Methodology floorplanning helper
rm_source -file ./rm_icc2_pnr_scripts/init_design.tcl.default.floorplanning \
    -print "Raven initialize_floorplan"

# Automatically place top-level signal pins/terminals after the boundary exists
puts "RM-info: Running automatic pin placement"
place_pins -self

puts "RM-info: Completed Raven SoC floorplan setup"
