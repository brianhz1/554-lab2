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
    input iSW,
);

logic [11:0] mGray;
logic grayValid;
logic [11:0] buf1_out1;
logic [11:0] buf1_out2;
logic [11:0] buf1_shift_out;
logic [11:0] buf2_out1;
logic [11:0] buf2_out2;
logic [11:0] buf2_shift_out;


RAW2GRAY g1(.oGreen(mGray),
				 .oDVAL(grayValid),
				 .iX_Cont(iX_Cont),
				 .iY_Cont(iY_Cont),
				 .iDATA(iDATA),
				 .iDVAL(iDVAL),
				 .iCLK(iCLK),
				 .iRST(iRST)
				 );

line_buffer_param buf1();
line_buffer_param buf2();

// LINE BUFFER 1
// LINE BUFFER 2
// PREV 2 REG
// PREV 1 REG

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
	end
	else
	begin
	end
end


endmodule;