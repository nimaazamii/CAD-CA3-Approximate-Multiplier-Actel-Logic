module OR4 (
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;

	Actel_C1 C1(
		.A0  ( c     ),
		.A1  ( cONE  ),
		.SA  ( d     ),   // Mux1 generates b
		.B0  ( cONE  ),
		.B1  ( cONE  ),
		.SB  ( cONE  ),   // Mux2 generates 1           
		.S0  ( a     ),   // Mux3 select = a|b
		.S1  ( b     ),   // Mux3 select = a|b
		.out ( y     )    // 
	);
	  
endmodule
