module Actel_S1 (
    input  D00,
    input  D01,
    input  D10,
    input  D11,
    input  A1,
    input  B1,
    input  A0,
    input  B0,

    input  CLR,
    input  CLK,

    output reg out
);
wire din;
	wire [1:0] S;

	assign S[1] = A1 | B1;
	assign S[0] = A0 & B0;
	
	assign din = (S==2'b00) ? D00 :
	             (S==2'b01) ? D01 :
	             (S==2'b10) ? D10 : D11;
	  
	always @ (posedge CLK or posedge CLR)
	begin
		if (CLR) out = 1'b0;
		else     out = din;
	end
	
endmodule
