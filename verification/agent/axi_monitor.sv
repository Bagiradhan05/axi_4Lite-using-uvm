//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi monitor 
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_MONITOR
`define _AXI_MONITOR

class axi_monitor extends uvm_monitor;

   axi_transaction transaction_h;
   virtual axi_interface vif;
   `uvm_component_utils(axi_monitor)
   uvm_analysis_port#(axi_transaction)ap_mon;
   

//   constructor for the axi monitor
   function new(string name="axi_monitor",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

//   build_phase for the axi monitor   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"this is constructor of axi monitor",UVM_LOW);
//  creating memory for the analysis port
      ap_mon=new("ap_mon",this);
//  accessing the interface signal using config_db get method
      if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif))
         `uvm_fatal("vif","virtual interface is not found")
   endfunction:build_phase

// main task is excuted here
   task run_phase(uvm_phase phase);
      forever begin
         @(posedge vif.aclk);
//  awvalid and awready must be  asseted for moniotring write address
         if(vif.monitor_cb.awvalid&&vif.monitor_cb.awready)begin
            transaction_h=axi_transaction::type_id::create("transaction_h");
            transaction_h.awaddr=vif.monitor_cb.awaddr;
            `uvm_info(get_type_name(),$sformatf("monitoring write adress channel awaddr=%0h",transaction_h.awaddr),UVM_LOW);
         end
//  wvalid and wready must be  asseted for moniotring write data
         if(vif.monitor_cb.wvalid&&vif.monitor_cb.wready)begin
            transaction_h.wdata=vif.monitor_cb.wdata;
            transaction_h.wstrb=vif.monitor_cb.wstrb;
            `uvm_info(get_type_name(),$sformatf("monitoring write data channel wdata=%0h wstrb=%0h",transaction_h.wdata,transaction_h.wstrb),UVM_LOW);
         end
//  bvalid and bready must be  asseted for moniotring write response
         if(vif.monitor_cb.bready&&vif.monitor_cb.bvalid)begin
            transaction_h.bresp=vif.monitor_cb.bresp;
            `uvm_info(get_type_name(),$sformatf("monitoring write response channel bresp=%0h",transaction_h.bresp),UVM_LOW);

//  write transaction writting transaction inside analysis port
            ap_mon.write(transaction_h);
            `uvm_info(get_type_name(),$sformatf("monitoring write data =%0s",transaction_h.sprint()),UVM_LOW);
         end
//  arvalid and arready must be  asseted for moniotring read address
         if(vif.monitor_cb.arvalid&&vif.monitor_cb.arready)begin
            transaction_h=axi_transaction::type_id::create("transaction_h");
            transaction_h.araddr=vif.monitor_cb.araddr;
            `uvm_info(get_type_name(),$sformatf("monitoring read adress channel araddr=%0h",transaction_h.araddr),UVM_LOW);
         end
//  rvalid and rready must be  asseted for moniotring read data and response
         if(vif.monitor_cb.rvalid&&vif.monitor_cb.rready)begin
            transaction_h.rdata=vif.monitor_cb.rdata;
            transaction_h.rresp=vif.monitor_cb.rresp;
            `uvm_info(get_type_name(),$sformatf("monitoring read data channel rdata=%0h rresp=%0h",transaction_h.rdata,transaction_h.rresp),UVM_LOW);
//  read transaction writting transaction inside analysis port
            ap_mon.write(transaction_h);
            `uvm_info(get_type_name(),$sformatf("monitoring read data =%0s",transaction_h.sprint()),UVM_LOW);
         end
      end
   endtask:run_phase

endclass:axi_monitor

`endif
