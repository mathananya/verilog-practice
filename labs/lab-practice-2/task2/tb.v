// tb.v -- Part B1: complete this self-checking testbench for ticket_machine.
// Keep the instance name dut. Do not change model.v.
// It must end by printing one line: RESULT: PASS or RESULT: FAIL
`timescale 1ns/1ps
module tb;
  reg        clk = 0, rst_n = 0, c5 = 0, c10 = 0, cancel = 0;
  wire [4:0] credit;
  wire       vend;
  ticket_machine dut (.clk(clk), .rst_n(rst_n), .c5(c5), .c10(c10), .cancel(cancel),
                      .credit(credit), .vend(vend));

  always #5 clk = ~clk;

  // (a) TODO: instantiate ticket_model (in model.v) as the reference model,
  //     driven by the same inputs as dut.

  // (a) TODO: after every clock edge, compare credit and vend of dut with the
  //     model's outputs; on a mismatch add 1 to errors ($display helps debug).
  integer errors = 0;

  // (b) TODO: test cases. Change inputs only at falling clock edges.
  //     Cases worth trying: 15 made as 5+10, a coin inserted in a vend cycle,
  //     10 + 10, cancel, and a reset pulse between two clock edges.
  initial begin
    #12 rst_n = 1;
    @(negedge clk) c5 = 1;
    @(negedge clk) c5 = 0;
    // ... your test cases here ...
    @(negedge clk); #1;                       // let the last check finish
    if (errors == 0) $display("RESULT: PASS");
    else             $display("RESULT: FAIL");
    $finish;
  end

  // waveform dump for the Run button: keep this block
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
  end
endmodule
