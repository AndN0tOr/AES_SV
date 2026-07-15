module AESv2_Avalon(
    input iClk,                
    input iReset,             
    input iChipSelect,         
    input iWrite,              
    input iRead,              
    input [3:0] iAddress,      
    input [31:0] iData,       
    output reg [31:0] oData    
);

    reg [127:0] key;       
    reg [127:0] data_in, out;   
    wire [127:0] data_out;  
    reg aes_en;            
    wire aes_done;             

    AESv2 aes_core(
        .clk(iClk),
        .reset(iReset),
        .AES_en(aes_en),
        .in(data_in),
        .key(key),
        .done(aes_done),
        .dataOut(data_out)  
    );
    // Xử lý việc ghi vào thanh ghi
    always @(posedge iClk or posedge iReset) begin
        if (iReset) begin
            key <= 128'h0;
            data_in <= 128'h0;
            aes_en <= 1'b0;
				out <= 128'b0;
        end
        else 
		  begin if (iChipSelect && iWrite) begin
            case (iAddress)

                4'h0: aes_en <= iData[0];

                4'h1: data_in[127:96] <= iData;
                4'h2: data_in[95:64] <= iData;
                4'h3: data_in[63:32] <= iData;
                4'h4: data_in[31:0] <= iData;

                4'h5: key[127:96] <= iData;
                4'h6: key[95:64] <= iData;
                4'h7: key[63:32] <= iData;
                4'h8: key[31:0] <= iData;

                default: begin
                    // Không làm gì
                end
            endcase
			end
					if(aes_done == 1'b1) out <= data_out;
				end
    end
    // Xử lý việc đọc từ thanh ghi
    always @(*) begin
        if (iChipSelect && iRead) begin
            case (iAddress)

                4'h0: oData <= {30'b0, aes_done, aes_en};

                //Doc gia tri datain
                4'h1: oData <= data_in[127:96];
                4'h2: oData <= data_in[95:64];
                4'h3: oData <= data_in[63:32];
                4'h4: oData <= data_in[31:0];

                //Doc gia tri Key
                4'h5: oData <= key[127:96];
                4'h6: oData <= key[95:64];
                4'h7: oData <= key[63:32];
                4'h8: oData <= key[31:0];

                //Gia tri output
                4'h9: oData <= out[127:96];
                4'hA: oData <= out[95:64];
                4'hB: oData <= out[63:32];
                4'hC: oData <= out[31:0];

                default: oData = 32'h0;
            endcase
        end
        else begin
            oData = 32'h0;
        end
    end
endmodule