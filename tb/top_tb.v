module top_tb;
  reg clk,rst,start,rw_in;
  reg[3:0] m_data_in,s_data_in;
  wire [3:0] m_rcvd_data,s_rcvd_data;
  
  top dut(clk,rst,start,rw_in,m_data_in,s_data_in,m_rcvd_data,s_rcvd_data);
  
    initial begin
      $dumpfile("top.vcd");
      $dumpvars(0, top_tb);
    end
  
  /// master to slave writing
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    rst = 1;
    #15;
    rst = 0;
    start =1;
    rw_in = 0; // writing to slave
    m_data_in = 4'd12;
   #50;
    start = 0;
    #100;
    $finish;
    
  end
  
  
  
  //// slave to mster reading
  
  /*initial begin
    clk = 0;
    forever #5clk = ~clk;
  end
  
  initial begin
        rst = 1;
    #15;
    rst = 0;
    start =1;
    rw_in = 1; // reading  to slave
    s_data_in = 4'd13;
   #50;
    start = 0;
    #100;
    $finish;
    
  end*/
  
endmodule