# CAD HW3 — Approximate Multiplier Using Actel-Style Logic Blocks

A Verilog coursework implementation of an approximate multiplication datapath and controller. The design uses small logic modules (such as mux-based combinational/sequential blocks, counters, adders and registers) to build the control and arithmetic datapath.

## Repository layout

- `src/hdl/` — RTL modules, including the top-level `approx_mult`, controller, datapath, multiplier and supporting logic.
- `sim/tb/test_top.v` — system-level testbench.
- `sim/tb/test_array_mult.v` — array-multiplier testbench.
- `sim/sim_top.tcl` — ModelSim/Questa simulation script.
- `sim/da.txt` and `sim/file/da.txt` — supplied data files.

## Simulation

Open ModelSim/Questa in the `sim/` directory and run:

```tcl
do sim_top.tcl
```


## Validation notes

This repository preparation did not establish a fresh independent simulation pass. The supplied system testbench has issues that should be addressed before relying on its results: `start` is driven from more than one initial process, and one 16-bit assignment uses a value wider than 16 bits (`16'h17235`), causing truncation. Add a single-driver, self-checking testbench before claiming complete verification.
