`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2022 10:39:05 PM
// Design Name: 
// Module Name: final_TB
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


module final_TB;

reg   rClk, rRst, rPushL,rPushR,rPushD,rPushU;
  wire  wLEDR,wLEDU,wLEDD,wLEDL;
  wire[9:0] w_oCountH,w_oCountV;
    wire    w_oHS,w_oVS;
    wire    p_oHS,p_oVS;
    wire[3:0] w_oRed,w_oBlue,w_oGreen;
  localparam CLK = 6;
  localparam WIDTH_inst = 15;
    localparam H_FP_inst = 2;
    localparam H_PW_inst = 1;
    localparam H_BP_inst = 2;   //H_TOT = 20
    localparam H_total_inst = WIDTH_inst+H_FP_inst+H_PW_inst+H_BP_inst;
    localparam HEIGHT_inst = 10;
    localparam V_FP_inst = 2;
    localparam V_PW_inst = 1;
    localparam V_BP_inst = 2; //V_TOT = 15
    //localparam V_total_inst = HEIGHT_inst + V_FP_inst + V_PW_inst + V_BP_inst;
  
  LED_toggling_FSM  #(.CLK_FREQ(CLK))  LED_toggling_FSM_INST
  ( .iClk(rClk), .iRst(rRst), .iPushLeft(rPushL),.iPushRight(rPushR),.iPushDown(rPushD),.iPushUp(rPushU), .oLEDUp(wLEDU),.oLEDDown(wLEDD),.oLEDLeft(wLEDL),.oLEDRight(wLEDR));
  VGA_timings#(.WIDTH(WIDTH_inst),.H_FP(H_FP_inst),.H_PW(H_PW_inst),.H_BP(H_BP_inst),
        .HEIGHT(HEIGHT_inst),.V_FP(V_FP_inst),.V_BP(V_BP_inst))
    VGA_timings_inst(.iClk(rClk),.iRst(rRst),.oCountH(w_oCountH),.oCountV(w_oCountV),.oHS(w_oHS),.oVS(w_oVS));
    VGA_pattern#(.WIDTH(WIDTH_inst),.H_FP(H_FP_inst),.H_PW(H_PW_inst),.H_BP(H_BP_inst),
        .HEIGHT(HEIGHT_inst),.V_FP(V_FP_inst),.V_BP(V_BP_inst))
    VGA_pattern_inst(.iClk(rClk),.iRst(rRst),.iCountH(w_oCountH),.iCountV(w_oCountV),.iHS(w_oHS),.iVS(w_oVS),.oHS_p(p_oHS),.oVS_p(p_oVS),.oRed(w_oRed),.oBlue(w_oBlue),.oGreen(w_oGreen),.iUp(wLEDU),.iDown(wLEDD),.iLeft(wLEDL),.iRight(wLEDR),.iShapeX(iShapeX),.iShapeY(iShapeY));
  
  
  // definition of clock period
  localparam  T = 20;  
  
  // generation of clock signal
  always 
  begin
    rClk = 1;
    #(T/2);
    rClk = 0;
    #(T/2);
  end
  
  // stimulus generator
  initial
  begin
    rRst = 1;       // assert reset
    rPushL = 0;      // assert push
    rPushR = 0;
    rPushD  = 0;
    rPushU = 0;
    #(5*T);         // wait
    rRst = 0;       // de-assert reset
    #(5*T);         // wait
    rPushR = 1;      // assert push
    #(20*T);         // wait
    rPushR = 0;      // de-assert push
    #(5*T);         // wait
    rPushL = 1;      // assert push
    #(5*T);         // wait
    rPushL = 0;      // de-assert push
    #(5*T);         // wait
    
    // let the counter run for at least 1 frame
    #(100*T);
    
    $stop;        //stop simulation       
  end

endmodule