

//LEDR[9:0] are used to indicate which song the user is on
module Ocarina_Of_Verilog(SW, KEY, CLOCK_50, LEDR, HEX0,
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,
		speaker);   					//	VGA Blue[9:0]);
	input [9:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	
	
	output reg speaker;
	
	reg [30:0] tone;
	always @(posedge CLOCK_50)
		tone <= tone += 1
	
	reg [9:0] clkdivider;
	
	
	output [9:0] LEDR;
	output [6:0] HEX0;	//THE SONG NUMBER WILL BE DISPLAYED
	
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	
	wire ld_song;
	//assign song_choice = 0;
	
	wire resetn;
	assign resetn = ~SW[9];
	
	//Notes
	wire low, midlow, midhigh, high;
	assign low = ~KEY[0];
	assign midlow = ~KEY[1];
	assign midhigh = ~KEY[2];
	assign high = ~KEY[3];
	
	reg [11:0] order; 
	wire [4:0]result;
	wire song1_en, song2_en, song3_en, song4_en, song5_en;
	
	wire song1tune_en, song2tune_en, song3tune_en, song4tune_en, song5tune_en;
	
	assign song1tune_en = 0;
	assign song2tune_en = 0;
	assign song3tune_en = 0;
	assign song4tune_en = 0;
	assign song5tune_en = 0;
	
	wire [2:0] song_num;
	
	localparam 	c			= 512*2-1,
					c_sharp	= 483*2-1,
					d			= 456*2-1,
					d_sharp	= 431*2-1,
					e			= 406*2-1,
					f			= 384*2-1,
					f_sharp	= 362*2-1,
					g			= 342*2-1,
					g_sharp	= 323*2-1,
					a			= 304*2-1,
					a_sharp	= 187*2-1,
					b			= 271*2-1,
					rest		= 0;
	
	zeldaslullaby z(.clk(CLOCK_50),.resetn(resetn),.enable(song1_en),.high(high),.low(low),.midhigh(midhigh),.midlow(midlow),.result(LEDR[2]), .failure(LEDR[1]), .tune(song1tune_en));
	eponasong es(.clk(CLOCK_50),.resetn(resetn),.enable(song2_en),.high(high),.low(low),.midhigh(midhigh),.midlow(midlow),.result(result[1]), .tune(song2tune_en));
	sariasong ss(.clk(CLOCK_50),.resetn(resetn),.enable(song3_en),.high(high),.low(low),.midhigh(midhigh),.midlow(midlow),.result(result[2]), .tune(song3tune_en));
	songofstorms sos(.clk(CLOCK_50),.resetn(resetn),.enable(song4_en),.high(high),.low(low),.midhigh(midhigh),.midlow(midlow),.result(result[3]), .tune(song4tune_en));
	windsrequium wr(.clk(CLOCK_50),.resetn(resetn),.enable(song5_en),.high(high),.low(low),.midhigh(midhigh),.midlow(midlow),.result(result[4]), .tune(song5tune_en));
	
	eponasongtune est(.enable(song1tune_en), .c(c),.c_sharp(c_sharp),.d(d),.d_sharp(d_sharp),.e(e),.f(f),.f_sharp(f_sharp),.g(g),.g_sharp(g_sharp),.a(a),.a_sharp(a_sharp),.b(b),.rest(rest),.clkdivider(clkdivider));
	sariasongtune sst(.enable(song2tune_en), .c(c),.c_sharp(c_sharp),.d(d),.d_sharp(d_sharp),.e(e),.f(f),.f_sharp(f_sharp),.g(g),.g_sharp(g_sharp),.a(a),.a_sharp(a_sharp),.b(b),.rest(rest),.clkdivider(clkdivider));
	songofstormstune sost(.enable(song2tune_en), .c(c),.c_sharp(c_sharp),.d(d),.d_sharp(d_sharp),.e(e),.f(f),.f_sharp(f_sharp),.g(g),.g_sharp(g_sharp),.a(a),.a_sharp(a_sharp),.b(b),.rest(rest),.clkdivider(clkdivider));
	windsrequiemtune wrt(.enable(song2tune_en), .c(c),.c_sharp(c_sharp),.d(d),.d_sharp(d_sharp),.e(e),.f(f),.f_sharp(f_sharp),.g(g),.g_sharp(g_sharp),.a(a),.a_sharp(a_sharp),.b(b),.rest(rest),.clkdivider(clkdivider));
	zeldaslullabytune zlt(.enable(song2tune_en), .c(c),.c_sharp(c_sharp),.d(d),.d_sharp(d_sharp),.e(e),.f(f),.f_sharp(f_sharp),.g(g),.g_sharp(g_sharp),.a(a),.a_sharp(a_sharp),.b(b),.rest(rest),.clkdivider(clkdivider));
	
	lfsr l(.clk(CLOCK_50),.resetn(resetn),.song1_en(song1_en),.song2_en(song2_en),.song3_en(song3_en),.song4_en(song4_en),.song5_en(song5_en),.dank(song_num));
	
	hex_decoder(.hex_digit(song_num), .segments(HEX0));
	
	reg [8:0] counter_note
	always @(posedge clk)
		if(counter_note == 0)
			counter_note <= clkdivider;
		else
			counter_note <= counter_note - 1;
	
	always @(posedge clk)
		if(counter_note == 0)
			speaker <= ~speaker;
			
	
	 always @(*) begin
        case (song_num)
			3'b001: begin
			order = 9'b110100010;
			end
			3'b010: begin end
			3'b011: begin end
			3'b100: begin end
			3'b101: begin end
		endcase
	end
		
	/*
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
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";	
    // Instansiate datapath
	// datapath d0(...);
	*/
	 datapath d(
		.clk(CLOCK_50),
		.order(order),
		.control(ctrl),
		.x(x),
		.y(y),
		.c(colour)
    );

    // Instansiate FSM control
    // control c0(...);

	 control c(
		 .clk(CLOCK_50),
		 .resetn(resetn),
		 .complete(stop),
		 .ctrl(ctrl),
		 .en(writeEn)
    );		
endmodule

module zeldaslullaby (
    input clk,
    input resetn,
	 input enable,
    input high,
	 input low,
	 input midhigh,
	 input midlow,
    output wire result,
	 output wire failure,
	 output wire tune
    );

	
	 
    reg [5:0] current_state, next_state; 
	 
    localparam  NOTE1  		= 4'd0,
					 STANDBY1	= 4'd1,
					 NOTE2  		= 4'd2,
					 STANDBY2 	= 4'd3,
					 NOTE3  		= 4'd4,
					 STANDBY3	= 4'd5,
					 COMPLETE	= 4'd6,
					 FAIL    	= 4'd7;
	 always@(*)
    begin: state_table 
            case (current_state)
					NOTE1: begin
							 if (midhigh && enable) next_state = STANDBY1;
							 else if ((midlow || low || high) && enable) next_state = FAIL;
							 else next_state = NOTE1;
							 end
				STANDBY1: begin
							 if(~midhigh && enable) next_state = NOTE2;
							 else next_state = STANDBY1;
							 end
					NOTE2: begin
							 if (high && enable) next_state = STANDBY2;
							 else if ((low || midhigh || midlow) && enable) next_state = FAIL;
							 else next_state = NOTE2;
							 end
				STANDBY2: begin
							 if(~high && enable) next_state = NOTE3;
							 else next_state = STANDBY2;
							 end
					NOTE3: begin
							 if (midlow && enable) next_state = STANDBY3;
							 else if ((low || midhigh || high) && enable) next_state = FAIL;
							 else next_state = NOTE3;
							 end
				STANDBY3: begin
							 if (~midlow && enable) next_state = COMPLETE;
							 else next_state = STANDBY3;
							 end  		 
            COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
  
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= NOTE1;
        else
            current_state <= next_state;
    end // state_FFS
	 
	 assign result = (next_state == COMPLETE);
	 assign failure = (next_state == FAIL);
	 
endmodule

module eponasong (
    input clk,
    input resetn,
	 input enable,
    input high,
	 input low,
	 input midhigh,
	 input midlow,
    output wire result,
	 output wire tune
    );
	 
    reg [5:0] current_state, next_state; 
	 
    localparam  NOTE1  		= 4'd0,
					 STANDBY1	= 4'd1,
					 NOTE2  		= 4'd2,
					 STANDBY2 	= 4'd3,
					 NOTE3  		= 4'd4,
					 STANDBY3	= 4'd5,
					 COMPLETE	= 4'd6,
					 FAIL    	= 4'd7;
	 always@(*)
    begin: state_table 
            case (current_state)
					NOTE1: begin
							 if (high && enable) next_state = STANDBY1;
							 else if ((midlow || low || midhigh) && enable) next_state = FAIL;
							 else next_state = NOTE1;
							 end
				STANDBY1: begin
							 if(~high && enable) next_state = NOTE2;
							 else next_state = STANDBY1;
							 end
					NOTE2: begin
							 if (midhigh && enable) next_state = STANDBY2;
							 else if ((low || high || midlow) && enable) next_state = FAIL;
							 else next_state = NOTE2;
							 end
				STANDBY2: begin
							 if(~midhigh && enable) next_state = NOTE3;
							 else next_state = STANDBY2;
							 end
					NOTE3: begin
							 if (midlow && enable) next_state = STANDBY3;
							 else if ((low || midhigh || high) && enable) next_state = FAIL;
							 else next_state = NOTE3;
							 end 
				STANDBY3: begin
							 if (~midlow && enable) next_state = COMPLETE;
							 else next_state = STANDBY3;
							 end  
            COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
  
    // current_state registers
    always@(posedge clk)
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
	 input enable,
    input high,
	 input low,
	 input midhigh,
	 input midlow,
    output wire result,
	 output wire tune
    );
	 
    reg [5:0] current_state, next_state; 
	 
    localparam  NOTE1  		= 4'd0,
					 STANDBY1	= 4'd1,
					 NOTE2  		= 4'd2,
					 STANDBY2 	= 4'd3,
					 NOTE3  		= 4'd4,
					 STANDBY3	= 4'd5,
					 COMPLETE	= 4'd6,
					 FAIL    	= 4'd7;
	 always@(*)
    begin: state_table 
            case (current_state)
					NOTE1: begin
							 if (low && enable) next_state = STANDBY1;
							 else if ((midlow || high || midhigh) && enable) next_state = FAIL;
							 else next_state = NOTE1;
							 end
				STANDBY1: begin
							 if(~low && enable) next_state = NOTE2;
							 else next_state = STANDBY1;
							 end
					NOTE2: begin
							 if (midlow && enable) next_state = STANDBY2;
							 else if ((low || high || midhigh) && enable) next_state = FAIL;
							 else next_state = NOTE2;
							 end
				STANDBY2: begin
							 if(~midlow && enable) next_state = NOTE3;
							 else next_state = STANDBY2;
							 end
					NOTE3: begin
							 if (midhigh && enable) next_state = STANDBY3;
							 else if ((low || midlow || high) && enable) next_state = FAIL;
							 else next_state = NOTE3;
							 end
				STANDBY3: begin
							 if (~midhigh && enable) next_state = COMPLETE;
							 else next_state = STANDBY3;
							 end  
            COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
  
    // current_state registers
    always@(posedge clk)
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
	 input enable,
    input high,
	 input low,
	 input midhigh,
	 input midlow,
    output wire result,
	 output wire tune
    );
	 
    reg [5:0] current_state, next_state; 
	 
    localparam  NOTE1  		= 4'd0,
					 STANDBY1	= 4'd1,
					 NOTE2  		= 4'd2,
					 STANDBY2 	= 4'd3,
					 NOTE3  		= 4'd4,
					 STANDBY3	= 4'd5,
					 COMPLETE	= 4'd6,
					 FAIL    	= 4'd7;
	 always@(*)
    begin: state_table 
            case (current_state)
					NOTE1: begin
							 if (low && enable) next_state = STANDBY1;
							 else if ((midlow || high || midhigh)&& enable) next_state = FAIL;
							 else next_state = NOTE1;
							 end
				STANDBY1: begin
							 if(~low && enable) next_state = NOTE2;
							 else next_state = STANDBY1;
							 end
					NOTE2: begin
							 if (midlow && enable) next_state = STANDBY2;
							 else if ((low || high || midhigh)&& enable) next_state = FAIL;
							 else next_state = NOTE2;
							 end
				STANDBY2: begin
							 if(~midlow && enable) next_state = NOTE3;
							 else next_state = STANDBY2;
							 end
					NOTE3: begin
							 if (high && enable) next_state = STANDBY3;
							 else if ((low || midlow || midhigh)&& enable) next_state = FAIL;
							 else next_state = NOTE3;
							 end
				STANDBY3: begin
							 if (~high && enable) next_state = COMPLETE;
							 else next_state = STANDBY3;
							 end  
            COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
  
    // current_state registers
    always@(posedge clk)
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
	 input enable,
    input high,
	 input low,
	 input midhigh,
	 input midlow,
    output wire result,
	 output wire tune
    );
	 
    reg [5:0] current_state, next_state; 
	 
    localparam  NOTE1  		= 4'd0,
					 STANDBY1	= 4'd1,
					 NOTE2  		= 4'd2,
					 STANDBY2 	= 4'd3,
					 NOTE3  		= 4'd4,
					 STANDBY3	= 4'd5,
					 COMPLETE	= 4'd6,
					 FAIL    	= 4'd7;
	 always@(*)
    begin: state_table 
            case (current_state)
					NOTE1: begin
							 if (high && enable) next_state = STANDBY1;
							 else if ((midlow || low || midhigh)&& enable) next_state = FAIL;
							 else next_state = NOTE1;
							 end
				STANDBY1: begin
							 if(~high && enable) next_state = NOTE2;
							 else next_state = STANDBY1;
							 end
					NOTE2: begin
							 if (midlow && enable) next_state = STANDBY2;
							 else if ((low || high || midhigh)&& enable) next_state = FAIL;
							 else next_state = NOTE2;
							 end
				STANDBY2: begin
							 if(~midlow && enable) next_state = NOTE3;
							 else next_state = STANDBY2;
							 end
					NOTE3: begin
							 if (midhigh && enable) next_state = STANDBY3;
							 else if ((low || midlow || high)&& enable) next_state = FAIL;
							 else next_state = NOTE3;
							 end
				STANDBY3: begin
							 if (~midhigh && enable) next_state = COMPLETE;
							 else next_state = STANDBY3;
							 end  
            COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
  
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= NOTE1;
        else
            current_state <= next_state;
    end // state_FFS
	 
	 assign result = (next_state == COMPLETE);
	 
