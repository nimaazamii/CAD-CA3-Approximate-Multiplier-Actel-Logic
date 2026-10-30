module all_zero5    // 5-bit Equal to ZERO Checker
(
    input  [4:0] din,
    output equal
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;
	
	wire nz_low;  // If 3 lower bits of din (i.e., din[2:0]) do not equal ZERO

	Actel_C2 OR_3 (       // This is a 3-input OR
		.D00 ( cZERO  ),
		.D01 ( cONE   ),
		.D10 ( cONE   ),
		.D11 ( cONE   ),
		.A1  ( din[2] ),
		.B1  ( din[1] ),
		.A0  ( din[0] ),
		.B0  ( din[0] ),
		.out ( nz_low )
	);
	
	Actel_C2 AND_3 (       // This is a 3-input NOR
		.D00 ( cONE   ),
		.D01 ( cZERO  ),
		.D10 ( cZERO  ),
		.D11 ( cZERO  ),
		.A1  ( din[4] ),
		.B1  ( din[3] ),
		.A0  ( nz_low ),
		.B0  ( nz_low ),
		.out ( equal  )
	);


endmodule
