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
    wire timerRst;
    reg nxtTimerRst;
    reg rToggle_Curr;
    
    timer_1s    #(.CLK_FREQ(CLK_FREQ))
    timer_1s_inst     (.iClk(iClk),.iRst(iRst),.oQ(w1));
    
    always @(posedge iClk)
        begin
        if(iRst == 1)
            begin
            rToggle_Curr <= 0;
            end
        else if(w1 == 1)
            begin
            rToggle_Curr <= 1;
            end
        else
            begin
            rToggle_Curr <= 0;
            end
        end      
    assign timerRst = nxtTimerRst;
    assign oToggle = rToggle_Curr;
endmodule
