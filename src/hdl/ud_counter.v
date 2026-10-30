module ud_counter #(parameter N = 8)
(
    input  clk,
    input  rst,
    input  inc,
    input  dec,
    output [N-1:0] count_out
);

	wire [N-1:0] add_out, sub_out;
	
	genvar i;
	generate
		for (i=0; i<N; i=i+1) begin

			Actel_S2 FF_i (
				.D00 ( count_out[i] ),
				.D01 ( count_out[i] ),
				.D10 ( add_out[i]   ),
				.D11 ( sub_out[i]   ),
				.A1  ( inc          ),   // if inc|dec is zero then hold (D00 and D01 inputs)
				.B1  ( dec          ),   // if inc|dec is zero then hold (D00 and D01 inputs)
				.A0  ( dec          ),   // else if dec==0, then add 1 (D10 input)
				.B0  ( dec          ),   // else if dec==1, then sub 1 (D11 input)
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

	dec_nbit #(N) SUB_1
	(
		.din  (count_out),
		.dout (sub_out  )
	);

endmodule
