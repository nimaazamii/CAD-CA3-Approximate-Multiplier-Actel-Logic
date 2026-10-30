module XOR2 (
    input  a,
    input  b,
    output y
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;

	Actel_C1 C1(
		.A0  ( cZERO ),
		.A1  ( cONE  ),
		.SA  ( b     ),   // Mux1 generates b
		.B0  ( cONE  ),
		.B1  ( cZERO ),
		.SB  ( b     ),   // Mux2 generates ~b
		.S0  ( a     ),   // Mux3 select = a|a
		.S1  ( a     ),   // Mux3 select = a|a
		.out ( y     )    // a XOR b = (a) ? ~b:b;
	);
	  
endmodule
