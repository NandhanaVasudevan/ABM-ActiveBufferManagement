 module queue_len_extractor #(parameter CONGESTION_THRESH = 2,
 parameter QUEUE_LEN_WIDTH = 16
 ) (
    input [QUEUE_LEN_WIDTH-1:0]threshold,
    input [QUEUE_LEN_WIDTH - 1 : 0] A,
    output reg congestion_flags
);
    
    always @(*) begin
        if(A>threshold/CONGESTION_THRESH) begin
            congestion_flags = 1;
        end else begin
            congestion_flags = 0;
        end
    end
    


    endmodule