//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi seqr 
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_SEQR
`define _AXI_SEQR

class axi_seqr extends uvm_sequencer#(axi_transaction);

// Factory registraction 
   `uvm_component_utils(axi_seqr)

//   constructor for the axi seqr
   function new(string name="axi_seqr",uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(),"this is constructor of axi_seqr",UVM_LOW);
   endfunction:new

endclass:axi_seqr

`endif
