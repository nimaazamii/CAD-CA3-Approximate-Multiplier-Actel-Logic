module half_sub (
    input  a,
    input  b,
    output diff, // difference
    output bout  // borrow-out
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;

	XOR2 g1 (a, b, diff);

	Actel_C1 C1(
		.A0  ( cZERO ),
		.A1  ( cZERO ),
		.SA  ( cZERO ),   // Mux1 generates 0
		.B0  ( cONE  ),
		.B1  ( cZERO ),
		.SB  ( a     ),   // Mux2 generates ~a

		.S0  ( b     ),   // Mux3 select = b|b
		.S1  ( b     ),   // Mux3 select = b|b

		.out ( bout  )    // y = ~a AND b = (b) ? ~a:0;
	);

endmodule
