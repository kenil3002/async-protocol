
module master (
    input        clk,
    input        rst,
    input        start,
    input        rw_in,
    input  [3:0] data_in,
  	//input i0,i1,i2,i3
    output reg   req,
    output reg   rw,
    output [3:0] rcvd_data,
    inout  [3:0] data_bus
);

    
    parameter IDLE     = 2'b00,
              SETUP    = 2'b01,
              TRANSFER = 2'b10,
              DONE     = 2'b11;

    
    parameter frq        = 50000000;
    parameter baudrate   = 115200;
    //parameter BAUD_TICKS = frq / baudrate;
   parameter BAUD_TICKS = 2;

    reg [1:0] ps, ns;
    reg [12:0] baud_cnt;

    wire baud_done = (baud_cnt == BAUD_TICKS-1);

    
    always @(posedge clk or negedge rst) begin
      if (rst)
            baud_cnt <= 0;
        else if (ps != ns)
            baud_cnt <= 0;
        else if (!baud_done)
            baud_cnt <= baud_cnt + 1;
    end

    /*always @(posedge clk or posedge rst) begin
       if (rst)
          rcvd_data <= 4'b0000;
   // else if (ps == TRANSFER && rw_in && baud_done)
    else if (ps == TRANSFER && rw_in)
          rcvd_data <= data_bus;
    end*/

    
    always @(posedge clk or negedge rst) begin
        if (rst)
            ps <= IDLE;
        else
            ps <= ns;
    end

    
    always @(*) begin
        ns = ps;
        case (ps)
            IDLE:     if (start)     ns = SETUP;
            SETUP:    if (baud_done) ns = TRANSFER;
            TRANSFER: if (baud_done) ns = DONE;
            DONE:     if (baud_done) ns = IDLE;
        endcase
    end

   
  always @(*) begin
    req = 0;
    rw  = 0;

    case (ps)
        IDLE: begin
            req = 0;
            rw  = 0;
        end

        SETUP: begin
            req = 0;
            rw  = rw_in;
        end

        TRANSFER: begin
            req = 1;
            rw  = rw_in;
          
        end

        DONE: begin
            req = 0;
            rw  = 0;
        end
    endcase
end


    	
  assign data_bus = ((ps == TRANSFER) && req && !rw) ? data_in : 4'bz;
  assign rcvd_data = ((ps == TRANSFER) && req && rw) ? data_bus :4'b0;

endmodule
