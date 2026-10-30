module up_counter #(parameter N = 8)
(
    input  clk,
    input  rst,
    input  clr,
    input  inc,
    output [N-1:0] count_out
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;

	wire [N-1:0] add_out;
	
	genvar i;
	generate
		for (i=0; i<N; i=i+1) begin

			Actel_S2 FF_i (
				.D00 ( count_out[i] ),
				.D01 ( add_out[i]   ),
				.D10 ( cZERO        ),
				.D11 ( cZERO        ),
				.A1  ( clr          ),   // S1=0, (D10 and D11 inputs are don't-cares)
				.B1  ( clr          ),   // S1=0, (D10 and D11 inputs are don't-cares)
				.A0  ( inc          ),   // if inc==0, then HOLD (D00 input)
				.B0  ( inc          ),   // else add-1 (D01 input)
				.CLR ( rst          ),
				.CLK ( clk          ),
				.out ( count_out[i] )
			);

		end
	endgenerate

	inc_nbit #(N) ADD_1
	(
		.din  (count_out),
		.dout (add_out  )
	);

endmodule
