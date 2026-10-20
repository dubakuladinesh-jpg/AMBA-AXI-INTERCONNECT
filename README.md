# Predictive AMBA AXI4 Interconnect Verification & RTL Design

## Overview
This repository contains the RTL design and verification environment for a synthesizable AMBA AXI4 interconnect module. The design features single-cycle stride prediction optimized for Linear (+48) and 2D Tensor (+648) burst access patterns[cite: 7].

## Verification & SVA
Functional correctness and protocol compliance were ensured using **SystemVerilog Assertions (SVA)**:
* Validated deadlock-free multi-channel handshake compliance across all five AXI4 channels (AW, W, B, AR, R)[cite: 7].
* Checked cycle-accurate pipeline rollback during address mispredictions[cite: 7].
* Authored directed and randomized test sequences to verify concurrent master-slave transactions[cite: 7].

## Synthesis Results
The RTL was verified for functional behavior and successfully synthesized for AMD Xilinx targets using Vivado, achieving[cite: 7]:
* **LUTs:** 69[cite: 7]
* **Flip-Flops (FFs):** 106[cite: 7]

## Tech Stack
* **Languages:** Verilog HDL, SystemVerilog (SVA)[cite: 7]
* **Protocols:** AMBA AXI4 (Handshake & Burst)[cite: 7]
* **Tools:** AMD Xilinx Vivado, XSim[cite: 7]
