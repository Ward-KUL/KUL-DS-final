`timescale 1ns / 1ps

module LED_toggling_FSM #(
    parameter CLK_FREQ = 25_000_000,
    parameter WIDTH		= 640,
	parameter H_FP		= 16,
	parameter H_PW		= 96,
	parameter H_BP		= 48,
	// V total = 480 + 10 + 2 + 33 = 525
	parameter HEIGTH	= 480,
	parameter V_FP		= 10,
	parameter V_PW		= 2,
	parameter V_BP		= 33,
	
	parameter increment = 1,
	parameter initSize = 60,
	parameter initH = 290,
	parameter initV = 210
    )
    
    (
  input   wire  iClk, iRst, iPushUp, iPushDown, iPushLeft, iPushRight,iSpecialMode,
  output  wire  oLEDUp,oLEDDown,oLEDRight,oLEDLeft,
  output wire [9:0] oShapeX,oShapeY,oSize
    );
    
  // 0. State definition
  localparam sIdle    = 3'b000;
  localparam sUp    = 3'b001;
  localparam sDown    = 3'b010;
  localparam sLeft = 3'b011;
  localparam sRight = 3'b100;
  localparam sReset = 3'b111;
  
  localparam endH = WIDTH - initSize;
  localparam endV = HEIGTH - initSize;
  
  reg[2:0] rFSM_current, wFSM_next;
  reg [9:0] oShapeCurrX, oShapeCurrY, oSizeCurr;
  wire toggleOut;
  timer_1s#(.CLK_FREQ(100000))
  timer_inst(.iClk(iClk),.iRst(iRst),.oQ(toggleOut));
  // 1. State register
  //  - with synchronous reset
  always @(posedge iClk)
  begin
    if (iRst == 1)
        begin
      rFSM_current <= sReset;
      end
    else if(iSpecialMode == 0)
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
      (sReset):
                begin
                if(iPushLeft == 1)
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
                    wFSM_next <= sReset;
                end
      
      (sLeft):
                  begin
                  if (iPushLeft == 0)
                      begin
                      wFSM_next <= sIdle;
                      end
                  else
                    wFSM_next <= sLeft;
                  end
                
      (sRight):
                begin
                if (iPushRight == 0)
                  wFSM_next <= sIdle;
                else
                    wFSM_next <= sRight;
                end
                
       (sUp):
            begin
            if(iPushUp == 0)
                wFSM_next <= sIdle;
            else
                wFSM_next <= sUp;
            end
       (sDown):
                begin
                if(iPushDown == 0)
                    wFSM_next <= sIdle;
                else
                    wFSM_next <= sDown;
                end
      
      default:  wFSM_next <= sReset;
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
        if(rFSM_current == sReset)
            begin
            oShapeCurrX <= 290;
            oShapeCurrY <= 210;
            oSizeCurr <= 60;
            end
        else if(rFSM_current == sLeft)
            begin
            if(oShapeCurrX>0)
                oShapeCurrX <= oShapeCurrX - 1;
            else if(iSpecialMode == 1)
                begin
                oSizeCurr = oSizeCurr + 1;
                oShapeCurrX <= WIDTH - oSizeCurr;
                end
            ledL = 1;
            end
        else if(rFSM_current == sRight)
            begin
            ledR = 1;
            if(oShapeCurrX<WIDTH - oSizeCurr)
                oShapeCurrX <= oShapeCurrX + 1;
            else if(iSpecialMode == 1)
                begin
                oShapeCurrX <= 0;
                oSizeCurr = oSizeCurr + 1;
                end
            end
        else if(rFSM_current == sUp)
            begin
            ledU = 1;
            if(oShapeCurrY > 0 )
                oShapeCurrY <= oShapeCurrY - 1;
            else if(iSpecialMode == 1)
                begin
                oShapeCurrY <= HEIGTH - oSizeCurr;
                oSizeCurr = oSizeCurr + 1;
                end
            end
        else if(rFSM_current == sDown)
            begin
            ledD = 1;
            if(oShapeCurrY < HEIGTH-oSizeCurr)
                oShapeCurrY <= oShapeCurrY + 1;
            else if(iSpecialMode == 1)
                begin
                oShapeCurrY <= 0;
                oSizeCurr = oSizeCurr + 1;
                end
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

