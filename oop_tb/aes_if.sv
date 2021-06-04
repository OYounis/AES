interface aes_if;
    bit clk, nrst;
    opcode opcode_i;
    bit start_i;
    bit key_ready_o;
    bit cipher_ready_o;
    bit busy_o;
    aes_128 key_i;
    aes_byte r_con_i;
    aes_128 plain_text_i;
    aes_128 cipher_o;

    initial begin 
        #10 nrst =1;
        forever #10 clk = ~clk;
    end

    task assign_transaction(transaction transaction_h);
        opcode_i     = transaction_h.opcode_i;
        start_i      = transaction_h.start_i;
        key_i        = transaction_h.key_i;
        r_con_i      = transaction_h.r_con_i;
        plain_text_i = transaction_h.plain_text_i;
    endtask
endinterface