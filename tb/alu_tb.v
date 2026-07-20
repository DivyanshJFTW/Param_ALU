`timescale 1ns/1ps

module alu_tb;

parameter P = 32;

reg  [P-1:0] a;
reg  [P-1:0] b;
reg  [3:0]   alu_sel;

wire [P-1:0] result;
wire carry;
wire overflow;
wire zero;

alu #(P) DUT (
    .a(a),
    .b(b),
    .alu_sel(alu_sel),
    .result(result),
    .carry(carry),
    .overflow(overflow),
    .zero(zero)
);

integer passed = 0;
integer failed = 0;

task check;
input [P-1:0] expected;
begin
    #5;

    if(result === expected)
    begin
        $display("[PASS] Opcode=%b A=%h B=%h Result=%h",
                 alu_sel,a,b,result);
        passed = passed + 1;
    end
    else
    begin
        $display("[FAIL] Opcode=%b A=%h B=%h Expected=%h Got=%h",
                 alu_sel,a,b,expected,result);
        failed = failed + 1;
    end
end
endtask

initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, alu_tb);

$display("ALU Verification Started");


// ADD

// Normal
a=20; b=15; alu_sel=4'b0000;
check(35);

// Zero result
a=0; b=0;
check(0);

// Carry generation
a=32'hFFFFFFFF;
b=1;
check(32'h00000000);

if(carry)
    $display("PASS Carry Generated");
else
    $display("FAIL Carry");

// Signed overflow
a=32'h7FFFFFFF;
b=1;
check(32'h80000000);

if(overflow)
    $display("PASS Overflow");
else
    $display("FAIL Overflow");

	 
// SUB

// Normal
a=40;
b=10;
alu_sel=4'b0001;
check(30);

// Zero result
a=100;
b=100;
check(0);

// Negative result
a=5;
b=10;
check(32'hFFFFFFFB);

// Signed overflow
a=32'h80000000;
b=1;
check(32'h7FFFFFFF);

// AND

alu_sel=4'b0010;

a=32'hAAAAAAAA;
b=32'h55555555;
check(32'h00000000);

a=32'hFFFFFFFF;
b=32'h12345678;
check(32'h12345678);

// OR

alu_sel=4'b0011;

a=32'hAAAAAAAA;
b=32'h55555555;
check(32'hFFFFFFFF);

// XOR

alu_sel=4'b0100;

a=32'hAAAAAAAA;
b=32'hAAAAAAAA;
check(0);

a=32'hFFFFFFFF;
b=0;
check(32'hFFFFFFFF);

// SHIFT LEFT

alu_sel=4'b0101;

// Shift by 0
a=32'h1;
b=0;
check(32'h1);

// Shift by 1
a=32'h1;
b=1;
check(32'h2);

// Shift by maximum (31)
a=32'h1;
b=31;
check(32'h80000000);

// SHIFT RIGHT LOGICAL

alu_sel=4'b0110;

a=32'h80000000;
b=1;
check(32'h40000000);

a=32'hFFFFFFFF;
b=31;
check(32'h00000001);


// SHIFT RIGHT ARITHMETIC

alu_sel=4'b0111;

// Sign extension
a=32'h80000000;
b=1;
check(32'hC0000000);

// All ones stay ones
a=32'hFFFFFFFF;
b=4;
check(32'hFFFFFFFF);

// Positive number
a=32'h70000000;
b=4;
check(32'h07000000);

// SEQ

alu_sel=4'b1000;

a=50;
b=50;
check(1);

a=50;
b=60;
check(0);


// SNE

alu_sel=4'b1001;

a=100;
b=200;
check(1);

a=100;
b=100;
check(0);

// SLT (SIGNED)

alu_sel=4'b1010;

// -1 < 1
a=32'hFFFFFFFF;
b=1;
check(1);

// 10 < -5
a=10;
b=-5;
check(0);

// Equal
a=20;
b=20;
check(0);

// SLTU (UNSIGNED)

alu_sel=4'b1011;

// FFFFFFFF > 1
a=32'hFFFFFFFF;
b=1;
check(0);

// 1 < FFFFFFFF
a=1;
b=32'hFFFFFFFF;
check(1);

// Equal
a=100;
b=100;
check(0);

// INVALID OPCODE

alu_sel=4'b1111;
a=32'h12345678;
b=32'h87654321;
check(0);

// ZERO FLAG TESTS

alu_sel=4'b0000;
a=0;
b=0;
#5;

if(zero)
    $display("PASS Zero Flag");
else
    $display("FAIL Zero Flag");

alu_sel=4'b0000;
a=10;
b=5;
#5;

if(!zero)
    $display("PASS Zero Clear");
else
    $display("FAIL Zero Clear");



$display("Tests Passed : %0d",passed);
$display("Tests Failed : %0d",failed);

$finish;

end

endmodule