# Synchronous FIFO — RTL-to-GDSII on Sky130

8-bit × 16-deep synchronous FIFO through a full open-source ASIC flow using LibreLane (OpenLane 2) with the Sky130 HD library at 100 MHz.

## Results
- Standard cells: 824
- Cell area: 8,520.67 µm² (die 19,430.1 µm²)
- Utilization: 56.7%
- Setup slack (ss_100C_1v60): +0.697 ns — no violations
- Hold slack (ff_n40C_1v95): 0 — no violations
- DRC/LVS: clean (Magic, KLayout, Netgen)
- Known warnings: 52 max-slew and 1 max-fanout at the slow corner, non-timing-critical (see reports/checks.rpt)

## Flow
Verilator lint → Yosys synthesis → floorplan → placement → CTS → global/detailed routing → RC extraction → post-PnR STA → Magic/KLayout DRC → Netgen LVS → GDS.

## Files
- sync_fifo.v — RTL
- config.json — LibreLane config
- sync_fifo.gds — final layout
- reports/ — metrics, timing, power, and check reports

## Reproduce
librelane --dockerized --pdk-root $HOME/.ciel config.json

## Layout
![layout](layout.png)

## Related
Verification testbench for this FIFO: https://github.com/DasAditya23/fifo-uvm-verification
