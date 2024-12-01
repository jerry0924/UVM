class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    function new( string name= "my_env",uvm_component parent = null );
        super.new(name,parent);    
    endfunction //new()
  
    my_driver   drv;
    my_monitor  i_mon;
    my_monitor  o_mon;
    virtual function void build_phase(uvm_phase  phase);
        super.build_phase(phase);
        `uvm_info("env","build_phase is called",UVM_LOW);
        drv = my_driver::type_id::create("drv", this);
        i_mon = my_monitor::type_id::create("i_mon", this);
        o_mon = my_monitor::type_id::create("o_mon", this);
    endfunction	
    
endclass //className extends superClass
