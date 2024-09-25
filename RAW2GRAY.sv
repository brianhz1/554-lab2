module RAW2GRAY (oRed,
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
reg		[11:0]	mCCD_R;
reg		[12:0]	mCCD_G;
reg		[11:0]	mCCD_B;
reg				mDVAL;

assign	oRed	=	mCCD_R[11:0];
assign	oGreen	=	mCCD_G[12:1];
assign	oBlue	=	mCCD_B[11:0];
assign	oDVAL	=	mDVAL;

Line_Buffer1 	u0	(	.clken(iDVAL),
						.clock(iCLK),
						.shiftin(iDATA),
						.taps0x(mDATA_1),
						.taps1x(mDATA_0)	);

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		mCCD_R	<=	0;
		mCCD_G	<=	0;
		mCCD_B	<=	0;
		mDATAd_0<=	0;
		mDATAd_1<=	0;
		mDVAL	<=	0;
	end
	else
	begin
		mDATAd_0	<=	mDATA_0;
		mDATAd_1	<=	mDATA_1;
		mDVAL		<=	{iY_Cont[0]|iX_Cont[0]}	?	1'b0	:	iDVAL;
		
		mCCD_R <= (mDATA_0+mDATAd_0+mDATA_1+mDATAd_1)/4;
		mCCD_G <= (mDATA_0+mDATAd_0+mDATA_1+mDATAd_1)/4;
		mCCD_B <= (mDATA_0+mDATAd_0+mDATA_1+mDATAd_1)/4;
	end
end

endmodule		

