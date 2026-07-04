set sdc_version 2.0

current_design ariane

# Clock only — no I/O delays, no latency
# Purpose: prove reg-to-reg timing cannot close at 450 MHz
create_clock -name core_clock -period 2.222 [get_ports clk_i]
