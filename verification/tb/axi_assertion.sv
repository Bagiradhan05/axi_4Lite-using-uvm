//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :AXI Lite  protocol
// Description:This file is implements the Axi env 
// Date       :25/05/2026
//
//***************************************//

`ifndef _AXI_ASSERTION
`define _AXI_ASSERTION

module axi_assertion(axi_interface aif);

//----------------------------//
//    aresetn checking        //
//----------------------------//

// awvalid must be low when aresetn is asserted
   property reset_awvalid;
      @(posedge aif.aclk)
      (!aif.aresetn)|->(!aif.awvalid);
   endproperty:reset_awvalid
   RESET_AWVALID:assert property(reset_awvalid);

// wvalid must be low when aresetn is asserted
   property reset_wvalid;
      @(posedge aif.aclk)
      (!aif.aresetn)|->(!aif.wvalid==1'b0);
   endproperty:reset_wvalid
   RESET_WVALID:assert property(reset_wvalid);

// arvalid must be low when aresetn is asserted
   property reset_arvalid;
      @(posedge aif.aclk)
      (!aif.aresetn)|->(!aif.arvalid);
   endproperty:reset_arvalid
   RESET_ARVALID:assert property(reset_arvalid);

// rready must be low when aresetn is asserted
   property reset_rready;
      @(posedge aif.aclk)
      (!aif.aresetn)|->(!aif.rready);
   endproperty:reset_rready
   RESET_RREADY:assert property(reset_rready);

//----------------------------//
//   WRITE ADDRESS CHANNEL    //
//----------------------------//


//  awvalid is must be asserted until awready is comes
   property awvalid_high;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.awvalid && !aif.awready)|=>aif.awvalid;
   endproperty:awvalid_high
   AWVALID_HIGH:assert property(awvalid_high);

//  awaddr must be stable until awready is asserted
   property awaddr_stable;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.awvalid && !aif.awready)|=>$stable(aif.awaddr);
   endproperty:awaddr_stable
   AWADDR_STABLE:assert property(awaddr_stable);

//  awvalid is asserted after only awready is asserted
   property awvalid_awready;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.awvalid |-> ## [0:$]aif.awready;
   endproperty:awvalid_awready
   AWVALID_AWREADY:assert property(awvalid_awready);

//  awaddr is not contain any x or z values
   property awaddr_unknown;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.awvalid |-> !$isunknown(aif.awaddr);
   endproperty:awaddr_unknown
   AWADDR_UNKNOWN:assert property(awaddr_unknown);

//----------------------------//
//   WRITE DATA CHANNEL       //
//----------------------------//


//  wvalid is must be asserted until wready is comes
   property wvalid_high;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.wvalid && !aif.wready)|=>aif.wvalid;
   endproperty:wvalid_high
   WVALID_HIGH:assert property(wvalid_high);

//  wdata must be stable until wready is asserted
   property wdata_stable;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.wvalid && !aif.wready)|=>$stable(aif.wdata);
   endproperty:wdata_stable
   WDATA_STABLE:assert property(wdata_stable);

//  wstrb must be stable until wready is asserted
   property wstrb_stable;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.wvalid && !aif.wready)|=>$stable(aif.wstrb);
   endproperty:wstrb_stable
    WSTRB_STABLE:assert property(wstrb_stable);

//  wvalid is asserted after only wready is asserted
   property wvalid_wready;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.wvalid |-> ## [0:$]aif.wready;
   endproperty:wvalid_wready
   WVALID_WREADY:assert property(wvalid_wready);

//  wdata is not contain any x or z values
   property wdata_unknown;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.wvalid |-> !$isunknown(aif.wdata);
   endproperty:wdata_unknown
   WDATA_UNKNOWN:assert property(wdata_unknown);

//  wstrb is not contain any x or z values
   property wstrb_unknown;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.wvalid |-> !$isunknown(aif.wstrb);
   endproperty:wstrb_unknown
   WSTRB_UNKNOWN:assert property(wstrb_unknown);

