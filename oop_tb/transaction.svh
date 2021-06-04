class transcation;
    rand opcode opcode_i;
    rand bit start_i;
    bit key_ready_o;
    bit cipher_ready_o;
    bit busy_o;
    rand aes_128 key_i;
    rand aes_byte r_con_i;
    rand aes_128 plain_text_i;
    aes_128 cipher_o;
  
endclass