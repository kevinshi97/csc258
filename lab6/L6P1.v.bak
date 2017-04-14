
//SW[0]:			reset Signal
//SW[1]:			input signal(w)
//KEY[0]:		clock
//LEDR[2:0]:	current state(
//LEDR[9]:		output(z)


module sequence_detector(SW, KEY, LEDR);
	input [9:0] SW;
	input [3:0] KEY;
	output[9:0] LEDR;
	
	wire w;
	wire clock;
	wire resetn;
	wire z;
	
	reg [2:0] y_q	//current state
	reg [2:0] y_d	//next state
	
	//States
	localparam a = 3'b000;
	localparam b = 3'b001;
	localparam c = 3'b010;
	localparam d = 3'b011;
	localparam e = 3'b100;
	localparam f = 3'b101;
	localparam g = 3'b110;
	
	assign w = SW[1];
	assign clock = KEY[0];
	assign resetn = SW[0];
	assign LEDR[2:0] = y_q;
	assign LEDR[9] = z;
	
	always @(*)
		begin
		//State Table
			case (y_Q)
				a: begin
						if(!w)
							y_d = a;
						else
							y_d = b;
					end
				b: begin
						if(!w)
							y_d = a;
						else
							y_d = c;
					end
				c: begin
						if(!w)
							y_d = e;
						else
							y_d = d;
					end
				d: begin
						if(!w)
							y_d = e;
						else
							y_d = f;
					end
				e: begin
						if(!w)
							y_d = a;
						else
							y_d = g;
					end
				f: begin
						if(!w)
							y_d = e;
						else
							y_d = f;
					end
				g: begin
						if(!w)
							y_d = a;
						else
							y_d = c;
					end
			endcase
		end
	
	//State Register
	always @(posedge clock)
		begin
			if(resetn = 1'b0)
				y_q <= a;
			else
				y_q <= y_d;
		end
	
	//Output Logic
	assign z = ((y_q == f) ||(y_q == g));
endmodule
		