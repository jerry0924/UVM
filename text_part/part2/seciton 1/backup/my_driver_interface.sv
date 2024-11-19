class my_driver extends uvm_driver;      //定义一个类 延申 uvm_driver
    `uvm_component_utils(my_driver)
    function new(string name= "my_driver",uvm_component parent = null);   //声明了函数  定义了名字 
        super.new(name,parent);                                            //调用基类的构造函数super.new，将name和parent参数传递给基类，以确保基类正确初始化。
    endfunction //new()
    virtual my_if vif;                                                     //声明类的变量  vif
    virtual function void build_phase(uvm_phase  phase);
        super.build_phase(phase);
        `uvm_info("driver","build_phase is called",UVM_LOW);
	   uvm_config_db#(virtual my_if)::get(this,"","vif",vif);
        //if(!uvm_config_db#(virtual my_if)::get(this,"","vif",vif)) 
          //  `uvm_fatal("my_driver","interface vif config error!!!!")
    endfunction	
extern virtual task main_phase(uvm_phase phase);                      //extern：表示该方法的定义在类体外部，这一行只是声明，实际的实现将在类外提供。
endclass //my_driver extends uvm_driver                                     //  virtual：表示这是一个虚方法，允许子类覆盖它。
                                                                            //指这是一个任务，与function不同，它可以包含延时（#）或等待语句

task my_driver::main_phase(uvm_phase phase);                                //说明main_phase是属于my_driver类的任务，是该类的方法实现。   可以传递参数，但不知道这个参数啥意思//在真正的验证平台
                                                                             //中，这个参数是不需要用户理会的  
    phase.raise_objection(this);
    `uvm_info("my_driver","main_phase is called",UVM_LOW);
    vif.vaild        <=      1'b0        ;
    vif.data         <=      8'd0        ;   
    while(!vif.rst_n)
        @ ( posedge vif.clk )
        // 定义在复位期间需要做的事情
        
        ;
        //复位结束
        for( int i = 0 ; i < 256 ; i ++  ) begin
            @(posedge vif.clk);   //等待时钟上升沿
            vif.data            <=      $urandom_range(0,255)        ;
            vif.vaild           <=      1'b1                         ;
            `uvm_info("my_driver", "data is drived", UVM_LOW);               //第三个参数优先级   UVM_HIGH 可有可无/UVM_MEDIUM /UVM_LOW 非常关键
        end
    @(posedge top_tb.clk);                                            //下一个时钟上升沿
    vif.vaild       <=      1'b0        ;
    phase.drop_objection(this);
endtask
