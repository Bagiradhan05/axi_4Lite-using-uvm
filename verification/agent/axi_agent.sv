//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi agent 
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_AGENT
`define _AXI_AGENT

class axi_agent extends uvm_agent;

//   Handle declaration 
   axi_driver axi_driver_h;
   axi_seqr axi_seqr_h;
   axi_monitor axi_monitor_h;

//   Factory registration
   `uvm_component_utils(axi_agent)

//   constructor for the axi agent
   function new(string name="axi_agent",uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(),"this is constructor axi agent",UVM_LOW);
   endfunction:new

//   build_phase for the axi agent   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"this is build_phase axi agent",UVM_LOW);

//   memroy creation for driver,sequecner and monitor
      axi_driver_h=axi_driver::type_id::create("axi_driver_h",this);
      axi_seqr_h=axi_seqr::type_id::create("axi_seqr_h",this);
      axi_monitor_h=axi_monitor::type_id::create("axi_monitor_h",this);
   endfunction:build_phase

//   connect_phase for the axi agent
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info(get_type_name(),"this is build phase of axi agent",UVM_LOW);

//   driver and sequencer connection
      axi_driver_h.seq_item_port.connect(axi_seqr_h.seq_item_export);
   endfunction:connect_phase

endclass:axi_agent

`endif
