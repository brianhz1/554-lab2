package tb_includes;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "base_item.svh"
	`include "rgb_item.svh"
	
	`include "base_sequence.svh"
	`include "sequencer.svh"
	
	`include "driver.svh"
	
	`include "out_monitor.svh"
	`include "val_monitor.svh"
	
	`include "sb_base.svh"
	`include "sb_final.svh"
	`include "sb_R2G.svh"
	`include "sb_SOBEL.svh"
	
	`include "base_test.svh"
	`include "rgray_test.svh"
	`include "sobel_test.svh"
	`include "raw2sobel_test.svh"
endpackage