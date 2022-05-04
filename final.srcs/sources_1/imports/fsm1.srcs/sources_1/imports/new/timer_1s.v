`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2022 03:09:59 PM
// Design Name: 
// Module Name: timer_1s
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


module timer_1s#(
    parameter CLK_FREQ = 25_000_000)
    (
    input wire iClk,iRst,
    output wire oQ
    );
//size of the instantiated counter
localparam CLK = 2000000; //the bigger the slowest(modifies low part of the puls
localparam N = $clog2(CLK-1);

//variable (N bits) to connect to the ouput of the counter
wire[N-1:0] wCntOut;
counter#(.LIM(CLK_FREQ))
counter_inst(.iClk(iClk),.iEnable(1),.iRst(iRst),.oQ(wCntOut));

assign oQ = (wCntOut == CLK-1)?1:0;
endmodule
