`timescale 1ns / 1ps

module ABM
#(
    parameter N                  = 16,
    parameter VOQ                = 3,
    parameter QUEUE_LEN_WIDTH    = 16,
    parameter ALPHA              = 1,
    parameter MEM_WIDTH          = 16,
    parameter CONGESTION_THRESH  = 8,
    parameter THRESHOLD_WIDTH    = 16
)
(
    input  clk,

    input  [N*VOQ*QUEUE_LEN_WIDTH-1 : 0] queue_len,
    input  [MEM_WIDTH-1 : 0] free_space,

    output reg [VOQ*THRESHOLD_WIDTH-1 : 0] threshold
);


wire [N*VOQ-1 : 0] cf;

wire [VOQ*$clog2(N)-1 : 0] cong_count;


/* Count the number of congested queues for each VOQ */
congestion_counter instance1 (.congestion_flags(cf), .congestion_count(cong_count));


/* Generate congestion flag for every queue */
genvar i;
genvar b;

generate
    for (i = 0; i < N; i = i + 1) begin : QUEUE_LEN_GEN
        for(b = 0; b < VOQ; b=b+1) begin : VOQ_GEN
            congestion_flag_calculator instance1 ( .A( queue_len[ ((VOQ*i+b)+1)*QUEUE_LEN_WIDTH-1 : (VOQ*i+b)*QUEUE_LEN_WIDTH ] ),.congestion_flags(cf[(VOQ*i+b)]), .threshold(threshold[(b+1)*THRESHOLD_WIDTH-1 : b*THRESHOLD_WIDTH ] ) );
        end
    end
endgenerate


/* Procedural loop variables */
integer a;
integer j;


/* Calculate threshold for every queue */
always @(posedge clk) begin

        for (j = 0; j < VOQ; j = j + 1) begin
            if (cong_count[j*$clog2(N) +: $clog2(N) ] != 0) begin
                threshold[j*THRESHOLD_WIDTH +: THRESHOLD_WIDTH] <=
                (ALPHA *(free_space - queue_len[j*QUEUE_LEN_WIDTH +: QUEUE_LEN_WIDTH]))/
                (cong_count[j*$clog2(N) +: $clog2(N)]* VOQ);
            end
            else begin
                threshold[j*THRESHOLD_WIDTH +: THRESHOLD_WIDTH ] <= 0;
            end
        end
    end


endmodule