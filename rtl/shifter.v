/* 
* Module : Shifter
* Description: Parameterized Shifter Module including logical shift left, logical shift right, signed shift.
*/

module shifter #(parameter P = 32)(
	input  [P-1:0] a,
   input  [$clog2(P)-1:0] shamt, // clog2 is Ceiling log base 2. Returnes the minimum number of bits to represent values from 0 to P-1.
	input [1:0] shift_sel,
	output reg [P-1:0] result
);

always @(*) begin
    case (shift_sel)
        2'b00: result = a << shamt;
        2'b01: result = a >> shamt;
        2'b10: result = $signed(a) >>> shamt;
        default: result = {P{1'b0}};
    endcase
end

endmodule
