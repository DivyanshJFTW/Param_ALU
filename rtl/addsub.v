/*
 * Module      : addsub
 * Description : Parameterized P-bit ripple-carry add/subtract unit.
 *
 * Operations:
 *   - addition      : a + b
 *   - Subtraction   : a + (~b) + 1
 *
 * Outputs:
 *   - Sum/Difference
 *   - Carry-out
 *   - Signed overflow
 */

module addsub #(parameter P = 32)(
input [P-1:0] a, b, 
output [P-1:0] add_sum, 
output [P-1:0] sub_sum,
output add_cout,
output sub_cout,
output add_overflow,
output sub_overflow);

wire [P:0] carry_add;
wire [P:0] carry_sub;

assign carry_add[0] = 1'b0; // add: a + b
assign carry_sub[0] = 1'b1; // sub: a + ~b +1


full_adder instadd [P-1:0] (
.a(a), 
.b(b), 
.cin(carry_add[P-1:0]), 
.cout(carry_add[P:1]), 
.sum(add_sum)); // add operation using P-bit Ripple Carry adder


full_adder instsub [P-1:0] (
.a(a), 
.b(~b), 
.cin(carry_sub[P-1:0]), 
.cout(carry_sub[P:1]), 
.sum(sub_sum)); // sub operation using P-bit Ripple Carry Subtractor

assign add_cout = carry_add[P];
assign sub_cout = carry_sub[P];

// Signed overflow = carry into MSb XOR carry out of MSb
assign add_overflow = carry_add[P-1] ^ carry_add[P];
assign sub_overflow = carry_sub[P-1] ^ carry_sub[P];

endmodule

module full_adder (
input a,
input b,
input cin,
output cout,
output sum);

assign {cout, sum} = (a + b + cin);

endmodule
