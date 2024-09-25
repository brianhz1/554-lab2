module line_buffer_tb();

    logic clk, rst_n, en;
    logic [11:0] d_shift_in, d_out_0, d_out_1;

    line_buffer_param u_line_buffer_param (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),	// shift if high
        .d_shift_in(d_shift_in),
        .d_out_0(d_out_0), // first in
        .d_out_1(d_out_1)	// second in
    );

    initial begin
        clk = 0;
        rst_n = 0;
        repeat(2) @(negedge clk);
        rst_n = 1;

        d_shift_in = 8'haa;
        repeat(1280) begin
            @(posedge clk);
            en = 1;
            @(posedge clk);
            en = 0;
            @(posedge clk);
        end
        d_shift_in = 8'h01;
        repeat(1280) begin
            @(posedge clk);
            en = 1;
            @(posedge clk);
            en = 0;
            @(posedge clk);
        end

        $stop();
    end

    always
        #20 clk = ~clk;

endmodule