module Actel_C1 (
    input  A0,
    input  A1,
    input  SA,
    input  B0,
    input  B1,
    input  SB,
    input  S0,
    input  S1,

    output out
);
wire F1, F2, S2;

	assign S2 = S0 | S1;
	
	assign F1  = (SA==1'b0) ? A0 : A1;
	assign F2  = (SB==1'b0) ? B0 : B1;
	assign out = (S2==1'b0) ? F1 : F2;
	
endmodule
