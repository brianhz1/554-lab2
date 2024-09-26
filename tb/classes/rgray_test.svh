class rgray_test extends base_test;
    `uvm_component_utils(rgray_test)
    
    sb_R2G R2G;
    base_sequence #(.P_WIDTH(1280), .P_HEIGHT(960)) bayer_seq;

    function new(string name="rgray_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        R2G = sb_R2G::type_id::create("R2G", this);
        bayer_seq = base_sequence#()::type_id::create("bayer_seq", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        monitor_h.val_port.connect(R2G.data_fifo.analysis_export);
        R2G.a_port.connect(sb_final_h.analysis_export);
    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<run_phase> started, objection raised.", UVM_NONE)

        // wait for reset
        wait (vif.rst_n == 1);
        `uvm_info(get_name(), "rst done\n", UVM_NONE)
        // starts sequence in sequencer
        bayer_seq.start(sequencer_h);

        phase.drop_objection(this);
        `uvm_info(get_name(), "<run_phase> finished, objection dropped.", UVM_NONE)
    endtask: run_phase
endclass