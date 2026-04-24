# Pulse_X1 "Titan" Core - AI Accelerator with Thermal Intelligence

## Overview
Pulse_X1 "Titan" is a high-performance, ultra-low-power AI accelerator core optimized for Edge Computing. It features an innovative **Autonomous Microfluidic Thermal Management System** that monitors real-time temperature and controls cooling pumps directly from the silicon logic to prevent thermal throttling.

## Key Features
* **Architecture:** 8-Core Parallel MAC units for high-speed neural network acceleration.
* **Thermal Intelligence:** Integrated hardware logic for dynamic pump control and thermal protection.
* **Compatibility:** Fully compatible with the Caravel SoC framework (Sky130 PDK).

## Technical Specifications (Sign-off Metrics)


| Metric | Value |
| --- | --- |
| **Technology** | Sky130 (130nm) |
| **Total Power** | 0.64 mW (Ultra-Low Power) |
| **Clock Frequency** | 100 MHz |
| **Setup Slack** | +7.06 ns (Verified) |
| **Status** | 100% DRC/LVS Clean |

## Physical Implementation (GDSII)
The design was successfully hardened using the **OpenLane** flow. The physical layout is optimized for a balanced density to ensure 100% routing completion.

### Silicon Layout
<img width="1280" height="720" alt="Screenshot (1774)" src="https://github.com/user-attachments/assets/a5f17e5d-7d9e-4720-acee-9ae77d518aa1" />


## Functional Verification (Simulations)
The design has been verified using `iverilog` and `GTKWave`. All logic tests passed, confirming the parallel execution of the 8 cores and the thermal management responses.

### Simulation Waveforms
<img width="1280" height="800" alt="Screenshot (1745)" src="https://github.com/user-attachments/assets/3d0ddd16-783f-4ddf-9b5b-2c9c88c6a838" />

## Hardening Success
The project passed the RTL-to-GDSII hardening cycle with zero violations.

### Build Status
<img width="1280" height="720" alt="Screenshot (1753)" src="https://github.com/user-attachments/assets/c59f0bba-b305-4a8d-86a7-59a5052ce70c" />

---
**Designed by Ahmed Mahmoud - Digital Design & Physical Implementation Engineer.**
