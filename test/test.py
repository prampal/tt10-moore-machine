import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Moore FSM test")

    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Init
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 2)

    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    x1_sequence = [0,1,1,0,1,1,0,1,0,1]

    for x1 in x1_sequence:
        dut.ui_in[0].value = x1
        await RisingEdge(dut.clk)

        uo = dut.uo_out.value.integer
        state = uo & 0b111
        z1    = (uo >> 3) & 0x1

        dut._log.info(
            f"x1={x1} | state={state:03b} | z1={z1}"
        )

    await ClockCycles(dut.clk, 5)
    dut._log.info("Moore FSM test complete ✅")
