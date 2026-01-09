module tb_slave;
  reg clk,rst,start,rw,req;
  reg[3:0] data_in;
  wire[3:0] rcvd_data;
  wire[3:0] data_bus;
  
  slave dut (.clk(clk), .rst(rst), .start(start), .rw(rw), .req(req), .data_in(data_in), .rcvd_data(rcvd_data), .data_bus(data_bus));
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
   initial begin
     $dumpfile("slave.vcd");
     $dumpvars(0, tb_slave);
    end
  
  initial begin
    #10 rst = 1;
    #10 rst = 0;
    start = 1;
    data_in = 4'd9;
    rw = 0;
    repeat(3)
      @(posedge clk);
    req = 1;
    repeat(3)
      @(posedge clk);
    req = 0;
    #100;
    $finish;
  end
  
endmodule