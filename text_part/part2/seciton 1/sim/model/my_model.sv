class my_model extends uvm_component;
    `uvm_component_utils(my_model)
    uvm_blocking_get_port#( my_transaction )  port;                            //agt_mdl FIFO 读接口            
    uvm_analysis_port#( my_transaction )  ap;                                      //mdl_scd fifo 写接口
   
   extern  function new(string name, uvm_component parent);
   extern  function void build_phase( uvm_phase phase);     
   extern  task  main_phase( uvm_phase phase);  

endclass //my_model extenextern ds uvm_componet
/*要干什么
1、从 i_monitor 拿数据  i_monitor — 写—FIFO - 读--my_model
2、处理（复制） 

3、写到soareboard 中   -my_model  -- 写 FIFO

*/
function my_model::new(string name, uvm_component parent);
    super.new(name,parent);
endfunction

 function void  my_model::build_phase( uvm_phase phase);    
    super.build_phase(phase);
    port = new("port",this);
    ap = new("ap",this);
 endfunction

task   my_model::main_phase( uvm_phase phase);  
    my_transaction tr;
    my_transaction new_tr;
    super.main_phase(phase);
    while(1)begin
     port.get(tr);                                                                              //从FIFO 拿数据
     new_tr = new("new_tr");
     new_tr.copy(tr);                                                                       //复制
     ap.write(new_tr);                                                                     //写入 FIFO
    end
endtask
