# Raven SoC Functional Simulation

This directory contains the files used for the Raven SoC functional
simulation described in the project report.

## Project-specific files

- `raven_soc/raven_soc_tb.v` - Xcelium testbench used for SoC-level verification.
- `raven_soc/raven_soc_xcelium.v` - simulation-compatible Raven SoC RTL.
  This is based on the original Raven `raven_soc.v`, with only declaration
  ordering changed so that the RTL is accepted by the simulation tool.
- `raven_soc/firmware.c` - firmware source used for the simulation.
- `raven_soc/firmware.hex` - compiled firmware image loaded by the SPI flash model.

## Upstream Raven/PicoRV32 files

The following files originate from the open-source Raven/PicoRV32 project:

- `raven_soc/picorv32.v`
- `raven_soc/spimemio.v`
- `raven_soc/simpleuart.v`
- `spiflash.v`
- `tbuart.v`
- `XSPRAM_1024X32_M8P.v`
- `raven_defs.h`

The original Raven/PicoRV32 licensing notice is included as
`LICENSE.raven-picorv32`.

## Simulation

The testbench models the Raven SoC boundary with behavioral SRAM and SPI
flash models, provides the required clock/reset and external inputs, monitors
UART activity, and records a VCD waveform.

The simulation was run with Cadence Xcelium using a 100 MHz `pll_clk`.
