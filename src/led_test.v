module led_test (clk,rst_n,led);
input clk,rst_n;
output reg [3:0] led;
reg [7:0] timer;
always @(posedge clk or negedge rst_n)
begin
if(rst_n==1'b0)
timer<=8'd0;
else if (timer==8'd199)
timer<=8'd0;
else
timer<=timer+8'd1;
end

always @(posedge clk or negedge rst_n)
begin
if(rst_n==1'b0)
led<=4'b0000;
else if(timer==8'd49)
led<=4'b0001;
else if(timer==8'd99)
led<=4'b0010;
else if(timer==8'd149)
led<=4'b0100;
else if(timer==8'd199)
led<=4'b1000;
end

endmodule