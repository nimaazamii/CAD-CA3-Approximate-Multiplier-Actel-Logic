module test_array_mult;

	localparam N = 4;
	integer  i, j;

    reg  [  N-1:0] a;
    reg  [  N-1:0] b;
    wire [2*N-1:0] P;

	array_multiplier #(N) UUT (a, b, P);

	initial begin
		a = 4'd0; b = 4'd0;
		for (i=0; i<16; i=i+1) begin
			a = i;
			for (j=0; j<16; j=j+1) begin
				b = j;
				#10;
			end
		end
	end

endmodule
