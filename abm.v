module ABM
 #( parameter N,
 	parameter VOQ,
    parameter QUEUE_LEN_WIDTH,
    parameter ALPHA,
    parameter MEM_WIDTH,
    parameter CONGESTION_THRESH,
    parameter THRESHOLD_WIDTH)


 ( input [N*VOQ*QUEUE_LEN_WIDTH - 1 :0 ] queue_len,
 input [MEM_WIDTH-1 : 0 ] free_space,
 output [N*VOQ*THRESHOLD_WIDTH-1 : 0] threshold);

 wire [N*VOQ -1 :0] cf;
 wire [VOQ*log(N) - 1 : 0] cong_count;

   congestion_counter instance1 ( .congestion_flags(cf), .congestion_count(cong_count))
genvar i;
generate
    for (i=0; i<N*VOQ; i=i+1) begin
        queue_len_extractor instance1 ( .A(queue_len [(i+1)*QUEUE_LEN_WIDTH - 1 : i*QUEUE_LEN_WIDTH]), .congestion_flags (cf[i]));
    end
endgenerate

for (int i=0; i<N; i=i+1)
begin
  for (int j=0;j<VOQ;j=j+1)
begin
    threshold[(j+1)*THRESHOLD_WIDTH-1+(i*VOQ*THRESHOLD_WIDTH):(j*THRESHOLD_WIDTH)+(i*VOQ*THRESHOLD_WIDTH)]= (ALPHA(1/congestion_count[j]) (free_space-queue_len[(j+1)*QUEUE_LEN_WIDTH-1+(i*VOQ*QUEUE_LEN_WIDTH):(j*QUEUE_LEN_WIDTH)+(i*VOQ*QUEUE_LEN_WIDTH)]))/VOQ
end
end


 


    endmodule