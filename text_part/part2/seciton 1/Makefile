#-------------------------------------------------------------------------------------------------------
comp  : clean vcs
#-------------------------------------------------------------------------------------------------------
vcs   :
	vcs  -f filelist.f  \
		-timescale=1ns/1ps \
		-ntb_opts uvm-1.2\
		-lca -kdb\
		-debug_access,-debug_region=cell+lib\
		-full64  -R  +vc  +v2k  -sverilog -debug_all\
		| tee vcs.log	 
#-------------------------------------------------------------------------------------------------------
verdi  :
	verdi -f filelist.f -ssf tb.fsdb -dbdir simv.daidir &    # undefined module
#-------------------------------------------------------------------------------------------------------
clean  :
	 rm  -rf  *~  core  csrc  simv*  vc_hdrs.h  ucli.key  urg* *.log  novas.* *.fsdb* verdiLog  64* DVEfiles *.vpd
#-------------------------------------------------------------------------------------------------------
# filelist update
filelist:
	@find ./rtl 		-name "*.sv" >filelist.f								#rtl file
	@find 			-name "*.sv" | grep -E '/top_tb\.sv$$' >>filelist.f			# top file 
	@find ./sim/transaction 	-name "*.sv" >>filelist.f							# transaction
	@find ./sim/if 		-name "*.sv" >>filelist.f							# interface
	@find ./sim/monitor 	-name "*.sv" >>filelist.f							# monitor
	@find ./sim/driver 	-name "*.sv" >>filelist.f							# interface
	@find ./sim/env 		-name "*.sv" >>filelist.f							# interface	
#-------------------------------------------------------------------------------------------------------
all :
	make clean
	make filelist
	make vcs
#-------------------------------------------------------------------------------------------------------
help	:
	@echo "#------------------------------------------#"
	@echo "make VCS   "
	@echo "make all 	 ： clean+fileist+vcs "
	@echo "make verid   ： 查看波形 "	
	@echo "make clean   ： 删除缓存文件 "
	@echo "make filelist： 完成filelist更新 "	
	@echo "#------------------------------------------#"

