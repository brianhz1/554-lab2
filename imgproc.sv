module imgproc (
    input iCLK,
    input iRST,
    input [11:0] iDATA,
    input iDVAL,
    output [11:0] oRed,
    output [11:0] oGreen,
    output [11:0] oBlue,
    output oDVAL,
    input [15:0] iX_Cont,
    input [15:0] iY_Cont,
    input iSW
);

// top row taps
wire	[11:0]	top_mDATA_0;
wire	[11:0]	top_mDATA_1;
wire	[11:0]	top_mDATA_2;

// middle row taps
wire	[11:0]	middle_mDATA_0;
wire	[11:0]	middle_mDATA_1;
wire	[11:0]	middle_mDATA_2;

// buffer registers
reg		[11:0]	mDATAd_0;
reg		[11:0]	mDATAd_1;
reg		[11:0]	mDATAd_2;

reg		[13:0]	mCCD;
reg				mDVAL;
reg				mDVAL_pipe;

wire [13:0] temp_data;
wire [13:0] horizontal; // intermediate sobel horizontal sum
wire [13:0] vertical;   // intermediate sobel vertical sum

// convolution
assign horizontal = (-top_mDATA_0-{top_mDATA_1,1'b0}-top_mDATA_2+mDATAd_0+{mDATAd_1, 1'b0}+mDATAd_2);
assign vertical = (-top_mDATA_0-{middle_mDATA_0,1'b0}-mDATAd_0+top_mDATA_2+{middle_mDATA_2, 1'b0}+mDATAd_2);

assign temp_data = iSW ? vertical : horizontal;

assign	oRed	=	mCCD[13:2];
assign	oGreen	=	mCCD[13:2];
assign	oBlue	=	mCCD[13:2];
assign	oDVAL	=	mDVAL_pipe;

line_buffer_param top_row (
	.clk(iCLK),
	.rst_n(iRST),
	.en(iDVAL),	// shift if high
	.d_shift_in(middle_mDATA_0),
	.d_out_0(top_mDATA_0), // first in
	.d_out_1(top_mDATA_1),	// second in
    .d_out_2(top_mDATA_2)	// third in
);

line_buffer_param middle_row (
	.clk(iCLK),
	.rst_n(iRST),
	.en(iDVAL),	// shift if high
	.d_shift_in(mDATAd_0),
	.d_out_0(middle_mDATA_0), // first in
	.d_out_1(middle_mDATA_1),	// second in
    .d_out_2(middle_mDATA_2)	// second in
);

    always@(posedge iCLK or negedge iRST) begin
        if(!iRST)
        begin
            mCCD <= 0;
            mDATAd_0<=	0;
            mDATAd_1<=	0;
            mDATAd_2<=  0;
            mDVAL	<=	0;
        end
        else
        begin
			// pipeline values
            if (iDVAL) begin
                mDATAd_0	<=	mDATAd_1;
                mDATAd_1	<=	mDATAd_2;
                mDATAd_2    <=  iDATA;
            end
			
			// valid on every other row
            mDVAL		<=	((iY_Cont != 0)) ? iDVAL : 1'b0;
            mDVAL_pipe <= mDVAL;
            mCCD <= temp_data[13] ? ((~temp_data)+1'b1) : temp_data; // apply values
        end
    end
endmodule