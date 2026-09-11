open_lib raven_soc
open_block raven_soc/icv_in_design

puts "FILLER_COUNT_ICV = [sizeof_collection [get_cells -quiet *RM_filler*]]"

check_legality
check_routes
report_qor

exit
