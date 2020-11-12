`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2020 07:44:57 PM
// Design Name: 
// Module Name: RAW_detection_unit
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


module RAW_detection_unit(
    input [4:0] WriteBackDest,
    input [4:0] EXMEM_Rt,
    output reg select
    );
    
    always @(*) begin
    select = 1'b0;
    if (WriteBackDest == EXMEM_Rt)
        select = 1'b1;
    end
endmodule
