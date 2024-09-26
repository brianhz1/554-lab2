virtual class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    virtual imgpr_if vif;
    sequencer sequencer_h;
    driver driver_h;
    val_monitor monitor_h;
    out_monitor monitor_out;
    sb_final sb_final_h;

    function new(string name="base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual imgpr_if)::get(this, "", "IMGPR_vif", vif)) begin
            `uvm_fatal(get_name(), "IMGPR_vif cannot be found")
        end
        uvm_config_db #(virtual imgpr_if)::set(this, "*", "vif", vif);

        sequencer_h = sequencer::type_id::create("sequencer_h", this);
        driver_h = driver::type_id::create("driver_h", this);
        monitor_h = val_monitor::type_id::create("monitor_h", this);
        monitor_out = out_monitor::type_id::create("monitor_out", this);
        sb_final_h = sb_final::type_id::create("sb_final_h", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
        monitor_out.out_port.connect(sb_final_h.dut_fifo.analysis_export);
    endfunction: connect_phase

    pure virtual task run_phase(uvm_phase phase);
endclass