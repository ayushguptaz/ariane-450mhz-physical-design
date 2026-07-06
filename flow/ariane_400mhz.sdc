set sdc_version 2.0

current_design ariane

# 400 MHz target (2.5 ns period)
set core_clock_period 2.5
set input_delay_pct 0.2
set output_delay_pct 0.2

# Create core clock
create_clock -name core_clock -period $core_clock_period [get_ports clk_i]

# Create virtual clock for I/O timing
create_clock -name vclk_core_clock -period $core_clock_period

# Clock latency (estimated from layout)
set_clock_latency 0.535 [get_clocks core_clock]

# Input delays (20% of period)
set input_delay [expr $core_clock_period * $input_delay_pct]
set_input_delay $input_delay -clock vclk_core_clock [all_inputs]

# Output delays (20% of period)
set output_delay [expr $core_clock_period * $output_delay_pct]
set_output_delay $output_delay -clock vclk_core_clock [all_outputs]

# Don't constrain clock and reset
set_input_delay 0 -clock vclk_core_clock [get_ports clk_i]
set_input_delay 0 -clock vclk_core_clock [get_ports rst_ni]
