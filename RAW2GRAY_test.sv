module RAW2GRAY_test (oRed,
				 oGreen,
				 oBlue,
				 oDVAL,
				 iX_Cont,
				 iY_Cont,
				 iDATA,
				 iDVAL,
				 iCLK,
				 iRST
				 );

input	[10:0]	iX_Cont;
input	[10:0]	iY_Cont;
input	[11:0]	iDATA;
input			iDVAL;
input			iCLK;
input			iRST;
output	[11:0]	oRed;
output	[11:0]	oGreen;
output	[11:0]	oBlue;
output			oDVAL;
wire	[11:0]	mDATA_0;
wire	[11:0]	mDATA_1;
reg		[11:0]	mDATAd_0;
reg		[11:0]	mDATAd_1;
reg		[13:0]	mCCD;
reg				mDVAL;

assign	oRed	=	mCCD[13:2];
assign	oGreen	=	mCCD[13:2];
assign	oBlue	=	mCCD[13:2];
assign	oDVAL	=	mDVAL;

line_buffer_param u_line_buffer_param (
	.clk(iCLK),
	.rst_n(iRST),
	.en(iDVAL),	// shift if high
	.d_shift_in(mDATAd_0),
	.d_out_0(mDATA_0), // first in
	.d_out_1(mDATA_1)	// second in
);

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		mCCD <= 0;
		mDATAd_0<=	0;
		mDATAd_1<=	0;
		mDVAL	<=	0;
	end
	else
	begin
		mDATAd_0	<=	mDATAd_1;
		mDATAd_1	<=	iDATA;
		mDVAL		<=	{iY_Cont[0]|iX_Cont[0]}	?	1'b0	:	iDVAL;
		mCCD <= (mDATA_0+mDATAd_0+mDATA_1+mDATAd_1);
	end
end

endmodule		

