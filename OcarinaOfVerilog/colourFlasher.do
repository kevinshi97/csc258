# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns colourFlasher.v

# Load simulation as the top level simulation module.
vsim colourFlasher

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {CLOCK_50} 0 0ns, 1 {1ns} -r 2ns
force {KEY[1]} 1;
force {stop} 0;
force {SW[8]} 0;
run 600ns

force {SW[8]} 1;
run 60ns

force {SW[9]} 1;
run 60ns

force {SW[9]} 0;
run 60ns

force {KEY[3]} 1;
run 60ns

force {SW[9]} 1;
run 10000 ns