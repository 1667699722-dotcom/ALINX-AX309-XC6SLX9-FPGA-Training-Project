`timescale 1ns/1ps;
module testbench_led_test;
reg clk,rst_n;
wire [3:0] led;

led_test u_led_test(.clk(clk),.rst_n(rst_n),.led(led));
initial begin
    clk=0;
    forever #1 clk=~clk;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,testbench_led_test);
    rst_n=1;#8.5;
    rst_n=0;#2;
    rst_n=1;#800;
    $finish;
end
endmodule