module congestion_counter #(
    parameter N   = 16,
    parameter VOQ = 3,
    parameter COUNT_WIDTH = $clog2(N+1)
)(
    input  [N*VOQ-1 : 0] congestion_flags,
    output reg [VOQ*COUNT_WIDTH-1 : 0] congestion_count
);

integer n;
integer i;

always @(*) begin

    // Initialize all counters to zero
    congestion_count = 0;

    for (n = 0; n < N; n = n + 1) begin
        for (i = 0; i < VOQ; i = i + 1) begin

            if (congestion_flags[n*VOQ + i] == 1'b1) begin

                congestion_count[
                    i*COUNT_WIDTH +: COUNT_WIDTH
                ] =
                congestion_count[
                    i*COUNT_WIDTH +: COUNT_WIDTH
                ] + 1'b1;

            end

        end
    end

end

endmodule