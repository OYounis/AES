class driver;
    virtual interface aes_if vif;
    mailbox drv_mbx;
    transaction transaction_h;
    event transaction_done;

    task run();
        forever 
            @(negedge clk);
            drv_mbx.get(transaction_h);
            if (transaction_h.start_i) begin
                vif.assign_transaction(transaction_h);                
            end
            -> transaction_done;
        end
    endtask
endclass