CMD = vcs -full64 -sverilog -R -debug_access+all -ntb_opts uvm-1.2 -f files.f -l axi_debug.log
CODE_COV = vcs -full64 -sverilog -R -debug_access+all -ntb_opts uvm-1.2 -f files.f -l axi_debug.log -cm line+tgl+cond+assert+fsm+branch
COV_DISPLAY = verdi -cov -covdir simv.vdb
WAVEFORM_DVE = ./simv -gui=dve
WAVEFORM_VERDI = ./simv -gui=verdi
CLEAR = rm -rf csrc DVEfiles flex* simv* ucli.key novas* vc_hdrs* inter.vpd tr_db* vdC* cm.log


DESIGN_PATH= /home/dvft1104/axi_4Lite/design/`:design.sv
TOP_PATH= /home/dvft1104/axi_4Lite/verification/tb/axi_top.sv

run :
	${CMD}
wave_dve :
	${WAVEFORM_DVE}
wave_verdi :
	${WAVEFORM_VERDI}
clear :
	${CLEAR}
code_cov :
	${CODE_COV}
cov_display :
	${COV_DISPLAY}
