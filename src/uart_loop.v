//uart_loop.v
//uart_loop模块实现了两个uart_full模块的连接，使得它们可以互相通信。
//uart1的接收端连接到uart2的发送端，uart2的接收端连接到uart1的发送端。通过sel1和sel2信号，可以选择是使用接收到的数据还是输入的数据进行发送。
module uart_loop
#(
    parameter clkfreqence = 50,//clock freqence 50MHz
    parameter baudrate=115200 //baud rate 115200bps
)
(
    input clk,
    input rst,
    input rx1_data_ready,
    input tx1_data_valid,
    input sel1,
    input [7:0] inputdata1,
    input rx2_data_ready,
    input tx2_data_valid,
    input sel2,
    input [7:0] inputdata2
);
//定义uart1_rx、uart1_tx、uart2_rx和uart2_tx信号，分别用于连接两个uart_full模块的接收和发送端口。
reg uart1_rx;
wire uart1_tx;
reg uart2_rx;
wire uart2_tx;
//实例化两个uart_full模块，分别命名为u_uart1和u_uart2。每个模块都连接到相应的输入和输出信号。
uart_full #(
    .clkfreqence(clkfreqence),//clock freqence 50MHz
    .baudrate(baudrate) //baud rate 115200bps
) u_uart1(
    .clk(clk),
    .rst(rst),
    .uart_rx(uart1_rx),
    .uart_tx(uart1_tx),
    .rx_data_ready(rx1_data_ready),
    .tx_data_valid(tx1_data_valid),
    .sel(sel1),
    .inputdata(inputdata1)
);

uart_full #(
    .clkfreqence(clkfreqence),//clock freqence 50MHz
    .baudrate(baudrate) //baud rate 115200bps
) u_uart2(
    .clk(clk),
    .rst(rst),
    .uart_rx(uart2_rx),
    .uart_tx(uart2_tx),
    .rx_data_ready(rx2_data_ready),
    .tx_data_valid(tx2_data_valid),
    .sel(sel2),
    .inputdata(inputdata2)
);
//在复位状态下，uart1_rx和uart2_rx都保持高电平（空闲状态）。当复位信号为1时，uart1_rx连接到uart2_tx，uart2_rx连接到uart1_tx，实现了两个uart_full模块的互联。
always @(*) begin
    if(rst==1'b0)
    begin
        uart1_rx<=1'b1;
        uart2_rx<=1'b1;
    end
    else
    begin
        uart1_rx<=uart2_tx;
        uart2_rx<=uart1_tx;
    end  
end

endmodule 

