`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: The Dude
// 
// Create Date: 11/09/2020 08:56:02 PM
// Design Name: 
// Module Name: forwarding_unit
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

//Inmplements the forwarding functionality neccessary to avoid common data hazards
module forwarding_unit(forwardA, forwardB, EXMEM_RegWrite, MEMWB_RegWrite, IDEX_Rs, IDEX_Rt, EXMEM_Dest, MEMWB_Dest);
    output reg  [1:0] forwardA;
    output reg  [1:0] forwardB;
    input             EXMEM_RegWrite;
    input             MEMWB_RegWrite;
    input       [4:0] IDEX_Rs;
    input       [4:0] IDEX_Rt;
    input       [4:0] EXMEM_Dest;          
    input       [4:0] MEMWB_Dest;      
    
    always @(*) begin
        //Default Case
        forwardA = 2'b00;
        forwardB = 2'b00;
          
        //Check for one away first, then two away if not one away
        if (EXMEM_Dest != 0 && IDEX_Rs == EXMEM_Dest && EXMEM_RegWrite) begin
            forwardA = 2'b10;
        end else begin
            if (MEMWB_Dest != 0 && IDEX_Rs == MEMWB_Dest && MEMWB_RegWrite) begin         
                forwardA = 2'b01;
            end
        end
        
        if (EXMEM_Dest != 0 && IDEX_Rt == EXMEM_Dest && EXMEM_RegWrite) begin
            forwardB = 2'b10;
        end else begin 
            if (MEMWB_Dest != 0 && IDEX_Rt == MEMWB_Dest && MEMWB_RegWrite) begin
                forwardB = 2'b01;
            end
        end
    end
    
endmodule
