module full_adder (
  input  logic a, b, c_in,
  output logic sum, c_out
);

  logic wire_1, wire_2;
  assign wire_1 = a ^ b;       // bitwise XOR
  assign wire_2 = wire_1 & c_in; // bitwise AND
  
  logic wire_3;
  assign wire_3 = a & b;       // bitwise AND

  always_comb begin
    c_out  = wire_2 | wire_3;     // bitwise OR
    sum    = wire_1 ^ c_in;    // bitwise XOR
  end

endmodule
