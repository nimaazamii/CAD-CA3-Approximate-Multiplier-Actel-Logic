module adder_nbit #(parameter N=8)
(
    input  [N-1:0] a,
    input  [N-1:0] b,

    output [N-1:0] sum,
    output cout
);

	wire [N:1] c;
	
	half_adder HA_0
	(
		.a    ( a[0]   ),
		.b    ( b[0]   ),
		.sum  ( sum[0] ),
		.cout ( c[1]   )
	);
	
	genvar i;
	generate
		for (i=1; i<N; i=i+1) begin
			full_adder FA_i
			(
				.a    ( a[i]   ),
				.b    ( b[i]   ),
				.cin  ( c[i]   ),
				.sum  ( sum[i] ),
				.cout ( c[i+1] )
			);
		end
	endgenerate

	assign cout = c[N];
	
endmodule
