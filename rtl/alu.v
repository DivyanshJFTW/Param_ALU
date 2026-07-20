/*
4 bit opcode alu with parameterized inputs

Opcodes:
alu_sel	Operation
0000	ADD
0001	SUB
0010	AND
0011	OR
0100	XOR
0101	SLL
0110	SRL
0111	SRA
1000	SEQ (==)
1001	SNE (!=)
1010	SLT (signed)
1011	SLTU (unsigned)
*/

module alu #(parameter P = 32)(
input [P-1:0] a, b,
input [3:0] alu_sel,
output reg [P-1:0] result,
output overflow,
output carry,
output zero
);

wire [P-1:0] add_sum;
wire [P-1:0] sub_sum;
wire add_cout, sub_cout;
wire add_overflow, sub_overflow;

// Add-Sub Module Instantiation
addsub #(P) add_sub (
.a(a),
.b(b),
.add_sum(add_sum),
.sub_sum(sub_sum),
.add_cout(add_cout),
.add_overflow(add_overflow),
.sub_cout(sub_cout),
.sub_overflow(sub_overflow)
);

wire [1:0] cmp_sel;
wire [P-1:0] cmp_result;
assign cmp_sel =
    (alu_sel == 4'b1000) ? 2'b00 :
    (alu_sel == 4'b1001) ? 2'b01 :
    (alu_sel == 4'b1010) ? 2'b10 :
                           2'b11;

// Comparator Module Instantiation
comparator #(P) cmp (
.a(a),
.b(b),
.cmp_sel(cmp_sel),
.result(cmp_result)
);

wire [P-1:0] and_out;
wire [P-1:0] or_out;
wire [P-1:0] xor_out;

// Logic Operation Module Instantiation
logicop #(P) logical (
.a(a),
.b(b),
.and_out(and_out),
.or_out(or_out),
.xor_out(xor_out)
);

wire [P-1:0] shift_result;
wire [1:0] shift_sel;

assign shift_sel = (alu_sel == 4'b0101) ? 2'b00 :
						 (alu_sel == 4'b0110) ? 2'b01: 2'b10;  // Using alu_sel as shift_sel operation

// Shifter Module Instantiation						 
shifter #(P) shift (
.a(a),
.shamt(b[$clog2(P)-1:0]),
.shift_sel(shift_sel),
.result(shift_result)
);


always @(*) begin
    case(alu_sel)

        4'b0000: result = add_sum;
        4'b0001: result = sub_sum;
		  
        4'b0010: result = and_out;
        4'b0011: result = or_out;
        4'b0100: result = xor_out;

        4'b0101,
        4'b0110,
        4'b0111: result = shift_result;

        4'b1000,
        4'b1001,
        4'b1010,
        4'b1011: result = cmp_result;

        default: result = {P{1'b0}};
    endcase
end

// Handling zero, carry, and overflow flags.

assign zero = (result == 0);
assign carry = (alu_sel == 4'b0000) ? add_cout :
					(alu_sel == 4'b0001) ? sub_cout :1'b0;
					
assign overflow = (alu_sel == 4'b0000) ? add_overflow :
						(alu_sel == 4'b0001) ? sub_overflow : 1'b0;
						
endmodule