module part3(SW, KEY, LEDR, COCK_50);
	input [2:0]SW;
	input [1:0]KEY;
	input CLOCK_50
	output [0:0]LEDR;
	wire [13:0]seq;
	wire [0:0]connect;
	wire [13:0]out;

	LUT(.in(SW),.seq(seq));
	rateDivider(.reset(KEY[0]), .enable(KEY[1]),.CLOCK_50(CLOCK_50), .cout(connect));
	shiftRegister(.reset(KEY[0]), .enable(connect), .seq(seq), .out(LEDR[0]));
endmodule
	
module LUT(in, seq);
	input [2:0]in;
	output [13:0]seq;
	
	always@(*)
	begin
		case(in[2:0])
			3'b000: seq = 14'b10101000000000;
			3'b001: seq = 14'b11100000000000;
			3'b010: seq = 14'b10101110000000;
			3'b011: seq = 14'b10101011100000;
			3'b100: seq = 14'b10111011100000;
			3'b101: seq = 14'b11101010111000;
			3'b110: seq = 14'b11101011101110;
			3'b111: seq = 14'b11101110101000;
		endcase
	end
endmodule
	
module rateDivider(reset, enable, CLOCK_50, cout);
	input [0:0]reset;
	input [0:0]enable;
	input CLOCK_50;
	output cout;
	
	reg [27:0]count;
	
	
	always@(posedge CLOCK_50)
	begin 
		if (reset == 1'b0)
			count <= 28'd24999999;
		else
			begin
			
				if (count == 0)
						count = 28'd24999999;
				else
						count <= count - 1'b1;
			end
	end
	
	assign cout = (count == 0) ? 1 : 0;
endmodule

module shiftRegister(reset, enable, seq, out)
	input [0:0]reset;
	input [0:0]enable;
	input [13:0]seq;
	output [0:0]out;
	
	reg [14:0]temp = {1'b0,seq};
	
	always@(posedge CLOCK_50)
	begin 
		if (reset == 1'b0)
			temp <= seq;
		else if (enable == 1'b1)
					temp = temp << 1'b1; 
	end
	assign out = temp[14];
endmodule
	
	
	