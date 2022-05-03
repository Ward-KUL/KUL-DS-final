`timescale 1ns / 1ps

module LED_toggling_FSM #(
    parameter CLK_FREQ = 25_000_000,
    parameter WIDTH		= 640,
    parameter HEIGTH	= 480,
    parameter initSize = 60,
	parameter initH = 290,
	parameter initV = 210
    )
    
    (
  input   wire  iClk, iRst, iPushUp, iPushDown, iPushLeft, iPushRight,
  output  wire  oLEDUp,oLEDDown,oLEDRight,oLEDLeft,
  output wire [9:0] oShapeX,oShapeY,oShapeSize
    );
    
  // 0. State definition
  localparam sIdle    = 4'b0000;
  localparam sUp    = 4'b0001;
  localparam sDown    = 4'b0010;
  localparam sLeft = 4'b0011;
  localparam sRight = 4'b0100;
  localparam sNoUp    = 4'b1001;
  localparam sNoDown    = 4'b1010;
  localparam sNoLeft = 4'b1011;
  localparam sNoRight = 4'b1100;
  
  reg[3:0] rFSM_current, wFSM_next;
  reg [9:0] iPosCurrV,iPosCurrH,iShapeSize;
  reg toggleRst;
  wire toggleOut;
  toggle #(.CLK_FREQ(CLK_FREQ))
  toggle_instance(.iClk(iClk),.iRst(toggleRst),.oToggle(toggleOut));
  // 1. State register
  //  - with synchronous reset
  always @(posedge iClk)
  begin
    if (iRst == 1)
      rFSM_current <= sIdle;
    else
      rFSM_current <= wFSM_next;
  end
  
  // 2. Next state logic
  //  - only defines the value of wFSM_next
  //  - in function of inputs and rFSM_current
  always @(*)
  begin
    if(iRst == 1)
        begin
        iPosCurrH <= initH;
	    iPosCurrV <= initV;
	    end
	else
	   begin
        case (rFSM_current)
        
          sIdle:    if(iPushLeft == 1)
                        begin
                        wFSM_next <= sLeft;
                        toggleRst = 1;
                        end
                     else if(iPushRight == 1)
                        begin
                        wFSM_next <= sRight;
                        toggleRst = 1;
                        end
                     else if(iPushDown == 1)
                        begin
                        wFSM_next <= sDown;
                        toggleRst = 1;
                        end
                     else if(iPushUp == 1)
                        begin
                        wFSM_next <= sUp;
                        toggleRst = 1;
                        end
                     else
                        begin
                        wFSM_next <= sIdle;
                        toggleRst = 0;
                        end
          
          (sLeft):
                      if (iPushLeft == 0)
                      begin
                      wFSM_next <= sIdle;
                      end
                    else
                      begin
                      toggleRst = 0;
                      if(toggleOut == 1)
                        wFSM_next <= sNoLeft;
                      else 
                        wFSM_next <= sLeft;
                      end
           (sNoLeft):
                    if (iPushLeft == 0)
                      begin
                      wFSM_next <= sIdle;
                      end
                    else
                      begin
                      toggleRst = 0;
                      if(toggleOut == 1)
                        wFSM_next <= sNoLeft;
                      else 
                        begin
                        wFSM_next <= sLeft;
                        iPosCurrH <= iPosCurrH - 1;
                        if(iPosCurrH < 0)
                           iPosCurrH <= 0;
                        end
                      end
                    
          (sRight):
                    if (iPushRight == 0)
                      wFSM_next <= sIdle;
                    else
                        begin
                        toggleRst = 0;
                        if(toggleOut == 1)
                            wFSM_next <= sNoRight;
                        else
                            wFSM_next <= sRight;
                        end
           (sNoRight):
                    if (iPushRight == 0)
                      wFSM_next <= sIdle;
                    else
                        begin
                        toggleRst = 0;
                        if(toggleOut == 1)
                            wFSM_next <= sNoRight;
                        else
                            begin
                            wFSM_next <= sRight;
                            iPosCurrH <= iPosCurrH + 1;
                            if(iPosCurrH > (WIDTH - iShapeSize))
                                iPosCurrH <= WIDTH - iShapeSize;
                            end
                        end
                    
           (sUp):
                if(iPushUp == 0)
                    wFSM_next <= sIdle;
                else
                    begin
                    toggleRst = 0;
                    if(toggleOut == 1)
                        wFSM_next <= sNoUp;
                    else
                        wFSM_next <= sUp;
                    end
           (sNoUp):
                if(iPushUp == 0)
                    wFSM_next <= sIdle;
                else
                    begin
                    toggleRst = 0;
                    if(toggleOut == 1)
                        wFSM_next <= sNoUp;
                    else
                        begin
                        wFSM_next <= sUp;
                        iPosCurrV <= iPosCurrV - 1;
                        if(iPosCurrV < 0)
                           iPosCurrV <= 0;
                        end
                    end
           (sDown):
                    if(iPushDown == 0)
                        wFSM_next <= sIdle;
                    else
                        begin
                        toggleRst = 0;
                        if(toggleOut == 1)
                            wFSM_next <= sNoDown;
                        else
                            wFSM_next <= sDown;
                        end
            (sNoDown):
                    if(iPushDown == 0)
                        wFSM_next <= sIdle;
                    else
                        begin
                        toggleRst = 0;
                        if(toggleOut == 1)
                            wFSM_next <= sNoDown;
                        else
                            begin
                            wFSM_next <= sDown;
                            iPosCurrV <= iPosCurrV + 1;
                            if(iPosCurrV > (HEIGTH-iShapeSize))
                               iPosCurrV <= (HEIGTH - iShapeSize);
                            end
                        end
          

          default:  wFSM_next <= sIdle;
        endcase
     end
  end
  
  // 3. Output logic
  // In this case, we need a register to keep track of the toggling
  
  // 3.1 Define the register
  reg ledD,ledU,ledL,ledR;
  
  always @(*)
  begin
        ledD = 0;
        ledU = 0;
        ledL = 0;
        ledR = 0;
        iShapeSize = initSize;
    if(rFSM_current == sLeft)
        begin
        ledL = 1;

        end
    else if(rFSM_current == sRight)
        begin
        ledR = 1;

        end
    else if(rFSM_current == sUp)
        begin
        ledU = 1;

        end
    else if(rFSM_current == sDown)
        begin
        ledD = 1;

        end
        
  end
  
  // the oLED connects to the toggle register
  assign oLEDUp = ledU;
  assign oLEDDown = ledD;
  assign oLEDRight = ledR;
  assign oLEDLeft = ledL;
  assign oShapeX = iPosCurrH;
  assign oShapeY = iPosCurrV;
  assign oShapeSize = iShapeSize;
  
endmodule

