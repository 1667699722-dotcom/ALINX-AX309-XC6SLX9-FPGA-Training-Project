//uart_rx.v
//UART receiver module
//Author: liuhuachao
//Date: 2024-06-01
//This module receives serial data from the rx_pin input, decodes it according to the UART protocol, and outputs the received data on the rx_data output. The module also generates a rx_data_valid signal to indicate when the received data is valid and ready to be read by the data receiver.
//The module uses a state machine to manage the different stages of the UART reception process, including idle, start bit detection, byte reception, stop bit detection, and data output. The module also includes a double flip-flop to detect the falling edge of the rx_pin input, which indicates the start of a new data frame.
//The module is parameterized to allow for different clock frequencies and baud rates, making it flexible for use in various applications. The cycle parameter is calculated based on the clock frequency and baud rate to ensure accurate timing for the UART reception process.
module uart_rx
#(
    parameter clkfreqence = 50,//clock freqence 50MHz
    parameter baudrate=115200 //baud rate 115200bps
)
(
    input clk,//clock input
    input rst,//reset input
    output reg[7:0] rx_data,//received serial data 
    output reg rx_data_valid,//received data is valid
    input rx_data_ready,//data receiver is ready
    input rx_pin //serial data input
);

localparam cycle =clkfreqence*1000000/baudrate;//calculae the clock cycle

localparam idle =3'd1 ;//state encoding
localparam start =3'd2;//state encoding
localparam recbyte =3'd3 ;//state encoding
localparam stop =3'd4 ;//state encoding
localparam data =3'd5 ;//state encoding

reg [2:0] state;//state register
reg [2:0] nextstate;//next state register
reg rx_d0;//double flip-flop to detect the falling edge of rx_pin
reg rx_d1;//double flip-flop to detect the falling edge of rx_pin
wire rx_negedge;//detect the falling edge of rx_pin
reg [7:0] rx_bits;//register to latch received bits
reg [15:0] cyc_cnt;//cycle counter
reg [2:0] bit_cnt;//bit counter

assign rx_negedge =rx_d1 && ~rx_d0;//detect the falling edge of rx_pin
//double flip-flop to detect the falling edge of rx_pin
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        rx_d0<=1'b0;
        rx_d1<=1'b0;
    end
    else
    begin
        rx_d0<=rx_pin;
        rx_d1<=rx_d0;
    end
end
//state transition
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        state<=idle;
    end
    else
    begin
        state<=nextstate;
    end
end
//next state logic
always @(*) begin
    case(state)
    idle:
    begin
        if(rx_negedge)
        begin
            nextstate<=start;
        end
        else
        begin
            nextstate<=idle;
        end
    end
    start:
    begin
        if(cyc_cnt==cycle-1)
        begin
            nextstate<=recbyte;
        end
        else
        begin
            nextstate<=start;
        end
    end
    recbyte:
    begin
        if(cyc_cnt==cycle-1 && bit_cnt==3'd7)
        begin
            nextstate<=stop; 
        end
        else
        begin
            nextstate<=recbyte;
        end
    end
    stop:
    begin
        if(cyc_cnt==cycle/2-1)
        begin
            nextstate<=data;
        end
        else
        begin
            nextstate<=stop;
        end
    end
    data:
    begin
        if(rx_data_ready)
        begin
            nextstate<=idle;
        end
        else
        begin
            nextstate<=data;
        end
    end
    default:
    begin
        nextstate<=idle;
    end
    endcase    
end
//received data valid logic
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        rx_data_valid<=1'b0;
    end
    else if(state==stop && nextstate!=state)
    begin
        rx_data_valid<=1'b1;
    end
    else if(state==data && rx_data_ready)
    begin
        rx_data_valid<=1'b0;
    end 
end
//latch received data
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        rx_data<=8'b0;
    end
    else if(state==stop && nextstate!=state)
    begin
        rx_data<=rx_bits;//latch data
    end
end
//bit counter logic
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        bit_cnt<=3'b0;
    end
    else if(state==recbyte)
    begin
        if(cyc_cnt==cycle-1)
        begin
            bit_cnt<=bit_cnt+3'b1;
        end
        else
        begin
            bit_cnt<=bit_cnt;
        end
    end
    else
    begin
        bit_cnt<=3'b0;
    end
end
//cycle counter logic
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        cyc_cnt<=16'b0;
    end
    else if((state==recbyte && cyc_cnt==cycle-1) || nextstate!=state)
    begin
        cyc_cnt<=16'b0;
    end
    else
    begin
        cyc_cnt<=cyc_cnt+16'b1;
    end
end
//received serial data bit latch logic
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        rx_bits<=8'b0;
    end
    else if(state==recbyte && cyc_cnt==cycle/2-1)
    begin
        rx_bits[bit_cnt]<=rx_pin;
    end
    else
    begin
        rx_bits<=rx_bits;
    end
end

endmodule