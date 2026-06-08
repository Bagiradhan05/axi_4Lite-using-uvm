//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi coverage 
// Date       :22/06/2026 - 30/06/2026
//
//***************************************//

`ifndef _AXI_COVERAGE
`define _AXI_COVERAGE
class axi_coverage extends uvm_subscriber#(axi_transaction);

//  Handle and analysis imp declaration, factory declaration
   axi_transaction transaction_h;
   `uvm_component_utils(axi_coverage)
   uvm_analysis_imp#(axi_transaction,axi_coverage)ap_cov;

//  coverage for write address channel
   covergroup write_addr_cg;
      coverpoint transaction_h.awready
      {
         bins awready_low={0};
         bins awready_high={0};
      }
      coverpoint transaction_h.awvalid
      {
         bins awvalid_low={0};
         bins awvalid_high={1};
      }
      coverpoint transaction_h.awaddr
      {
         bins low_awaddr={[0:255]};
         bins mid_awaddr={[256:1023]};
         bins high_awaddr={[1024:4095]};
      }
   endgroup:write_addr_cg
//  coverage for write data channel
   covergroup write_data_cg;
      coverpoint transaction_h.wready
      {
         bins wready_low={0};
         bins wready_high={0};
      }
      coverpoint transaction_h.wvalid
      {
         bins wvalid_low={0};
         bins wvalid_high={1};
      }
      coverpoint transaction_h.wdata
      {
         bins zero_data={32'b0};
         bins all_1_data={32'hffff_ffff};
         bins others=default;
      }
      coverpoint transaction_h.wstrb
      {
         bins byte0={4'b0001};
         bins byte1={4'b0010};
         bins byte2={4'b0100};
         bins byte3={4'b1000};

         bins byte_full={4'b1111};
      }
   endgroup:write_data_cg
//  coverage for write response channel
   covergroup write_response_cg;
      coverpoint transaction_h.bready
      {
         bins bready_low={0};
         bins bready_high={0};
      }
      coverpoint transaction_h.bvalid
      {
         bins bvalid_low={0};
         bins bvalid_high={1};
      }
      coverpoint transaction_h.bresp
      {
         bins bresp_okay={2'b00};
         bins bresp_exokay={2'b01};
         bins bresp_slverr={2'b10};
         bins bresp_decerr={2'b11};
      }
   endgroup:write_response_cg
//  coverage for read address channel
   covergroup read_addr_cg;
      coverpoint transaction_h.arready
      {
         bins arready_low={0};
         bins arready_high={0};
      }
      coverpoint transaction_h.arvalid
      {
         bins arvalid_low={0};
         bins arvalid_high={1};
      }
      coverpoint transaction_h.araddr
      {
         bins low_awaddr={[0:255]};
         bins mid_awaddr={[256:1023]};
         bins high_awaddr={[1024:4095]};
      }
   endgroup:read_addr_cg
//  coverage for read data channel
   covergroup read_data_cg;
      coverpoint transaction_h.rready
      {
         bins rready_low={0};
         bins rready_high={0};
      }
      coverpoint transaction_h.rvalid
      {
         bins rvalid_low={0};
         bins rvalid_high={1};
      }
      coverpoint transaction_h.rdata
      {
         bins zero_data={32'b0};
         bins all_1_data={32'hffff_ffff};
         bins others=default;
      }
      coverpoint transaction_h.rresp
      {
         bins rresp_okay={2'b00};
         bins rresp_exokay={2'b01};
         bins rresp_slverr={2'b10};
         bins rresp_decerr={2'b11};
      }
   endgroup:read_data_cg

//  constructor for coverage 
   function new(string name="axi_coverage",uvm_component parent=null);
      super.new(name,parent);
//  creating memory for covergroup 
      write_addr_cg=new();
      write_data_cg=new();
      write_response_cg=new();
      read_addr_cg=new();
      read_data_cg=new();
   endfunction:new

// build_phase for coverage
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
//  creating mermory for analysis imp 
      ap_cov=new("ap_cov",this);
   endfunction:build_phase

//write operation for access the output received from monitor using analysis port
   function void write(axi_transaction t);
      transaction_h=t;
//  sampling the  data,it is check data is hit or not
      write_addr_cg.sample();
      write_data_cg.sample();
      write_response_cg.sample();
      read_addr_cg.sample();
      read_data_cg.sample();
   endfunction:write

endclass:axi_coverage
`endif
