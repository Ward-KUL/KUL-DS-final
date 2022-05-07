`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2022 14:24:35
// Design Name: 
// Module Name: VGA_pattern
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


module VGA_pattern #(
	// H total = 640 + 16 + 96 + 48 = 800
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
	input	wire		iClk, iRst,iColor,
	input	wire [9:0]	iCountH, iCountV,
	input	wire		iHS, iVS,
	input wire iUp,iDown,iRight,iLeft,
	input wire [9:0] iShapeX,iShapeY,iSize,
	output 	wire		oHS_p, oVS_p,
	// 12 bits RGB
	output	wire [3:0]	oRed, oGreen, oBlue
	);
	
	reg [3:0] oRedCurr, oBlueCurr, oGreenCurr;
	reg [3:0] redBack,blueBack,greenBack;
	reg [2:0] colorSelect;
	wire colorToggle; 
	
	timer#(.CLK_FREQ(100000))
    timer_ins(.iClk(iClk),.iRst(iRst),.oQ(colorToggle));
	
	always@(posedge colorToggle)
	begin
	   if(iColor == 0)
	       begin
	       redBack <= 0;
	       blueBack <= 5;
	       greenBack <= 0;
	       colorSelect <= 0;
	       end
	   else
	       begin
	       if(colorSelect == 0 || colorSelect == 2 || colorSelect == 4)
	          begin
               if(redBack < 15)
                   redBack <= redBack + 1;
               else
                    redBack <= 0;
              end
           else if(colorSelect == 1 || colorSelect == 5)
                begin
                if(greenBack < 15)
                    greenBack <= greenBack +1;
                else
                    greenBack <= 0;
                end
           else if(colorSelect == 3)
            begin
                if(redBack <15)
                    blueBack <= blueBack + 1;
                else
                    blueBack <= 0;
            end
	       colorSelect <= colorSelect + 1;
	   end
	       
	end
	
	always@(*)
	begin

	//in kleuren
	   oRedCurr <= redBack;
	   oBlueCurr <= blueBack;
	   oGreenCurr <= greenBack;
	   if(iCountH >= WIDTH || iCountV >= HEIGTH)
	       begin
	           oRedCurr <= 0;
	           oBlueCurr <= 0;
	           oGreenCurr <= 0;
	       end
	   else if(((iCountH >= iShapeX) && (iCountV >= iShapeY)) && (iCountH <= (iShapeX + initSize)) && (iCountV <= (iShapeY + initSize))) //blok
	       begin
	           oRedCurr <= 15;
	           oBlueCurr <= 0;
	           oGreenCurr <= 0;
	       end
	
	end
		
    assign oHS_p = iHS;
    assign oVS_p = iVS;
    assign oRed = oRedCurr;
    assign oBlue = oBlueCurr;
    assign oGreen = oGreenCurr;
	
	
endmodule
