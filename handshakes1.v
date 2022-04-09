module handshakes1
        (
        clk                                                                   ,
        reset                                                                 ,
        valid_i                                                               ,
		  valid_o                                                             	,
        data_i                                                               	,
        data_o                                                                ,
        ready_i		  																			,
        ready_o																					,
		  receiver                                                              
        );
		  

//a) 总线master发出data信号，同时master用valid信号拉高表示data有效；
//b) 总线slave发出ready信号，ready信号拉高表示slave可以接收数据；
//c) 当valid和slave同时为高时，表示data信号从master到slave发送接收成功。
//-----------------------------------------------------------------------------
parameter WIDTH            = 8                                                 ;

//-----------------------------------------------------------------------------


input                      clk                                                 ;
input                      reset                                               ;
input                      valid_i                                             ;
output                     valid_o                                           	 ;
input  [WIDTH-1:0]         data_i                                              ;
output [WIDTH-1:0]         data_o                                            	 ;
input                      ready_i                                           	 ;
output                     ready_o 															 ;
output [WIDTH-1:0]         receiver                                            ;

//-----------------------------------------------------------------------------
//输出的一般用reg 但是本次实验设计目的是对valid+data打拍，因此仅有这两个用reg类型
wire                       clk                                                 ;
wire                       reset                                               ;
wire                       valid_i                                             ;
wire                       ready_i                                             ;
wire   [WIDTH-1:0]         data_i                                              ;
reg                        valid_o                                           	 ;
wire                       ready_o                                              ;
reg    [WIDTH-1:0]         data_o                                              ;
reg    [WIDTH-1:0]         receiver 														 ;
//-----------------------------------------------------------------------------
//打拍用的两个寄存器
reg    [WIDTH-1:0]         reg_fist															 ;
reg    				         reg_second														 ;
//-----------------------------------------------------------------------------
//根据时序图写程序（注意保持原理）（写一个不连续传输数据的系统）


//(由于要求是打一拍，这也就意味着原本的时序问题是ready_i落后于ready_o一个时钟节拍)（因此后面的保持都保持一个时钟节拍）

//??下面是打拍保持电路的编写
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~接收数据的规则
//always @(posedge clk)
//if (reset)  begin data_o <= {WIDTH{1'd0}}; receiver <=  {WIDTH{1'd0}} ; end                                    
//else        receiver <= (ready_i && valid_o) ? data_o : {WIDTH{1'd0}} ;//这里以{WIDTH{1'd0}} 作为无效数据//测试初始化时data_i要附上无效数据

//当前出现的问题是data_o拿不到数据，并且valid_o也拿不到数据，，，也就是打拍出现了问题


always @(posedge clk)
begin

if (reset)  begin data_o <= {WIDTH{1'd0}}; receiver <=  {WIDTH{1'd0}} ; end  
else        receiver <= (ready_i && valid_o) ? data_o :{WIDTH{1'd0}} ;//这里以{WIDTH{1'd0}} 作为无效数据//测试初始化时data_i要附上无效数据
//当满足sender传输条件时，之前data_i给data_o并保持一个周期,之前valid_i给valid_o并保持一个周期//此时刚好与测试中人为指定的ready_i对应上
if(ready_o && valid_i) 
begin  
								reg_fist <= data_i; 
								reg_second <=  valid_i;
						
end
if ( reg_second > valid_i)
				begin
				 valid_o <= reg_second; 
				 data_o <= reg_fist;//完成对valid+data打拍
				 end

//其实ready_i与ready_o无特别必要的联系，，，，ready_i类似时钟的规律信号即可。ready_o只在数据，valid_i都准备好的情况下持续一个时钟周期
//-----------------------------------------------------------------------------

//(***********************************data_i与valid_i保持同步)
//(*********当sender端满足握手条件时，在下面的时钟周期里valid_o始终保持上一个时钟周期valid_i的高电平；数据data_o也是如此)（此操作称为对data+valid打拍）
//(*********上一条操作直到规信号ready_i高电平时得以输出)
///////////////特别注意这里的data_o并非最终的输出，，，最终过的输出是 ready_i与valid_o与data_o共同作用下的输出结果

//进行测试编程时:clk，valid_i,data_i自行满足时序要求，ready_i正好与之错开一个时钟周期，valid_i也可以是时钟周期类似的输入
//(测试)ready_o比ready_i超前一个时钟周期



end

assign  ready_o = ~ready_i ;


endmodule