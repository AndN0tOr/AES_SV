`timescale 1ns/1ps
module AES_tb;

	reg clk , reset, AES_en;
	reg [127:0] in, key;
	wire done;
	wire [127:0] dataOut;
	
	
	AESv2 AES_core(.clk(clk), .reset(reset), .AES_en(AES_en), .in(in), .key(key), .done(done), .dataOut(dataOut));
	 integer test_case;
	 
	 // Tạo xung clock 10ns (100MHz)
    always #5 clk = ~clk;
    
    // Mảng chứa dữ liệu đầu vào và khóa cho 10 trường hợp kiểm tra
    reg [127:0] test_inputs [0:9];
    reg [127:0] test_keys [0:9];
    
    // Mảng chứa kết quả dự kiến cho 10 trường hợp
    reg [127:0] expected_outputs [0:9];
    
    // Kiểm tra kết quả
    task check_result;
        input integer test_num;
        begin
            $display("Test case %0d", test_num);
            $display("Input: %h", test_inputs[test_num]);
            $display("Key: %h", test_keys[test_num]);
            $display("Output: %h", dataOut);
            // Nếu có kết quả dự kiến, hãy so sánh
            // $display("Expected: %h", expected_outputs[test_num]);
            // if (dataOut === expected_outputs[test_num])
            //     $display("PASS");
            // else
            //     $display("FAIL");
            $display("------------------------------");
        end
    endtask
    
    // Thực hiện mã hóa cho một trường hợp
    task run_test_case;
        input integer test_num;
        begin
            // Reset
            reset = 1;
            AES_en = 0;
            @(posedge clk);
            
            // Bắt đầu chu kỳ đầu tiên
            reset = 0;
            AES_en = 1;
            in = test_inputs[test_num];
            key = test_keys[test_num];
            @(posedge clk);
            
            // Chu kỳ thứ hai, giữ dữ liệu đầu vào
            AES_en = 0;
            @(posedge clk);
            
            // Đợi 10 chu kỳ tiếp theo (tổng 12 chu kỳ)
            repeat(10) @(posedge clk);
            
            // Kiểm tra kết quả khi done = 1
            if (done) begin
                check_result(test_num);
            end else begin
                $display("Test case %0d: Done signal not asserted after 12 cycles", test_num);
                // Đợi thêm một số chu kỳ nếu cần
                repeat(5) @(posedge clk);
                if (done) check_result(test_num);
            end
        end
    endtask
    
    // Khởi tạo các giá trị
    initial begin
        // Khởi tạo giá trị cho clock và reset
        clk = 0;
        reset = 0;
        AES_en = 0;
        
        // Trường hợp kiểm tra 1: Plaintext và Key đều là 0
        test_inputs[0] = 128'h00000000000000000000000000000000;
        test_keys[0] = 128'h00000000000000000000000000000000;
        
        // Trường hợp kiểm tra 2: Giá trị từ FIPS-197 (AES Standard)
        test_inputs[1] = 128'h00112233445566778899aabbccddeeff;
        test_keys[1] = 128'h000102030405060708090a0b0c0d0e0f;
        
        // Trường hợp kiểm tra 3: Plaintext là tất cả 1, Key là tất cả 0
        test_inputs[2] = 128'hffffffffffffffffffffffffffffffff;
        test_keys[2] = 128'h00000000000000000000000000000000;
        
        // Trường hợp kiểm tra 4: Plaintext là tất cả 0, Key là tất cả 1
        test_inputs[3] = 128'h00000000000000000000000000000000;
        test_keys[3] = 128'hffffffffffffffffffffffffffffffff;
        
        // Trường hợp kiểm tra 5: Cả hai đều là tất cả 1
        test_inputs[4] = 128'hffffffffffffffffffffffffffffffff;
        test_keys[4] = 128'hffffffffffffffffffffffffffffffff;
        
        // Trường hợp kiểm tra 6: Mẫu thay đổi - 1010...
        test_inputs[5] = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
        test_keys[5] = 128'h55555555555555555555555555555555;
        
        // Trường hợp kiểm tra 7: Các giá trị thực tế
        test_inputs[6] = 128'h3243f6a8885a308d313198a2e0370734;
        test_keys[6] = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        
        // Trường hợp kiểm tra 8: Plaintext và Key giống nhau
        test_inputs[7] = 128'h0123456789abcdef0123456789abcdef;
        test_keys[7] = 128'h0123456789abcdef0123456789abcdef;
        
        // Trường hợp kiểm tra 9: Một byte khác nhau
        test_inputs[8] = 128'h00000000000000000000000000000000;
        test_keys[8] = 128'h00000000000000000000000000000001;
        
        // Trường hợp kiểm tra 10: Một byte khác nhau
        test_inputs[9] = 128'h01000000000000000000000000000000;
        test_keys[9] = 128'h00000000000000000000000000000000;
        
        // Chạy các trường hợp kiểm tra
        for (test_case = 0; test_case < 10; test_case = test_case + 1) begin
            run_test_case(test_case);
        end
        
        // Kết thúc mô phỏng
        #20 $finish;
    end
    
    // Monitor để hiển thị các tín hiệu quan trọng
    initial begin
        $monitor("Time=%0t: AES_en=%b, reset=%b, done=%b", 
                 $time, AES_en, reset, done);
    end
    
endmodule 