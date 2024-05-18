module alu #(
  parameter  WIDTH     = 8,
  localparam W_ALU_SEL = 3
)(
  input  logic signed [WIDTH-1:0] bus_a,
  input  logic signed [WIDTH-1:0] bus_b,
  output logic signed [WIDTH-1:0] alu_out,
  input  logic [W_ALU_SEL   -1:0] alu_sel,
  output logic zero, negative
);

//  always_comb begin
//    if (alu_sel == 3'b000) alu_out = bus_a +  bus_b;
//    else if (alu_sel == W_ALU_SEL'b001) alu_out = bus_a -  bus_b;
//    else if (alu_sel == W_ALU_SEL'b010) alu_out = bus_a *  bus_b;
//    else if (alu_sel == W_ALU_SEL'b011 & bus_b != WIDTH'b00000000) alu_out = bus_a /  bus_b;
//    else if (alu_sel == W_ALU_SEL'b100  & bus_b != 2'h00) alu_out = bus_a % bus_b;
//    else                       alu_out = bus_a;  // pass a if 0
//end

//Usually Use Switch case as MULTIPLEXER
  always_comb begin
    case (alu_sel)
      3'b000: alu_out = bus_a + bus_b;
      3'b001: alu_out = bus_a - bus_b;
      3'b010: alu_out = bus_a * bus_b;
      3'b011: alu_out = (bus_b != 0) ? (bus_a / bus_b) : '0;
      3'b100: alu_out = (bus_b != 0) ? (bus_a % bus_b) : '0;
      default: alu_out = bus_a; // pass a if 0
    endcase
  end

  assign zero     = (alu_out == 0);
  assign negative = (alu_out < 0);

endmodule
