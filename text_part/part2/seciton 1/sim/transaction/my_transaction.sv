class my_transaction extends uvm_sequence_item;
     rand bit [47:0] dmac;
     rand bit [47:0] smac;
     rand bit [15:0] ether_type;
     rand byte  pload[];
     rand bit  [31:0] crc;

     constraint pload_cons{
        pload.size  >= 46     ;
        pload.size  <= 1500   ;
     }
    function bit [31:0] calc_crc();
      return 32'h0;
    endfunction

    function void post_randomize();                                          //post_randomize是SystemVerilog中提供的一个函数，当某个类的实例的randomize函数被调用后，post_randomize会紧随其后无条件地被调用。
      crc = calc_crc ;
    endfunction
     //实现factory 机制
   // `uvm_object_utils(my_transaction)
     //声明函数  包含名字
    function new(string name = "my_transaction");
      super.new(name);
    endfunction //
  `uvm_object_utils_begin(my_transaction)
    `uvm_field_int(dmac,UVM_ALL_ON);                          //整型
    `uvm_field_int(smac,UVM_ALL_ON);
    `uvm_field_int(ether_type,UVM_ALL_ON);
    `uvm_field_array_int(pload,UVM_ALL_ON);                //列表，里面的内容是int
    `uvm_field_int(crc,UVM_ALL_ON);
  `uvm_object_utils_end
endclass //my_transaction extends uvm_sequence_item  

