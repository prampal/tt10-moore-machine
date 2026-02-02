# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Initial conditions
dut.ena.value = 1 # required for Tiny Tapeout
dut.ui_in.value = 0
dut.uio_in.value = 0
dut.rst_n.value = 0
# Wait for a few clock cycles with reset low
await ClockCycles(dut.clk, 2)
# Release reset
dut.rst_n.value = 1
await RisingEdge(dut.clk)
# Define x1 stimulus sequence (bit 0 of ui_in)
x1_sequence = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1,
0]
for x1 in x1_sequence:
dut.ui_in[0].value = x1
dut._log.info(f"x1={x1}, y={dut.uo_out.value},
z1={dut.uio_out[0].value}")
await RisingEdge(dut.clk)
# Extra clock cycles to allow state settling
await ClockCycles(dut.clk, 5)
dut._log.info("Finished Moore SSM test")
