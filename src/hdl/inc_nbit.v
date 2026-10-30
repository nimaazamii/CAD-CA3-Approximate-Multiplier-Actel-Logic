module inc_nbit #(parameter N=8)
(
    input  [N-1:0] din,
    output [N-1:0] dout
);

	wire [N-1:0] c;
	
	assign c[0] = 1;
	
	genvar i;
	generate
		for (i=0; i<N-1; i=i+1) begin
			half_adder HA_i
			(
				.a    ( din[i]  ),
				.b    ( c[i]    ),
				.sum  ( dout[i] ),
				.cout ( c[i+1]  )
			);
		end
	endgenerate
	
	XOR2 HA_n (din[N-1], c[N-1], dout[N-1]);

endmodule
