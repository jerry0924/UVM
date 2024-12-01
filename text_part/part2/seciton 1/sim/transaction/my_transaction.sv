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
    `uvm_object_utils(my_transaction)
     //声明函数  包含名字
    function new(string name = "my_transaction");
      super.new(name);
    endfunction //

    function void my_print();
      $display("dmac = %0h", dmac);
      $display("smac = %0h", smac);
      $display("ether_type = %0h", ether_type);
      for(int i = 0; i < pload.size; i++) begin
        $display("pload[%0d] = %0h", i, pload[i]);
      end
      $display("crc = %0h", crc);
    endfunction    
endclass //my_transaction extends uvm_sequence_item  

