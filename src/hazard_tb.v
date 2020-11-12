`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2020 09:39:03 PM
// Design Name: 
// Module Name: hazard_tb
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


module hazard_tb();

   // Inputs
   reg clk;
   reg Reset;
   reg LoadInstructions;
   reg [31:0] Instruction;
   
   // Outputs
   wire [31:0] out;
   
   // Instantiate the Unit Under Test (UUT)
   CPU uut (
            .out(out), 
            .clk(clk), 
            .Reset(Reset), 
            .LoadInstructions(LoadInstructions), 
            .Instruction(Instruction)
            );
   
   initial begin
      // Initialize Inputs
      clk = 0;
      Reset = 1;
      LoadInstructions = 0;
      Instruction = 0;
      #10;
      
      Reset = 0;
      LoadInstructions = 1;
      // #10;
      // 0
	  
	  Instruction = 32'b001000_00000_00001_0000000110100111; // addi $R1, $0, 423
      #10; // 1                                              // -> 423
      Instruction = 32'b001000_00000_00010_0000000001011100; // addi $R2, $0, 92
      #10; // 2                                              // -> 92
      Instruction = 32'b001000_00000_00011_0000000000001101; // addi $R3, $0, 13
      #10; // 3                                              // -> 13
      Instruction = 32'b001000_00000_00100_0000000010010010; // addi $R4, $0, 146
      #10; // 4                                              // -> 146
      Instruction = 32'b001000_00000_00101_0000000000000101; // addi $R5, $0, 5
      #10; // 5                                              // -> 5
	  
	  //One away test for Rt
	  Instruction = 32'b000000_00001_00101_00101_00000_100000; // add $R5, $R1, $R5
      #10; // 6                                             // -> 428 (423 if wrong)
	  
	  //One away test for Rs
	  Instruction = 32'b001000_00101_00101_0000000000000101; // addi $R5, $R5, 5
      #10; // 7                                              // -> 433 (428 or 423 if wrong)	  
	  
	  //Two away test for Rt
	  Instruction = 32'b001000_00000_00011_0000000101001101;   // addi $R3, $0, 333
      #10; // 8                                                // -> 333
	  Instruction = 32'b001000_00000_00010_0000000011011110;   // addi $R2, $0, 222
      #10; // 9                                                // -> 222
      Instruction = 32'b000000_00001_00011_00110_00000_100000; // add $R6, $R1, $R3
      #10; // 10                                               // -> 756 (436 if wrong)
      
      //Two away test for Rs
      Instruction = 32'b000000_00010_00001_00110_00000_100000; // add $R6, $R2, $R1
      #10; // 11                                               // -> 645 (515 if wrong)
      
      //One away and two away test for Rs (should prioritize one away)
      Instruction = 32'b000000_00110_00001_00111_00000_100000; // add $R7, $R6, $R1
      #10; // 12                                               // -> 1068 if correct
	  
	  //Pre-Test register bypass (NOP)
	  Instruction = 32'b000000_00000_00000_00000_00000_000000; // NOP instruction to test
      #10; // 13                                               // register bypass w/ next inst.  

	  //Test register bypass
	  Instruction = 32'b000000_00110_00011_00001_00000_100000; // add $R1, $R6, $R3
      #10;  // 14                                              // testing R6: R1 = (645 + 333) = 958 if correct
      
      //Test No Write using BEQ
 	  Instruction = 32'b000100_00110_00000_0000000000001000; // BEQ $R5, $R0, d'8 (offset)
      #10; // 15
      	  
 	  //cont. Test No Write using BEQ  
      Instruction = 32'b000000_00110_00001_00110_00000_100000; // add $R6, $R5, $R1
      #10; // 16                                               // should not forward (not writing to reg)
      
      //Test 0 Write Forwarding
      Instruction = 32'b000000_00110_00001_00000_00000_100000; // add $R0, $R5, $R1
      #10; // 17                                              // should not forward (writing to $0)
                                                     
       //cont. Test 0 Write Forwarding
      Instruction = 32'b000000_00000_00001_00110_00000_100000; // add $R6, $R0, $R1
      #10; // 18                                               // thus no forwarding (can check using waveform)
                                                                                                                                                  	  
	  //Extra Credit Test
	  Instruction = 32'b100011_00010_00001_000000000001010;   // LW $R1, 10($R2)
      #10; // 19                                              // -> 0
      
      Instruction = 32'b101011_00100_00001_0000000000000000;  // SW $R1, 0($R4)
      #10; // 20                                              // -> not 423 (in our case 146)
      
      
      
      
      LoadInstructions = 0;
      Reset = 1;
      #10;
		
      Reset = 0;
      #100;
      
   end
	
   always begin
      #5;
      clk = ~clk;
   end

endmodule
