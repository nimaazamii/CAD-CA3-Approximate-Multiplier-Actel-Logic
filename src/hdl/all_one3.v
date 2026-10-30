module all_one3    // 3-bit Equal to 3'b111 Checker
(
    input  [2:0] din,
    output equal
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;

	// This is a 3-input AND
	Actel_C2 ins1 (
		.D00 ( cZERO  ), // if din[1] or din[0] is not ONE (A0 & B0 == 0)
		.D01 ( cZERO  ), // if (din == 3'b011)
		.D10 ( cZERO  ), // if din[1] or din[0] is not ONE (A0 & B0 == 0)
		.D11 ( cONE   ), // if (din == 3'b111)
		.A1  ( din[2] ),
		.B1  ( din[2] ),
		.A0  ( din[1] ),
		.B0  ( din[0] ),
		.out ( equal  )
	);

endmodule
