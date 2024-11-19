`timescale  1ns/1ps
`include "uvm_macros.svh"  //这个文件是 UVM 框架中的标准头文件，包含了一组预定义的 UVM 宏（例如 uvm_info、 uvm_error、 uvm_warning` 等）。

import uvm_pkg::*;          //语句使用户能够访问 uvm_pkg 包中定义的所有 UVM 类和方法，而不需要在每次使用它们时都指定完整路径。例如，可以直接使用 uvm_component、uvm_env、uvm_driver 等常见的 UVM 类。
`include "my_transaction.sv"
`include "test.sv"
`include "my_if.sv"
`include "my_driver.sv"

module top_tb();
reg                         clk             ;
reg                         rst_n           ;
reg                         rx_en           ;
reg         [7:0]           rx_data         ;
wire        [7:0]           tx_data         ;
wire                        tx_en           ;

//parameter 定义 后面可以行成专门的文件
localparam  DATA_WIDTH = 8 ;

//接口例化
my_if input_if(clk,rst_n);                                                  //这里的例化类比 传统的模块例化（接口例化）

dut my_dut(
.clk            (   clk                    ),
.rst_n          (   rst_n                  ),
.rx_data        (   input_if.data          ),
.rx_en          (   input_if.valid         ),
.tx_data        (   tx_data                ),
.tx_en          (   tx_en                  )                 
);
//时钟和复位激励
initial begin
    clk = 0;
    forever begin
        #100 clk = ~clk;
    end
end

initial begin
    rst_n = 1'b0;
    #1000;
    rst_n = 1'b1;
end
//激励调用
initial begin
    run_test("my_driver");
end
//波形产生
initial begin
	$fsdbDumpfile("tb.fsdb"); //指定生成的的fsdb
	$fsdbDumpvars(0,top_tb);   //0表示生成dut模块及以下所有的仿真数据
	$vcdpluson;   //下面这两个是保存所有仿真数据
	$vcdplusmemon;
end
//接口连接
initial begin
    uvm_config_db#(virtual my_if)::set(null,"uvm_test_top","vif",input_if);                 //#(virtual my_if)：定义 uvm_config_db 操作的数据类型。这里 my_if 是虚接口类型。
end

endmodule
