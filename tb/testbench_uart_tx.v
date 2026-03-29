`timescale 1ns/1ps;
module testbench_uart_tx;
reg clk,rst,tx_data_valid;
reg [7:0] tx_data;
wire tx_pin;
wire tx_data_ready;

uart_tx #(
    .clkfreqence(50),//clock freqence 50MHz
    .baudrate(115200) //baud rate 115200bps
) u_uart_tx(
    .clk(clk),
    .rst(rst),
    .tx_data_valid(tx_data_valid),
    .tx_data(tx_data),
    .tx_pin(tx_pin),
    .tx_data_ready(tx_data_ready)
);

initial begin
    clk=0;
    forever #10 clk=~clk;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,testbench_uart_tx);
    rst=1'b0;#80;
    rst=1'b1;tx_data_valid=1'b0;tx_data=8'h00;#4000;
    tx_data_valid=1'b1;tx_data=8'h55;#4000;
    tx_data_valid=1'b0;#120000;
    tx_data_valid=1'b1;tx_data=8'hAA;#4000;
    tx_data_valid=1'b0;#120000;
    rst=1'b0;#80;
    rst=1'b1;#4000;
    $finish;
end
endmodule