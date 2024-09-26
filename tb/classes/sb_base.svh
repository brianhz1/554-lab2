virtual class sb_base extends uvm_component;
    `uvm_component_utils(sb_base)
    
    uvm_analysis_port #(base_item) gray_port;   // gray data output 
    uvm_analysis_port #(rgb_item) a_port;

    function new(string name="sb_base", uvm_component parent);
        super.new(name, parent);
        a_port = new("a_port", this);
        gray_port = new("gray_port", this);
    endfunction: new

    pure virtual task run_phase(uvm_phase phase);
endclass