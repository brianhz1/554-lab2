// generates a item type T for each pixel of P_WIDTH x P_HEIGHT
class base_sequence #(type T = base_item, parameter int P_WIDTH = 1280, int P_HEIGHT = 960) extends uvm_sequence#(T);
    `uvm_object_utils(base_sequence#(T, P_WIDTH, P_HEIGHT))

    rand integer delay; // delay between valid data

    constraint max_delay {
        delay inside {[1:5]};
    }

    function new(string name = "base_sequence");
        super.new(name);
        if (!this.randomize()) begin
            `uvm_error("base_sequence", "failed to randomize sequence")
        end 
    endfunction: new

    extern virtual task body();
endclass: base_sequence

task base_sequence::body();
    T item;
    item = T::type_id::create("item");

    for (int i = 0; i < P_HEIGHT; i++) begin // iterate all rows
    `uvm_info("base_sequence", $psprintf("running row %d of %d", i+1, P_HEIGHT), UVM_NONE)
        for (int j = 0; j < P_WIDTH; j++) begin // iterate all col
            for (int delay_c = 0; delay_c < delay; delay_c++) begin // creates delay items
                start_item(item);
                if (!item.randomize()) begin
                    `uvm_error("base_sequence", "failed to randomize item")
                end
                item.data_val = 0;
                finish_item(item);
            end
            start_item(item);
            if (!item.randomize()) begin
                `uvm_error("base_sequence", "failed to randomize item")
            end
            item.data_val = 1;
            finish_item(item);
        end
    end

    start_item(item);
    item.data_val = 0;
    finish_item(item);
    #1000000;
endtask