//----------------------------//
//   WRITE RESPONSE CHANNEL   //
//----------------------------//


//  wvalid is must be asserted until wready is comes
   property bvalid_high;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.bvalid && !aif.bready)|=>aif.bvalid;
   endproperty:bvalid_high
   BVALID_HIGH:assert property(bvalid_high);

//  bresp must be stable until bready is asserted
   property bresp_stable;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.bvalid && !aif.bready)|=>$stable(aif.bresp);
   endproperty:bresp_stable
   BRESP_STABLE:assert property(bresp_stable);

//  bvalid is asserted after only bready is asserted
   property bvalid_bready;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.bvalid |-> ## [0:$]aif.bready;
   endproperty:bvalid_bready
   BVALID_BREADY:assert property(bvalid_bready);

//  bresp is not contain any x or z values
   property bresp_unknown;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.bvalid |-> !$isunknown(aif.bresp);
   endproperty:bresp_unknown
   BRESP_UNKNOWN:assert property(bresp_unknown);

//  bvalid is not contain any x or z values
   property bvalid_unknown;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      !$isunknown(aif.bvalid);
   endproperty:bvalid_unknown
   BVALID_UNKNOWN:assert property(bvalid_unknown);

//----------------------------//
//   READ ADDRESS CHANNEL    //
//----------------------------//


//  arvalid is must be asserted until arready is comes
   property arvalid_high;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.arvalid && !aif.arready)|=>aif.arvalid;
   endproperty:arvalid_high
   ARVALID_HIGH:assert property(arvalid_high);

//  araddr must be stable until arready is asserted
   property araddr_stable;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.arvalid && !aif.arready)|=>$stable(aif.araddr);
   endproperty:araddr_stable
   ARADDR_STABLE:assert property(araddr_stable);

//  arvalid is asserted after only arready is asserted
   property arvalid_arready;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.arvalid |-> ## [0:$]aif.arready;
   endproperty:arvalid_arready
   ARVALID_ARREADY:assert property(arvalid_arready);

//  araddr is not contain any x or z values
   property araddr_unknown;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.arvalid |-> !$isunknown(aif.araddr);
   endproperty:araddr_unknown
   ARADDR_UNKNOWN:assert property(araddr_unknown);

//----------------------------//
//    READ DATA CHANNEL       //
//----------------------------//


//  rvalid is must be asserted until rready is comes
   property rvalid_high;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.rvalid && !aif.rready)|=>aif.rvalid;
   endproperty:rvalid_high
   RVALID_HIGH:assert property(rvalid_high);

//  rdata must be stable until rready is asserted
   property rdata_stable;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.rvalid && !aif.rready)|=>$stable(aif.rdata);
   endproperty:rdata_stable
   RDATA_STABLE:assert property(rdata_stable);

//  rresp must be stable until rready is asserted
   property rresp_stable;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      (aif.rvalid && !aif.rready)|=>$stable(aif.rresp);
   endproperty:rresp_stable
    RRESP_STABLE:assert property(rresp_stable);

//  rvalid is asserted after only rready is asserted
   property rvalid_rready;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.rvalid |-> ## [0:$]aif.rready;
   endproperty:rvalid_rready
   RVALID_RREADY:assert property(rvalid_rready);

//  rdata is not contain any x or z values
   property rdata_unknown;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.rvalid |-> !$isunknown(aif.rdata);
   endproperty:rdata_unknown
   RDATA_UNKNOWN:assert property(rdata_unknown);

//  rresp is not contain any x or z values
   property rresp_unknown;
      @(posedge aif.aclk)
      disable iff(!aif.aresetn)
      aif.rvalid |-> !$isunknown(aif.rresp);
   endproperty:rresp_unknown
   RRESP_UNKNOWN:assert property(rresp_unknown);

endmodule:axi_assertion
`endif
