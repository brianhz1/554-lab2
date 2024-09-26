class sobel_test extends base_test;
    `uvm_component_utils(sobel_test)
    
    sb_SOBEL sobel;
    base_sequence #(.P_WIDTH(640), .P_HEIGHT(480)) gray_seq;

    function new(string name="sobel_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sobel = sb_SOBEL#(.EDGE(1))::type_id::create("sobel", this);
        gray_seq = base_sequence#(.P_WIDTH(640), .P_HEIGHT(480))::type_id::create("gray_seq", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        monitor_h.val_port.connect(sobel.data_fifo.analysis_export);
        sobel.a_port.connect(sb_final_h.analysis_export);
    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_name(), "<run_phase> started, objection raised.", UVM_NONE)

        // wait for reset
        wait (vif.rst_n == 1);
        `uvm_info(get_name(), "rst done\n", UVM_NONE)
        // starts sequence in sequencer
        gray_seq.start(sequencer_h);

        phase.drop_objection(this);
        `uvm_info(get_name(), "<run_phase> finished, objection dropped.", UVM_NONE)
    endtask: run_phase
endclass