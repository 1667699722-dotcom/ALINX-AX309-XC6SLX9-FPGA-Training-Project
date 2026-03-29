`timescale 1ns/1ps;

module testbench_uart_full;

reg clk,rst,rx_data_ready,tx_data_valid;
reg uart_rx;
reg sel;
reg [7:0] inputdata;
wire uart_tx;
uart_full #(
    .clkfreqence(50),//clock freqence 50MHz
    .baudrate(115200) //baud rate 115200bps
) u_uart_full(
    .clk(clk),
    .rst(rst),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .rx_data_ready(rx_data_ready),
    .tx_data_valid(tx_data_valid),
    .inputdata(inputdata),
    .sel(sel)
);
initial begin
    clk=0;
    forever #10 clk=~clk;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,testbench_uart_full);
    rst=1'b0;#80;
    rst=1'b1;sel=1'b1;inputdata=8'hA3;#20000;
    rx_data_ready=1'b1;tx_data_valid=1'b1;#80;
    rx_data_ready=1'b0;tx_data_valid=1'b0;#80000;
    sel=1'b0;
    uart_rx=1'b1;#8680;
    uart_rx=1'b0;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b0;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b1;#8680;#20000;
    rx_data_ready=1'b1;tx_data_valid=1'b1;#80;
    rx_data_ready=1'b0;tx_data_valid=1'b0;#80;#100000;
     uart_rx=1'b1;#8680;
    uart_rx=1'b0;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b0;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b0;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b0;#8680;
    uart_rx=1'b1;#8680;
    uart_rx=1'b0;#8680;#20000;
    rx_data_ready=1'b1;tx_data_valid=1'b1;#80;
    rx_data_ready=1'b0;tx_data_valid=1'b0;#80;#100000;
    $finish;
end
endmodule