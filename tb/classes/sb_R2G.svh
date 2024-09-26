// RAW2GRAY scoreboard
class sb_R2G extends sb_base;
    `uvm_component_utils(sb_R2G)
    
    uvm_tlm_analysis_fifo #(base_item) data_fifo; // dut input fifo

    localparam P_WIDTH = 1280; // horizontal pixel count
    localparam P_HEIGHT = 960; // veritical pixel count

    function new(string name="sb_R2G", uvm_component parent);
	       super.new(name, parent);
        data_fifo = new("data_fifo", this);
    endfunction: new

    extern task run_phase(uvm_phase phase);
endclass

task sb_R2G::run_phase(uvm_phase phase);
    // initialize
	rgb_item color_item;
    base_item gray;
	base_item item;
    bit [11:0] row1 [P_WIDTH];
    bit [11:0] row2 [P_WIDTH];
	bit [13:0] data;
	int x_count;
	bit [11:0] y_count;
  
    color_item = rgb_item::type_id::create("rgb_item");
    x_count = 0;
    y_count = 0; // select row 1 or 2
    forever begin
		#10;
        if (!data_fifo.is_empty()) begin
            data_fifo.get(item);
            if (y_count[0])
                row1[x_count] = item.data;
            else
                row2[x_count] = item.data;

            x_count++;
            if (x_count == P_WIDTH) begin
                if (y_count[0]) begin
                    for (int i = 0; i < P_WIDTH; i = i+2) begin			
						data = (row1[i] + row1[i+1] + row2[i] + row2[i+1]);
                        color_item.r_data = data[13:2];
                        color_item.g_data = data[13:2];
                        color_item.b_data = data[13:2];
                        a_port.write(color_item);
						gray = base_item::type_id::create("gray");
						gray.data = data[13:2];
                        gray_port.write(gray);
                    end
                end
                x_count = 0;
                y_count++;
            end
        end
    end
endtask
