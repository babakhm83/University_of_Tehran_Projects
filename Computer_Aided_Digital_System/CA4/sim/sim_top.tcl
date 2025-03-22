	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"Processing_element_tb1"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"1 us"
#	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Add_and_mod.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Adder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Buffer_read_controller_Filter.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Buffer_read_controller_IFMap.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Buffer_write_controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Buffer.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Circular_buffer.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Counter_fifo.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Counter_wth_load.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Counter.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Datapath_fifo.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Main_control_unit.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Multiplier.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Pipeline.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Processing_element.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Read_address_generator.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Register_type_scratchpad.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Register.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/SRAM_type_scratchpad.v
		
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
	