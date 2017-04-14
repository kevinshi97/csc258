module lab5(SW, KEY, HEX0, HEX1);
	input [9:0]SW;
	input [3:0]KEY;
	output [6:0]HEX0;
	output [6:0]HEX1;
	wire [7:0] out;
	wire [6:0] temp;

	myTff tff0(.t(SW[1]),.clock(KEY[0]), .clear_b(SW[0]), .q(out[0]));
	
	assign temp[0] = out[0] && SW[1];
	myTff tff1(.t(temp[0]),.clock(KEY[0]), .clear_b(SW[0]), .q(out[1]));
	
	assign temp[1] = out[1] && temp[0];
	myTff tff2(.t(temp[1]),.clock(KEY[0]), .clear_b(SW[0]), .q(out[2]));
	
	assign temp[2] = out[2] && temp[1];
	myTff tff3(.t(temp[2]),.clock(KEY[0]), .clear_b(SW[0]), .q(out[3]));
	
	assign temp[3] = out[3] && temp[2];
	myTff tff4(.t(temp[3]),.clock(KEY[0]), .clear_b(SW[0]), .q(out[4]));
	
	assign temp[4] = out[4] && temp[3];
	myTff tff5(.t(temp[4]),.clock(KEY[0]), .clear_b(SW[0]), .q(out[5]));
	
	assign temp[5] = out[5] && temp[4];
	myTff tff6(.t(temp[5]),.clock(KEY[0]), .clear_b(SW[0]), .q(out[6]));
	
	assign temp[6] = out[6] && temp[5];
	myTff tff7(.t(temp[6]),.clock(KEY[0]), .clear_b(SW[0]), .q(out[7]));
	
	SevenSegmentDecoder display0(.in(out[3:0]), .out(HEX0));
	SevenSegmentDecoder display1(.in(out[7:4]), .out(HEX1));
	
endmodule

module myTff(t, clock, clear_b, q);
	input t;
	input clock;
	input clear_b;
	output reg q;
	
	always @(posedge clock, negedge clear_b)
		begin
			if(~clear_b)
				q <= 1'b0;
			else
				q <= q^t;
		end
endmodule

module SevenSegmentDecoder(in, out);
	input[3:0]in;
	output reg [6:0]out;
	
	
	always @*
		case(in)
			4'b0000 : out = ~7'b0111111; //0
			4'b0001 : out = ~7'b0000110; //1
			4'b0010 : out = ~7'b1011011; //2
			4'b0011 : out = ~7'b1001111; //3
			4'b0100 : out = ~7'b1100110; //4
			4'b0101 : out = ~7'b1101101; //5 
			4'b0110 : out = ~7'b1111101; //6
			4'b0111 : out = ~7'b0000111; //7
			4'b1000 : out = ~7'b1111111; //8
			4'b1001 : out = ~7'b1101111; //9
			4'b1010 : out = ~7'b1110111; //A
			4'b1011 : out = ~7'b1111100; //b
			4'b1100 : out = ~7'b0111001; //C
			4'b1101 : out = ~7'b1011110; //d
			4'b1110 : out = ~7'b1111001; //E
			4'b1111 : out = ~7'b1110001; //F

		endcase
endmodule 