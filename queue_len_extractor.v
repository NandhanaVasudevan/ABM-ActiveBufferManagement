 module queue_len_extractor #(parameter CONGESTION_THRESH) (
    input [QUEUE_LEN_WIDTH - 1 : 0] A,
    output congestion_flags
);
    
    always @(*) begin
        if(A>CONGESTION_THRESH) begin
            congestion_flags = 1;
        end else begin
            congestion_flags = 0;
        end
    end
    


    endmodule