endmodule


module lfsr(
	input clk,
	input resetn,
	//input HEX0,
	
	output reg song1_en,
	output reg song2_en,
	output reg song3_en,
	output reg song4_en,
	output reg song5_en,
	
	output reg [2:0] dank
	);
	
	//reg [2:0] rando;
	initial dank = 3'b001;
	always @(posedge clk) begin
		if(!resetn) begin
			dank <= dank + 1;
			if (dank > 3'b100)
			dank <= 3'b001;
			end
		end
	
	always @(posedge clk) begin
		//begin: song_selection
			case(dank)
				3'b001: 	begin
							song1_en <= 1'b1;
							song2_en <= 1'b0;
							song3_en <= 1'b0;
							song4_en <= 1'b0;
							song5_en <= 1'b0;
							end
				3'b010: 	begin
							song1_en <= 1'b0;
							song2_en <= 1'b1;
							song3_en <= 1'b0;
							song4_en <= 1'b0;
							song5_en <= 1'b0;
							end
				3'b011: 	begin
							song1_en <= 1'b0;
							song2_en <= 1'b0;
							song3_en <= 1'b1;
							song4_en <= 1'b0;
							song5_en <= 1'b0;
							end
				3'b100: 	begin
							song1_en <= 1'b0;
							song2_en <= 1'b0;
							song3_en <= 1'b0;
							song4_en <= 1'b1;
							song5_en <= 1'b0;
							end
				default: begin
							song1_en <= 1'b0;
							song2_en <= 1'b0;
							song3_en <= 1'b0;
							song4_en <= 1'b0;
							song5_en <= 1'b1;
							end
			endcase
		end
endmodule

module eponasongtune(enable, c,c_sharp,d,d_sharp,e,f,f_sharp,g,g_sharp,a,a_sharp,b,rest,clkdivider);
	input enable;
	input [17:0]c;
	input [17:0]c_sharp;
	input [17:0]d;
	input [17:0]d_sharp;
	input [17:0]e;
	input [17:0]f;
	input [17:0]f_sharp;
	input [17:0]g;
	input [17:0]g_sharp;
	input [17:0]a;
	input [17:0]a_sharp;
	input [17:0]b;
	input [17:0]rest;
	output reg [17:0] clkdivider;
	
	reg [4:0] current_state, next_state;
	
	localparam  NOTE1    = 5'd0,
					NOTE2 	= 5'd1,
					NOTE3    = 5'd2,
					NOTE4 	= 5'd3,
					NOTE5    = 5'd4,
					NOTE6 	= 5'd5,
					NOTE7    = 5'd6,
					NOTE8 	= 5'd7,
					NOTE9    = 5'd8,
					NOTE10 	= 5'd9,
					NOTE11   = 5'd10,
					NOTE12 	= 5'd11,
					NOTE13   = 5'd12,
					NOTE14 	= 5'd13,
					NOTE15   = 5'd14,
					NOTE16   = 5'd15,
					NOTE17 	= 5'd16,
					NOTE18   = 5'd17,
					NOTE19 	= 5'd18,
					NOTE20   = 5'd19,
					NOTE21   = 5'd20,
					NOTE22   = 5'd21,
					NOTE23 	= 5'd22,
					NOTE24   = 5'd23,
					FINISH	= 5'd24;
	
	always @(enable)
   begin: state_table 
		case (current_state)
			NOTE1:  next_state = NOTE2; 
         NOTE2:  next_state = NOTE3;
			NOTE3:  next_state = NOTE4;
			NOTE4:  next_state = NOTE5;
			NOTE5:  next_state = NOTE6;
			NOTE6:  next_state = NOTE7;
			NOTE7:  next_state = NOTE8;
			NOTE8:  next_state = NOTE9;
			NOTE9:  next_state = NOTE10;
			NOTE10: next_state = NOTE11;
			NOTE11: next_state = NOTE12;
			NOTE12: next_state = NOTE13;
			NOTE13: next_state = NOTE14;
         NOTE14: next_state = NOTE15;
			NOTE15: next_state = NOTE16;
			NOTE16: next_state = NOTE17;
			NOTE17: next_state = NOTE18;
			NOTE18: next_state = NOTE19;
			NOTE19: next_state = NOTE20;
			NOTE20: next_state = NOTE21;
			NOTE21: next_state = NOTE22;
			NOTE22: next_state = NOTE23;
			NOTE23: next_state = NOTE24;
			NOTE24: next_state = FINISH;
			FINISH: next_state = FINISH;
			default:	next_state = NOTE1;
		endcase
    end // state_table
	 
	always @(enable)
		begin: output_logic 
			case (current_state)
				NOTE1:  clkdivider = d;
				NOTE2:  clkdivider = b;
				NOTE3:  clkdivider = a;
				NOTE4:  clkdivider = a;
				NOTE5:  clkdivider = a;
				NOTE6:  clkdivider = a;
				NOTE7:  clkdivider = d;
				NOTE8:  clkdivider = b;
				NOTE9:  clkdivider = a;
				NOTE10: clkdivider = a;
				NOTE11: clkdivider = a;
				NOTE12: clkdivider = a;
				NOTE13: clkdivider = d;
				NOTE14: clkdivider = b;
				NOTE15: clkdivider = a;
				NOTE16: clkdivider = a;
				NOTE17: clkdivider = b;
				NOTE18: clkdivider = b;
				NOTE19: clkdivider = a;
				NOTE20: clkdivider = a;
				NOTE21: clkdivider = a;
				NOTE22: clkdivider = a;
				NOTE23: clkdivider = rest;
				NOTE24: clkdivider = rest;
				FINISH: clkdivider = rest;
				//default:	clkdivider = NOTE1;	//ALL STATES ARE COVERED IN FSM
			endcase
		 end // state_table
endmodule

module sariasongtune(enable, c,c_sharp,d,d_sharp,e,f,f_sharp,g,g_sharp,a,a_sharp,b,rest,clkdivider);
	input enable;
	input [17:0]c;
	input [17:0]c_sharp;
	input [17:0]d;
	input [17:0]d_sharp;
	input [17:0]e;
	input [17:0]f;
	input [17:0]f_sharp;
	input [17:0]g;
	input [17:0]g_sharp;
	input [17:0]a;
	input [17:0]a_sharp;
	input [17:0]b;
	input [17:0]rest;
	output reg [17:0] clkdivider;
	
	reg [4:0] current_state, next_state;
	
	localparam  NOTE1    = 5'd0,
					NOTE2 	= 5'd1,
					NOTE3    = 5'd2,
					NOTE4 	= 5'd3,
					NOTE5    = 5'd4,
					NOTE6 	= 5'd5,
					NOTE7    = 5'd6,
					NOTE8 	= 5'd7,
					NOTE9    = 5'd8,
					NOTE10 	= 5'd9,
					NOTE11   = 5'd10,
					NOTE12 	= 5'd11,
					NOTE13   = 5'd12,
					NOTE14 	= 5'd13,
					NOTE15   = 5'd14,
					NOTE16   = 5'd15,
					NOTE17 	= 5'd16,
					NOTE18   = 5'd17,
					NOTE19 	= 5'd18,
					NOTE20   = 5'd19,
					NOTE21   = 5'd20,
					NOTE22   = 5'd21,
					NOTE23 	= 5'd22,
					NOTE24   = 5'd23,
					FINISH	= 5'd24;
	
	always @(enable)
   begin: state_table 
		case (current_state)
			NOTE1:  next_state = NOTE2; 
         NOTE2:  next_state = NOTE3;
			NOTE3:  next_state = NOTE4;
			NOTE4:  next_state = NOTE5;
			NOTE5:  next_state = NOTE6;
			NOTE6:  next_state = NOTE7;
			NOTE7:  next_state = NOTE8;
			NOTE8:  next_state = NOTE9;
			NOTE9:  next_state = NOTE10;
			NOTE10: next_state = NOTE11;
			NOTE11: next_state = NOTE12;
			NOTE12: next_state = NOTE13;
			NOTE13: next_state = NOTE14;
         NOTE14: next_state = NOTE15;
			NOTE15: next_state = NOTE16;
			NOTE16: next_state = NOTE17;
			NOTE17: next_state = NOTE18;
			NOTE18: next_state = NOTE19;
			NOTE19: next_state = NOTE20;
			NOTE20: next_state = NOTE21;
			NOTE21: next_state = NOTE22;
			NOTE22: next_state = NOTE23;
			NOTE23: next_state = NOTE24;
			NOTE24: next_state = FINISH;
			FINISH: next_state = FINISH;
			default:	next_state = NOTE1;
		endcase
    end // state_table
	 
	always @(enable)
		begin: output_logic 
			case (current_state)
				NOTE1:  clkdivider = f;
				NOTE2:  clkdivider = a;
				NOTE3:  clkdivider = b;
				NOTE4:  clkdivider = b;
				NOTE5:  clkdivider = f;
				NOTE6:  clkdivider = a;
				NOTE7:  clkdivider = b;
				NOTE8:  clkdivider = b;
				NOTE9:  clkdivider = f;
				NOTE10: clkdivider = a;
				NOTE11: clkdivider = b;
				NOTE12: clkdivider = e;
				NOTE13: clkdivider = d;
				NOTE14: clkdivider = d;
				NOTE15: clkdivider = b;
				NOTE16: clkdivider = c;
				NOTE17: clkdivider = e;
				NOTE18: clkdivider = g;
				NOTE19: clkdivider = e;
				NOTE20: clkdivider = e;
				NOTE21: clkdivider = e;
				NOTE22: clkdivider = e;
				NOTE23: clkdivider = rest;
				NOTE24: clkdivider = rest;
				FINISH: clkdivider = rest;
				//default:	clkdivider = NOTE1;	//ALL STATES ARE COVERED IN FSM
			endcase
		 end // state_table
endmodule

module songofstormstune(enable, c,c_sharp,d,d_sharp,e,f,f_sharp,g,g_sharp,a,a_sharp,b,rest,clkdivider);
	input enable;
	input [17:0]c;
	input [17:0]c_sharp;
	input [17:0]d;
	input [17:0]d_sharp;
	input [17:0]e;
	input [17:0]f;
	input [17:0]f_sharp;
	input [17:0]g;
	input [17:0]g_sharp;
	input [17:0]a;
	input [17:0]a_sharp;
	input [17:0]b;
	input [17:0]rest;
	output reg [17:0] clkdivider;
	
	reg [4:0] current_state, next_state;
	
	localparam  NOTE1    = 5'd0,
					NOTE2 	= 5'd1,
					NOTE3    = 5'd2,
					NOTE4 	= 5'd3,
					NOTE5    = 5'd4,
					NOTE6 	= 5'd5,
					NOTE7    = 5'd6,
					NOTE8 	= 5'd7,
					NOTE9    = 5'd8,
					NOTE10 	= 5'd9,
					NOTE11   = 5'd10,
					NOTE12 	= 5'd11,
					NOTE13   = 5'd12,
					NOTE14 	= 5'd13,
					NOTE15   = 5'd14,
					NOTE16   = 5'd15,
					NOTE17 	= 5'd16,
					NOTE18   = 5'd17,
					NOTE19 	= 5'd18,
					NOTE20   = 5'd19,
					NOTE21   = 5'd20,
					NOTE22   = 5'd21,
					NOTE23 	= 5'd22,
					NOTE24   = 5'd23,
					FINISH	= 5'd24;
	
	always @(enable)
   begin: state_table 
		case (current_state)
			NOTE1:  next_state = NOTE2; 
         NOTE2:  next_state = NOTE3;
			NOTE3:  next_state = NOTE4;
			NOTE4:  next_state = NOTE5;
			NOTE5:  next_state = NOTE6;
			NOTE6:  next_state = NOTE7;
			NOTE7:  next_state = NOTE8;
			NOTE8:  next_state = NOTE9;
			NOTE9:  next_state = NOTE10;
			NOTE10: next_state = NOTE11;
			NOTE11: next_state = NOTE12;
			NOTE12: next_state = NOTE13;
			NOTE13: next_state = NOTE14;
         NOTE14: next_state = NOTE15;
			NOTE15: next_state = NOTE16;
			NOTE16: next_state = NOTE17;
			NOTE17: next_state = NOTE18;
			NOTE18: next_state = NOTE19;
			NOTE19: next_state = NOTE20;
			NOTE20: next_state = NOTE21;
			NOTE21: next_state = NOTE22;
			NOTE22: next_state = NOTE23;
			NOTE23: next_state = NOTE24;
			NOTE24: next_state = FINISH;
			FINISH: next_state = FINISH;
			default:	next_state = NOTE1;
		endcase
    end // state_table
	 
	always @(enable)
		begin: output_logic 
			case (current_state)
				NOTE1:  clkdivider = d;
				NOTE2:  clkdivider = f;
				NOTE3:  clkdivider = d;
				NOTE4:  clkdivider = d;
				NOTE5:  clkdivider = d;
				NOTE6:  clkdivider = d;
				NOTE7:  clkdivider = d;
				NOTE8:  clkdivider = f;
				NOTE9:  clkdivider = d;
				NOTE10: clkdivider = d;
				NOTE11: clkdivider = d;
				NOTE12: clkdivider = d;
				NOTE13: clkdivider = e;
				NOTE14: clkdivider = e;
				NOTE15: clkdivider = e;
				NOTE16: clkdivider = f;
				NOTE17: clkdivider = e;
				NOTE18: clkdivider = f;
				NOTE19: clkdivider = e;
				NOTE20: clkdivider = c;
				NOTE21: clkdivider = a;
				NOTE22: clkdivider = a;
				NOTE23: clkdivider = a;
				NOTE24: clkdivider = a;
				FINISH: clkdivider = rest;
				//default:	clkdivider = NOTE1;	//ALL STATES ARE COVERED IN FSM
			endcase
		 end // state_table
endmodule

module windsrequiemtune(enable, c,c_sharp,d,d_sharp,e,f,f_sharp,g,g_sharp,a,a_sharp,b,rest,clkdivider);
	input enable;
	input [17:0]c;
	input [17:0]c_sharp;
	input [17:0]d;
	input [17:0]d_sharp;
	input [17:0]e;
	input [17:0]f;
	input [17:0]f_sharp;
	input [17:0]g;
	input [17:0]g_sharp;
	input [17:0]a;
	input [17:0]a_sharp;
	input [17:0]b;
	input [17:0]rest;
	output reg [17:0] clkdivider;
	
	reg [4:0] current_state, next_state;
	
	localparam  NOTE1    = 5'd0,
					NOTE2 	= 5'd1,
					NOTE3    = 5'd2,
					NOTE4 	= 5'd3,
					NOTE5    = 5'd4,
					NOTE6 	= 5'd5,
					NOTE7    = 5'd6,
					NOTE8 	= 5'd7,
					NOTE9    = 5'd8,
					NOTE10 	= 5'd9,
					NOTE11   = 5'd10,
					NOTE12 	= 5'd11,
					NOTE13   = 5'd12,
					NOTE14 	= 5'd13,
					NOTE15   = 5'd14,
					NOTE16   = 5'd15,
					NOTE17 	= 5'd16,
					NOTE18   = 5'd17,
					NOTE19 	= 5'd18,
					NOTE20   = 5'd19,
					NOTE21   = 5'd20,
					NOTE22   = 5'd21,
					NOTE23 	= 5'd22,
					NOTE24   = 5'd23,
					FINISH	= 5'd24;
	
	always @(enable)
   begin: state_table 
		case (current_state)
			NOTE1:  next_state = NOTE2; 
         NOTE2:  next_state = NOTE3;
			NOTE3:  next_state = NOTE4;
			NOTE4:  next_state = NOTE5;
			NOTE5:  next_state = NOTE6;
			NOTE6:  next_state = NOTE7;
			NOTE7:  next_state = NOTE8;
			NOTE8:  next_state = NOTE9;
			NOTE9:  next_state = NOTE10;
			NOTE10: next_state = NOTE11;
			NOTE11: next_state = NOTE12;
			NOTE12: next_state = NOTE13;
			NOTE13: next_state = NOTE14;
         NOTE14: next_state = NOTE15;
			NOTE15: next_state = NOTE16;
			NOTE16: next_state = NOTE17;
			NOTE17: next_state = NOTE18;
			NOTE18: next_state = NOTE19;
			NOTE19: next_state = NOTE20;
			NOTE20: next_state = NOTE21;
			NOTE21: next_state = NOTE22;
			NOTE22: next_state = NOTE23;
			NOTE23: next_state = NOTE24;
			NOTE24: next_state = FINISH;
			FINISH: next_state = FINISH;
			default:	next_state = NOTE1;
		endcase
    end // state_table
	 
	always @(enable)
		begin: output_logic 
			case (current_state)
				NOTE1:  clkdivider = a;
				NOTE2:  clkdivider = a;
				NOTE3:  clkdivider = a;
				NOTE4:  clkdivider = a;
				NOTE5:  clkdivider = a;
				NOTE6:  clkdivider = a;
				NOTE7:  clkdivider = a;
				NOTE8:  clkdivider = a;
				NOTE9:  clkdivider = b;
				NOTE10: clkdivider = b;
				NOTE11: clkdivider = b;
				NOTE12: clkdivider = b;
				NOTE13: clkdivider = b;
				NOTE14: clkdivider = b;
				NOTE15: clkdivider = b;
				NOTE16: clkdivider = b;
				NOTE17: clkdivider = a;
				NOTE18: clkdivider = a;
				NOTE19: clkdivider = a;
				NOTE20: clkdivider = a;
				NOTE21: clkdivider = a;
				NOTE22: clkdivider = a;
				NOTE23: clkdivider = a;
				NOTE24: clkdivider = a;
				FINISH: clkdivider = a;
				//default:	clkdivider = NOTE1;	//ALL STATES ARE COVERED IN FSM
			endcase
		 end // state_table
endmodule

module zeldaslullabytune(enable, c,c_sharp,d,d_sharp,e,f,f_sharp,g,g_sharp,a,a_sharp,b,rest,clkdivider);
	input enable;
	input [17:0]c;
	input [17:0]c_sharp;
	input [17:0]d;
	input [17:0]d_sharp;
	input [17:0]e;
	input [17:0]f;
	input [17:0]f_sharp;
	input [17:0]g;
	input [17:0]g_sharp;
	input [17:0]a;
	input [17:0]a_sharp;
	input [17:0]b;
	input [17:0]rest;
	output reg [17:0] clkdivider;
	
	reg [4:0] current_state, next_state;
	
	localparam  NOTE1    = 5'd0,
					NOTE2 	= 5'd1,
					NOTE3    = 5'd2,
					NOTE4 	= 5'd3,
					NOTE5    = 5'd4,
					NOTE6 	= 5'd5,
					NOTE7    = 5'd6,
					NOTE8 	= 5'd7,
					NOTE9    = 5'd8,
					NOTE10 	= 5'd9,
					NOTE11   = 5'd10,
					NOTE12 	= 5'd11,
					NOTE13   = 5'd12,
					NOTE14 	= 5'd13,
					NOTE15   = 5'd14,
					NOTE16   = 5'd15,
					NOTE17 	= 5'd16,
					NOTE18   = 5'd17,
					NOTE19 	= 5'd18,
					NOTE20   = 5'd19,
					NOTE21   = 5'd20,
					NOTE22   = 5'd21,
					NOTE23 	= 5'd22,
					NOTE24   = 5'd23,
					FINISH	= 5'd24;
	
	always @(enable)
   begin: state_table 
		case (current_state)
			NOTE1:  next_state = NOTE2; 
         NOTE2:  next_state = NOTE3;
			NOTE3:  next_state = NOTE4;
			NOTE4:  next_state = NOTE5;
			NOTE5:  next_state = NOTE6;
			NOTE6:  next_state = NOTE7;
			NOTE7:  next_state = NOTE8;
			NOTE8:  next_state = NOTE9;
			NOTE9:  next_state = NOTE10;
			NOTE10: next_state = NOTE11;
			NOTE11: next_state = NOTE12;
			NOTE12: next_state = NOTE13;
			NOTE13: next_state = NOTE14;
         NOTE14: next_state = NOTE15;
			NOTE15: next_state = NOTE16;
			NOTE16: next_state = NOTE17;
			NOTE17: next_state = NOTE18;
			NOTE18: next_state = NOTE19;
			NOTE19: next_state = NOTE20;
			NOTE20: next_state = NOTE21;
			NOTE21: next_state = NOTE22;
			NOTE22: next_state = NOTE23;
			NOTE23: next_state = NOTE24;
			NOTE24: next_state = FINISH;
			FINISH: next_state = FINISH;
			default:	next_state = NOTE1;
		endcase
    end // state_table
	 
	always @(enable)
		begin: output_logic 
			case (current_state)
				NOTE1:  clkdivider = b;
				NOTE2:  clkdivider = b;
				NOTE3:  clkdivider = b;
				NOTE4:  clkdivider = b;
				NOTE5:  clkdivider = d;
				NOTE6:  clkdivider = d;
				NOTE7:  clkdivider = a;
				NOTE8:  clkdivider = a;
				NOTE9:  clkdivider = a;
				NOTE10: clkdivider = a;
				NOTE11: clkdivider = g;
				NOTE12: clkdivider = a;
				NOTE13: clkdivider = b;
				NOTE14: clkdivider = b;
				NOTE15: clkdivider = b;
				NOTE16: clkdivider = b;
				NOTE17: clkdivider = d;
				NOTE18: clkdivider = d;
				NOTE19: clkdivider = a;
				NOTE20: clkdivider = a;
				NOTE21: clkdivider = a;
				NOTE22: clkdivider = a;
				NOTE23: clkdivider = a;
				NOTE24: clkdivider = a;
				FINISH: clkdivider = rest;
				//default:	clkdivider = NOTE1;	//ALL STATES ARE COVERED IN FSM
			endcase
		 end // state_table
endmodule

