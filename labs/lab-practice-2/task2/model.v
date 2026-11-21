// model.v -- Given, do not modify.
// ticket_model: a purely behavioural model of the ticket machine, written only to
// generate the correct expected outputs. It is not built like ticket_machine.
module ticket_model (input clk, rst_n, c5, c10, cancel,
                     output reg [4:0] credit, output reg vend);
  always @(posedge clk or negedge rst_n)
    if (!rst_n)      credit <= 5'd0;
    else if (cancel) credit <= 5'd0;
    else             credit <= credit + (c5 ? 5'd5 : 5'd0) + (c10 ? 5'd10 : 5'd0)
                               - ((credit >= 5'd15) ? 5'd15 : 5'd0);
  always @(*)
    vend = (credit >= 5'd15);
endmodule
