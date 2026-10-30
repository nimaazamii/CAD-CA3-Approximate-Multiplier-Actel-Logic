module full_adder (
    input  a,
    input  b,
    input  cin,

    output sum,
    output cout   // carry-out
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;

	wire w1;
	
	XOR2 ins1(a,  b,   w1);
	XOR2 ins2(w1, cin, sum);

	Actel_C1 ins3 (
		.A0  ( cZERO ),
		.A1  ( b     ),
		.SA  ( a     ),   // Mux1 generates a & b
		.B0  ( b     ),
		.B1  ( cONE  ),
		.SB  ( a     ),   // Mux2 generates a | b
		.S0  ( cin   ),   // Mux3 select = cin
		.S1  ( cin   ),   // Mux3 select = cin
		.out ( cout  )    // cout = (cin) ? a|b : a&b;
	);
	  
		
endmodule
