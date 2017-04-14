

//LEDR[9:0] are used to indicate which song the user is on
module OcarinaOfVerilog(SW, KEY, CLOCK_50, LEDR, HEX0);
	input [9:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	
	output [9:0] LEDR;
	output [6:0] HEX0;	//THE SONG NUMBER WILL BE DISPLAYED
	
	wire ld_song;
	wire [1:0] song_choice;
	
	wire resetn;
	assign resetn = SW[9];
	
	wire low, midlow, midhigh, high;
	
	/*These paramaters represent which song is to be played
					zl	= 4'b0000;	//Zeldas Lullaby
					es = 4'd0001;	//Epona Song
					ss = 4'b0010;	//Saria Song
					sos= 4'b0011;	//Song of Storms
					wr	= 4'b0100;	//Winds Reqrium
	*/			
	/*Used to determine when we need to switch songs				
					select_song_state = 1'b0;
					play_song_state	= 1'b1;
	*/
	assign song_choice = 3'b00;
	
	hex_decoder H0(.hex_digit(song_choice[2:0]), .segments(HEX0));
	
	
	controler C0(
        .clk(CLOCK_50),
        .resetn(resetn),
		  .song_choice(song_choice),
		  .low(low),
		  .midlow(midlow),
		  .midhigh(midhigh),
		  .high(high),
		  .result(LEDR[9])
		  //.result(ld_song)
    );
	 
	datapathest d0(.clk(CLOCK_50),
	.resetn(resetn),
	//.ld_song(ld_song),
   .KEY(KEY[3:0]),
   .song_choice(song_choice),
	.low(low),
	.midlow(midlow),
	.midhigh(midlow),
	.high(high)
   );
endmodule

module controler(
   input clk,
   input resetn,
	input [2:0] song_choice,	//Song choice from 0 to 4
   input low,
	input midlow,
	input midhigh,
	input high,
   output wire result
   );
	 
	/*These are the keys that are to be pressed, each indicates a note
	wire low, midlow, midhigh, high;
	assign 	low = ~KEY[0];
				midlow = ~KEY[1];
				midhigh = ~KEY[2];
				high = ~KEY[3];
	*/
	
	always@(*)
	begin: songtable
		case(song_choice[2:0])
		/*
			3'b000: begin
						zeldaslullaby z(.clk(clk), 
								.resetn(resetn), 
								.high(high), 
								.low(low), 
								.midhigh(midhigh), 
								.midlow(midlow), 
								.result(result));
						end
			3'b001: begin
						eponasong es(
								.clk(clk), 
								.resetn(resetn), 
								.high(high), 
								.low(low), 
								.midhigh(midhigh), 
								.midlow(midlow), 
								.result(result));
						end
			3'b010: begin
						sariasong ss(
								.clk(clk), 
								.resetn(resetn), 
								.high(high), 
								.low(low), 
								.midhigh(midhigh), 
								.midlow(midlow), 
								.result(result));
						end
			3'b011: begin
						songofstorms sos(
								.clk(clk), 
								.resetn(resetn), 
								.high(high), 
								.low(low), 
								.midhigh(midhigh), 
								.midlow(midlow), 
								.result(result));
						end
			3'b100: begin
						windsrequium wr(
								.clk(clk), 
								.resetn(resetn), 
								.high(high), 
								.low(low), 
								.midhigh(midhigh), 
								.midlow(midlow), 
								.result(result));
						end
						*/
			default: begin end
		endcase
	end
endmodule


module datapathest(
   input clk,
	input resetn,
	//input ld_song,
   input [3:0] KEY,
   output reg [2:0] song_choice,
	output reg low,
	output reg midlow,
	output reg midhigh,
	output reg high
   );
	
	//reg 
	//Random r(.song(song_choice))
	always @ (posedge clk) begin
		//if (ld_song) begin
			//song_choice <= $urandom%4;
		//end
		if(resetn)
			song_choice <= $urandom(4);
		else begin
			low 		<= KEY[0];
			midlow 	<= KEY[1];
			midhigh	<= KEY[2];
			high		<= KEY[3];
		end
	end
endmodule

/*
module Random(song);
	output assign [3:0] song = $urandom%4;
	
endmodule
*/



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
							 if (midhigh) next_state = STANDBY1;
							 else if (midlow || low || high) next_state = FAIL;
							 else next_state = NOTE1;
							 end
				STANDBY1: begin
							 if(~midhigh) next_state = NOTE2;
							 else next_state = STANDBY1;
							 end
					NOTE2: begin
							 if (high) next_state = STANDBY2;
							 else if (low || midhigh || midlow) next_state = FAIL;
							 else next_state = NOTE2;
							 end
				STANDBY2: begin
							 if(~high) next_state = NOTE3;
							 else next_state = STANDBY2;
							 end
					NOTE3: begin
							 if (midlow) next_state = STANDBY3;
							 else if (low || midhigh || high) next_state = FAIL;
							 else next_state = NOTE3;
							 end
				STANDBY3: begin
							 if (~midlow) next_state = COMPLETE;
							 else next_state = STANDBY3;
							 end  		 
            COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
  
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
    output wire result
    );

	 wire wire1;
	 RateDiv rdiv(wire1, CLOCK_50); // get the shift speed from RateDivider 
	 
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
							 if (high) next_state = STANDBY1;
							 else if (midlow || low || midhigh) next_state = FAIL;
							 else next_state = NOTE1;
							 end
				STANDBY1: begin
							 if(~high) next_state = NOTE2;
							 else next_state = STANDBY1;
							 end
					NOTE2: begin
							 if (midhigh) next_state = STANDBY2;
							 else if (low || high || midlow) next_state = FAIL;
							 else next_state = NOTE2;
							 end
				STANDBY2: begin
							 if(~midhigh) next_state = NOTE3;
							 else next_state = STANDBY2;
							 end
					NOTE3: begin
							 if (midlow) next_state = STANDBY3;
							 else if (low || midhigh || high) next_state = FAIL;
							 else next_state = NOTE3;
							 end 
				STANDBY3: begin
							 if (~midlow) next_state = COMPLETE;
							 else next_state = STANDBY3;
							 end  
            COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
  
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
    output wire result
    );

	 wire wire1;
	 RateDiv rdiv(wire1, CLOCK_50); // get the shift speed from RateDivider 
	 
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
							 if (low) next_state = STANDBY1;
							 else if (midlow || high || midhigh) next_state = FAIL;
							 else next_state = NOTE1;
							 end
				STANDBY1: begin
							 if(~low) next_state = NOTE2;
							 else next_state = STANDBY1;
							 end
					NOTE2: begin
							 if (midlow) next_state = STANDBY2;
							 else if (low || high || midhigh) next_state = FAIL;
							 else next_state = NOTE2;
							 end
				STANDBY2: begin
							 if(~midlow) next_state = NOTE3;
							 else next_state = STANDBY2;
							 end
					NOTE3: begin
							 if (midhigh) next_state = STANDBY3;
							 else if (low || midlow || high) next_state = FAIL;
							 else next_state = NOTE3;
							 end
				STANDBY3: begin
							 if (~midhigh) next_state = COMPLETE;
							 else next_state = STANDBY3;
							 end  
            COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
  
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
    output wire result
    );

	 wire wire1;
	 RateDiv rdiv(wire1, CLOCK_50); // get the shift speed from RateDivider 
	 
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
							 if (low) next_state = STANDBY1;
							 else if (midlow || high || midhigh) next_state = FAIL;
							 else next_state = NOTE1;
							 end
				STANDBY1: begin
							 if(~low) next_state = NOTE2;
							 else next_state = STANDBY1;
							 end
					NOTE2: begin
							 if (midlow) next_state = STANDBY2;
							 else if (low || high || midhigh) next_state = FAIL;
							 else next_state = NOTE2;
							 end
				STANDBY2: begin
							 if(~midlow) next_state = NOTE3;
							 else next_state = STANDBY2;
							 end
					NOTE3: begin
							 if (high) next_state = STANDBY3;
							 else if (low || midlow || midhigh) next_state = FAIL;
							 else next_state = NOTE3;
							 end
				STANDBY3: begin
							 if (~high) next_state = COMPLETE;
							 else next_state = STANDBY3;
							 end  
            COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
  
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
    output wire result
    );

	 wire wire1;
	 RateDiv rdiv(wire1, CLOCK_50); // get the shift speed from RateDivider 
	 
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
							 if (high) next_state = STANDBY1;
							 else if (midlow || low || midhigh) next_state = FAIL;
							 else next_state = NOTE1;
							 end
				STANDBY1: begin
							 if(~high) next_state = NOTE2;
							 else next_state = STANDBY1;
							 end
					NOTE2: begin
							 if (midlow) next_state = STANDBY2;
							 else if (low || high || midhigh) next_state = FAIL;
							 else next_state = NOTE2;
							 end
				STANDBY2: begin
							 if(~midlow) next_state = NOTE3;
							 else next_state = STANDBY2;
							 end
					NOTE3: begin
							 if (midhigh) next_state = STANDBY3;
							 else if (low || midlow || high) next_state = FAIL;
							 else next_state = NOTE3;
							 end
				STANDBY3: begin
							 if (~midhigh) next_state = COMPLETE;
							 else next_state = STANDBY3;
							 end  
            COMPLETE: next_state =  COMPLETE; // Loop in current state until go signal goes low
                FAIL: next_state = FAIL; // we will be done our two operations, start over after
            default:  next_state = NOTE1;
        endcase
    end // state_table
  
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

module RateDiv(clk, en);
	//Rate Divider, rate = 1/4 second
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


module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule