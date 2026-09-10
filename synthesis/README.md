# Raven SoC Logic Synthesis

This directory contains the project-specific files used to synthesize the
Raven SoC with Synopsys Design Compiler.

## Contents

- `rtl/raven_soc_dc.v` - synthesis-compatible Raven SoC RTL.
- `scripts/synth_raven_soc.tcl` - Design Compiler synthesis script.

The synthesis RTL is based on the original Raven SoC RTL. The internal
`mem_*` wire declarations were moved earlier in the module as a
nonfunctional declaration-ordering adjustment.

The PicoRV32, SPI flash controller, and UART RTL included by
`raven_soc_dc.v` are stored in `../simulation/raven_soc/`.

## Standard-cell library

No PDK or standard-cell library files are included in this repository.

Before running synthesis, set `RAVEN_TARGET_DB` to a compatible Synopsys
Liberty `.db` standard-cell library:

    export RAVEN_TARGET_DB=/path/to/compatible/library.db

## Running synthesis

Run Design Compiler from this directory so that the relative paths used by
the synthesis script resolve correctly:

    cd synthesis
    dc_shell -f scripts/synth_raven_soc.tcl

The script creates the `reports`, `outputs`, and `work` directories as needed.
Generated synthesis databases, reports, logs, and mapped netlists are not
included in the repository.
