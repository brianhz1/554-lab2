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


RAW2GRAY g1();

endmodule;