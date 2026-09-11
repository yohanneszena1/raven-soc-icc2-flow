################################################################################
# Raven SoC parasitic setup
################################################################################

set parasitic_nominal "nominal"

# Parasitic technology files must be supplied externally.
# No PDK, TLUPlus, or layer-map files are included in this repository.
if {![info exists ::env(RAVEN_TLUPLUS_FILE)]} {
    error "Set RAVEN_TLUPLUS_FILE to the required TLUPlus file."
}

if {![info exists ::env(RAVEN_LAYER_MAP_FILE)]} {
    error "Set RAVEN_LAYER_MAP_FILE to the required layer-map file."
}

set tluplus_file($parasitic_nominal) $::env(RAVEN_TLUPLUS_FILE)
set layer_map_file($parasitic_nominal) $::env(RAVEN_LAYER_MAP_FILE)

foreach p [array name tluplus_file] {
    read_parasitic_tech -tlup $tluplus_file($p) -layermap $layer_map_file($p) -name $p
}
