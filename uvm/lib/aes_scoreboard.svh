//`include "uvm_macros.svh"
//`include "seq item.sv"
//`include "fill.sv"
//import uvm_pkg::*;
class aes_scoreboard extends uvm_subscriber #(aes_transaction);
   `uvm_component_utils(aes_scoreboard);
    fill f;

        uvm_analysis_export #(aes_transaction) export_before;
	uvm_analysis_export#(aes_transaction) export_after;

	uvm_tlm_analysis_fifo #(aes_transaction) before_fifo;
	uvm_tlm_analysis_fifo #(aes_transaction) after_fifo;
        aes_transaction transaction_before;
	aes_transaction transaction_after;
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);

	export_before	= new("export_before", this);
	export_after	= new("export_after", this);

    	before_fifo = new ("before_fifo", this);
    	after_fifo = new ("after_fifo", this);
   endfunction : build_phase

    function void connect_phase(uvm_phase phase);
	export_before.connect(before_fifo.analysis_export);
	export_after.connect(after_fifo.analysis_export);
    endfunction:connect_phase

   parameter N=127;
  // bit[127:0] ct_mc[99:0],pt_mc[99:0],k_mc[99:0];
//   bit[127:0] ct_mm[9:0],pt_mm[9:0],k_mm[9:0];
   //function to scan the test vectors
	function void read_file(string location,bit[127:0] ct[int],pt[int],k[int]);
      int c,fd,m;
      fd = $fopen(location,"r");
       while(!$feof(fd))
         begin
          m=$fscanf(fd,"COUNT = %d\n",c);
          m=$fscanf(fd,"KEY = %h\n",k[c]);
          m=$fscanf(fd,"PLAINTEXT = %h\n",pt[c]);
          m=$fscanf(fd,"CIPHERTEXT = %h\n\n",ct[c]);
         $display(" %d\n %h\n %h\n %h",c,k[c],pt[c],ct[c]);
         end
   endfunction
	function void read_file_mmt(string location,bit[1279:0] ct[int], pt[int],bit[127:0] k[int],int i[9:0]);
      int c,fd,m;
	c=0;	
      fd = $fopen(location,"r");
       while(!$feof(fd))
         begin
		 m=$fscanf(fd,"COUNT = %d\n",i[c]);
          m=$fscanf(fd,"KEY = %h\n",k[c]);
          m=$fscanf(fd,"PLAINTEXT = %h\n",pt[c]);
          m=$fscanf(fd,"CIPHERTEXT = %h\n\n",ct[c]);
         $display(" %d\n %h\n %h\n %h",c,k[c],pt[c],ct[c]);
	c++;	 
         end
   endfunction
//function to extract the result from the test vectors
	function  predict_result(aes_transaction cmd, bit[127:0] predicted);
   bit[127:0] ct_kat[int];
   bit[127:0]k_kat[int];
   bit[127:0]pt_kat[int];
   bit[127:0] ct_mc[int];
   bit[127:0]k_mc[int];
   bit[127:0]pt_mc[int];
   bit[1279:0] ct_mmt[int];
   bit[127:0] k_mmt[int];
   bit[1279:0] pt_mmt[int];
   int l[9:0];
   int s [$];
   int w [$];
   int a [$];
   int b [$];
     fill();
      if(cmd.opcode_i==AESENCFULL)
    begin
    if(cmd.key_i==0)
    read_file("ECBVarTxt128.txt",ct_kat,pt_kat,k_kat);
    a= pt_kat.find_index with (item==cmd.plain_text_i);
    predicted=ct_kat[a];
	 else if(cmd.plain_text_i==0)
    read_file("ECBVarKey128.txt",ct_kat,pt_kat,k_kat);
    b= pt_kat.find_index with (item==cmd.key_i);
    predicted=ct_kat[b];
      end
       else
       begin
	   read_file("ECBMCT128.txt",ct_mc,pt_mc,k_mc);
         s= pt_mc.find_index with (item==cmd.plain_text_i);
         w= k_mc.find_index with (item==cmd.key_i);   
	 if(pt_mc.exists(s)&&k_mc.exists(w))
	  begin
          predicted=ct_mc[s];
	  end
       end 
          else begin	
	       read_file_mmt("ECBMMT128.txt",ct_mmt,pt_mmt,k_mmt,l);
               for (int i =0;i<10;i++ ) begin
                  if (cmd.plain_text_i==pt_mmt[i][127:0]&&cmd.key_i==k_mmt)
                   begin
                  for (int j =0; j<l[i]+1; j++ ) begin
                    
                     if (j==0) begin
                        predicted=ct_mmt[l[i]][127:0];   
                     end
                     if (j==1) begin
                        predicted_=ct_mmt[l[i]][255:128];   
                     end
                     if (j==2) begin
                        predicted=ct_mmt[l[i]][383:256];   
                     end
                     if (j==3) begin
                        predicted=ct_mmt[l[i]][511:384];   
                     end
                     if (j==4) begin
                        predicted=ct_mmt[l[i]][639:512];   
                     end
                     if (j==5) begin
                        predicted=ct_mmt[l[i]][767:640];   
                     end
                     if (j==6) begin
                        predicted=ct_mmt[l[i]][895:768];   
                     end
                     if (j==7) begin
                        predicted=ct_mmt[l[i]][1023:896];   
                     end
                     if (j==8) begin
                        predicted=ct_mmt[l[i]][1151:1024];   
                     end
                     if (j==9) begin
                        predicted=ct_mmt[l[i]][1279:1152];   
                     end
                  end 
                  end
               
               end
       end
	 
	 end
   end 
end
else
	`uvm_fatal("GET CMD ","failed to get CMD");

endfunction : predict_result
 
 virtual function  compare(aes_transaction kmd,bit[127:0] predicted);
		if(kmd.cipher_o== predicted) begin
         
			`uvm_info("compare", {"Test: OK!"}, UVM_LOW);
			
		end else begin
         
			`uvm_error("compare", {"Test: Fail!"});
			
		end
	endfunction: compare


	task run();
		bit[127:0] predicted
		fork
		begin
		forever begin
			before_fifo.get(transaction_before);
			after_fifo.get(transaction_after);
			out=predict_result(transaction_after);
		        end
		end//thread 1
		begin
			forever begin	
			compare(transaction_before, out);
			 end
		end//thread2
		join_none	
	endtask: run

  virtual function void write(aes_transaction t );
		`uvm_info("write",$sformatf("data received=0x%0h",t),UVM_MEDIUM)
	endfunction:write

  endclass : aes_scoreboard
