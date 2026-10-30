module test_top;

    reg  clk;
    reg  rst;
    reg  start;
    wire inp_read;
    wire out_valid;

	reg  [15:0] data_in;
	wire [15:0] data_out;


	approx_mult #(16, 16) UUT (
		clk,
		rst,
		start,
		inp_read,
		out_valid,
		data_in,
		data_out
	);

    initial
    begin
        clk = 1;
        repeat(1000)
        	#10 clk = ~clk;
    end
    
    initial
    begin
        rst   = 0;
        #10 rst = 1;
        #20 rst = 0;  start = 1;
        #40 start = 0;
    end
    
    initial begin
            start = 0;
        #20 start = 1;
        #40 start = 0;
		    data_in = 16'h0841;

    	@ (posedge out_valid);
    	@ (negedge out_valid);
    	#50 start = 1;
        #20 start = 0;
    	@ (posedge inp_read);
    	@ (posedge clk);         data_in = 16'd5567;
    	@ (posedge clk);         data_in = 16'h17235;
    	@ (posedge clk);         data_in = 16'h0000;
    	
    	@ (posedge out_valid);
    	@ (negedge out_valid);
    	#1  start = 1;
        #20 start = 0;
    	@ (posedge inp_read);
    	@ (posedge clk);         data_in = 16'h0045;
    	@ (posedge clk);         data_in = 16'h93fb;
    	@ (posedge clk);         data_in = 16'h0000;
    	
    	@ (posedge out_valid);
    	@ (negedge out_valid);
    	#1  start = 1;
        #20 start = 0;
    	@ (posedge inp_read);
    	@ (posedge clk);         data_in = 16'h00ab;
    	@ (posedge clk);         data_in = 16'h0037;
    	@ (posedge clk);         data_in = 16'h0000;
    	

    end

endmodule
