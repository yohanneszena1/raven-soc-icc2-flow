################################################################################
# Raven SoC standard-cell filler insertion before chip_finish
################################################################################

puts "RM-info: Raven SoC custom standard-cell filler insertion with violation cleanup"

# Filler-cell library references must be supplied externally.
# No standard-cell library information is included in this repository.
if {![info exists ::env(RAVEN_FILLER_LIB_CELLS)]} {
    error "Set RAVEN_FILLER_LIB_CELLS to the filler-cell library references required by the target technology."
}

set raven_filler_cells $::env(RAVEN_FILLER_LIB_CELLS)

set raven_filler_cells_sorted [get_object_name \
  [sort_collection -descending [get_lib_cells $raven_filler_cells] area]]

puts "RM-info: Running create_stdcell_fillers -lib_cells <filler_list> -prefix RM_filler"

create_stdcell_fillers -lib_cells $raven_filler_cells_sorted -prefix RM_filler
connect_pg_net

puts "RM-info: Filler count before cleanup = [sizeof_collection [get_cells -quiet *RM_filler*]]"

puts "RM-info: Running remove_stdcell_fillers_with_violation"
remove_stdcell_fillers_with_violation
connect_pg_net

puts "RM-info: Filler count after cleanup = [sizeof_collection [get_cells -quiet *RM_filler*]]"

check_legality
check_routes
