module MAC_float(
  	input [31:0]a,b,
    input clk,en,rst,
    output reg[31:0]result
);

wire [31:0]product;
wire [31:0]add_result;

Multiply M0(.a(a),.b(b),.enable(clk&en),.result(product));
Addr A0(.a(product),.b(result),.enable((~clk)&en),.result(add_result));

always @(product)begin
#1
result<=add_result;
end

always @(posedge rst or posedge clk)begin
    if(rst)begin 
    result <= 0;

    end
end


endmodule

module Addr(
    input [31:0]a,b,
    input enable,
    output [31:0]result
);

wire [31:0]smal,big;
wire [23:0]man_small,man_big,man_small2;
//reg [7:0]exp_small,exp_big;
wire [7:0]exp_diff;
  wire [4:0]zero_shift;
  //wire [31:0]add_res;
  wire [23:0]subman;

//reg [23:0]man_small;
wire [24:0]man_sum;
wire [23:0]man_diff;
wire compare,addsub;




assign {compare,smal,big} = a[30:0]<b[30:0]?{1'b1,a,b}:{1'b0,b,a};
    //signs
    
  assign addsub = a[31]^b[31];
    //all zero case add
    assign man_big = {1'b1,big[22:0]};
    assign man_small = {1'b1,smal[22:0]};
    assign exp_diff = big[30:23] - smal[30:23];
    assign man_small2 = man_small>>exp_diff;

    assign man_sum = man_big + man_small2;
  	assign man_diff = man_big - man_small2;
  	//find zero shift
  assign zero_shift = man_diff[23]?5'd0:man_diff[22]?5'd1:man_diff[21]?5'd2:man_diff[20]?5'd3:man_diff[19]?5'd4:man_diff[18]?5'd5:man_diff[17]?5'd6:man_diff[16]?5'd7:man_diff[15]?5'd8:man_diff[14]?5'd9:man_diff[13]?5'd10:man_diff[12]?5'd11:man_diff[11]?5'd12:man_diff[10]?5'd13:man_diff[9]?5'd14:man_diff[8]?5'd15:man_diff[7]?5'd16:man_diff[6]?5'd17:man_diff[5]?5'd18:man_diff[4]?5'd19:man_diff[3]?5'd20:man_diff[2]?5'd21:man_diff[1]?5'd22:man_diff[0]?5'd23:5'd24;
  
  assign subman = man_diff<<zero_shift;
  
  assign result[22:0] = addsub?(subman[22:0]):(man_sum[24]?man_sum[23:1]:man_sum[22:0]);
  assign result[30:23] = addsub?(big[30:23]-zero_shift):(man_sum[24]?(1'b1+big[30:23]):big[30:23]);
  	
    assign result[31] = big[31];


endmodule


//make sepreate variables

module Multiply(
    input [31:0]a,b,
    input enable,
  output  [31:0] result
  
);

 wire [7:0]exp_a;
 wire [7:0]exp_b;
wire [23:0]man_a;
wire [23:0]man_b;
wire [8:0]sum_exp;
wire [8:0]exponent;

wire [47:0]man_product;
  wire [47:0]norm_product;
wire norm;
wire sign;



assign sign = a[31] ^ b[31];

//exponent zero case-> |a=1'b0,man_a
assign man_a = (|a[30:23]) ? {1'b1,a[22:0]} : {1'b0,a[22:0]};
assign man_b = (|b[30:23]) ? {1'b1,b[22:0]} : {1'b0,b[22:0]};
  assign exp_a = {a[30:23]};
  assign exp_b = {b[30:23]};

assign man_product = man_a*man_b;
//rounding?
assign norm = man_product[47] ? 1'b1 : 1'b0;	
assign sum_exp = exp_a + exp_b - 8'd127;

assign exponent = norm?sum_exp+1:sum_exp;

assign norm_product = norm?man_product:man_product<<1;

//overflow/underflow?

  assign result = {sign,exponent[7:0],norm_product[46:24]};



endmodule