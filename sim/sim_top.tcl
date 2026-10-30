	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB				"test_top"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"3 us"
#	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Actel_C1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Actel_C2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Actel_S1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Actel_S2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder_nbit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/all_one3.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/all_zero3.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/all_zero5.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/AND2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/approx_mult.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/array_multiplier.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/dec_nbit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/full_adder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/half_adder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/half_sub.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/inc_nbit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/OR4.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/SHL_Register.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/SHR_Register.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/ud_counter.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/up_counter.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/XOR2.v

	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================

	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/uut/*	
	add wave sim:/$TB/UUT/*
#	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	