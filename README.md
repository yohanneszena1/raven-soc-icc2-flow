# Raven SoC ICC2 Flow

Project files used for the Raven SoC implementation described in the associated
Virginia Tech MEng report.

This repository contains the non-proprietary RTL, simulation, synthesis,
Formality, and ICC2 scripts used in the project.

## Contents

### `rtl/`

- `raven_soc.v` - original upstream Raven SoC RTL.

### `simulation/`

Contains the files used for functional simulation with Cadence Xcelium,
including:

- Raven/PicoRV32 RTL
- SoC testbench
- behavioral SRAM, SPI flash, and UART models
- firmware source and firmware image

`raven_soc_xcelium.v` is based on the original `raven_soc.v` with only
declaration ordering changed for tool compatibility.

The upstream Raven/PicoRV32 licensing notice is included as
`simulation/LICENSE.raven-picorv32`.

### `synthesis/`

Contains the Synopsys Design Compiler synthesis script and synthesis-compatible
Raven SoC RTL.

`raven_soc_dc.v` contains the same nonfunctional declaration-ordering
adjustment used for tool compatibility.

The synthesis script expects the target standard-cell timing library to be
provided externally:

    export RAVEN_TARGET_DB=/path/to/library.db

Run synthesis from the `synthesis` directory:

    dc_shell -f scripts/synth_raven_soc.tcl

### `synthesis/formality/`

Contains the Synopsys Formality script used to compare the RTL against the
mapped synthesis netlist.

Run from the `synthesis` directory after synthesis:

    fm_shell -f formality/scripts/fm_raven_soc.tcl

### `icc2/`

Contains the Raven-specific portions of the ICC2 physical-design flow:

- `setup/` - project configuration, floorplan, MCMM, and parasitic setup
- `user_scripts/` - custom chip-finish filler insertion and cleanup
- `checks/` - final implementation checking
- `export/` - GDS export for external physical verification

The final ICC2 implementation stage order was:

    init_design
    place_opt
    clock_opt_cts
    clock_opt_opto
    route_auto
    route_opt
    chip_finish
    icv_in_design
    write_data

Technology-specific inputs used by the sanitized ICC2 scripts are supplied
externally through:

    RAVEN_TLUPLUS_FILE
    RAVEN_LAYER_MAP_FILE
    RAVEN_FILLER_LIB_CELLS
    RAVEN_STREAM_OUT_LAYER_MAP
    RAVEN_DRC_GDS_OUTPUT

## Excluded files

This repository intentionally does not include:

- PDK files
- standard-cell library files
- LEF, DB, NDM, TLUPlus, or other technology collateral
- foundry physical-verification decks or runsets
- Synopsys Reference Methodology source files
- generated implementation databases, logs, reports, or layout outputs
- debug, experimental, and abandoned pad-flow scripts

The ICC2 files in this repository contain only the Raven-specific project
configuration and custom code needed to document the implemented flow.
