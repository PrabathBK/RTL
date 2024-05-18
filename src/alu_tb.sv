class Random_Num #(WIDTH);
  rand bit signed [WIDTH-1:0] num;
endclass

class Random_Sel;
  rand bit [2:0] num;
  constraint c {num inside {[0:4]};}

  function new();
    this.randomize();
  endfunction
endclass

module alu_tb();
  timeunit 1ns/1ps;
  logic clk = 0;
  localparam CLK_PERIOD = 10;

  initial begin
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  localparam WIDTH = 8;
  logic        [2:0]       alu_sel;
  logic signed [WIDTH-1:0] bus_a, bus_b, alu_out;
  logic                    zero, negative;

  alu #(.WIDTH(WIDTH)) dut (
    .bus_a(bus_a),
    .bus_b(bus_b),
    .alu_out(alu_out),
    .alu_sel(alu_sel),
    .zero(zero),
    .negative(negative)
  );

  Random_Num #(WIDTH) A_r = new();
  Random_Num #(WIDTH) B_r = new();
  Random_Sel sel_r = new();

  initial begin
    bus_a <= 8'd5;
    bus_b <= 8'd0;
    alu_sel <= 3'b011;

    #10;
    bus_a <= 8'd30; 
    bus_b <= -8'd10; 
    alu_sel <= 3'b001;

//    @(posedge clk);
#10;
    bus_a <= 8'd5; 
    bus_b <= 8'd10; 
    alu_sel <= 3'b010;

//    @(posedge clk);
#10;
    bus_a <= 8'd51; 
    bus_b <= 8'd17; 
    alu_sel <= 3'b011;

    repeat(5) begin
//      @(posedge clk);
#10;
      A_r.randomize();
      B_r.randomize();
      sel_r.randomize();
      bus_a <= A_r.num; 
      bus_b <= B_r.num; 
      alu_sel <= sel_r.num;
    end
  end

  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars(0, alu_tb);
  end
endmodule
