// Matrix class for random data generation and multiplication
  class Matrix #(parameter WIDTH, parameter N);
    typedef logic signed [WIDTH-1:0] m_t [N][N];
    rand m_t data;

    // Constraint for random data generation
    constraint c {
      foreach (data[i, j]) {
        data[i][j] inside {[-2**(WIDTH-1):2**(WIDTH-1)-1]};
      }
    }

    // Constructor
    function new();
      this.randomize();
    endfunction

    // Matrix multiplication function
    static function m_t matmul(m_t m1, m_t m2);
      m_t out;
      foreach (out[i, j]) begin
        integer signed sum = 0;
        foreach (m1[i, k]) begin
          sum += m1[i][k] * m2[k][j];
        end
        out[i][j] = sum;
      end
      return out;
    endfunction
  endclass

module matmul_tb;

  // Timescale and precision
  timeunit 1ns;
  timeprecision 1ps;

  // Clock signal
  logic clk;
  localparam CLK_PERIOD = 10;
  initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
  end

  // Parameters
  localparam N = 2;
  localparam WIDTH = 8;
  localparam LATENCY = $clog2(N) + 1;

  // Signals for the DUT
  logic [N*N*WIDTH-1:0] A_flat, B_flat, C_flat;

  // Instantiate the DUT
  matmul #(
    .N(N),
    .WIDTH(WIDTH)
  ) dut (
    .clk(clk),
    .A_flat(A_flat),
    .B_flat(B_flat),
    .C_flat(C_flat)
  );

  // 2D arrays for input and output matrices
  logic signed [WIDTH-1:0] A [N][N];
  logic signed [WIDTH-1:0] B [N][N];
  logic signed [WIDTH-1:0] C [N][N];

  // Flatten the 2D arrays into 1D arrays
  assign {<<{A_flat}} = A;
  assign {<<{B_flat}} = B;
  assign C = {>>{{<<{C_flat}}}};
  
  typedef Matrix #(.WIDTH(WIDTH), .N(N)) Mat_N_t ;
  Mat_N_t matrix_a,matrix_b;

  // Initial block for testing
  initial begin
    // Default values for A and B
    @ (posedge clk);
    A = '{default: 1}; 
    B = '{default: 1};
    
    // Initialize A and B matrices
    @ (posedge clk);
    for (int i = 0; i < N; i++) begin:r
      for (int j = 0; j < N; j++) begin:c
        A[i][j] = 10*i + j;
        B[i][j] = 1;
      end
    end

    // Initialize A and B matrices using foreach
    @ (posedge clk);
    foreach (A[i, j]) begin
      A[i][j] = 10*i + j;
      B[i][j] = 1;
    end

    // Repeat the test 20 times with random matrices
    repeat (20) begin
      @ (posedge clk);
      matrix_a = new();
      matrix_b = new();
      A = matrix_a.data;
      B = matrix_b.data;

      // Wait for the latency period
      # (LATENCY * CLK_PERIOD + 1);
      
      $display("%p", Mat_N_t::matmul(A, B));
      assert (Mat_N_t::matmul(A, B) == C);
    end
  end
  endmodule
