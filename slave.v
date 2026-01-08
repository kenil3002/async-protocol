module slave (clk,rst,start,rw,req,data_in,rcvd_data,data_bus);
  
  input clk,rst,start,rw,req;
  input [3:0] data_in;
  output[3:0] rcvd_data;
  inout[3:0] data_bus;
  
  parameter IDLE     = 2'b00,
  			WAIT     = 2'b01,
  			TRANSFER = 2'b10,
  			DONE     = 2'b11;
  
    parameter frq        = 50000000;
    parameter baudrate   = 115200;
    //parameter BAUD_TICKS = frq / baudrate;
    parameter BAUD_TICKS = 2;
  
  reg [1:0] ps,ns;
  reg [12:0] baud_cnt;
  
  wire baud_done = (baud_cnt == BAUD_TICKS-1 );
  
  always @(posedge clk or posedge rst) begin
      if (rst)
            baud_cnt <= 0;
        else if (ps != ns)
            baud_cnt <= 0;
        else if (!baud_done)
            baud_cnt <= baud_cnt + 1;
    end
  
  
  always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= IDLE;
        else
            ps <= ns;
    end

	
  always@(*)
    begin
      case(ps)
        IDLE : if (start) ns = WAIT;
        WAIT : if (req)   ns = TRANSFER;
        TRANSFER : if(baud_done) ns = DONE;
        DONE : if(baud_done) ns = IDLE;
      endcase
          
    end
   
  assign data_bus = ( (ps == TRANSFER) && req && !rw) ? data_in : 4'bz;
  assign rcvd_data = ( (ps == TRANSFER) && req && rw) ? data_bus: 4'b0;
   
   endmodule
   		