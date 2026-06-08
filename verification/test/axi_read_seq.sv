//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi read axi 
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_READ_SEQ
`define _AXI_READ_SEQ

class axi_read_seq extends uvm_sequence#(axi_transaction);

//  Handle declaration, factory registration
   axi_transaction transaction_req_h;
   axi_transaction transaction_res_h;
   `uvm_object_utils_begin(axi_read_seq)
   `uvm_field_object(transaction_req_h,UVM_ALL_ON)
   `uvm_object_utils_end

   int number_of_transaction;

//   constructor for the axi seq
   function new(string name="axi_read_seq");
      super.new(name);
   endfunction:new

   task body();
// creating memory for transaction response 
      transaction_res_h=axi_transaction::type_id::create("transaction_res_h");

//  number of transaction want to generate that things can be control in command line
      if ($value$plusargs("number_of_transaction=%0d",number_of_transaction))
        number_of_transaction=number_of_transaction;
     else
        number_of_transaction = 10;

//  read sequence logic is excuted here
     repeat(number_of_transaction)begin

//  creating memory for request transaction
        transaction_req_h=axi_transaction::type_id::create("transaction_req_h");
        `uvm_info(get_type_name(),"before start item",UVM_LOW);
        start_item(transaction_req_h);
        `uvm_info(get_type_name(),"after start item",UVM_LOW);

//  if reset is occures in between the transaction that transaction send to driver
         if(transaction_res_h.flag==1)begin
            transaction_res_h.flag=0;
            transaction_req_h.copy(transaction_res_h);
            `uvm_info("debug",$sformatf("response data passing to driver=%0s",transaction_req_h.sprint()) ,UVM_LOW);
         end
//  if reset is not occures randomization data sends to driver
         else begin
            `uvm_info(get_type_name(),"before randomize",UVM_LOW);
            if(!transaction_req_h.randomize()with{awaddr==0;wdata==0;})
               $display(" not randomization");
            `uvm_info(get_type_name(),$sformatf("randomizing data =%0s",transaction_req_h.sprint()),UVM_LOW);
            `uvm_info(get_type_name(),"after randomize",UVM_LOW);
         end
        `uvm_info(get_type_name(),"before finish item",UVM_LOW);
        finish_item(transaction_req_h);
        `uvm_info(get_type_name(),"after finish item",UVM_LOW);
    
//  response data reciving from driver
        get_response(transaction_res_h);
        `uvm_info("res debug",$sformatf("get response data=%0s",transaction_res_h.sprint()) ,UVM_LOW);
     end
   endtask:body

endclass:axi_read_seq

`endif
