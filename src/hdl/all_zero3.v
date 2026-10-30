module all_zero3    // 3-bit Equal to ZERO Checker
(
    input  [2:0] din,
    output equal
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;

	// This is a 3-input NOR
	Actel_C2 ins1 (
		.D00 ( cONE   ),
		.D01 ( cZERO  ),
		.D10 ( cZERO  ),
		.D11 ( cZERO  ),
		.A1  ( din[2] ),
		.B1  ( din[1] ),
		.A0  ( din[0] ),
		.B0  ( din[0] ),
		.out ( equal  )
	);

endmodule
