interface my_if#(
parameter DATA_WIDTH = 8
)(
    input               clk               ,
    input               rst_n             
);
    logic   [ DATA_WIDTH-1: 0 ]     data        ;
    logic                           valid       ;

endinterface //my_if
