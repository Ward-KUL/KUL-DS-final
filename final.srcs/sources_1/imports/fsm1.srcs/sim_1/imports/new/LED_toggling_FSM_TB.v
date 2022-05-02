`timescale 1ns / 1ps

module LED_toggling_FSM_TB;

  reg   rClk, rRst, rPushL,rPushR,rPushD,rPushU;
  wire  wLEDR,wLEDU,wLEDD,wLEDL;
  localparam CLK = 2;
  
  LED_toggling_FSM  #(.CLK_FREQ(CLK))  LED_toggling_FSM_INST
  ( .iClk(rClk), .iRst(rRst), .iPushLeft(rPushL),.iPushRight(rPushR),.iPushDown(rPushD),.iPushUp(rPushU), .oLEDUp(wLEDU),.oLEDDown(wLEDD),.oLEDLeft(wLEDL),.oLEDRight(wLEDR));
  
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
    #(2*T);         // wait
    rRst = 0;       // de-assert reset
    #(5*T);         // wait
    rPushL = 1;      // assert push
    #(5*T);         // wait
    rPushL = 0;      // de-assert push
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
