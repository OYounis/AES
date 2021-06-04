class generator;
mailbox drv_mbx;

task run();
repeat(20)begin
    transaction transaction_h = new();
    if(! transaction_h.randomize())
        $display("randomization failed");
    else 
        drv_mbx.put(transaction_h);
end
endtask
endclass