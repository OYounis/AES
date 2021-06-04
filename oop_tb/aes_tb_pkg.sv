package aes_tb_pkg;
 typedef enum bit [2:0] {NOOP, AESENCFULL, AESENC, AESENCLAST, AESKEYGENASSIST, 
        AESDEC, AESDECLAST, AESIMC} opcode;

    typedef bit [0:15][7:0] aes_128;
    typedef bit [0:3][7:0]  aes_32;
    typedef bit [0:3][31:0] key_128;
    typedef bit [0:5][31:0] key_192;
    typedef bit [0:7][31:0] key_256; 
    typedef bit [7:0] aes_byte;
    typedef bit [3:0] aes_nibble;
    typedef bit [1:0] aes_half_nibble;

    
endpackage