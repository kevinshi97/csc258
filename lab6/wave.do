# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns sequence_detector.v

# Load simulation using mux as the top level simulation module.
vsim sequence_detector

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


force {SW[1]} 1
force {SW[0]} 0
force {KEY[0]} 0
run 2 ns
force {KEY[0]} 1
run 2 ns

force {KEY[0]} 0
run 2 ns
force {KEY[0]} 1
run 2 ns

force {KEY[0]} 0
run 2 ns
force {KEY[0]} 1
run 2 ns

force {KEY[0]} 0
run 2 ns
force {KEY[0]} 1
run 2 ns

force {KEY[0]} 0
run 2 ns
force {KEY[0]} 1
run 2 ns

force {KEY[0]} 0
run 2 ns
force {KEY[0]} 1
run 2 ns

force {KEY[0]} 0
run 1 ns
force {KEY[0]} 1
run 1 ns

force {KEY[0]} 0
run 1 ns
force {KEY[0]} 1
run 1 ns
force {KEY[0]} 0
run 1 ns
force {SW[1]} 0
force {KEY[0]} 1
run 1 ns
force {KEY[0]} 0
run 1 ns
force {KEY[0]} 1
run 1 ns
force {KEY[0]} 0
run 1 ns
force {KEY[0]} 1
run 1 ns
force {KEY[0]} 0
run 1 ns
force {KEY[0]} 1
run 1 ns
force {KEY[0]} 0
run 1 ns
force {KEY[0]} 1
run 1 ns

force {SW[0]} 0

force {KEY[0]} 0
run 5 ns
force {KEY[0]} 1
run 5 ns

force {SW[0]} 1

force {KEY[0]} 0
run 5 ns
force {KEY[0]} 1
run 5 ns

force {SW[1]} 0
force {KEY[0]} 0
run 2 ns
force {KEY[0]} 1
run 2 ns

force {SW[1]} 1
force {KEY[0]} 0
run 2 ns
force {KEY[0]} 1
run 2 ns
force {KEY[0]} 0
run 2 ns
force {KEY[0]} 1
run 2 ns