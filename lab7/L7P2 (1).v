// Part 2 skeleton

module L7P2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	 datapath d0(.clock(CLOCK_50),
	 .resetn(reset_n),
	 .data_in(SW[6:0]),
	 .colourIn(SW[9:7]),
	 .ld_x(load_x),
	 .ld_y(load_y),
	 .ld_colour(colour),
	 .enable(count),
	 .ld_r_x(ld_result_x),
	 .ld_r_y(ld_result_y),
	 .data_result_x(x),
	 .data_result_y(y),
	 .colour(colour),
	 .stop(stop)
	 ) ;

    // Instansiate FSM control
    control c0(.clk(CLOCK_50),
	 .resetn(resetn),
	 .xstuff(KEY[1]),
	 .plot(KEY[3]),
	 .stop(stop),
	 .load_x(load_x),
	 .load_y(load_y), 
	 .count(count), 
	 .ld_result_x(ld_result_x),
	 .ld_result_y(ld_result_y), 
	 .load_col(load_col),
	 .enable(writeEn)
	 );
    
endmodule

module datapath(
	input clock,
	input resetn,
	input [6:0] data_in,
	input [2:0] colourIn, 
	input ld_x, ld_y, ld_colour, enable,
	input ld_r_x, ld_r_y,
	output reg [7:0] data_result_x,
	output reg [6:0] data_result_y,
	output reg [2:0] colour,
	output reg stop
);
	
	// register inputs
	reg[6:0] x;
	reg[6:0] y;

	reg[3:0] count;
	
	always @ (posedge clock) begin
        if (!resetn) begin
            x <= 8'd0; 
            y <= 7'd0;
				colour <= 3'b0;
        end
        else begin
				if (ld_x)
					x <= data_in;
				if(ld_y)
					y <= data_in;
				if(ld_colour)
					colour <= colourIn;
			end
    end
 
 
	 always @ (posedge clock) begin
		if (!resetn)
			begin
				count <= 4'b0000;
				stop <= 0;
			end
		if (enable)
			begin
				if (count == 4'b1111) begin
					count <= 0;
					stop <= 1;
				end
				else begin
					count <= count + 1'b1;
					stop <= 0;
				end
			end
	end
	 
	 
    // Output result register
    always @ (posedge clock) begin
        if (!resetn) begin
            data_result_x <= 8'd0; 
				data_result_y <= 7'd0; 
        end
        else begin
				if (ld_r_x)
					data_result_x <= x + count[1:0]; // make x 8 bits
				if (ld_r_y)
					data_result_y <= y + count[3:2];
		  end
    end
endmodule

module control(
    input clk,
    input resetn,
    input xstuff,
	 input plot,
	 input stop,
    output reg load_x, load_y, count, ld_result_x, ld_result_y, load_col, enable
    );

    reg [5:0] current_state, next_state; 
    
    localparam  S_LOAD_X        = 4'd0,
                S_LOAD_X_WAIT   = 4'd1,
                S_LOAD_Y        = 4'd2,
                S_LOAD_Y_WAIT   = 4'd3,
                S_CYCLE_0       = 4'd4,
                S_CYCLE_1       = 4'd5;
 
    
    // Next state logic aka our state table ????
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_X: next_state = xstuff ? S_LOAD_X_WAIT : S_LOAD_X; // Loop in current state until value is input
                S_LOAD_X_WAIT: next_state = xstuff ? S_LOAD_X_WAIT : S_LOAD_Y; // Loop in current state until go signal goes low
                S_LOAD_Y: next_state = plot ? S_LOAD_Y_WAIT : S_LOAD_Y; // Loop in current state until value is input
                S_LOAD_Y_WAIT: next_state = plot ? S_LOAD_Y_WAIT : S_CYCLE_0; // Loop in current state until go signal goes low
                S_CYCLE_0: next_state = S_CYCLE_1;
                S_CYCLE_1: next_state = stop ? S_LOAD_X : S_CYCLE_0; // we will be done our two operations, start over after
            default:     next_state = S_LOAD_X;
        endcase
    end // state_table
   

    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        load_x = 1'b0;
        load_y = 1'b0;
        count = 1'b0;
		  ld_result_x = 1'b0;
		  ld_result_y = 1'b0;
		  enable = 1'b0;
		  load_col = 1'b0;

        case (current_state)
            S_LOAD_X: begin
                load_x = 1'b1;
                end
            S_LOAD_Y: begin
                load_y = 1'b1;
					 load_col = 1'b1;
                end
            S_CYCLE_0: begin
				    ld_result_x = 1'b1;
					 ld_result_y = 1'b1;
					end
            S_CYCLE_1: begin
					 enable = 1'b1;
					 count = 1'b1;
					end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_X;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

