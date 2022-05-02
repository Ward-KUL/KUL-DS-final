`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2022 03:17:41 PM
// Design Name: 
// Module Name: toggle
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


module toggle#(
    parameter CLK_FREQ = 25_000_000
    )
    (
    input wire iClk,iRst,
    output wire oToggle
    );
    wire w1;
    
    reg rToggle_Curr;
    wire    wToggle_Next;
    
    timer_1s    #(.CLK_FREQ(CLK_FREQ))
    timer_1s_inst     (.iClk(iClk),.iRst(iRst),.oQ(w1));
    always @(posedge iClk)
        if(iRst == 1)
            rToggle_Curr <= 0;
        else if(w1==1)
            rToggle_Curr <= wToggle_Next;
            
    assign wToggle_Next = ~rToggle_Curr;
    
    assign oToggle = rToggle_Curr;
endmodule
