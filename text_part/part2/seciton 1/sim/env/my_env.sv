class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    uvm_tlm_analysis_fifo #(my_transaction) agt_mdl_fifo;
     uvm_tlm_analysis_fifo #(my_transaction) mdl_scd_fifo;
    function new( string name= "my_env",uvm_component parent = null );
        super.new(name,parent);    
    endfunction //new()
  //协议 driver monitor
    my_agent  i_agt;
    my_agent  o_agt;
//reference model
    my_model mdl;
    virtual function void build_phase(uvm_phase  phase);
        super.build_phase(phase);
        `uvm_info("env","build_phase is called",UVM_LOW);
        i_agt = my_agent::type_id::create("i_agt", this);
        o_agt = my_agent::type_id::create("o_agt", this);
        i_agt.is_active = UVM_ACTIVE;
        o_agt.is_active = UVM_PASSIVE;
        mdl = my_model::type_id::create("mdl", this);
        agt_mdl_fifo = new("agt_mdl_fifo",this);
        mdl_scd_fifo = new("mdl_scd_fifo",this);
     endfunction

    extern  function void connect_phase( uvm_phase phase);     

endclass //className extends superClass

 function void  my_env::connect_phase( uvm_phase phase);      //连接
    super.connect_phase(phase);
    i_agt.ap.connect(agt_mdl_fifo.analysis_export);
    mdl.port.connect(agt_mdl_fifo.blocking_get_export);

    mdl.ap.connect(mdl_scd_fifo.analysis_export);
 endfunction