interface imgpr_if();
    bit p_clk;
    bit rst_n;
    bit [15:0] X_cnt;
    bit [15:0] Y_cnt;

    bit i_data_val;     // data valid
    bit [11:0] i_data;  // data input
    bit [11:0] oRed;    // red value output
    bit [11:0] oGreen;  // green value output
    bit [11:0] oBlue;   // blue value output
    bit o_data_val;     // output data valid

    initial begin
        p_clk = 0;
        rst_n = 0;
        fork
            forever begin // clock generator
                #20; // 50 MHz
                p_clk = ~p_clk;
            end
            begin   // rst_n sequence
                @(negedge p_clk);
                rst_n = 1'b1;
            end
        join_none
    end
endinterface