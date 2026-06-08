//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi interface 
// Date       :25/05/2026
//
//***************************************//

`ifndef _AXI_INTERFACE
`define _AXI_INTERFACE

interface axi_interface#(
   parameter ADDR_WIDTH=12,
   parameter DATA_WIDTH=32
)(
   input logic aclk,input logic aresetn);

//    Global signals
//   logic aclk;
//   logic aresetn;

//   write address channel signals
   logic [ADDR_WIDTH-1:0]     awaddr;
   logic                      awvalid;
   logic                      awready;
//   logic        awprot;

//    Write data channel signals
   logic [DATA_WIDTH-1:0]     wdata;
   logic [(DATA_WIDTH/8)-1:0] wstrb;
   logic                      wvalid;
   logic                      wready;

//   write response channel signals
   logic [(DATA_WIDTH/16)-1:0]bresp;
   logic                      bvalid;
   logic                      bready;

//   read address channel signals
   logic[ADDR_WIDTH-1:0]      araddr;
   logic                      arvalid;
   logic                      arready;
// logic                      arprot;

//   read data channel signals
   logic [DATA_WIDTH-1:0]     rdata;
   logic [(DATA_WIDTH/16)-1:0]rresp;
   logic                      rvalid;
   logic                      rready;

//   clocking block
   clocking master_cb@(posedge aclk);

//      default input#2 output#3;
      input awready,wready,bresp,bvalid,arready,rdata,rresp,rvalid;
      output awaddr,awvalid,wdata,wstrb,wvalid,bready,araddr,arvalid,rready;

   endclocking:master_cb

   clocking monitor_cb@(posedge aclk);

//      default input#2 output#3;
      input awready,wready,bresp,bvalid,arready,rdata,rresp,rvalid;
      input awaddr,awvalid,wdata,wstrb,wvalid,bready,araddr,arvalid,rready;

   endclocking:monitor_cb

//   modport
   modport slave_mp(
      output awready,wready,bresp,bvalid,arready,rdata,rresp,rvalid,
      input awaddr,awvalid,wdata,wstrb,wvalid,bready,araddr,arvalid,rready);




endinterface:axi_interface

`endif
