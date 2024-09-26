class out_monitor extends uvm_monitor;
    `uvm_component_utils(out_monitor)

    virtual imgpr_if vif;
    uvm_analysis_port #(rgb_item) out_port;

    function new (string name="out_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual imgpr_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_name(), {"virtual interface is not set for ", get_full_name(), ".vif"})
        end
        out_port = new("out_port", this);
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        rgb_item item;
		item = rgb_item::type_id::create("rgb_item");
        forever begin
            @(posedge vif.p_clk);
            if (vif.o_data_val) begin
                item.data_val <= 1;
                item.r_data <= vif.oRed;
                item.g_data <= vif.oGreen;
                item.b_data <= vif.oBlue;
                out_port.write(item);
            end
        end
    endtask: run_phase
endclass