class my_monitor extends  uvm_monitor;
    uvm_analysis_port#( my_transaction )  ap;          // //agt_mdl FIFO 写接口 
    function new( string name= "my_monitor",uvm_component parent = null );
        super.new(name,parent);    
    endfunction //new()
    //注册、
    `uvm_component_utils(my_monitor)
    virtual my_if vif;                                                     //声明类的变量  vif
    virtual function void build_phase(uvm_phase  phase);
        super.build_phase(phase);
        `uvm_info("monitor","build_phase is called",UVM_LOW);
        ap = new("ap",this);
        if(!uvm_config_db#(virtual my_if)::get(this,"","vif",vif)) 
           `uvm_fatal("monitor","interface vif config error!!!!")
    endfunction	
    extern virtual task main_phase(uvm_phase phase); 
    extern virtual task collect_one_pkt(my_transaction tr);  
endclass //className extends superClass

task my_monitor::main_phase(uvm_phase phase);     
    my_transaction tr;                                                                                 //申请的临时变量
     phase.raise_objection(this);
    `uvm_info("monitor","main_phase is called",UVM_LOW);

    for( int i = 0; i<2;i++ ) begin
        tr = new("tr");
        collect_one_pkt(tr);  
        ap.write(tr);
     end	
     @(posedge vif.clk);                                            //下一个时钟上升沿
	phase.drop_objection(this);
endtask

task my_monitor::collect_one_pkt(my_transaction tr);
    byte    unsigned    data_q[$];                                                           //申请一个 动态数组 来接受数据
    byte    unsigned    data_array[];                                                       //静态数组
    int data_size; 
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
    data_size       =   data_q.size();
    data_array      =   new[data_size];                                                  //静态数据 指定大小
    for (int i =0  ;i< data_size ;i++ ) begin
        data_array[i] = data_q[i];                                                          //unpack 要求输入必须是静态数组
    end
    tr.pload          =   new[data_size-18];    
    data_size       =   tr.unpack_bytes(data_array) / 8;              
    `uvm_info("my_monitor", "end collect one pkt", UVM_LOW);
     tr.print(); 
endtask