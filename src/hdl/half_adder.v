module half_adder (
    input  a,
    input  b,
    output sum,
    output cout  // carry-out
);

	XOR2 g1 (a, b, sum);
	AND2 g2 (a, b, cout);

endmodule
