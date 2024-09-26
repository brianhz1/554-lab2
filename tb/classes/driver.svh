class driver extends uvm_driver #(base_item);
    `uvm_component_utils(driver);

    localparam P_WIDTH = 1280; // horizontal pixel count
    localparam P_HEIGHT = 960; // veritical pixel count
    int row_count;
    int col_count;

    virtual imgpr_if vif;
    base_item item;

    // constructor
    function new (string name="driver", uvm_component parent=null);
        super.new(name, parent);
        row_count = 0;
        col_count = 0;
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual imgpr_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_name(), ".vif is not set")
        end
        item = base_item::type_id::create("base_item");
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        // initial bus values
        vif.X_cnt <= 0;
        vif.Y_cnt <= 0;
        vif.i_data_val <= 0;
        vif.i_data <= 0;

        forever begin 
            seq_item_port.get_next_item(item);
            @(posedge vif.p_clk);
            vif.X_cnt <= col_count;
            vif.Y_cnt <= row_count;
            vif.i_data_val <= item.data_val;
            vif.i_data <= item.data;

            if (item.data_val) begin
                col_count <= col_count + 1;
                if (col_count==P_WIDTH-1) begin
                    row_count <= row_count + 1;
                    col_count <= 0;
                end
            end
            seq_item_port.item_done();
        end
    endtask: run_phase
    

endclass : driver