module AND2 (
    input  a,
    input  b,
    output y
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;

	Actel_C1 C1(
		.A0  ( cZERO ),
		.A1  ( cZERO ),
		.SA  ( b     ),   // Mux1 generates 0
		.B0  ( cZERO ),
		.B1  ( cONE  ),
		.SB  ( b     ),   // Mux2 generates b
		.S0  ( a     ),   // Mux3 select = a|a
		.S1  ( a     ),   // Mux3 select = a|a
		.out ( y     )    // a AND b = (a) ? b:0;
	);

endmodule
