# Asynchronous FIFO Design — Verilog RTL

A complete, documented implementation of an Asynchronous FIFO based on the Cliff Cummings SNUG 2002 standard architecture. Built for learning and reference — covers full theory, design, waveforms, flowcharts, and verified RTL.

---

## What This Repository Covers

| Phase | Content |
|---|---|
| Theory | CDC, metastability, Gray code, synchronizers |
| Design | Block diagram, specs, flowcharts |
| Waveforms | Expected write-side and read-side timing |
| RTL | All 5 modules in Verilog |
| Verification | Testbench with full/empty corner cases |
| Results | Simulation waveforms |

---

## Design Parameters

| Parameter | Value | Description |
|---|---|---|
| `DATA_WIDTH` | 8 (default) | Width of data bus |
| `ADDR_WIDTH` | 4 (default) | Address bits — depth = 2^ADDR_WIDTH |
| `FIFO_DEPTH` | 16 | Memory locations (2^4) |
| `PTR_WIDTH` | 5 | Pointer bits = ADDR_WIDTH + 1 |

---

## Repository Structure

```
async-fifo/
│
├── README.md                        ← you are here
│
├── docs/
│   ├── theory.md                    ← CDC, Gray code, metastability theory
│   ├── specifications.md            ← design specs and parameter calculations
│   ├── block_diagram.png            ← full architecture diagram
│   ├── flowchart_write.png          ← write side logic flowchart
│   ├── flowchart_read.png           ← read side logic flowchart
│   ├── waveform_write_expected.png  ← write side expected waveform
│   └── waveform_read_expected.png   ← read side expected waveform
│
├── rtl/
│   ├── async_fifo_top.v             ← top module (instantiates all below)
│   ├── fifo_mem.v                   ← dual-port RAM
│   ├── wptr_full.v                  ← write pointer + full flag
│   ├── rptr_empty.v                 ← read pointer + empty flag
│   └── ff_synch.v                   ← 2FF synchronizer (wptr & rptr crossing)
│
├── tb/
│   ├── case_1_tb.v                  ← full/empty flag and read/write operation
│   ├── case_2_tb.v                  ← simultaneous read and write operation
│   ├── ff_synch_tb.v                ← 2FF synchronizer testbench
│   ├── fifo_mem_tb.v                ← dual port RAM testbench
│   ├── rptr_empty_tb.v              ← read pointer + empty flag testbench
│   └── wptr_full_tb.v               ← write pointer + full flag testbench
│
└── sim/
    └── waveform_results.png         ← simulation output screenshots
```

---

## Key Concepts Implemented

- **Clock Domain Crossing (CDC)** — write and read clocks are completely independent
- **Gray Code Pointers** — only 1 bit changes per increment, safe to synchronize
- **2FF Synchronizer** — prevents metastability when crossing clock domains
- **Full Flag** — detected when wptr MSBs inverted vs synchronized rptr
- **Empty Flag** — detected when rptr equals synchronized wptr (all bits)

---

## Reference

This design follows the industry-standard architecture from:

> Clifford E. Cummings — *"Simulation and Synthesis Techniques for Asynchronous FIFO Design"*
> SNUG San Jose 2002
> [Download PDF](https://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf)

---

