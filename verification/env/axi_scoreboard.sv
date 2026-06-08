//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi scoreboard 
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_SCOREBOARD
`define _AXI_SCOREBOARD

class axi_scoreboard extends uvm_scoreboard;

// Handle declaration,local memory,factory registration and analysis imp
   axi_transaction transaction_h;
   `uvm_component_utils(axi_scoreboard)
   bit[31:0]mem[bit[11:0]];
   uvm_analysis_imp#(axi_transaction,axi_scoreboard)ap_sb;


//   constructor for the axi scoreboard
   function new(string name="axi_scoreboard",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

//   build_phase for the axi scoreboard   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"this is constructor of axi scoreboard",UVM_LOW);
//  memory creation for analysis imp 
      ap_sb=new("ap_sb",this);
   endfunction:build_phase

//write operation for access the output received from monitor using analysis port
   function void write(axi_transaction transaction_h);

      `uvm_info(get_type_name(),"inside scoreboard receiving the packet",UVM_LOW);
// write operation begins writting transaction inside the local memory
      if(transaction_h.bresp==2'b00)begin
         mem[transaction_h.awaddr]=transaction_h.wdata;
         `uvm_info(get_type_name(),$sformatf("write pass to memory awaddr=%0h wdata=%0h",transaction_h.awaddr,transaction_h.wdata),UVM_LOW);
      end

// read operation begins checking data and local memory data ,if it is pass or fail
      if(transaction_h.rresp==2'b00)begin
         if(mem.exists(transaction_h.araddr))begin
            if(mem[transaction_h.araddr]==transaction_h.rdata)begin
               `uvm_info(get_type_name(),$sformatf("read pass araddr=%0h randomize_data=%0h actual_data=%0h",transaction_h.araddr,mem[transaction_h.araddr],transaction_h.rdata),UVM_LOW);
            end
            else begin
               `uvm_info(get_type_name(),$sformatf("read pass araddr=%0h randomize_data=%0h actual_data=%0h",transaction_h.araddr,mem[transaction_h.araddr],transaction_h.rdata),UVM_LOW);
            end
         end
//  there is address not match,it excuted uninitialized address
         else begin
               `uvm_info(get_type_name(),$sformatf("read from uninitialized araddr=%0h this address is not found in the memory ",transaction_h.araddr),UVM_LOW);

         end
      end

   endfunction:write


endclass:axi_scoreboard

`endif
