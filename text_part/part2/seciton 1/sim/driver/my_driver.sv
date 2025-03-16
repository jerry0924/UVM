class my_driver extends uvm_driver#(my_transaction);      //定义一个类 延申 uvm_driver
    `uvm_component_utils(my_driver)
    function new(string name= "my_driver",uvm_component parent = null);   //声明了函数  定义了名字 
        super.new(name,parent);                                            //调用基类的构造函数super.new，将name和parent参数传递给基类，以确保基类正确初始化。
    endfunction //new()
    virtual my_if vif;                                                     //声明类的变量  vif
    virtual function void build_phase(uvm_phase  phase);
        super.build_phase(phase);
        `uvm_info("driver","build_phase is called",UVM_LOW);
        if(!uvm_config_db#(virtual my_if)::get(this,"","vif",vif)) 
           `uvm_fatal("my_driver","interface vif config error!!!!")
    endfunction	
extern virtual task main_phase(uvm_phase phase);                      //extern：表示该方法的定义在类体外部，这一行只是声明，实际的实现将在类外提供。
extern virtual task driver_one_pkt(my_transaction tr);  
endclass //my_driver extends uvm_driver                                     //  virtual：表示这是一个虚方法，允许子类覆盖它。
                                                                            //指这是一个任务，与function不同，它可以包含延时（#）或等待语句

task my_driver::main_phase(uvm_phase phase);                                //说明main_phase是属于my_driver类的任务，是该类的方法实现。   可以传递参数，但不知道这个参数啥意思//在真正的验证平台 //中，这个参数是不需要用户理会的  
        super.main_phase(phase);
    `uvm_info("my_driver","main_phase is called",UVM_LOW);
        while(1)begin
            seq_item_port.try_next_item(req);                                     //seq_item_port driver 自带接口向sequencer申请transaction
            if(req != null) begin
                driver_one_pkt(req);
                seq_item_port.item_done(req);                                    //握手机制
            end
            else begin
                @(posedge vif.clk);  
            end
        end    
endtask

task my_driver::driver_one_pkt(my_transaction tr);
    byte unsigned data_q[];
    int data_size;

   data_size = tr.pack_bytes(data_q)/8;                                                                             //pack_bytes 函数，将 transcaction 中定义的变量进行打包
    `uvm_info("my_driver","data pocket is beginning transaction",UVM_LOW);

       while (!vif.rst_n) begin            //在复位时期
        vif.valid <= 1'b0;
        vif.data  <= 8'h0;     
	@(posedge vif.clk);

    end
    for (int i =0 ;i <=data_size  ;i++ ) begin
        @(posedge vif.clk);
        vif.valid <= 1'b1;
        vif.data  <= data_q[i];
    end
    //
    @(posedge vif.clk);
    vif.valid <= 1'b0;
    vif.data  <= 8'h0; 
    `uvm_info("my_driver","data pocket transaction end",UVM_LOW);
endtask
