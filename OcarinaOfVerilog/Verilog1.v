module eponasong(c,c#,d,d#,e,f,f#,g,g#,a,a#,b,rest,clkdivider);
	input [25:0]c;
	input [25:0]c#;
	input [25:0]d;
	input [25:0]d#;
	input [25:0]e;
	input [25:0]f;
	input [25:0]f#;
	input [25:0]g;
	input [25:0]g#;
	input [25:0]a;
	input [25:0]a#;
	input [25:0]b;
	input [25:0]rest;
	output reg [25:0] clkdivider;
	
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
	
	
	localparam	
	
	always@(*)
   begin: state_table 
		case (current_state)
			NOTE1:  next_state = NOTE2,
         NOTE2:  next_state = NOTE3,
			NOTE3:  next_state = NOTE4,
			NOTE4:  next_state = NOTE5,
			NOTE5:  next_state = NOTE6,
			NOTE6:  next_state = NOTE7,
			NOTE7:  next_state = NOTE8,
			NOTE8:  next_state = NOTE9,
			NOTE9:  next_state = NOTE10,
			NOTE10: next_state = NOTE11,
			NOTE11: next_state = NOTE12;
			NOTE12: next_state = NOTE13,
			NOTE13: next_state = NOTE14,
         NOTE14: next_state = NOTE15,
			NOTE15: next_state = NOTE16,
			NOTE16: next_state = NOTE17,
			NOTE17: next_state = NOTE18,
			NOTE18: next_state = NOTE19,
			NOTE19: next_state = NOTE20,
			NOTE20: next_state = NOTE21,
			NOTE21: next_state = NOTE22,
			NOTE22: next_state = NOTE23,
			NOTE23: next_state = NOTE24,
			NOTE24: next_state = FINISH;
			FINISH: next_state = FINISH;
			default:	next_state = NOTE1;
		endcase
    end // state_table
	 
	 always@(*)
   begin: OUTPUT LOGIC 
		case (current_state)
			NOTE1:  clkdivider = d,
         NOTE2:  clkdivider = b,
			NOTE3:  clkdivider = a,
			NOTE4:  clkdivider = a,
			NOTE5:  clkdivider = a,
			NOTE6:  clkdivider = a,
			NOTE7:  clkdivider = d,
			NOTE8:  clkdivider = b,
			NOTE9:  clkdivider = a,
			NOTE10: clkdivider = a,
			NOTE11: clkdivider = a;
			NOTE12: clkdivider = a,
			NOTE13: clkdivider = d,
         NOTE14: clkdivider = b,
			NOTE15: clkdivider = a,
			NOTE16: clkdivider = a,
			NOTE17: clkdivider = b,
			NOTE18: clkdivider = b,
			NOTE19: clkdivider = a,
			NOTE20: clkdivider = a,
			NOTE21: clkdivider = a,
			NOTE22: clkdivider = a,
			NOTE23: clkdivider = rest,
			NOTE24: clkdivider = rest;
			FINISH: clkdivider = rest;
			//default:	clkdivider = NOTE1;	//ALL STATES ARE COVERED IN FSM
		endcase
    end // state_table
endmodule 