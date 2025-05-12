`celldefine
module PDD24DGZ (I, OEN, PAD, C);
  inout PAD;
  input I, OEN;
  output C;

  parameter PullTime = 100000;
 
  reg lastPAD, pull;
  bufif1 (weak0,weak1) (C_buf, 1'b0, pull);
  buf    (C, C_buf);
  bufif0 (PAD, I, OEN);
  pmos   (C_buf, PAD, 1'b0);

  always @(PAD) begin
 
    if (PAD === 1'bx && !$test$plusargs("bus_conflict_off") &&
        $countdrivers(PAD))
       $display("%t ++BUS CONFLICT++ : %m", $realtime);
 
    if (PAD === 1'bz) begin
       if (lastPAD === 1'b0) pull=1;
       else pull <= #PullTime 1;
    end
    else pull=0; 
    lastPAD=PAD;
 
  end

  specify
    (I => PAD)=(0, 0);
     (OEN => PAD)=(0, 0, 0, 0, 0, 0);
    (PAD => C)=(0, 0);
  endspecify

endmodule
`endcelldefine