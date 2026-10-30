module controller (
    input clk,
    input rst,
    input start,

    input mult_ready,
    input msb_a,
    input msb_b,
    input shift_8,
    input wbc_zero,

    output load_a,
    output load_b,
    output shl_a,
    output shl_b,
    output mult_start,
    output load_res,
    output shr_res,
    output wbc_rst,
    output wbc_inc,
    output wbc_dec,
    output shc_rst,
    output shc_inc,
	output inp_read,
    output out_valid
);

	localparam cZERO = 1'b0;
	localparam cONE  = 1'b1;

    wire INIT1      ; // 4'b0000;
    wire INIT2      ; // 4'b0001;
    wire READ_A     ; // 4'b0010;
    wire LOAD_A     ; // 4'b0011;
    wire LOAD_B     ; // 4'b0100;
    wire SHL_A      ; // 4'b0101;
    wire SHL_B      ; // 4'b0110;
    wire MULT       ; // 4'b0111;
    wire SHR_RR     ; // 4'b1000;
    wire DONE       ; // 4'b1001;

	wire SHL_A_END; // Temp: It means last cycle of SHL_A


	Actel_S2 FF_INIT1 (  // rst | DONE | (INIT1 & ~start)
		.D00 ( INIT1        ),
		.D01 ( cZERO        ),
		.D10 ( cONE         ),
		.D11 ( cONE         ),
		.A1  ( DONE         ),
		.B1  ( rst          ),
		.A0  ( start        ),
		.B0  ( start        ),
		.CLR ( cZERO        ),
		.CLK ( clk          ),
		.out ( INIT1        )
	);

	Actel_S2 FF_INIT2 (
		.D00 ( cZERO        ),
		.D01 ( cZERO        ),
		.D10 ( cZERO        ),
		.D11 ( cONE         ),
		.A1  ( INIT1        ),
		.B1  ( INIT2        ),
		.A0  ( start        ),
		.B0  ( start        ),
		.CLR ( rst          ),
		.CLK ( clk          ),
		.out ( INIT2        )
	);

	Actel_S2 FF_READ_A (  // INIT2 & ~start
		.D00 ( INIT2        ),
		.D01 ( cZERO        ),
		.D10 ( cZERO        ),  // don't care
		.D11 ( cZERO        ),  // don't care
		.A1  ( cZERO        ),
		.B1  ( cZERO        ),
		.A0  ( start        ),
		.B0  ( start        ),
		.CLR ( rst          ),
		.CLK ( clk          ),
		.out ( READ_A       )
	);

	Actel_S2 FF_LOAD_A (  // READ_A
		.D00 ( READ_A       ),
		.D01 ( READ_A       ),
		.D10 ( cZERO        ),
		.D11 ( cZERO        ),
		.A1  ( cZERO        ),
		.B1  ( cZERO        ),
		.A0  ( cZERO        ),
		.B0  ( cZERO        ),
		.CLR ( rst          ),
		.CLK ( clk          ),
		.out ( LOAD_A       )
	);

	Actel_S2 FF_LOAD_B (  // LOAD_A
		.D00 ( LOAD_A       ),
		.D01 ( LOAD_A       ),
		.D10 ( cZERO        ),
		.D11 ( cZERO        ),
		.A1  ( cZERO        ),
		.B1  ( cZERO        ),
		.A0  ( cZERO        ),
		.B0  ( cZERO        ),
		.CLR ( rst          ),
		.CLK ( clk          ),
		.out ( LOAD_B       )
	);


	Actel_S2 FF_SHL_A (  // LOAD_B | shl_a
		.D00 ( SHL_A        ),
		.D01 ( cONE         ), // when LOAD_B=1
		.D10 ( cZERO        ),
		.D11 ( cONE         ), // when LOAD_B=1
		.A1  ( msb_a        ),
		.B1  ( shift_8      ),
		.A0  ( LOAD_B       ),
		.B0  ( LOAD_B       ),
		.CLR ( rst          ),
		.CLK ( clk          ),
		.out ( SHL_A        )
	);

	Actel_C1 LOGIC_SHL_A (  // assign shl_a = SHL_A & ~msb_a
		.A0  ( cZERO    ),
		.A1  ( cZERO    ),
		.SA  ( cZERO    ),
		.B0  ( cONE     ),
		.B1  ( cZERO    ),
		.SB  ( msb_a    ),  // mux2.out = ~msb_a
		.S0  ( SHL_A    ), 
		.S1  ( SHL_A    ), 
		.out ( shl_a    )  
	);


	OR4 ins_OR1 (msb_a, shift_8, cZERO, cZERO, SHL_A_END);
	
	Actel_S2 FF_SHL_B (  // LOAD_B | shl_a
		.D00 ( SHL_B        ),
		.D01 ( SHL_A_END    ), // when SHL_A =1
		.D10 ( cZERO        ),
		.D11 ( SHL_A_END    ), // when SHL_A =1
		.A1  ( msb_b        ),
		.B1  ( shift_8      ),
		.A0  ( SHL_A        ),
		.B0  ( SHL_A        ),
		.CLR ( rst          ),
		.CLK ( clk          ),
		.out ( SHL_B        )
	);

	Actel_C1 LOGIC_SHL_B (  // assign shl_b = SHL_B & ~msb_b
		.A0  ( cZERO    ),
		.A1  ( cZERO    ),
		.SA  ( cZERO    ),
		.B0  ( cONE     ),
		.B1  ( cZERO    ),
		.SB  ( msb_b    ),  // mux2.out = ~msb_b
		.S0  ( SHL_B    ), 
		.S1  ( SHL_B    ), 
		.out ( shl_b    )  
	);


	Actel_S2 FF_MULT (  // SHL_B & (msb_b | shift_8)
		.D00 ( cZERO        ),
		.D01 ( cZERO        ),
		.D10 ( SHL_B        ),
		.D11 ( SHL_B        ),
		.A1  ( msb_b        ),
		.B1  ( shift_8      ),
		.A0  ( cZERO        ),
		.B0  ( cZERO        ),
		.CLR ( rst          ),
		.CLK ( clk          ),
		.out ( MULT         )
	);

	Actel_S2 FF_SHR_RR (  // MULT | (SHR_RR & ~wbc_zero)
		.D00 ( SHR_RR       ),
		.D01 ( cZERO        ),
		.D10 ( cONE         ),
		.D11 ( cONE         ),
		.A1  ( MULT         ),
		.B1  ( MULT         ),
		.A0  ( wbc_zero     ),
		.B0  ( wbc_zero     ),
		.CLR ( rst          ),
		.CLK ( clk          ),
		.out ( SHR_RR       )
	);

	Actel_S2 FF_DONE (  // SHR_RR & wbc_zero
		.D00 ( cZERO        ),
		.D01 ( cONE         ),
		.D10 ( cZERO        ), // don't care
		.D11 ( cZERO        ), // don't care
		.A1  ( cZERO        ),
		.B1  ( cZERO        ),
		.A0  ( SHR_RR       ),
		.B0  ( wbc_zero     ),
		.CLR ( rst          ),
		.CLK ( clk          ),
		.out ( DONE         )
	);


	assign load_a     = LOAD_A;
	assign load_b     = LOAD_B;
	assign mult_start = MULT;
	assign load_res   = MULT;

	Actel_C1 C1_INS1(             // shr_res = SHR_RR & ~wbc_zero
		.A0  ( cZERO    ),
		.A1  ( cZERO    ),
		.SA  ( cZERO    ),   // Mux1 generates 0
		.B0  ( cONE     ),
		.B1  ( cZERO    ),
		.SB  ( wbc_zero ), 
		.S0  ( SHR_RR   ), 
		.S1  ( SHR_RR   ), 
		.out ( shr_res  )  
	);
	
	assign out_valid = DONE;

	assign wbc_rst   = INIT1;


	Actel_C1 C1_INS2 (
		.A0  ( SHL_A    ),
		.A1  ( shift_8  ),
		.SA  ( shl_a    ),   // Mux1 generates (SHL_A & ~shl_a) || (shl_a & shift_8)
		.B0  ( cONE     ),
		.B1  ( cONE     ),
		.SB  ( cONE     ),   // Mux2 generates 1
		.S0  ( INIT1    ), 
		.S1  ( INIT1    ), 
		.out ( shc_rst  )    // shc_rst = INIT1 | (SHL_A & (msb_a | shift_8))
	);
	
	OR4 ins_OR2 (SHL_A, SHL_B, cZERO, cZERO, shc_inc);
	OR4 ins_OR3 (shl_a, shl_b, cZERO, cZERO, wbc_inc);

	OR4 ins_OR4 (READ_A, LOAD_A, cZERO, cZERO, inp_read);

	assign wbc_dec = shr_res;

endmodule
