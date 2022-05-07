`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2022 14:50:45
// Design Name: 
// Module Name: VGA_timings
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


module VGA_timings #(
    parameter WIDTH = 640,
    parameter H_FP = 16,
    parameter H_PW = 96,
    parameter H_BP = 48,
    parameter H_total = WIDTH+H_FP+H_PW+H_BP,
    
    parameter HEIGHT = 480,
    parameter V_FP = 10,
    parameter V_PW = 2,
    parameter V_BP = 33,
    parameter V_total = HEIGHT+V_FP+V_PW+V_BP,
    
    parameter N = $clog2(WIDTH + H_FP + H_PW + H_BP - 1)
    ,parameter Nv = $clog2(V_total - 1)
    
    )
    (
    input   wire iClk, iRst,
    output  wire oHS, oVS,
    
    output  wire [N-1:0] oCountH, oCountV,
    output wire ivSync
    );
    
    wire [N-1:0] oCountHCurr;
    wire [N-1:0] oCountVCurr2;
    
    
    counter #( .LIM(WIDTH+H_FP+H_PW+H_BP) )
    counter_hor ( .iClk(iClk), .iRst(iRst), .oQ(oCountHCurr),.iEnable(1) );
    counter#(.LIM(V_total))
    counter_ver(.iClk(iClk),.iRst(iRst),.iEnable(oCountHCurr >= (H_total -1)),.oQ(oCountVCurr2));
    

    assign oHS = ((oCountHCurr <= WIDTH + H_FP)||(oCountHCurr >= WIDTH + H_FP+H_PW))?1:0;
    assign oVS = ((oCountVCurr2 <= HEIGHT+V_FP)||(oCountVCurr2 >= HEIGHT+V_FP+V_PW))?1:0;
    assign ivSync = ((oCountVCurr2 == (V_total -1)))?1:0;
    assign oCountH = oCountHCurr;
    assign oCountV = oCountVCurr2;     
          
endmodule
