class my_driver extends uvm_driver;      //定义一个类 延申 uvm_driver
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
    	my_transaction tr;
     phase.raise_objection(this);
    `uvm_info("my_driver","main_phase is called",UVM_LOW);
    
   
    //引入transaction
    for (int i=0; i<2; i++) begin
        tr = new("tr");
        if (!tr.randomize() with { pload.size == 200; }) begin
  		`uvm_error("RANDOMIZE_FAIL", "Randomization failed")
	  end
	 $display("enter i transaction", i);
        driver_one_pkt(tr);    
  	 $display("exit i transaction", i);	
    end
    $display("for cycle");	
    @(posedge vif.clk);                                            //下一个时钟上升沿
      phase.drop_objection(this);
endtask

task my_driver::driver_one_pkt(my_transaction tr);
    byte temp_data[];
    bit  [7:0]   data_q[$];

    temp_data  = {tr.dmac,tr.smac,tr.ether_type,tr.pload,tr.crc};
    //int width = ;
    //数据预处理 压入至队列
    //push all
    `uvm_info("my_driver","data pocket is beginning transaction",UVM_LOW);
    for (int i =0 ;i <=(temp_data.size())  ;i++ ) begin
        data_q.push_back(temp_data[i]);
	 //$display("The value of i is: %d", i); 
	 //$display("The value of r is: %d", temp_data.size()/8); 
    end
    //

    while (!vif.rst_n) begin            //在复位时期
        vif.valid <= 1'b0;
        vif.data  <= 8'h0;     
	@(posedge vif.clk);

    end
		
    while (data_q.size() > 0) begin
        @(posedge vif.clk);
        vif.valid <= 1'b1;
        vif.data  <= data_q.pop_front();

    end
    @(posedge vif.clk);
    vif.valid <= 1'b0;
    `uvm_info("my_driver","data pocket transaction end",UVM_LOW);
endtask
