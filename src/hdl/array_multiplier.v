module array_multiplier #(parameter N=8)
(
    input  [N-1:0] a,
    input  [N-1:0] b,

    output [2*N-1:0] product
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;

	wire [N-1:0] PP [0:N-1];  // Partial Products
	wire [N  :0] PS [0:N-1];  // Partial Sums of Products
	
	genvar i, j, k;
	
	generate
		for (i=0; i<N; i=i+1) begin
			for (j=0; j<N; j=j+1) begin
				AND2 ins_Pij (a[i], b[j], PP[i][j]);
			end
		end
	endgenerate


	assign PS[0] = {1'b0, PP[0]};
	generate
		for (k=0; k<N-1; k=k+1) begin

			assign product[k] = PS[k][0];
			adder_nbit #(N) ADDER_N
			(
				.a    ( PP[k+1]        ),
				.b    ( PS[k  ][N:1]   ),
				.sum  ( PS[k+1][N-1:0] ),
				.cout ( PS[k+1][N]     )
			);

		end
	endgenerate

	assign product[2*N-1:N-1] = PS[N-1];

endmodule
