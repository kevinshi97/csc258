//Zelda's Lullaby

module Ocarina_Of_Verilog (SW, KEY, LEDR, CLOCK_50);
	input  [9:0] SW;
	input CLOCK_50;
	input  [3:0] KEY;
	output [9:0] LEDR;
	
	wire out_light;
	wire out_light2;
	
	zeldaslullaby z(.clk(CLOCK_50), .resetn(SW[9]), .high(KEY[3]), .low(KEY[0]), .midhigh(KEY[2]), .midlow(KEY[1]), .result(out_light));
	eponasong saria(.clk(CLOCK_50), .resetn(SW[9]), .high(KEY[3]), .low(KEY[0]), .midhigh(KEY[2]), .midlow(KEY[1]), .result(out_light2));

	 
endmodule

module zeldaslullaby (
    input clk,
    input resetn,
    input high,
	 input low,
	 input midhigh,
	 input midlow,
    output wire result
    );

	 wire wire1;
	 RateDiv rdiv(wire1, CLOCK_50); // get the shift speed from RateDivider 
	 
    reg [5:0] current_state, next_state; 
	 
      localparam  NOTE1        = 4'd0,
                NOTE2  = 4'd1,
                NOTE3        = 4'd2,
                COMPLETE   = 4'd3,
                FAIL     = 4'd4;
    
    // logic is timing based
    always@(*)
    begin: state_table 
            case (current_state)
                NOTE1: next_state = midhigh ? NOTE2 : FAIL; // Loop in current state until value is input
                NOTE2: next_state = high ? NOTE3 : FAIL; // Loop in current state until go signal goes low
                NOTE3: next_state = midlow ? COMPLETE : FAIL; // Loop in current state until value is input
                COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:     next_state = NOTE1;
        endcase
    end // state_table
   
	
	/*
		always@(*)
    begin: state_table 
            case (current_state)
                NOTE1: begin
                   if (midhigh) next_state = NOTE2;
					else if (midlow || low || high) next_state = FAIL;
                   else next_state = NOTE1;
				end
				NOTE2: begin
                   if (high) next_state = NOTE3;
				   else if (low || midhigh || midlow) next_state = FAIL;
                   else next_state = NOTE2;
				end               
				NOTE3: begin
                   if (midlow) next_state = COMPLETE;
				   else if (low || midhigh || high) next_state = FAIL;
                   else next_state = NOTE3;
				end    
                COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
	 */
   
    // current_state registers
    always@(posedge wire1)
    begin: state_FFs
        if(!resetn)
            current_state <= NOTE1;
        else
            current_state <= next_state;
    end // state_FFS
	 
	 assign result = (next_state == COMPLETE);
	 
endmodule


module eponasong (
    input clk,
    input resetn,
    input high,
	 input low,
	 input midhigh,
	 input midlow,
	 output [9:0] LEDR,
    output wire result
    );

	 wire wire1;
	 RateDiv rdiv(wire1, CLOCK_50); // get the shift speed from RateDivider 
	 
    reg [5:0] current_state, next_state; 
	 
    localparam  NOTE1 = 4'd0, NOTE2 = 4'd1, NOTE3 = 4'd2, COMPLETE = 4'd3, FAIL = 4'd4;
    
    // logic is timing based
 	 always@(*)
    begin: state_table 
            case (current_state)
                NOTE1: next_state = high ? NOTE2 : FAIL; // Loop in current state until value is input
                NOTE2: next_state = midhigh ? NOTE3 : FAIL; // Loop in current state until go signal goes low
                NOTE3: next_state = midlow ? COMPLETE : FAIL; // Loop in current state until value is input
                COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:     next_state = NOTE1;
        endcase
    end // state_table
	
   /*
	always@(*)
    begin: state_table 
            case (current_state)
                NOTE1: begin
                   if (high) next_state = NOTE2;
					else if (midlow || low || midhigh) next_state = FAIL;
                   else next_state = NOTE1;
				end
				NOTE2: begin
                   if (midhigh) next_state = NOTE3;
				   else if (low || high || midlow) next_state = FAIL;
                   else next_state = NOTE2;
				end               
				NOTE3: begin
                   if (midlow) next_state = COMPLETE;
				   else if (low || midhigh || high) next_state = FAIL;
                   else next_state = NOTE3;
				end    
                COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
	 */
   
    // current_state registers
    always@(posedge wire1)
    begin: state_FFs
        if(!resetn)
            current_state <= NOTE1;
        else
            current_state <= next_state;
    end // state_FFS
	 
	 assign result = (next_state == COMPLETE);

	 
endmodule

