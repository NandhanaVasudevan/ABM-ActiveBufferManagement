module congestion_counter (
    input [N*VOQ -1 :0] congestion_flags,
    output [VOQ*log(N) - 1 : 0] congestion_count
)
    always @(*)
    begin
        congestion_count = 0;
        for (int n=0; n<N; n=n+1)
        begin
            for(int i; i<VOQ; i=i+1) 
            begin
                if(congestion_flags [n*VOQ + i]==1)
               congestion_count[i] = congestion_count[i] + 1;
            end
        end
    end
endmodule