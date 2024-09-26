class val_monitor extends uvm_monitor;
    `uvm_component_utils(val_monitor)

    virtual imgpr_if vif;
    uvm_analysis_port #(base_item) val_port;

    function new (string name="val_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual imgpr_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_name(), ".vif is not set")
        end
        val_port = new("val_port", this);
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        base_item item;
		item = base_item::type_id::create("base_item");
        forever begin
            @(posedge vif.p_clk);
            if (vif.i_data_val) begin
                item.data_val <= 1;
                item.data <= vif.i_data;
                val_port.write(item);
            end
        end
    endtask: run_phase
endclass