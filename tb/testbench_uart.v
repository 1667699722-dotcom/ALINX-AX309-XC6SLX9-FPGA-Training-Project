`timescale 1ns/1ps;
module testbench_uart;
reg clk,rst,rx_data_ready;
reg uart_rx;
wire uart_tx;


uart #(
    .clkfreqence(50),//clock freqence 50MHz
    .baudrate(115200) //baud rate 115200bps
) u_uart(
    .clk(clk),
    .rst(rst),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .rx_data_ready(rx_data_ready)
);

initial begin
    clk=0;
    forever #10 clk=~clk;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,testbench_uart);
    rst=1'b0;rx_data_ready=1'b0;uart_rx=1'b1;#80;
    rst=1'b1;#2000000;
    rx_data_ready=1'b0;#12000;
    uart_rx=1'b0;#8680;
    uart_rx=1'b0;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b0;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b0;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b0;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b1;#8680;#1000000;
    rx_data_ready=1'b1;#80
    rx_data_ready=1'b0;
    uart_rx=1'b1;#2000000;


    $finish;
end
endmodule
