set sdc_version 2.0

current_design ariane

set clk_name core_clock
set clk_port_name clk_i
set clk_period 2.222
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]

# Primary clock — 450 MHz
create_clock -name $clk_name -period $clk_period $clk_port

# Virtual clock for I/O timing
set clk_io_name vclk_$clk_name
create_clock -name $clk_io_name -period $clk_period

# Clock source latency
set_clock_latency 0.535 [get_clocks $clk_name]
set_clock_latency 0.535 [get_clocks $clk_io_name]

# I/O delays — 20% of clock period
set non_clock_inputs [all_inputs -no_clocks]
set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_io_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_io_name [all_outputs]
