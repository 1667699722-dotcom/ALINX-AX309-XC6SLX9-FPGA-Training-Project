`timescale 1ns/1ps;
module testbench_key_test;
reg clk;
reg [3:0] key;
wire [3:0] led;

key_test u_key_test(.clk(clk),.key(key),.led(led));

initial begin
    clk=0;
    forever #10 clk=~clk;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,testbench_key_test);
    key=4'b1111;#36;
    key=4'b1110;#36;
    key=4'b1101;#36;
    key=4'b1011;#36;
    key=4'b0111;#36;
    key=4'b1111;#80;
    $finish;
end

endmodule