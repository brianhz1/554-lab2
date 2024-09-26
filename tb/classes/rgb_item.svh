class rgb_item extends uvm_sequence_item;
    `uvm_object_utils(rgb_item);

    rand bit [11:0] r_data;
    rand bit [11:0] b_data;
    rand bit [11:0] g_data;
    bit data_val;   // data valid

    function new(string name = "rgb_item");
        super.new(name);
    endfunction: new
endclass: rgb_item