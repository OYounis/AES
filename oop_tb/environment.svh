class environment;
    driver driver_h;
    generator generator_h;
    mailbox driver_to_generator_mbx;

    function build();
        driver_h = new();
        generator_h = new();

        driver_to_agent_mbx = new(1);

        /*
        
        
        */
    endfunction

    function connect();
        driver_h.drv_mbx = driver_to_generator_mbx;
        generator_h.gen_mbx = driver_to_generator_mbx;
    endfunction

    task run();
        fork 
        driver_h.run();
        generator_h.run();
        /*
        
        
        */
        join_any
        $finish;
    endtask
endclass