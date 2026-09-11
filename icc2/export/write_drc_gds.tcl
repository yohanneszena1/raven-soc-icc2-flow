################################################################################
# Raven SoC GDS export for external physical verification
################################################################################

open_lib raven_soc
open_block raven_soc/write_data

# The stream-out layer map is technology-specific and must be supplied externally.
if {![info exists ::env(RAVEN_STREAM_OUT_LAYER_MAP)]} {
    error "Set RAVEN_STREAM_OUT_LAYER_MAP to the required stream-out layer-map file."
}

# The output GDS path must be supplied by the user.
if {![info exists ::env(RAVEN_DRC_GDS_OUTPUT)]} {
    error "Set RAVEN_DRC_GDS_OUTPUT to the desired output GDS path."
}

set stream_map $::env(RAVEN_STREAM_OUT_LAYER_MAP)
set out_gds    $::env(RAVEN_DRC_GDS_OUTPUT)

puts "RM-info: Writing GDS for external physical verification"

write_gds \
    -compress \
    -hierarchy all \
    -long_names \
    -keep_data_type \
    -layer_map $stream_map \
    $out_gds

exit
