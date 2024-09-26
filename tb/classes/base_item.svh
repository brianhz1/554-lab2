class base_item extends uvm_sequence_item;
    `uvm_object_utils(base_item);

    rand bit [11:0] data;
    bit data_val;

    function new(string name = "base_item");
        super.new(name);
    endfunction: new
endclass: base_item