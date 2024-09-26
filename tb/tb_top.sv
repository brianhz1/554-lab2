module tb_top ();
	import tb_includes::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
    imgpr_if IMGPR();

    // instantiate DUT
    RAW2GRAY DUT (
    .oRed       (IMGPR.oRed),
    .oGreen     (IMGPR.oGreen),
    .oBlue      (IMGPR.oBlue),
    .oDVAL      (IMGPR.o_data_val),
    .iX_Cont    (IMGPR.X_cnt),
    .iY_Cont    (IMGPR.Y_cnt),
    .iDATA      (IMGPR.i_data),
    .iDVAL      (IMGPR.i_data_val),
    .iCLK       (IMGPR.p_clk),
    .iRST       (IMGPR.rst_n)
    );

    initial begin
        uvm_config_db #(virtual imgpr_if)::set(null, "", "IMGPR_vif", IMGPR);
        run_test("rgray_test");
    end
endmodule