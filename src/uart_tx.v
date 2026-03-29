//uart_tx.v
//UART transmitter module
//Author: liuhuachao
//Date: 2024-06-01
//This module takes parallel data from the tx_data input, encodes it according to the UART
//protocol, and transmits it serially on the tx_pin output. The module also generates a tx_data_ready signal to indicate when the transmitter is ready to accept new data for transmission.
//The module uses a state machine to manage the different stages of the UART transmission process, including
module uart_tx
#(
    parameter clkfreqence = 50,//clock freqence 50MHz
    parameter baudrate=115200 //baud rate 115200bps
)
(
    input clk,//clock input
    input rst,//reset input
    input [7:0] tx_data,//data to be transmitted
    input tx_data_valid,//data to be transmitted is valid
    output reg tx_data_ready,//data transmitter is ready
    output  tx_pin //serial data output
); 

localparam cycle =clkfreqence*1000000/baudrate;//calculae the clock cycle

localparam idle =3'd1 ;//state encoding
localparam start =3'd2;//state encoding
localparam sendbyte =3'd3 ;//state encoding
localparam stop =3'd4 ;//state encoding

reg [2:0] state;//state register
reg [2:0] nextstate;//next state register
reg [7:0] tx_bits;//register to latch bits to be transmitted
reg [15:0] cyc_cnt;//cycle counter
reg [2:0] bit_cnt;//bit counter 
reg  tx_reg;//register to hold the value of tx_pin

assign tx_pin = tx_reg;//assign tx_reg to tx_pin

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
        if(tx_data_valid)
        begin
            nextstate = start;
        end
        else
        begin
            nextstate = idle;
        end
    end
    start:
    begin
        if(cyc_cnt==cycle-1)
        begin
            nextstate = sendbyte;
        end
        else
        begin
            nextstate = start;
        end
    end
    sendbyte:
    begin
        if(cyc_cnt==cycle-1 && bit_cnt==3'd7)
        begin
            nextstate = stop;
        end
        else
        begin
            nextstate = sendbyte;
        end
    end
    stop:
    begin
        if(cyc_cnt==cycle-1)
        begin
            nextstate = idle;
        end
        else
        begin
            nextstate = stop;
        end
    end
    default:
    begin
        nextstate = idle;
    end
    endcase
end
//output tx_data_ready logic
always @(posedge clk or negedge rst) begin 
    if(rst==1'b0)
    begin
        tx_data_ready<=1'b0;
    end
    else if(state==idle)
    begin
        if(tx_data_valid)
        begin
            tx_data_ready<=1'b0;
        end
        else
        begin
            tx_data_ready<=1'b1;
        end
    end
    else if(state==stop && cyc_cnt==cycle-1)
    begin
        tx_data_ready<=1'b1;
    end
end
//latch data to be transmitted
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        tx_bits<=8'd0;
    end
    else if(state==idle && tx_data_valid)
    begin
        tx_bits<=tx_data;
    end
    end
//bit_cnt 
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        bit_cnt<=3'd0;
    end
    else if(state==sendbyte)
    begin
        if(cyc_cnt==cycle-1)
        begin
            bit_cnt<=bit_cnt+3'd1;
        end
        else
        begin
            bit_cnt<=bit_cnt; 
        end
    end
    else
    begin
        bit_cnt<=3'd0;
    end
end
//cycle counter logic
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        cyc_cnt<=16'b0;
    end
    else if(state==sendbyte && cyc_cnt==cycle-1 || nextstate!=state)
    begin
        cyc_cnt<=16'b0;
    end
    else
    begin
        cyc_cnt<=cyc_cnt+16'b1;
    end
end
//tx_reg logic
always @(posedge clk or negedge rst) begin
    if(rst==1'b0)
    begin
        tx_reg<=1'b1;//idle state, tx_pin is high
    end
    else 
    begin
        case(state)
        idle:
        begin
            tx_reg<=1'b1;//idle state, tx_pin is high
        end
        start:
        begin
            tx_reg<=1'b0;//start bit, tx_pin is low
        end
        sendbyte:
        begin
            tx_reg<=tx_bits[bit_cnt];//data bits, tx_pin is the current bit
        end
        stop:
        begin
            tx_reg<=1'b1;//stop bit, tx_pin is high
        end
        default:
        begin
            tx_reg<=1'b1;//default state, tx_pin is high    
        end
        endcase
    end
end

endmodule

