// Code your testbench here
// or browse Examples
module tb_master();
reg clk,rst,start,rw_in;
  reg[3:0] data_in;
  wire [3:0] data_bus;
  wire req,rw;
  
  
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end
    
  master dut (
        .clk      (clk),
    .rst    (rst),
        .start    (start),
        .rw_in    (rw_in),
        .data_in  (data_in),
        .req      (req),
        .rw       (rw),
        .data_bus (data_bus)
    );
    
  
    initial begin
      $dumpfile("master.vcd");
        $dumpvars(0, tb_master);
    end
  
  initial begin
    #10;
    rst = 1;
    #10;
    data_in = 4'b1111;
    rst =  0 ;
    rw_in = 1'b0;
    #10;
    start = 1'b1;
    #200;
    $finish;
  end
  
endmodule
    
  