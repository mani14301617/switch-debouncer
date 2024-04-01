module switch_debouncer(Q,q,clk,reset);
  output reg Q;
  input q,clk,reset;
  reg timer_done;
  parameter s0=0,s1=1,s2=2,s3=3;
  reg [1:0]state,next_state;
  reg [3:0]count;
  reg start;
  always@(negedge reset,posedge clk) begin
   if(~reset) begin
    state<=s0; next_state<=s0; end
    else 
    state<=next_state;
    end
  
  
  always@(q,timer_done)
    begin
      case(state)
        s0:
          if(q)
            begin 
              start=1;
              next_state=s1;
              Q=0;
             // timer_done<=0;
            end
          else
            begin
              Q=0;
              start=0;
            end
        s1:
          if(q&timer_done)
            begin
              next_state=s2;
              Q=1;
              start=0;
             // count<='b0;
            end
          else if(q&(~timer_done))
            begin
              start=1;
              Q=0;
            end
          else
            begin
              
              next_state=s0;
              start=0;
              Q=0;
            end
        s2:
          if(~q)
            begin
              next_state=s3;
              Q=1;
              start=1;
            end
          else
            start=0;
        s3:
          if(q)
            begin
              start=0;
              next_state=s2;
              
            end
        else if((~q)&timer_done)
          begin
            start=0;
            next_state=s0;
            Q=0;
            
          end
        else
         // begin
            start=1;
            
      endcase 
    end
  always@(posedge clk)
    begin
      if(start)
        begin
          if(count<10)
            begin
              count=count+1; 
              timer_done=0;
            end  
            else
              begin
              count='b0; 
              timer_done=1;
              end
            
         end
        
      else
        begin
          count='b0;
        end
        
    end
  
endmodule
