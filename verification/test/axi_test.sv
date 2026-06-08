//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi Test 
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_TEST
`define _AXI_TEST

class axi_test extends uvm_test;

//  Handle declaration, factory registration
   axi_write_seq axi_write_seq_h;
   axi_read_seq axi_read_seq_h;
   axi_wr_seq axi_wr_seq_h;
   axi_env axi_env_h;
   `uvm_component_utils(axi_test)
//   constructor for the axi test
   function new(string name="axi_test",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

//   build_phase for the axi test   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"this is constructor of axi test",UVM_LOW);
      axi_env_h=axi_env::type_id::create("axi_env_h",this);
   endfunction:build_phase

//   connect_phase for the axi test
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info(get_type_name(),"this is build phase of axi test",UVM_LOW);
   endfunction:connect_phase

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info(get_type_name(),"this is run phase of axi test",UVM_LOW);
//  memory creation for write,read and write followed by read sequece 
      axi_write_seq_h=axi_write_seq::type_id::create("axi_write_seq_h");
      axi_read_seq_h=axi_read_seq::type_id::create("axi_read_seq_h");
      axi_wr_seq_h=axi_wr_seq::type_id::create("axi_wr_seq_h");
$display("-------------------------------------------");
$display("---------------write sequence--------------");
      axi_write_seq_h.start(axi_env_h.axi_agent_h.axi_seqr_h);
$display("-------------------------------------------");
$display("---------------read sequence---------------");
      axi_read_seq_h.start(axi_env_h.axi_agent_h.axi_seqr_h);
$display("-------------------------------------------");
$display("-----------write and read sequence---------");
      axi_wr_seq_h.start(axi_env_h.axi_agent_h.axi_seqr_h);
$display("-------------------------------------------");
      phase.drop_objection(this);
   endtask:run_phase

endclass:axi_test

`endif
