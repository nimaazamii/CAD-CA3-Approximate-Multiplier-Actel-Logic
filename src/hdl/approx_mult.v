module approx_mult #(
    parameter I_DWIDTH = 16,
    parameter O_DWIDTH = I_DWIDTH
) (
    input  clk,
    input  rst,
    input  start,
    output inp_read,
    output out_valid,

	input  [I_DWIDTH-1:0] data_in,
	output [O_DWIDTH-1:0] data_out
);


	wire load_a;
	wire load_b;
	wire shl_a;
	wire shl_b;
	wire mult_start;  // useless for array multiplier
	wire load_res;
	wire shr_res;
	wire wbc_rst;
	wire wbc_inc;
	wire wbc_dec;
	wire shc_rst;
	wire shc_inc;

	wire mult_ready;
	wire msb_a;
	wire msb_b;
	wire shift_8;
	wire wbc_zero;


	datapath #(I_DWIDTH, O_DWIDTH) DP (
		.clk         ( clk         ),
		.rst         ( rst         ),

		.data_in     ( data_in     ),
		.data_out    ( data_out    ),

		.load_a      ( load_a      ),
		.load_b      ( load_b      ),
		.shl_a       ( shl_a       ),
		.shl_b       ( shl_b       ),
		.mult_start  ( mult_start  ),
		.load_res    ( load_res    ),
		.shr_res     ( shr_res     ),
		.wbc_rst     ( wbc_rst     ),
		.wbc_inc     ( wbc_inc     ),
		.wbc_dec     ( wbc_dec     ),
		.shc_rst     ( shc_rst     ),
		.shc_inc     ( shc_inc     ),

		.mult_ready  ( mult_ready  ),
		.msb_a       ( msb_a       ),
		.msb_b       ( msb_b       ),
		.shift_8     ( shift_8     ),
		.wbc_zero    ( wbc_zero    )
	);

	controller CU (
		.clk        ( clk        ),
		.rst        ( rst        ),
		.start      ( start      ),
		.mult_ready ( mult_ready ),
		.msb_a      ( msb_a      ),
		.msb_b      ( msb_b      ),
		.shift_8    ( shift_8    ),
		.wbc_zero   ( wbc_zero   ),

		.load_a     ( load_a     ),
		.load_b     ( load_b     ),
		.shl_a      ( shl_a      ),
		.shl_b      ( shl_b      ),
		.mult_start ( mult_start ),
		.load_res   ( load_res   ),
		.shr_res    ( shr_res    ),
		.wbc_rst    ( wbc_rst    ),
		.wbc_inc    ( wbc_inc    ),
		.wbc_dec    ( wbc_dec    ),
		.shc_rst    ( shc_rst    ),
		.shc_inc    ( shc_inc    ),
		.inp_read   ( inp_read   ),
		.out_valid  ( out_valid  )
	);


endmodule
