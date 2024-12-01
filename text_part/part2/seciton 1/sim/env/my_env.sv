class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    function new( string name= "my_env",uvm_component parent = null );
        super.new(name,parent);    
    endfunction //new()
  
    my_agent  i_agt;
    my_agent  o_agt;
    virtual function void build_phase(uvm_phase  phase);
        super.build_phase(phase);
        `uvm_info("env","build_phase is called",UVM_LOW);
        i_agt = my_agent::type_id::create("i_agt", this);
        o_agt = my_agent::type_id::create("o_agt", this);
        i_agt.is_active = UVM_ACTIVE;
        o_agt.is_active = UVM_PASSIVE;
    endfunction	
    
endclass //className extends superClass
