//https://www.runoob.com/w3cnote/verilog-fir.html
//�����վ�Ĵ���

/***********************************************************
>> V201001 : Fs��50Mhz, fstop��1Mhz-6Mhz, order�� 15
************************************************************/
`define SAFE_DESIGN
 
module fir_guide    (
    input                rstn,  //��λ������Ч
    input                clk,   //����Ƶ�ʣ�������Ƶ��
    input                en,    //����������Ч�ź�
    input        [11:0]  xin,   //������Ƶ�ʵ��ź�����
    output               valid, //���������Ч�ź�
    output       [28:0]  yout   //������ݣ���Ƶ�źţ���250KHz
    );
 
    //data en delay 
    reg [3:0]            en_r ;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            en_r[3:0]      <= 'b0 ;
        end
        else begin
            en_r[3:0]      <= {en_r[2:0], en} ;
        end
    end
 
   //(1) 16 ����λ�Ĵ���
    reg        [11:0]    xin_reg[15:0];
    reg [3:0]            i, j ;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i=0; i<15; i=i+1) begin
                xin_reg[i]  <= 12'b0;
            end
        end
        else if (en) begin
            xin_reg[0] <= xin ;
            for (j=0; j<15; j=j+1) begin
                xin_reg[j+1] <= xin_reg[j] ; //��������λ����
            end
        end
    end
 
   //Only 8 multipliers needed because of the symmetry of FIR filter coefficient
   //(2) ϵ���Գƣ�16����λ�Ĵ������ݽ�����λ���
	//Error 1:ӦΪreg        [12:0]    add_reg[7:0];
    reg        [9:0]    add_reg[7:0];
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i=0; i<8; i=i+1) begin
                add_reg[i] <= 13'd0 ;
            end
        end
        else if (en_r[0]) begin
            for (i=0; i<8; i=i+1) begin
				//Error 2: ӦΪadd_reg[i] <= xin_reg[i] + xin_reg[15-i] ;
                add_reg[i] <= xin_reg[i] + xin_reg[10-i] ;
            end
        end
    end
 
    //(3) 8���˷���
    // �˲���ϵ�����Ѿ���һ�������ķŴ�
    wire        [11:0]   coe[7:0] ;
    assign coe[0]        = 12'd11 ;
    assign coe[1]        = 12'd31 ;
    assign coe[2]        = 12'd63 ;
    assign coe[3]        = 12'd104 ;
    assign coe[4]        = 12'd152 ;
    assign coe[5]        = 12'd198 ;
    assign coe[6]        = 12'd235 ;
    assign coe[7]        = 12'd255 ;
    reg        [24:0]   mout[7:0]; 
 
`ifdef SAFE_DESIGN
    //��ˮ��ʽ�˷���
    wire [7:0]          valid_mult ;
    genvar              k ;
    generate
        for (k=0; k<8; k=k+1) begin
            mult_man #(13, 12)
            u_mult_paral          (
              .clk        (clk),
              .rstn       (rstn),
              .data_rdy   (en_r[1]),
              .mult1      (add_reg[k]),
              .mult2      (coe[k]),
              .res_rdy    (valid_mult[k]), //�������ʹ����ȫһ��  
              .res        (mout[k])
            );
        end
    endgenerate
    wire valid_mult7     = valid_mult[7] ;
 
`else
    //�����ʱ��Ҫ�󲻸ߣ�����ֱ���ó˺�
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i=0 ; i<8; i=i+1) begin
                mout[i]     <= 25'b0 ;
            end
        end
        else if (en_r[1]) begin
            for (i=0 ; i<8; i=i+1) begin
                mout[i]     <= coe[i] * add_reg[i] ;
            end
        end
    end
    wire valid_mult7 = en_r[2];
`endif
 
    //(4) �����ۼӣ�8��25bit���� -> 1�� 29bit ����
    //������Ч��ʱ
    reg [3:0]            valid_mult_r ;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            valid_mult_r[3:0]  <= 'b0 ;
        end
        else begin
            valid_mult_r[3:0]  <= {valid_mult_r[2:0], valid_mult7} ;
        end
    end

`ifdef SAFE_DESIGN
    //�ӷ�����ʱ���ֶ�����ڽ�����ˮ���Ż�ʱ��
    reg        [28:0]    sum1 ;
    reg        [28:0]    sum2 ;
    reg        [28:0]    yout_t ;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sum1   <= 29'd0 ;
            sum2   <= 29'd0 ;
            yout_t <= 29'd0 ;
        end
        else if(valid_mult7) begin
            sum1   <= mout[0] + mout[1] + mout[2] + mout[3] ;
            sum2   <= mout[4] + mout[5] + mout[6] + mout[7] ;
            yout_t <= sum1 + sum2 ;
        end
    end
 
`else 
    //һ�������ۼӽ��������ʵ����ʱ��ǳ�Σ��
    reg signed [28:0]    sum ;
    reg signed [28:0]    yout_t ;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sum    <= 29'd0 ;
            yout_t <= 29'd0 ;
        end
        else if (valid_mult7) begin
            sum    <= mout[0] + mout[1] + mout[2] + mout[3] + mout[4] + mout[5] + mout[6] + mout[7];
            yout_t <= sum ;
        end
    end 
`endif
    assign yout  = yout_t ;
    assign valid = valid_mult_r[0];

endmodule