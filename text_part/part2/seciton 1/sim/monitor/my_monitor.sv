class my_monitor extends  uvm_monitor;
    function new( string name= "my_monitor",uvm_component parent = null );
        super.new(name,parent);    
    endfunction //new()
    //注册、
    `uvm_component_utils(my_monitor)
    virtual my_if vif;                                                     //声明类的变量  vif
    virtual function void build_phase(uvm_phase  phase);
        super.build_phase(phase);
        `uvm_info("monitor","build_phase is called",UVM_LOW);
        if(!uvm_config_db#(virtual my_if)::get(this,"","vif",vif)) 
           `uvm_fatal("monitor","interface vif config error!!!!")
    endfunction	
    extern virtual task main_phase(uvm_phase phase); 
    extern virtual task collect_one_pkt(my_transaction tr);  
endclass //className extends superClass

task my_monitor::main_phase(uvm_phase phase);     
    my_transaction tr;
     phase.raise_objection(this);
    `uvm_info("monitor","main_phase is called",UVM_LOW);

    for( int i = 0; i<2;i++ ) begin
        tr = new("tr");
        collect_one_pkt(tr);  	
     end	
     @(posedge vif.clk);                                            //下一个时钟上升沿
	phase.drop_objection(this);
endtask

task my_monitor::collect_one_pkt(my_transaction tr);
    bit  [7:0]   data_q[$];

    while (1) begin
        @(posedge vif.clk);
	  if( vif.valid ) break;
    end
   `uvm_info("my_monitor","data pocket is beginning collect",UVM_LOW);
    //传递的数据都压入堆栈
    while (vif.valid) begin 
        data_q.push_back(vif.data);   //注意此时先压入堆栈
        @(posedge vif.clk);
    end

    //数据解码
    // pop dmac
    for (int i =0 ; i<6 ;i++ ) begin
        tr.dmac  =  {tr.dmac[39:0],data_q.pop_front()};
    end
    // pop smac
    for (int i =0 ; i<6 ;i++ ) begin
        tr.smac  =  {tr.dmac[39:0],data_q.pop_front()};
    end
    //pop ether_type
    for (int i =0 ; i<2 ;i++ ) begin
        tr.ether_type  =  {tr.ether_type[7:0],data_q.pop_front()};
    end
     //pop pload
    for (int i =0 ; i<tr.pload.size();i++ ) begin
        tr.pload[i]  = data_q.pop_front();
    end
     //pop crc
    for (int i =0 ; i<$bits(tr.crc)/8;i++ ) begin
        tr.pload  =  {tr.crc[$bits(tr.crc)-8:0],data_q.pop_front()};
    end

    `uvm_info("my_monitor", "end collect one pkt", UVM_LOW);
     tr.my_print(); 
endtask
