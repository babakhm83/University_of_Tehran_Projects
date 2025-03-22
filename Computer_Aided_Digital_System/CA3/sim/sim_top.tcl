	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"Approximate_multiplier_tb"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"1 us"
#	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/AND.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Approximate_multiplier.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/C1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/C2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/D_flip_flop.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Down_counter_3bit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Down_counter_4bit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Full_Adder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Half_Adder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/OR.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/NOT.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/S1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/S2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Shiftreg.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Shiftreg2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/XOR.v
		
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/uut/*	
	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	