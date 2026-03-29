`timescale 1ns/1ps;

module testbench_uart_loop;
reg clk,rst,rx1_data_ready,tx1_data_valid,sel1;
reg [7:0] inputdata1;
reg rx2_data_ready,tx2_data_valid,sel2;
reg [7:0] inputdata2;

uart_loop #(
    .clkfreqence(50),//clock freqence 50MHz
    .baudrate(115200) //baud rate 115200bps
) u_uart_loop(
    .clk(clk),
    .rst(rst),
    .rx1_data_ready(rx1_data_ready),
    .tx1_data_valid(tx1_data_valid),
    .sel1(sel1),
    .inputdata1(inputdata1),
    .rx2_data_ready(rx2_data_ready),
    .tx2_data_valid(tx2_data_valid),
    .sel2(sel2),
    .inputdata2(inputdata2)
);

initial begin
    clk=0;
    forever #10 clk=~clk;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,testbench_uart_loop);
    rst=1'b0;#8000;
    rst=1'b1;sel1=1'b1;inputdata1=8'hA3;sel2=1'b0;inputdata2=8'b10101010;#80;#8000;
    tx1_data_valid=1'b1;rx1_data_ready=1'b1;#80;
    tx1_data_valid=1'b0;rx1_data_ready=1'b0;sel1=1'b0;#160000;
    tx2_data_valid=1'b1;rx2_data_ready=1'b1;#80;
    tx2_data_valid=1'b0;rx2_data_ready=1'b0;#160000;
    tx1_data_valid=1'b1;rx1_data_ready=1'b1;#80;
    tx1_data_valid=1'b0;rx1_data_ready=1'b0;#160000;
    sel2=1'b1;inputdata2=8'b10101010;#80;
    tx2_data_valid=1'b1;rx2_data_ready=1'b1;#80;
    tx2_data_valid=1'b0;rx2_data_ready=1'b0;#160000;
    sel2=1'b0;inputdata2=8'b10101010;#80;
    tx1_data_valid=1'b1;rx1_data_ready=1'b1;#80;
    tx1_data_valid=1'b0;rx1_data_ready=1'b0;#160000;
    tx2_data_valid=1'b1;rx2_data_ready=1'b1;#80;
    tx2_data_valid=1'b0;rx2_data_ready=1'b0;#160000;
    tx1_data_valid=1'b1;rx1_data_ready=1'b1;#80;
    tx1_data_valid=1'b0;rx1_data_ready=1'b0;#160000;
    tx2_data_valid=1'b1;rx2_data_ready=1'b1;#80;
    tx2_data_valid=1'b0;rx2_data_ready=1'b0;#160000;
    $finish;
end

endmodule
