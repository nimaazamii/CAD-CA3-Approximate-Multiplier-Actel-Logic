module dec_nbit #(parameter N=8)
(
    input  [N-1:0] din,
    output [N-1:0] dout
);

	wire [N-1:0] b; // borrow bits
	
	assign b[0] = 1;
	
	genvar i;
	generate
		for (i=0; i<N-1; i=i+1) begin
			half_sub HS_i
			(
				.a    ( din[i]  ),
				.b    ( b[i]    ),
				.diff ( dout[i] ),
				.bout ( b[i+1]  )
			);
		end
	endgenerate
	
	XOR2 HS_n (din[N-1], b[N-1], dout[N-1]);

endmodule
