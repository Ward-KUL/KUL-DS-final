`timescale 1ns / 1ps

module LED_toggling_FSM #(
    parameter CLK_FREQ = 25_000_000
    )
    
    (
  input   wire  iClk, iRst, iPushUp, iPushDown, iPushLeft, iPushRight,
  output  wire  oLEDUp,oLEDDown,oLEDRight,oLEDLeft,
  output wire [9:0] oShapeX,oShapeY,oSize
    );
    
  // 0. State definition
  localparam sIdle    = 3'b000;
  localparam sUp    = 3'b001;
  localparam sDown    = 3'b010;
  localparam sLeft = 3'b011;
  localparam sRight = 3'b100;
  
  reg[2:0] rFSM_current, wFSM_next;
  reg [9:0] oShapeCurrX, oShapeCurrY, oSizeCurr;
  wire toggleOut;
  toggle #(.CLK_FREQ(CLK_FREQ))
  toggle_instance(.iClk(iClk),.iRst(iRst),.oToggle(toggleOut));
  // 1. State register
  //  - with synchronous reset
  always @(posedge iClk)
  begin
    if (iRst == 1)
        begin
      rFSM_current <= sIdle;
      oShapeCurrX <= 0;
      oShapeCurrY <= 0;
      end
    else
      rFSM_current <= wFSM_next;
  end
  
  // 2. Next state logic
  //  - only defines the value of wFSM_next
  //  - in function of inputs and rFSM_current
  always @(*)
  begin
    case (rFSM_current)
    
      sIdle:    if(iPushLeft == 1)
                    begin
                    wFSM_next <= sLeft;
                    end
                 else if(iPushRight == 1)
                    begin
                    wFSM_next <= sRight;
                    end
                 else if(iPushDown == 1)
                    begin
                    wFSM_next <= sDown;
                    end
                 else if(iPushUp == 1)
                    begin
                    wFSM_next <= sUp;
                    end
                 else
                    begin
                    wFSM_next <= sIdle;
                    end
      
      (sLeft):
                  begin
                  if (iPushLeft == 0)
                      begin
                      wFSM_next <= sIdle;
                      end
                  end
                
      (sRight):
                begin
                if (iPushRight == 0)
                  wFSM_next <= sIdle;
                end
                
       (sUp):
            begin
            if(iPushUp == 0)
                wFSM_next <= sIdle;
            end
       (sDown):
                begin
                if(iPushDown == 0)
                    wFSM_next <= sIdle;
                end
      
      default:  wFSM_next <= sIdle;
    endcase
  end
  
  // 3. Output logic
  // In this case, we need a register to keep track of the toggling
  
  // 3.1 Define the register
  reg ledD,ledU,ledL,ledR;
  always @(posedge toggleOut)
  begin
        ledD = 0;
        ledU = 0;
        ledL = 0;
        ledR = 0;
    if(rFSM_current == sLeft)
        begin
        if(oShapeCurrX>0)
            oShapeCurrX <= oShapeCurrX - 1;
        ledL = 1;
        end
    else if(rFSM_current == sRight)
        begin
        ledR = 1;
        if(oShapeCurrX<420)
            oShapeCurrX <= oShapeCurrX + 1;
        end
    else if(rFSM_current == sUp)
        begin
        ledU = 1;
        if(oShapeCurrY > 420)
            oShapeCurrY <= 420;
        end
    else if(rFSM_current == sDown)
        begin
        ledD = 1;
        if(oShapeCurrY < 0)
            oShapeCurrY <= 0;
        end
        
  end
  
  // the oLED connects to the toggle register
  assign oLEDUp = ledU;
  assign oLEDDown = ledD;
  assign oLEDRight = ledR;
  assign oLEDLeft = ledL;
  assign oShapeX = oShapeCurrX;
  assign oShapeY = oShapeCurrY;
  assign oSize = oSizeCurr;
  
endmodule

