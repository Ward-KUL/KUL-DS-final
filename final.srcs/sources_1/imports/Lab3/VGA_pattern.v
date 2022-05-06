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
	input	wire		iClk, iRst,
	input	wire [9:0]	iCountH, iCountV,
	input	wire		iHS, iVS,
	input wire iUp,iDown,iRight,iLeft,
	input wire [9:0] iShapeX,iShapeY,iSize,
	output 	wire		oHS_p, oVS_p,
	// 12 bits RGB
	output	wire [3:0]	oRed, oGreen, oBlue
	);
	
	reg [3:0] oRedCurr, oBlueCurr, oGreenCurr;
	
	
	always@(*)
	begin
	
	//in kleuren
	   oRedCurr <= 0;
	   oBlueCurr <= 5;
	   oGreenCurr <= 0;
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
