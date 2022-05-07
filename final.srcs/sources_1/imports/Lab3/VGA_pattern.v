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
	parameter initV = 210,
	
	parameter colorTimer = 3,
	parameter Ncolor = $clog2(colorTimer -1)
	)
	(
	input	wire		iClk, iRst,iColor,
	input	wire [9:0]	iCountH, iCountV,
	input	wire		iHS, iVS,vSync,
	input wire iUp,iDown,iRight,iLeft,
	input wire [9:0] iShapeX,iShapeY,iSize,
	output 	wire		oHS_p, oVS_p,
	// 12 bits RGB
	output	wire [3:0]	oRed, oGreen, oBlue
	);
	
	reg [3:0] oRedCurr, oBlueCurr, oGreenCurr;
	reg [3:0] redBack,blueBack,greenBack;
	reg [2:0] colorSelect;
	reg redUp,greenUp,blueUp;
	wire colorSync;
	wire [Ncolor:0] counterOut;
    counter#(.LIM(10))
    counter_vga(.iClk(vSync),.iRst(iRst),.iEnable(1),.oQ(counterOut));
	
	always@(posedge colorSync)
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
	          if(redUp == 1)
                  begin
                   if(redBack < 15)
                        begin
                       redBack <= redBack + 1;
                       end
                   else
                        begin
                        redUp <= 0;
                        redBack <= redBack -1;
                        end
                  end
              else
                begin
                    if(redBack > 0)
                        redBack <= redBack - 1;
                    else 
                        begin
                        redBack <= redBack +1 ;
                        redUp <= 1;
                        end
                end
              end
           else if(colorSelect == 1 || colorSelect == 5)
                begin
                if(greenUp == 1)
                    begin
                    if(greenBack < 15)
                        greenBack <= greenBack +1;
                    else
                        greenUp <= 0;
                    end
                else 
                    begin
                    if(greenBack > 0)
                        greenBack <= greenBack -1;
                    else 
                        greenUp <= 1;
                    end
                end
           else if(colorSelect == 3)
           begin
                if(blueUp == 1)
                begin
                    if(blueBack <15)
                        blueBack <= blueBack + 1;
                    else
                        blueUp <= 0;
                end
                else
                    begin
                    if(blueBack > 0)
                        blueBack <= blueBack -1;
                    else
                        blueUp <= 1;
                    end
           end
           if(colorSelect < 5)
	           colorSelect <= colorSelect + 1;
	       else
	           colorSelect <= 0;
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
	
	assign colorSync = (counterOut == (colorTimer -1))?1:0;
	
endmodule