module sariasong (
    input clk,
    input resetn,
    input high,
	 input low,
	 input midhigh,
	 input midlow,
	 output [9:0] LEDR,
    output wire result
    );

	 wire wire1;
	 RateDiv rdiv(wire1, CLOCK_50); // get the shift speed from RateDivider 
	 
    reg [5:0] current_state, next_state; 
	 
    localparam  NOTE1 = 4'd0, NOTE2 = 4'd1, NOTE3 = 4'd2, COMPLETE = 4'd3, FAIL = 4'd4;
    
	 always@(*)
    begin: state_table 
            case (current_state)
                NOTE1: next_state = low ? NOTE2 : FAIL; // Loop in current state until value is input
                NOTE2: next_state = midlow ? NOTE3 : FAIL; // Loop in current state until go signal goes low
                NOTE3: next_state = midhigh ? COMPLETE : FAIL; // Loop in current state until value is input
                COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:     next_state = NOTE1;
        endcase
    end // state_table
	
	/*
	always@(*)
    begin: state_table 
            case (current_state)
                NOTE1: begin
                   if (low) next_state = NOTE2;
						 else if (midlow || midhigh || high) next_state = FAIL;
                   else next_state = NOTE1;
					 end
					NOTE2: begin
                   if (midlow) next_state = NOTE3;
						 else if (low || midhigh || high) next_state = FAIL;
                   else next_state = NOTE2;
					 end               
					 NOTE3: begin
                   if (midhigh) next_state = COMPLETE;
						 else if (low || midlow || high) next_state = FAIL;
                   else next_state = NOTE3;
					 end    
                COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
   */
   
    // current_state registers
    always@(posedge wire1)
    begin: state_FFs
        if(!resetn)
            current_state <= NOTE1;
        else
            current_state <= next_state;
    end // state_FFS
	 
	 assign result = (next_state == COMPLETE);

	 
endmodule


module songofstorms (
    input clk,
    input resetn,
    input high,
	 input low,
	 input midhigh,
	 input midlow,
	 output [9:0] LEDR,
    output wire result
    );

	 wire wire1;
	 RateDiv rdiv(wire1, CLOCK_50); // get the shift speed from RateDivider 
	 
    reg [5:0] current_state, next_state; 
	 
    localparam  NOTE1 = 4'd0, NOTE2 = 4'd1, NOTE3 = 4'd2, COMPLETE = 4'd3, FAIL = 4'd4;
    
	 always@(*)
    begin: state_table 
            case (current_state)
                NOTE1: next_state = low ? NOTE2 : FAIL; // Loop in current state until value is input
                NOTE2: next_state = midlow ? NOTE3 : FAIL; // Loop in current state until go signal goes low
                NOTE3: next_state = high ? COMPLETE : FAIL; // Loop in current state until value is input
                COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:     next_state = NOTE1;
        endcase
    end // state_table
	
	/*
	always@(*)
    begin: state_table 
            case (current_state)
                NOTE1: begin
                   if (low) next_state = NOTE2;
					else if (midlow || high || midhigh) next_state = FAIL;
                   else next_state = NOTE1;
				end
				NOTE2: begin
                   if (midlow) next_state = NOTE3;
				   else if (low || high || midhigh) next_state = FAIL;
                   else next_state = NOTE2;
				end               
				NOTE3: begin
                   if (high) next_state = COMPLETE;
				   else if (low || midhigh || midlow) next_state = FAIL;
                   else next_state = NOTE3;
				end    
                COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
	 */

   
    // current_state registers
    always@(posedge wire1)
    begin: state_FFs
        if(!resetn)
            current_state <= NOTE1;
        else
            current_state <= next_state;
    end // state_FFS
	 
	 assign result = (next_state == COMPLETE);
	 
endmodule


module windsrequium (
    input clk,
    input resetn,
    input high,
	 input low,
	 input midhigh,
	 input midlow,
	 output [9:0] LEDR,
    output wire result
    );

	 wire wire1;
	 RateDiv rdiv(wire1, CLOCK_50); // get the shift speed from RateDivider 
	 
    reg [5:0] current_state, next_state; 
	 
    localparam  NOTE1 = 4'd0, NOTE2 = 4'd1, NOTE3 = 4'd2, COMPLETE = 4'd3, FAIL = 4'd4;
    
	 always@(*)
    begin: state_table 
            case (current_state)
                NOTE1: next_state = high ? NOTE2 : FAIL; // Loop in current state until value is input
                NOTE2: next_state = midlow ? NOTE3 : FAIL; // Loop in current state until go signal goes low
                NOTE3: next_state = midhigh ? COMPLETE : FAIL; // Loop in current state until value is input
                COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default: next_state = NOTE1;
        endcase
    end // state_table
	
   
	   /*
	always@(*)
    begin: state_table 
            case (current_state)
                NOTE1: begin
                   if (high) next_state = NOTE2;
					else if (midlow || low || midhigh) next_state = FAIL;
                   else next_state = NOTE1;
				end
				NOTE2: begin
                   if (midlow) next_state = NOTE3;
				   else if (low || high || midhigh) next_state = FAIL;
                   else next_state = NOTE2;
				end               
				NOTE3: begin
                   if (midhigh) next_state = COMPLETE;
				   else if (low || midlow || high) next_state = FAIL;
                   else next_state = NOTE3;
				end    
                COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
	 */
   
    // current_state registers
    always@(posedge wire1)
    begin: state_FFs
        if(!resetn)
            current_state <= NOTE1;
        else
            current_state <= next_state;
    end // state_FFS
	 
	 assign result = (next_state == COMPLETE);
	 
endmodule

module RateDiv(en, clk);
	input clk;
	output en;
	
	assign en = (q == 0) ? 1 : 0;
	
	reg [31:0] q = 32'b0000_1011_1110_1011_1100_0001_1111; // countdown number (12,500,000 - 1); rate = 1/4 second
	
	always @(posedge clk)
		begin
			if (q == 0) q <= 32'b0000_1011_1110_1011_1100_0001_1111;
			else q <= q - 1;
		end
endmodule

