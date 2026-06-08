//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi Top 
// Date       :25/05/2026
//
//***************************************//

`ifndef _AXI_TOP
`define _AXI_TOP
import uvm_pkg::*;
`include "uvm_macros.svh"

module axi_top;
logic aclk;
logic aresetn;
axi_interface intf(aclk,aresetn);
axi4_lite_slave dut(
   .aclk(intf.aclk),
   .aresetn(intf.aresetn),
   .awaddr(intf.awaddr),
   .awready(intf.awready),
   .awvalid(intf.awvalid),
   .wdata(intf.wdata),
   .wready(intf.wready),
   .wvalid(intf.wvalid),
   .wstrb(intf.wstrb),
   .bresp(intf.bresp),
   .bvalid(intf.bvalid),
   .bready(intf.bready),
   .araddr(intf.araddr),
   .arready(intf.arready),
   .arvalid(intf.arvalid),
   .rdata(intf.rdata),
   .rvalid(intf.rvalid),
   .rready(intf.rready),
   .rresp(intf.rresp));
bind axi4_lite_slave axi_assertion assert_uut(intf);

always #5aclk=~aclk;
initial
   uvm_config_db#(virtual axi_interface)::set(null,"*","vif",intf);
initial begin
   aclk=0;aresetn=0;
   #10;aresetn=1;
   #50;aresetn=0;
   #20;aresetn=1;
end
initial begin
   run_test("axi_test");
end
endmodule:axi_top
`endif
