//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi env 
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_ENV
`define _AXI_ENV

class axi_env extends uvm_env;

   axi_agent axi_agent_h;
   axi_scoreboard axi_scoreboard_h;
   axi_coverage axi_coverage_h;
   `uvm_component_utils(axi_env)

//   constructor for the axi env
   function new(string name="axi_env",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

//   build_phase for the axi env   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"this is constructor of axi env",UVM_LOW);
// memory creating for agent ,scoreboard and coverage
      axi_agent_h=axi_agent::type_id::create("axi_agent_h",this);
      axi_scoreboard_h=axi_scoreboard::type_id::create("axi_scoreboard_h",this);
      axi_coverage_h=axi_coverage::type_id::create("axi_coverage_h",this);

   endfunction:build_phase

//   connect_phase for the axi env
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info(get_type_name(),"this is build phase of axi env",UVM_LOW);
//  connecting the monitor to scoreboard and monitor to coverage using analysis port
      axi_agent_h.axi_monitor_h.ap_mon.connect(axi_scoreboard_h.ap_sb);
      axi_agent_h.axi_monitor_h.ap_mon.connect(axi_coverage_h.ap_cov);
   endfunction:connect_phase

endclass:axi_env

`endif
