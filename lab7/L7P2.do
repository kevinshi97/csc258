# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns L7P2_no_vga.v

# Load simulation as the top level simulation module.
vsim L7P2

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {CLOCK_50} 0 0ns, 1 {10ns} -r 20ns
force {KEY[0]} 0;
force {KEY[3]} 0;
force {KEY[1]} 0;
force {stop} 0;
force {SW[6:0]} 7'b1111111;
run 60ns
force {KEY[0]} 1;
force {KEY[1]} 1;
run 60ns

force {KEY[1]} 0;
run 60ns

force {SW[9:7]} 3'b111;
force {SW[6:0]} 7'b0100101;
run 60ns

force {KEY[3]} 1;
run 60ns

force {KEY[3]} 0;
run 60ns

force {KEY[3]} 1;
run 60ns

force {KEY[3]} 0;
run 2000 ns