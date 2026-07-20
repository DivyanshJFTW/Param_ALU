module comparator #(parameter P = 32)(
input [P-1:0] a,
input [P-1:0] b,
input [1:0] cmp_sel,
output reg [P-1:0] result
);

always @(*) begin
	case (cmp_sel)
		2'b00 : result = (a == b)? 1 : 0;
		2'b01 : result = (a != b)? 1 : 0;
		2'b10 : result = ($signed(a) < $signed(b)) ? 1 : 0;
		2'b11: result = (a < b) ? 1 : 0;
		default : result = {P{1'b0}};
		endcase
	end
	
endmodule