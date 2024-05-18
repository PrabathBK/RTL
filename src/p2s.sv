    module p2s #(N = 8)
    (
      input  logic clk , ser_ready, par_valid, 
      input  logic [N-1:0] par_data,
      output logic par_ready, ser_data, ser_valid
    );
      localparam N_BITS = $clog2(N);
    
      typedef enum logic [0:0]{
      RX= 1'b0,
      TX=1'b1} state_t; //= RX;
      
      state_t state=RX;
      state_t next_state;
      
      logic [N_BITS-1:0] count; // = 0; // Initial values when FPGA powers up
     
    
      always_comb
        unique case (state)
          RX: begin
          if(par_valid)  next_state = TX;
          else next_state=RX;
          end
          
          TX: begin
          if(ser_ready && count==N-1)  next_state = RX;
          else next_state=TX;
          end
    
        endcase
    
      always_ff @(posedge clk)begin
        state <= next_state;
        end 
        
      logic [N-1:0] shift_reg;
    
      assign ser_data  = shift_reg[0];
      
      assign par_ready = (state == RX);
      assign ser_valid = (state == TX);
    
      always_ff @(posedge clk ) begin//or negedge rstn
    //    if (!rstn) count    <= '0;
    //    else 
          unique case (state)
            RX: begin  
                  shift_reg <= par_data;
                  count     <= '0;
                end
            TX: if (ser_ready) begin
                  shift_reg <= shift_reg >> 1;
                  count     <= count + 1'd1;
                end 
                else begin 
                shift_reg <= shift_reg;
                count <= count;
                end
          endcase
          end
    endmodule
