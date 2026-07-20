/* 
* Module : logicop (Logic Operations)
* Description : Parameterized Logic Operations including aND, OR, XOR.
*/


module logicop #(parameter P = 32)(
    input  [P-1:0] a,
    input  [P-1:0] b,
    output [P-1:0] and_out,
    output [P-1:0] or_out,
    output [P-1:0] xor_out
);

assign and_out = a & b;
assign or_out  = a | b;
assign xor_out = a ^ b;

endmodule