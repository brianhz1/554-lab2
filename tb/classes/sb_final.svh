// RAW2GRAY scoreboard
class sb_final extends sb_base;
    `uvm_component_utils(sb_final)
	
    localparam P_WIDTH = 640; // horizontal pixel count
    localparam P_HEIGHT = 480; // veritical pixel count

    uvm_analysis_imp #(rgb_item, sb_final) analysis_export;  // model input
    uvm_tlm_analysis_fifo #(rgb_item) dut_fifo;  // dut input
	rgb_item item;
	rgb_item model_item;
	rgb_item test;
    int err_cnt;
	int x_count; // col
    int y_count; // row
    int dut_x_count; // col
    int dut_y_count; // row
	
	int count; // pixels received from model
    int dut_count; // pixels received from dut
	
    bit [11:0] image [P_HEIGHT][P_WIDTH][3];     // channels 0,1,2 are r,g,b respectively
    bit [11:0] dut_image [P_HEIGHT][P_WIDTH][3]; // channels 0,1,2 are r,g,b respectively

    function new(string name="sb_final", uvm_component parent);
        super.new(name, parent);
        dut_fifo = new("dut_fifo", this);
        analysis_export = new("analysis_export", this);
		item = rgb_item::type_id::create("item");
		model_item = rgb_item::type_id::create("model_item");
		
		x_count = 0; // col
		y_count = 0; // row
		count = 0;
        dut_count = 0;
    endfunction: new

    extern function void extract_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
	
	virtual function void write (rgb_item rgb);
		// from model
            count++;
            if (!((y_count > P_HEIGHT-1) || (x_count > P_WIDTH-1))) begin
                image[y_count][x_count][0] = rgb.r_data;
                image[y_count][x_count][1] = rgb.g_data;
                image[y_count][x_count][2] = rgb.b_data;
			end
            else
                `uvm_error("SB_FINAL", $psprintf("MODEL data out-of-bounds, row = %d, col = %d", y_count, x_count))

            x_count++;
            if (x_count == P_WIDTH) begin
                x_count = 0;
                y_count++;
            end
        
endfunction
endclass

function void sb_final::extract_phase(uvm_phase phase);
    // error calculation
    int file;
    err_cnt = 0;
    file = $fopen("./note.txt", "w");
    for (int row = 0; row < P_HEIGHT; row++) begin
        for (int col = 0; col < P_WIDTH; col++) begin
            for (int channel = 0; channel < 3; channel++) begin
                if (image[row][col][channel] != dut_image[row][col][channel]) begin
                    $fdisplay(file, "row = %d, col = %d, dut = %h, model = %h", row, col, dut_image[row][col][channel], image[row][col][channel]);
                    err_cnt++;
                end
            end
        end
    end
    $fclose(file);
endfunction: extract_phase

function void sb_final::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SB_FINAL", $psprintf("model pixel count = %d", count), UVM_NONE)
    `uvm_info("SB_FINAL", $psprintf("dut pixel count = %d", dut_count), UVM_NONE)
    `uvm_info("SB_FINAL", $psprintf("PIXEL MISMATCH CNT: %d", err_cnt), UVM_NONE)
	`uvm_info("SB_FINAL", $psprintf("IMAGE: %d, %d, %d, %d", image[0][0][0],image[0][1][0],image[0][2][0],image[0][3][0]), UVM_NONE)
	`uvm_info("SB_FINAL", $psprintf("DUT_IMAGE: %d, %d, %d, %d", dut_image[0][0][0],dut_image[0][1][0],dut_image[0][2][0],dut_image[0][3][0]), UVM_NONE)
endfunction: report_phase

task sb_final::run_phase(uvm_phase phase);
    // initialize
    dut_x_count = 0; // col
    dut_y_count = 0; // row
	


    forever begin
		#10;
        // from dut
        if (!dut_fifo.is_empty()) begin
            dut_fifo.get(item);
            dut_count++;
            if (!((dut_y_count > P_HEIGHT-1) || (dut_x_count > P_WIDTH-1))) begin
                dut_image[dut_y_count][dut_x_count][0] = item.r_data;
                dut_image[dut_y_count][dut_x_count][1] = item.g_data;
                dut_image[dut_y_count][dut_x_count][2] = item.b_data;
            end
			else
                `uvm_error("SB_FINAL", $psprintf("DUT data out-of-bounds, row = %d, col = %d", dut_y_count, dut_x_count))

            dut_x_count++;
            if (dut_x_count == P_WIDTH) begin
                dut_x_count = 0;
                dut_y_count++;
            end
        end
    end
endtask
