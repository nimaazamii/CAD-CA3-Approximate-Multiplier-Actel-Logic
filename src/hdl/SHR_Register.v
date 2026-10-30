module SHR_Register #(parameter N = 16)
(
    input  clk,
    input  rst,
    input  load,
    input  shr,
    input  [N-1:0] din,
    output [N-1:0] dout
);

	wire [N-1:0] shifted;
	assign shifted = {1'b0, dout[N-1:1]};

	genvar i;
	generate
		for (i=0; i<N; i=i+1) begin

			Actel_S2 FF_i (
				.D00 ( dout[i]      ),   // Hold
				.D01 ( shifted[i]   ),   // SHR
				.D10 ( din[i]       ),   // Load-din
				.D11 ( din[i]       ),   // Load-din
				.A1  ( load         ),   // S1=load, (Parallel Load via D10 and D11 Inputs)
				.B1  ( load         ),   // S1=load, (D10 and D11 inputs are don't-cares)
				.A0  ( shr          ),   // if inc==0, then HOLD (D00 input)
				.B0  ( shr          ),   // else SHR the stored value (D01 input)
				.CLR ( rst          ),
				.CLK ( clk          ),
				.out ( dout[i]      )
			);

		end
	endgenerate

endmodule
