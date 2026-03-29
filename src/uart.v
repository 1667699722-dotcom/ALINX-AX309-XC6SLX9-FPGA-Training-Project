//uart module
//This module integrates the uart_rx and uart_tx modules to implement a simple UART communication system. The module takes serial data from the uart_rx input, decodes it using the uart_rx module
module uart
#(
    parameter clkfreqence = 50,//clock freqence 50MHz
    parameter baudrate=115200 //baud rate 115200bps
)
(
    input clk,
    input rst,
    input uart_rx,
    output uart_tx,
    input rx_data_ready
);

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

localparam idle = 0;
localparam sendbyte = 1;
localparam waitbyte = 2;
wire[7:0] rx_data;
reg [7:0] tx_data;
reg tx_data_valid;
//state register
reg [3:0] state;
reg [7:0] str;
reg [31:0] wait_cnt;
reg [7:0] tx_cnt;

always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        wait_cnt<=32'd0;
        tx_data<=8'd0;
        state<=idle;
        tx_data_valid<=1'b0;
        tx_cnt<=8'd0;
    end
    else
    begin
        case (state)
            idle: 
            begin
                state<=sendbyte;
            end
            sendbyte: 
            begin
                wait_cnt<=32'd0;
                tx_data<=str;
                if(tx_data_valid==1'b1 && tx_data_ready==1'b1 && tx_cnt<8'd12)
                begin
                    tx_cnt<=tx_cnt+8'd1;
                end
                else if(tx_data_valid==1'b1 && tx_data_ready==1'b1 )
                begin
                    tx_cnt<=8'd0;
                    state<=waitbyte;
                    tx_data_valid<=1'b0;
                    tx_data<=8'd0;
                end
                else if(tx_data_valid==1'b0)
                begin
                    tx_data_valid<=1'b1;
                end 
            end
            waitbyte: 
            begin
                wait_cnt<=wait_cnt+32'd1;
                if(rx_data_valid==1'b1 )
                begin
                    tx_data_valid<=1'b1;
                    tx_data<=rx_data;
                end
                else if(tx_data_valid==1'b1 && tx_data_ready==1'b1)
                begin
                    tx_data_valid<=1'b0;
                    tx_data<=8'd0;
                end
                else if(wait_cnt>=32'd40000)
                begin
                    state<=idle;
                end
            end
            default: 
            begin
                state<=idle;
            end
        endcase
    end
end

always @(*) begin
    case (tx_cnt)
    0: str<="\n";
    1: str<="H";
    2: str<="e";
    3: str<="l";
    4: str<="l";
    5: str<="o";
    6: str<="W";
    7: str<="o";
    8: str<="r";
    9: str<="l";
    10: str<="d";
    11: str<="!";
    default: str=8'd0;
    endcase
end
endmodule