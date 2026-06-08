//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi transaction
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_TRANSACTION
`define _AXI_TRANSACTION

class axi_transaction extends uvm_sequence_item;

// write address channel tranaction signals
        bit        awvalid;
        bit        awready;
   rand bit [11:0] awaddr;

// write data channel tranaction signals
        bit        wvalid;
        bit        wready;
   rand bit [31:0] wdata;
   rand bit [3:0]  wstrb;

// write response channel tranaction signals
        bit        bready;
        bit        bvalid;
        bit [1:0]  bresp;

// read address channel tranaction signals
        bit        arvalid;
        bit        arready;
   rand bit [11:0] araddr;

// read data channel tranaction signals
        bit [31:0] rdata;
        bit        rready;
        bit        rvalid;
        bit [1:0]  rresp;

// this signal is helps to wherever reset occurs that transaction should be save 
        bit        flag;


//  Factory registraction
    `uvm_object_utils_begin(axi_transaction)
    `uvm_field_int(awaddr,UVM_ALL_ON)
    `uvm_field_int(wdata,UVM_ALL_ON)
    `uvm_field_int(wstrb,UVM_ALL_ON)
    `uvm_field_int(bresp,UVM_ALL_ON)
    `uvm_field_int(araddr,UVM_ALL_ON)
    `uvm_field_int(rdata,UVM_ALL_ON)
    `uvm_field_int(rresp,UVM_ALL_ON)
    `uvm_field_int(flag,UVM_ALL_ON)
    `uvm_object_utils_end

// constructor for axi_tranaction
    function new(string name="axi_transaction");
       super.new(name);
    endfunction:new

//  For understanding purpose giving limied range values
   constraint awaddr_generate{awaddr inside{[32'h0:32'h50]};} 
   constraint araddr_generate{araddr inside{[32'h0:32'h50]};} 

//  In design there is memory depth in 1kb only actual 4kb we should generate the adress that particular range,generate address more 1kb it shows error rresp or bresp is 2
    constraint bresp_rresp{awaddr %4==0;
                            araddr %4==0;}
// we can access the entire 32 location width 
    constraint strb{wstrb==4'hf;}
endclass:axi_transaction
`endif
