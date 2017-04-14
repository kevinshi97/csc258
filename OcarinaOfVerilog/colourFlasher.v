// Part 2 skeleton

module colourFlasher
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
	assign resetn = SW[8];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	
	/*
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

			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "64x64";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
	*/

	 wire [2:0] colourIn;
	 
	 getColour g(.HIGH(KEY[3]), .LOW(KEY[0]), .MIDLOW(KEY[1]), .MIDHIGH(KEY[2]), .clk(CLOCK_50), .colourOut(colourIn));
	 
	 
    // Instansiate datapath
	// datapath d0(...);
	 datapath d(
		.clk(CLOCK_50),
		.resetn(resetn),
		.col_in(colourIn),
		.count(count),
		.ld_col(ld_col),
		.result_x(x),
		.result_y(y),
		.col(colour),
		.stop(stop)
    );
	
    // Instansiate FSM control
    // control c0(...);
	 control c(
		 .clk(CLOCK_50),
		 .resetn(resetn),
		 .draw(SW[9]),
		 .stop(stop),
		 .count(count),
		 .ld_col(ld_col),
		 .en(writeEn)
    );
    
endmodule

module getColour(
	input HIGH, MIDHIGH, MIDLOW, LOW, clk,
	output [2:0] colourOut
);
	reg [2:0] temp;
	

	always @(posedge clk)
    begin: colourchooser
       if(LOW == 1'b1)
            temp <=  3'b001; 
       else if(MIDLOW == 1'b1)
            temp <=  3'b010; 
		 else if(MIDHIGH == 1'b1)
				temp <=  3'b100; 
		 else if(HIGH == 1'b1)
				temp <=  3'b110; 
		 else
			temp <= 3'b111;
    end // State Register
	
	assign colourOut[2:0] = temp[2:0];
	
endmodule

module control(
    input clk,
    input resetn,
	input draw,
	input stop,

    output reg   count, en, ld_col
	 //output reg x_out, y_out, col_out
    );

    reg [5:0] current_state, next_state; 
    
    localparam  S_LOAD_COLOUR        = 3'd0,
                S_LOAD_COLOUR_WAIT  = 3'd1,
                S_CYCLE_0        = 3'd3;
    
    // Next state logic aka our state table
    always @(*)
    begin: state_table 
            case (current_state)
                S_LOAD_COLOUR: next_state = draw ? S_LOAD_COLOUR_WAIT : S_LOAD_COLOUR; // Loop in current state until value is input
                S_LOAD_COLOUR_WAIT: next_state = draw ? S_LOAD_COLOUR_WAIT : S_CYCLE_0; // Loop in current state until go signal goes low
                S_CYCLE_0: next_state = stop ? S_LOAD_COLOUR : S_CYCLE_0;
            default:     next_state = S_LOAD_COLOUR;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        count = 1'b0;
		 en = 1'b0;
		 ld_col = 1'b0;
        case (current_state)
            S_LOAD_COLOUR: begin
				ld_col = 1'b1;
               end
            S_CYCLE_0: begin
					 en = 1'b1;
					 count = 1'b1;
            end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_COLOUR;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input clk,
    input resetn,
	 input [2:0] col_in,
    input count, ld_col,
    output reg [6:0] result_x, result_y,
	 output reg [2:0] col,
	 output reg stop
    );
    
    // input registers
    reg [6:0] x, y;
    reg [7:0] c;
    
    // Registers a, b, c, x with respective input logic
    always@(posedge clk) begin
        if(!resetn) begin
            x <= 7'b0; 
            y <= 7'b0;
				col <= 3'b0;
        end
        else begin
           if(ld_col)
              col <= col_in;
        end
    end
 
	// counter
 	always @ (posedge clk)
	begin
		if (!resetn)
			begin
				c <= 8'b00000000;
				stop <= 0;
			end
		if (count) 
		begin
			if (c == 8'b11111111) begin
				c <= 0;
				stop <= 1;
				end
			else begin
				c <= c + 1'b1;
				stop <= 0;
				end
		end
	end
 
    // Output result register
    always@(posedge clk) begin
        if(!resetn) begin
            result_x <= 7'b0;
			result_y <= 7'b0;
        end
        else begin
         result_x <= x + c[3:0];
			result_y <= y + c[7:4];
		  end
    end

endmodule
