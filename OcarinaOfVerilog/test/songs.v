module songs();

	output reg speaker;
	
	
	reg [9:0] clkdivider;
	
	wire 	enable1,
			enable2,
			enable3,
			enable4,
			enable5;
			
	assign enable1 = 0;
	assign enable2 = 0;
	assign enable3 = 0;
	assign enable4 = 0;
	assign enable5 = 0;
				
	/*
	localparam 	c			= 50000000/261,
					c_sharp	= 50000000/277,
					d			= 50000000/293,
					d_sharp	= 50000000/311,
					e			= 50000000/330,
					f			= 50000000/349,
					f_sharp	= 50000000/370,
					g			= 50000000/392,
					g_sharp	= 50000000/415,
					a			= 50000000/440,
					a_sharp	= 50000000/466,
					b			= 50000000/494;
	*/
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
	
	eponasongtune est(.enable(enable1), .c(c),.c_sharp(c_sharp),.d(d),.d_sharp(d_sharp),.e(e),.f(f),.f_sharp(f_sharp),.g(g),.g_sharp(g_sharp),.a(a),.a_sharp(a_sharp),.b(b),.rest(rest),.clkdivider(clkdivider));
	sariasongtune sst(.enable(enable2), .c(c),.c_sharp(c_sharp),.d(d),.d_sharp(d_sharp),.e(e),.f(f),.f_sharp(f_sharp),.g(g),.g_sharp(g_sharp),.a(a),.a_sharp(a_sharp),.b(b),.rest(rest),.clkdivider(clkdivider));
	songofstormstune sost(.enable(enable3), .c(c),.c_sharp(c_sharp),.d(d),.d_sharp(d_sharp),.e(e),.f(f),.f_sharp(f_sharp),.g(g),.g_sharp(g_sharp),.a(a),.a_sharp(a_sharp),.b(b),.rest(rest),.clkdivider(clkdivider));
	windsrequiemtune wrt(.enable(enable4), .c(c),.c_sharp(c_sharp),.d(d),.d_sharp(d_sharp),.e(e),.f(f),.f_sharp(f_sharp),.g(g),.g_sharp(g_sharp),.a(a),.a_sharp(a_sharp),.b(b),.rest(rest),.clkdivider(clkdivider));
	zeldaslullabytune zlt(.enable(enable5), .c(c),.c_sharp(c_sharp),.d(d),.d_sharp(d_sharp),.e(e),.f(f),.f_sharp(f_sharp),.g(g),.g_sharp(g_sharp),.a(a),.a_sharp(a_sharp),.b(b),.rest(rest),.clkdivider(clkdivider));
	
	
	reg counter_note
	always @(posedge clk)
		if(counter_note == 0)
			counter_note <= clkdivider;
		else
			counter_note <= counter_note - 1;
	
	always @(posedge clk)
		if(counter_note == 0)
			speaker <= ~speaker;
			
	
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
