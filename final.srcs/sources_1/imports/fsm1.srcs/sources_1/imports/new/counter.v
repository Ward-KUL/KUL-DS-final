`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2022 02:20:57 PM
// Design Name: 
// Module Name: counter
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


module counter#(
    parameter LIM = 150,
    parameter N = $clog2(LIM-1)
    )
    (
    input wire iClk, iRst,iEnable,
    output wire[N-1:0] oQ
    );
    
    //signal declaration
    reg[N-1:0] r_CntCurr;
    wire[N-1:0] w_CntNext;
    wire w_Rst;
    
   //the counter register
   always@(posedge iClk)
   if(iRst==1)
    r_CntCurr <= 0;
   else if(iEnable == 1) begin
    if(r_CntCurr == LIM -1)
        r_CntCurr <= 0;
    else
        r_CntCurr <= w_CntNext;
    end
//the increment circuit
assign w_CntNext = r_CntCurr + 1;
//the output
assign oQ = r_CntCurr;
endmodule