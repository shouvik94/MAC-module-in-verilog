
module tb_MAC_float;

  reg [31:0] a, b;
  reg clk,en,rst;
  wire [31:0] result;
  
  
  MAC_float mac_inst (
    a,b,clk,en,rst,result
  );
	
  
  
  always #5 clk = ~clk;
  
  initial begin
    clk = 0;
  	en = 0;
    rst =0;
    #5 rst = 1;
    #5 rst = 0;
    en =1;
    
    #10 
     a=32'h40accccd;  //5.4 
     b=32'h400ccccd;   // * 2.2 = 11.88 = 0x413e147b
    
     #10
     a=32'h40500000; // + 3.25
     b=32'h40b00000; // * 5.5 = 17.875 + 11.88 = 29.755 = 0x41ee0a3d
    
    #10
     a=32'h40f33333; //+ 7.6 
     b=32'h40800000; // * 4 = 29.755 + 30.4 = 60.155 = 0x42709eb8
    
    #10
     a=32'h40400000; //+ 3 
    b=32'hc0200000; // * (-2.5) = 60.155 - 7.5 = 52.655 = 0x42529eb8
    
    
    
    
    

    #20 $finish;
  end

//  always @(posedge clk) begin
//    $display("Time = %0t, a = %h, b = %h, en = %b,clk = %b, rst= %b, result = %h", $time, a, b,en,clk,rst,result);
//  end
  
//  initial begin
//    $dumpfile("dump.vcd");
//    $dumpvars(1);
//  end

endmodule
