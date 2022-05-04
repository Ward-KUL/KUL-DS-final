`timescale 1ns / 1ps

module LED_toggling_FSM #(
    parameter CLK_FREQ = 25_000_000
    )
    
    (
  input   wire  iClk, iRst, iPushUp, iPushDown, iPushLeft, iPushRight,
  output  wire  oLEDUp,oLEDDown,oLEDRight,oLEDLeft
    );
    
  // 0. State definition
  localparam sIdle    = 4'b0000;
  localparam sUp    = 4'b0001;
  localparam sDown    = 4'b0010;
  localparam sLeft = 4'b0011;
  localparam sRight = 4'b0100;
  
  reg[3:0] rFSM_current, wFSM_next;
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
                  begin
                  toggleRst = 0;  
                  if (iPushLeft == 0)
                      begin
                      wFSM_next <= sIdle;
                      end
                  end
                
      (sRight):
                begin
                toggleRst = 0;
                if (iPushRight == 0)
                  wFSM_next <= sIdle;
                end
                
       (sUp):
            begin
            toggleRst = 0;
            if(iPushUp == 0)
                wFSM_next <= sIdle;
            end
       (sDown):
                begin
                toggleRst = 0;
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
  always @(*)
  begin
        ledD = 0;
        ledU = 0;
        ledL = 0;
        ledR = 0;
    if(rFSM_current == sLeft)
        begin
        ledL = toggleOut;
        end
    else if(rFSM_current == sRight)
        begin
        ledR = toggleOut;
        end
    else if(rFSM_current == sUp)
        begin
        ledU = toggleOut;
        end
    else if(rFSM_current == sDown)
        begin
        ledD = toggleOut;
        end
        
  end
  
  // the oLED connects to the toggle register
  assign oLEDUp = ledU;
  assign oLEDDown = ledD;
  assign oLEDRight = ledR;
  assign oLEDLeft = ledL;
  
endmodule

