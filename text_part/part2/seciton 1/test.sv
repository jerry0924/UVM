//

module dut #(
    DATA_WIDTH      =      8
) (
    input   wire                              clk             ,
    input   wire                              rst_n           ,

    input   wire                              rx_en           ,
    input   wire      [DATA_WIDTH-1:0]        rx_data         ,

    output  reg                               tx_en           ,
    output  reg       [DATA_WIDTH-1:0]        tx_data           
);
    

    always@(posedge clk ) begin
        if ( !rst_n )begin
            tx_en           <=      1'b0                        ;
            tx_data         <=      {DATA_WIDTH{1'b0}}          ; 
        end 
        else begin
            tx_en           <=      rx_en                       ;
            tx_data         <=      rx_data                     ; 
        end
    end
endmodule
