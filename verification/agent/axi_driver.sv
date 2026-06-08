//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi driver 
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_DRIVER
`define _AXI_DRIVER

class axi_driver extends uvm_driver#(axi_transaction);

//  Handle declaration for transaction request and response
   axi_transaction transaction_res_h;
   axi_transaction transaction_req_h;

//  virtual interface declaration
   virtual axi_interface vif;

//  Factory registration
   `uvm_component_utils(axi_driver)

//   constructor for the axi driver
   function new(string name="axi_driver",uvm_component parent=null);
      super.new(name,parent);
   endfunction:new

//   build_phase for the axi driver   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"this is constructor of axi driver",UVM_LOW);

//  accessing the interface signal using config_db get method
      if(!uvm_config_db#(virtual axi_interface)::get(this,"","vif",vif))
         `uvm_fatal("vif","virtual interface is not found")
   endfunction:build_phase

   task run_phase(uvm_phase phase);
      forever begin
         `uvm_info(get_type_name(),"before get next item ",UVM_LOW);
         seq_item_port.get_next_item(transaction_req_h);
         `uvm_info(get_type_name(),"after get next item ",UVM_LOW);
         main_run(transaction_req_h);
         `uvm_info(get_type_name(),"before item done",UVM_LOW);
         seq_item_port.item_done();
         `uvm_info(get_type_name(),"after item done",UVM_LOW);

//   if reset is asserted that transaction should be pass to driver
         if(transaction_res_h!=null&&transaction_res_h.flag==1)begin
            `uvm_info("res","reset transaction pass to driver",UVM_LOW);
            seq_item_port.put_response(transaction_res_h);
         end
//   if reset is not asserted normal transaction should be pass to driver
         else begin 
            `uvm_info("res","normal transaction pass to driver",UVM_LOW);
            seq_item_port.put_response(transaction_req_h);
         end

      end
   endtask:run_phase

  task main_run(axi_transaction transaction_req_h);
      @(vif.master_cb);
//  this is reset logic
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_logic(transaction_req_h);
      end
//  this is main driver logic
      else begin
         driver_logic(transaction_req_h);
      end
   endtask:main_run

//  if reset occurs that transaction data wants to copy in transaction_res_h using clone and setting id information and flag is 1
   extern task reset_code(axi_transaction transaction_req_h);

   task reset_logic(axi_transaction transaction_req_h);
      `uvm_info("reset_occurs","inside reset_logic",UVM_LOW);
      do begin
      vif.master_cb.awvalid<=0;
      vif.master_cb.awaddr<=0;
      vif.master_cb.araddr<=0;
      vif.master_cb.wdata<=0;
      vif.master_cb.wvalid<=0;
      vif.master_cb.bready<=0;
      vif.master_cb.arvalid<=0;
      vif.master_cb.rready<=0;
      @(vif.master_cb);
   end
      while(!vif.aresetn||$isunknown(vif.aresetn));
      `uvm_info("reset_occurs","outside reset_logic",UVM_LOW);
   endtask:reset_logic

   task driver_logic(axi_transaction transaction_req_h);
 //     fork
       //   begin
//  write address,data and response logic excute sequentially
             write_address(transaction_req_h);
             write_data(transaction_req_h);
             write_response(transaction_req_h);
        //  end
        //  begin
//  read address and data logic excute sequentially
             read_address(transaction_req_h);
             read_data(transaction_req_h);
        //  end
//      join
   endtask:driver_logic

// write address logic should be excute here
   task write_address(axi_transaction transaction_req_h);
      @(posedge vif.aclk);
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         `uvm_info("reset","reset is occured before awaddr assserting",UVM_LOW);
         reset_code(transaction_req_h);
         return;
      end
      else begin
         `uvm_info(get_type_name(),"awvalid is asserted",UVM_LOW);
         vif.master_cb.awvalid<=1'b1;
         vif.master_cb.awaddr<=transaction_req_h.awaddr;
      end
      do begin
         if(!vif.master_cb.awready);
         @(posedge vif.aclk);
         `uvm_info(get_type_name(),"awready is asserted",UVM_LOW);
      end
      while(vif.master_cb.awready);
      @(posedge vif.aclk);
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         `uvm_info("reset","reset is occured before awvalid deassserting",UVM_LOW);
         reset_code(transaction_req_h);
         return;
      end
      else begin
         vif.master_cb.awvalid<=1'b0;
      end
   endtask:write_address


// write data logic should be excute here
   task write_data(axi_transaction transaction_req_h);
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         `uvm_info("reset","reset is occured before avalid assserting",UVM_LOW);
         reset_code(transaction_req_h);
         return;
      end
      else begin
         `uvm_info(get_type_name(),"wvalid is asserted",UVM_LOW);
         vif.master_cb.wvalid<=1'b1;
         vif.master_cb.wdata<=transaction_req_h.wdata;
         vif.master_cb.wstrb<=transaction_req_h.wstrb;
      end
      do begin
         if(!vif.master_cb.wready);
         @(posedge vif.aclk);
         `uvm_info(get_type_name(),"wready is asserted",UVM_LOW);
      end
      while(vif.master_cb.wready);
      @(posedge vif.aclk);
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         `uvm_info("reset","reset is occured before avalid deassserting",UVM_LOW);
         return;
      end
      else begin
         `uvm_info(get_type_name(),"wvalid is deasserted",UVM_LOW);
         vif.master_cb.wvalid<=1'b0;
      end
   endtask:write_data


// write response logic should be excute here
   task write_response(axi_transaction transaction_req_h);
      do begin
         if(!vif.master_cb.bvalid);
         @(posedge vif.aclk);
         `uvm_info(get_type_name(),"bvalid is asserted",UVM_LOW);
      end
      while(vif.master_cb.bvalid);

      @(posedge vif.aclk);
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         `uvm_info("reset","reset is occured before bready assserting",UVM_LOW);
         reset_code(transaction_req_h);
         return;
      end
      else begin
         `uvm_info(get_type_name(),"bready is asserted",UVM_LOW);
         vif.master_cb.bready<=1'b1;
         transaction_req_h.bresp<=vif.master_cb.bresp;
      end

      @(posedge vif.aclk);
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         `uvm_info("reset","reset is occured before bready deassserting",UVM_LOW);
         return;
      end
      else begin
         `uvm_info(get_type_name(),"bready is deasserted",UVM_LOW);
         vif.master_cb.bready<=1'b0;
         `uvm_info(get_type_name(),$sformatf("write is completed data =%0s",transaction_req_h.sprint()),UVM_LOW);
      end
   endtask:write_response


// read address logic should be excute here
   task read_address(axi_transaction transaction_req_h);
      @(posedge vif.aclk);
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         `uvm_info("reset","reset is occured before arvalid assserting",UVM_LOW);
         return;
      end
      else begin
         `uvm_info(get_type_name(),"arvalid is asserted",UVM_LOW);
         vif.master_cb.araddr<=transaction_req_h.araddr;
         vif.master_cb.arvalid<=1'b1;
      end
      do begin
         if(!vif.master_cb.arready);
         @(posedge vif.aclk);
         `uvm_info(get_type_name(),"arready is asserted",UVM_LOW);
      end
      while(vif.master_cb.arready);

      @(posedge vif.aclk);

      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         `uvm_info("reset","reset is occured before arvalid deassserting",UVM_LOW);
         return;
      end
      else begin
         `uvm_info(get_type_name(),"arvalid is deasserted",UVM_LOW);
         vif.master_cb.arvalid<=1'b0;
      end
   endtask:read_address


// read address logic should be excute here
   task read_data(axi_transaction transaction_req_h);
      do begin
         if(!vif.master_cb.rvalid);
         @(posedge vif.aclk);
      end
      while(vif.master_cb.rvalid);

      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         `uvm_info("reset","reset is occured before rvalid assserting",UVM_LOW);
         return;
      end
      else begin
         `uvm_info(get_type_name(),"rready is asserted",UVM_LOW);
         vif.master_cb.rready<=1'b1;
         transaction_req_h.rdata<=vif.master_cb.rdata;
         transaction_req_h.rresp<=vif.master_cb.rresp;
      end
      @(posedge vif.aclk);
      if(!vif.aresetn||$isunknown(vif.aresetn))begin
         reset_code(transaction_req_h);
         `uvm_info("reset","reset is occured before rvalid deassserting",UVM_LOW);
         return;
      end
      else begin
         `uvm_info(get_type_name(),"rready is deasserted",UVM_LOW);
         vif.master_cb.rready<=1'b0;
         `uvm_info(get_type_name(),$sformatf("read is completed data =%0s",transaction_req_h.sprint()),UVM_LOW);
      end
   endtask:read_data
endclass:axi_driver

// reset code is excuted here
task axi_driver::reset_code(axi_transaction transaction_req_h);
   $cast(transaction_res_h,transaction_req_h.clone());
   transaction_res_h.set_id_info(transaction_req_h);
   transaction_res_h.flag=1;
   `uvm_info("rd",$sformatf("reset data =%0s",transaction_res_h.sprint()) ,UVM_LOW);
   reset_logic(transaction_req_h);
endtask:reset_code

`endif
