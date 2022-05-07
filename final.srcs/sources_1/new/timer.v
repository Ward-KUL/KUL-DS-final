`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2022 09:40:51 PM
// Design Name: 
// Module Name: timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module timer#(
parameter CLK_FREQ = 25_000_000)
    (
    input wire iClk,iRst,
    output wire oQ
    );
//size of the instantiated counter
localparam N = $clog2(CLK_FREQ-1);

//variable (N bits) to connect to the ouput of the counter
wire[N-1:0] wCntOut;
counter#(.LIM(CLK_FREQ))
counter_inst(.iClk(iClk),.iEnable(1),.iRst(iRst),.oQ(wCntOut));

assign oQ = (wCntOut == CLK_FREQ-1)?1:0;
endmodule
