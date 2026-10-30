module datapath #(
	parameter I_DWIDTH = 16,
	parameter O_DWIDTH = I_DWIDTH
) (
	input  clk,
	input  rst,

	input  [I_DWIDTH-1:0] data_in,
	output [O_DWIDTH-1:0] data_out,

	input  load_a,
	input  load_b,
	input  shl_a,
	input  shl_b,
	input  mult_start,  // useless for array multiplier
	input  load_res,
	input  shr_res,
	input  wbc_rst,
	input  wbc_inc,
	input  wbc_dec,
	input  shc_rst,
	input  shc_inc,

	output mult_ready,
	output msb_a,
	output msb_b,
	output shift_8,
	output wbc_zero
);

	localparam MULT_SIZE = I_DWIDTH / 2;     // WIDTH of The Multiplier's Input Data
	localparam WBC_BITS  = $clog2(I_DWIDTH)+1;  // 5
	localparam SHC_BITS  = $clog2(I_DWIDTH)-1;  // 3

	wire [I_DWIDTH-1:0] A_value;
	wire [I_DWIDTH-1:0] B_value;
	wire [MULT_SIZE-1:0] mult_inA;    // MULT_SIZE = I_DWIDTH/2 = 8
	wire [MULT_SIZE-1:0] mult_inB;    // MULT_SIZE = I_DWIDTH/2 = 8
	wire [I_DWIDTH -1:0] mult_result;
	wire [I_DWIDTH-1:0] RR_in;         // The input of Result Register

	wire [WBC_BITS-1:0] wbc_amt;
	wire [SHC_BITS-1:0] shl_amt;

	// The Multiplier's Input Registers
	SHL_Register #(I_DWIDTH) A_REG
	(
		.clk  ( clk       ),
		.rst  ( rst       ),
		.load ( load_a    ),
		.shl  ( shl_a     ),
		.din  ( data_in   ),
		.dout ( A_value   )
	);


	SHL_Register #(I_DWIDTH) B_REG
	(
		.clk  ( clk       ),
		.rst  ( rst       ),
		.load ( load_b    ),
		.shl  ( shl_b     ),
		.din  ( data_in   ),
		.dout ( B_value   )
	);

	assign msb_a = A_value[I_DWIDTH-1];
	assign msb_b = B_value[I_DWIDTH-1];

	assign mult_inA = A_value[I_DWIDTH-1:I_DWIDTH/2]; // A_value[15:8]
	assign mult_inB = B_value[I_DWIDTH-1:I_DWIDTH/2]; // B_value[15:8]


	// Multiply Engine (It is an Array Multiplier for now)
	array_multiplier #(MULT_SIZE) MULT_UNIT
	(
		.a       ( mult_inA ),
		.b       ( mult_inB ),
		.product ( RR_in    ) 
	);
	assign mult_ready = 1'b1;  // always 1 for array multiplier


	// Multiply Result-Register

	SHR_Register #(I_DWIDTH) RES_REG
	(
		.clk  ( clk        ),
		.rst  ( rst        ),
		.load ( load_res   ),
		.shr  ( shr_res    ),
		.din  ( RR_in      ),
		.dout ( data_out   )
	);


	// COUNTERS FOR COUNTING AMOUNTS OF SHL AND SHR

	// Counter of  Worthless-Bits of both Operands
	ud_counter #(WBC_BITS) WBC   // Worthless-Bits Counter
	(
		.clk        ( clk     ),
		.rst        ( wbc_rst ),
		.inc        ( wbc_inc ),
		.dec        ( wbc_dec ),
		.count_out  ( wbc_amt )
	);

	// assign wbc_zero = (wbc_amt==0) ? 1 : 0;    // if WBC counter is zero
	all_zero5 WBC_EQZ (
		.din   (wbc_amt ),
		.equal (wbc_zero)
	);

	// Counter of  Shift-Lefts for each Operand
	up_counter #(SHC_BITS) SHC   // SHift-left Counter
	(
		.clk        ( clk     ),
		.rst        ( rst     ),
		.clr        ( shc_rst ),
		.inc        ( shc_inc ),
		.count_out  ( shl_amt )
	);
	
	// assign shift_8 = &shl_amt; // If all bits of the counter are '1', then no more shifts
	all_one3 SHL_8    // 3-bit Equal to 3'b111 Checker
	(
	    .din   (shl_amt ),
	    .equal (shift_8 )
	);

endmodule
