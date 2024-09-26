// SOBEL scoreboard
// edge = 1; vertical edge
// edge = 0; horizontal edge
class sb_SOBEL #(bit EDGE = 1) extends sb_base;
    `uvm_component_utils(sb_SOBEL#(EDGE))

    uvm_tlm_analysis_fifo #(base_item) data_fifo; // input fifo

    localparam P_WIDTH = 640; // horizontal pixel count
    localparam P_HEIGHT = 480; // veritical pixel count

    function new(string name="sb_SOBEL", uvm_component parent);
        super.new(name, parent);
        data_fifo = new("data_fifo", this);
    endfunction: new

    extern task run_phase(uvm_phase phase);
endclass

task sb_SOBEL::run_phase(uvm_phase phase);
    // initialize
    rgb_item color_item; // color output
    base_item data_item; // single channel output
    base_item item;
    bit [11:0] data [P_HEIGHT+2][P_WIDTH+2];
    bit [13:0] temp_sum;
    int x_count; // col index
    int y_count; // row index
	
    color_item = rgb_item::type_id::create("color_item");
    data_item = base_item::type_id::create("data_item");
    x_count = 1;
    y_count = 1;
    forever begin
        #10;
        if (!data_fifo.is_empty()) begin
            data_fifo.get(item);
            if (x_count > P_WIDTH+1 || y_count > P_HEIGHT+1)
                `uvm_error("sb_SOBEL", $psprintf("MODEL data out-of-bounds, row = %d, col = %d", y_count, x_count))
            else 
                data[y_count][x_count] = item.data;

            x_count++;
            if (x_count == P_WIDTH+1) begin
                x_count = 1;
                y_count++;
                if (y_count == P_HEIGHT+1) begin
                    for (int row = 1; row < P_HEIGHT+1; row++) begin
                        for (int col = 1; col < P_WIDTH+1; col++) begin
                            if (EDGE) 
                                temp_sum = (-data[row-1][col-1]) + (-2*data[row-1][col]) + (-data[row-1][col+1])
                                     + data[row+1][col-1] + (2*data[row+1][col]) + data[row+1][col+1];
                            else
                                temp_sum = (-data[row-1][col-1]) + (-2*data[row-1][col]) + (-data[row-1][col+1])
                                     + data[row+1][col-1] + (2*data[row+1][col]) + data[row+1][col+1];
                            
                            if (row == 1 && col == 1) begin
                                $display("%d  %d  %d", data[row-1][col-1], data[row-1][col], data[row-1][col+1]);
                                $display("%d  %d  %d", data[row][col-1], data[row][col], data[row][col+1]);
                                $display("%d  %d  %d", data[row+1][col-1], data[row+1][col], data[row+1][col+1]);
                            end
                            color_item.r_data = temp_sum[13:2];
                            color_item.g_data = temp_sum[13:2];
                            color_item.b_data = temp_sum[13:2];
                            color_item.data_val = 1;
                            data_item.data = temp_sum[13:2];
                            data_item.data_val = 1;
                            a_port.write(color_item);
                            gray_port.write(data_item);
                        end
                    end
                end
            end
        end
    end
endtask
