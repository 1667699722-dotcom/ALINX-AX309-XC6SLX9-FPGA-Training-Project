`timescale 1ns/1ps;
module key_test(clk,key,led);
input clk;
input [3:0] key;
output [3:0] led;
reg [3:0] led_r,led_r1;

always @(posedge clk)
begin
    led_r<=#2 ~key;
end

always @(posedge clk)
begin
    led_r1<=#2 led_r;
end

assign led=led_r1;

endmodule
