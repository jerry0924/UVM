class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    uvm_analysis_port#( my_transaction )  ap;   
    function new(string name= "my_agent",uvm_component parent = null);
        super.new(name,parent);    
    endfunction //new()
    my_driver           drv;
    my_monitor          mon;
    my_sequencer        sqr; 
    extern virtual function void build_phase(uvm_phase  phase);
    extern virtual function void connect_phase(uvm_phase  phase);
endclass //className extends superClass  用来管理monitor 和 driver

function void my_agent::build_phase(uvm_phase  phase);                             //构造 driver 和 monitor
    super.build_phase(phase);
        `uvm_info("agent","build_phase is called",UVM_LOW);
        if( is_active == UVM_ACTIVE )begin
            drv = my_driver::type_id::create("drv", this);
            sqr = my_sequencer::type_id::create("sqr", this);
        end
        mon = my_monitor::type_id::create("mon", this);
endfunction
function void my_agent::connect_phase(uvm_phase  phase);                             //连接函数                         
    super.connect_phase(phase);
        `uvm_info("agent","connect_phase is called",UVM_LOW);
        if(is_active == UVM_ACTIVE )begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
        ap = mon.ap;
endfunction