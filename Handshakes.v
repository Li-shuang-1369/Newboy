module Handshakes
        (
        CLK                                                                     ,
        RESET                                                                   ,
        VALID_UP                                                                ,
        READY_UP                                                                ,
        DATA_UP                                                                 ,
        VALID_DOWN                                                              ,
        READY_DOWN                                                              ,
        DATA_DOWN
        );
		  


//-----------------------------------------------------------------------------
parameter WIDTH            = 8                                                 ;

//-----------------------------------------------------------------------------
input                      CLK                                                  ;
input                      RESET                                                ;
input                      VALID_UP                                             ;
output                     READY_UP                                             ;
input  [WIDTH-1:0]         DATA_UP                                              ;
output                     VALID_DOWN                                           ;
input                      READY_DOWN                                           ;
output [WIDTH-1:0]         DATA_DOWN                                            ;

//-----------------------------------------------------------------------------
wire                       CLK                                                  ;
wire                       RESET                                                ;
wire                       VALID_UP                                             ;
wire                       READY_UP                                             ;
wire   [WIDTH-1:0]         DATA_UP                                              ;
//Down Stream
reg                        VALID_DOWN                                           ;
wire                       READY_DOWN                                           ;
reg    [WIDTH-1:0]         DATA_DOWN                                            ;

//-----------------------------------------------------------------------------
//Valid
always @(posedge CLK)//当时钟上升沿到来时//当复位键置1时，slave接收到的valid置0 
if (RESET)  VALID_DOWN <= 1'b0                                                  ;                                                
else        VALID_DOWN <= READY_UP ? VALID_UP : VALID_DOWN                      ;
//当slave向master回馈ready_up=1时 salve接收到的valID_DOWN置1：说明此时传输数据有效
//综上RESET置0时是正常工作状态//VALID_UP由master控制


//Data
always @(posedge CLK)
if (RESET)  DATA_DOWN <= {WIDTH{1'd0}}                                          ;//当复位键置1时，接收端数据统统清0                                       
else        DATA_DOWN <= (READY_UP && VALID_UP) ? DATA_UP : DATA_DOWN           ;//在正常工作时，如果符合握手协议，就将数据进行传送，否则接收端保持原来的数值

//assign READY_UP = READY_DOWN || ~VALID_DOWN                                     ;//READY_UP是怎么决定出来的（这里的字面意思是当外部输入reaDY_DOWN=1）

assign READY_UP = READY_DOWN                                                  ;//或者发送准备位等于0

endmodule

 
