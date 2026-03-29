`timescale 1ns/1ps;

module testbench_uart_rx;
reg clk,rst,rx_data_ready,rx_pin;
wire [7:0] rx_data;
wire rx_data_valid;

uart_rx #(
    .clkfreqence(50),//clock freqence 50MHz
    .baudrate(115200) //baud rate 115200bps
) u_uart_rx(
    .clk(clk),
    .rst(rst),
    .rx_data_ready(rx_data_ready),
    .rx_pin(rx_pin),
    .rx_data(rx_data),
    .rx_data_valid(rx_data_valid)
);

initial begin
    clk=0;
    forever #10 clk=~clk;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,testbench_uart_rx);
    rst=1'b0;#80;
    rst=1'b1;rx_data_ready=1'b0;rx_pin=1'b1;#4000;
    rx_pin=1'b0;#8680;//start bit
    rx_pin=1'b1;#8680;//bit 0
    rx_pin=1'b0;#8680;//bit 1
    rx_pin=1'b1;#8680;//bit 2
    rx_pin=1'b0;#8680;//bit 3
    rx_pin=1'b1;#8680;//bit 4
    rx_pin=1'b0;#8680;//bit 5
    rx_pin=1'b1;#8680;//bit 6
    rx_pin=1'b0;#8680;#8680;//bit 7
    rx_data_ready=1'b1;rst=1'b1;#4000;
    rx_data_ready=1'b0;rx_pin=1'b1;#12000;
    rx_pin=1'b0;#8680;//start bit
    rx_pin=1'b1;#8680;//bit 0
    rx_pin=1'b1;#8680;//bit 1
    rx_pin=1'b1;#8680;//bit 2
    rx_pin=1'b1;#8680;//bit 3
    rx_pin=1'b1;#8680;//bit 4
    rx_pin=1'b0;#8680;//bit 5
    rx_pin=1'b1;#8680;//bit 6
    rx_pin=1'b0;#8680;//bit 7
    rx_pin=1'b1;#8680;
    rst=1'b0;#80;
    rst=1'b1;#4000;
    $finish;
end
endmodule