module part2(SW, HEX0, CLOCK_50);
	input [4:0] SW;
	input CLOCK_50;
	output [6:0] HEX0;
	
	reg [27:0] lim; 
	wire [0:0]connect; 
	wire [3:0] out;
	

	//Speed
	always@(*)
	begin
		case({SW[1], SW[0]})
			2'b00: lim = 0;
			2'b01: lim = 28'd49999999;
			2'b10: lim = 28'd99999999;
			2'b11: lim = 28'd199999999;
		endcase
	end
	
	rateDivider rd(.lim(lim),.reset(SW[4]),.CLOCK_50(CLOCK_50),.cout(connect));
	displayCounter dc(.enable(connect),.reset(SW[4]),.CLOCK_50(CLOCK_50),.out(out));
	SevenSegmentDecoder ssd(.in(out[3:0]),.out(HEX0[6:0]));
	
	
endmodule

module rateDivider(lim, reset, CLOCK_50, cout);
	input [27:0]lim;
	input [0:0]reset;
	input CLOCK_50;
	output cout;
	
	reg [27:0]count;
	
	
	always@(posedge CLOCK_50)
	begin 
		if (reset == 1'b0)
			count <= lim;
		else
			begin
			
				if (count == 0)
						count <= lim;
				else
						count <= count - 1'b1;
			end
	end
	
	assign cout = (count == 0) ? 1 : 0;
endmodule

module displayCounter(enable, reset, CLOCK_50,out);
	input [0:0]enable;
	input [0:0]reset;
	input CLOCK_50;
	output reg [3:0]out;
	
	
	always@(posedge CLOCK_50)
	begin 
		if (reset == 1'b0)
			out <= 0;
		else if (enable == 1'b1)
					out <= out + 1'b1; 
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
