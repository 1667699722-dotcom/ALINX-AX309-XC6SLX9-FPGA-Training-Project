//uart_full.v
//uart_full模块实现了一个完整的UART通信接口，包括接收和发送功能。它由三个子模块组成：uart_rx、uart_tx和mux2。
//uart_rx模块负责接收UART数据，并将其转换为并行数据输出。uart_tx模块负责将并行数据转换为UART信号进行发送。mux2模块用于选择是使用接收到的数据还是输入的数据进行发送。
module uart_full
#(
    parameter clkfreqence = 50,//clock freqence 50MHz
    parameter baudrate=115200 //baud rate 115200bps
)
(
    input clk,
    input rst,
    input uart_rx,
    output uart_tx,
    input rx_data_ready,
    input tx_data_valid,
    input sel,
    input [7:0] inputdata
);

reg [7:0] tx_data;
wire [7:0] rx_data;
wire [7:0] out;
//实例化uart_rx模块，连接相应的输入和输出信号。uart_rx模块负责接收UART数据，并将其转换为并行数据输出。
uart_rx #(
    .clkfreqence(clkfreqence),
    .baudrate(baudrate)
) u_uart_rx(
    .clk(clk),
    .rst(rst),
    .rx_pin(uart_rx),
    .rx_data(rx_data),
    .rx_data_valid(rx_data_valid),
    .rx_data_ready(rx_data_ready)
);
//实例化uart_tx模块，连接相应的输入和输出信号。uart_tx模块负责将并行数据转换为UART信号进行发送。
uart_tx #(
    .clkfreqence(clkfreqence),
    .baudrate(baudrate)
) u_uart_tx(
    .clk(clk),
    .rst(rst),
    .tx_data(tx_data),
    .tx_data_valid(tx_data_valid),
    .tx_data_ready(tx_data_ready),
    .tx_pin(uart_tx)
);
//实例化mux2模块，连接相应的输入和输出信号。mux2模块用于选择是使用接收到的数据还是输入的数据进行发送。
mux2 u_mux2(
    .sel(sel),
    .a(rx_data),
    .b(inputdata),
    .out(out)
);
//在时钟上升沿或复位信号的下降沿触发的always块中，根据复位信号的状态来更新tx_data寄存器的值。当复位信号为0时，tx_data被重置为0；当复位信号为1时，tx_data被更新为mux2模块的输出值out。
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        tx_data<=8'd0;
    end
    else
    begin
        tx_data<=out;
    end
end

endmodule