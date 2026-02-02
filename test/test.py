import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Moore FSM test")

    # Clock: 10 us period (100 kHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Initial conditions
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Hold reset
    await ClockCycles(dut.clk, 2)

    # Release reset
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # x1 stimulus
    x1_sequence = [0,1,1,0,1,1,0,1,0,1]

    for x1 in x1_sequence:
        dut.ui_in[0].value = x1
        await RisingEdge(dut.clk)

        state = dut.uo_out[2:0].value
        z1    = dut.uo_out[3].value

        dut._log.info(
            f"x1={x1} | state={state.binstr} | z1={int(z1)}"
        )

    await ClockCycles(dut.clk, 5)
    dut._log.info("Moore FSM test complete")
