module n_bit_dec #(
    parameter n = 2
)(
    input logic [n-1:0] in,
    output logic [(1<<n) - 1:0] out
);
    assign out = 1 << in;

endmodule : n_bit_dec