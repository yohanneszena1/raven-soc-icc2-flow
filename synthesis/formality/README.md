# Raven SoC Formal Equivalence Checking

This directory contains the project-specific Synopsys Formality script used
to compare the synthesis-compatible Raven SoC RTL against the mapped
Design Compiler gate-level netlist.

## Prerequisites

Run the Design Compiler synthesis flow first. Formality uses the generated:

- `outputs/raven_soc.svf`
- `outputs/raven_soc_synth.v`

These generated files are not included in the repository.

No PDK or standard-cell library files are included. Set `RAVEN_TARGET_DB`
to the same compatible standard-cell `.db` library used for synthesis:

    export RAVEN_TARGET_DB=/path/to/compatible/library.db

## Running Formality

Run Formality from the `synthesis` directory:

    cd synthesis
    fm_shell -f formality/scripts/fm_raven_soc.tcl

The script generates matched, unmatched, failing, and passing point reports
under `formality/reports/`.
