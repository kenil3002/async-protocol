`include "master.v"
`include "slave.v"

module top(clk,rst,start,rw_in,m_data_in,s_data_in,m_rcvd_data,s_rcvd_data);
  
  input clk,rst,start,rw_in;
  input [3:0] m_data_in,s_data_in;
  output [3:0] m_rcvd_data,s_rcvd_data;
  
  wire req;
  wire rw;
  wire [3:0] data_bus;
  
    master u_master (
    .clk       (clk),
    .rst       (rst),
    .start     (start),
    .rw_in     (rw_in),
    .data_in  (m_data_in),
    .req       (req),
    .rw        (rw),
    .rcvd_data (m_rcvd_data),
    .data_bus (data_bus)
  );
  
    slave u_slave (
    .clk       (clk),
    .rst       (rst),
    .start     (start),
    .rw        (rw),
    .req       (req),
    .data_in  (s_data_in),
    .rcvd_data (s_rcvd_data),
    .data_bus (data_bus)
  );
  
endmodule
  