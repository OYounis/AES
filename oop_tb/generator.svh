class generator;
milbaox gen_mbx;
event transaction_done;

task run();
repeat(20)begin
    transaction transaction_h = new();
    if(! transaction_h.randomize())
        $display("randomization failed");
    else 
        drv_mbx.put(transaction_h);
        @(transaction_done);
end
endtask
endclass