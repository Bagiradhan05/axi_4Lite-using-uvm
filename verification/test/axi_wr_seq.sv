//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi write and read seq 
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_WR_SEQ
`define _AXI_WR_SEQ

class axi_wr_seq extends uvm_sequence#(axi_transaction);

//  Handle declaration, factory registration
   axi_transaction transaction_h;
   axi_transaction read_transaction_h;
   `uvm_object_utils_begin(axi_wr_seq)
   `uvm_field_object(transaction_h,UVM_ALL_ON)
   `uvm_object_utils_end

   int number_of_transaction;

//   constructor for the axi seq
   function new(string name="axi_wr_seq");
      super.new(name);
   endfunction:new

   task body();

//  number of transaction want to generate that things can be control in command line
      if ($value$plusargs("number_of_transaction=%0d",number_of_transaction))
        number_of_transaction=number_of_transaction;
     else
        number_of_transaction = 10;

     repeat(number_of_transaction)begin

//  creating memory for  transaction
        transaction_h=axi_transaction::type_id::create("transaction_h");
        `uvm_info(get_type_name(),"before start item",UVM_LOW);
        start_item(transaction_h);
        `uvm_info(get_type_name(),"after start item",UVM_LOW);
        `uvm_info(get_type_name(),"before randomize",UVM_LOW);

//  randomization data sends to driver
        if(!transaction_h.randomize()with{araddr==0;})
           $display(" not randomization");
      `uvm_info(get_type_name(),$sformatf("randomizing data =%0s",transaction_h.sprint()),UVM_LOW);
        `uvm_info(get_type_name(),"after randomize",UVM_LOW);
        `uvm_info(get_type_name(),"before finish item",UVM_LOW);
        finish_item(transaction_h);
        `uvm_info(get_type_name(),"after finish item",UVM_LOW);
//  response data reciving from driver

        get_response(transaction_h);
        `uvm_info("res debug",$sformatf("get response data=%0s",transaction_h.sprint()) ,UVM_LOW);

// write followed by read excuted here write address randomize same address here randomize in read addres
        read_transaction_h=axi_transaction::type_id::create("read_transaction_h");
        `uvm_info(get_type_name(),"before start item",UVM_LOW);
        start_item(read_transaction_h);
        `uvm_info(get_type_name(),"after start item",UVM_LOW);
        `uvm_info(get_type_name(),"before randomize",UVM_LOW);
//  randomization data sends to driver
        if(!read_transaction_h.randomize()with{araddr==transaction_h.awaddr;
                                               awaddr==0;wdata==0;})
           $display(" not randomization");
      `uvm_info(get_type_name(),$sformatf("randomizing data =%0s",transaction_h.sprint()),UVM_LOW);
        `uvm_info(get_type_name(),"after randomize",UVM_LOW);
        `uvm_info(get_type_name(),"before finish item",UVM_LOW);
        finish_item(read_transaction_h);
        `uvm_info(get_type_name(),"after finish item",UVM_LOW);

//  response data reciving from driver
        get_response(transaction_h);
        `uvm_info("res debug",$sformatf("get response data=%0s",transaction_h.sprint()) ,UVM_LOW);

     end
   endtask:body

endclass:axi_wr_seq

`endif
