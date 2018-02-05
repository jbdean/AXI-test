library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.safeop_serial_pkg.all;

entity testbench is
generic
(
  C_S_AXI_DATA_WIDTH             : integer              := 32;
  C_S_AXI_ADDR_WIDTH             : integer              := 8
);

end testbench;

architecture Behavioral of testbench is
    
    signal S_AXI_ACLK                     :  std_logic;
    signal S_AXI_ARESETN                  :  std_logic;
    signal S_AXI_AWADDR                   :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal S_AXI_AWVALID                  :  std_logic;
    signal S_AXI_WDATA                    :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal S_AXI_WSTRB                    :  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    signal S_AXI_WVALID                   :  std_logic;
    signal S_AXI_BREADY                   :  std_logic;
    signal S_AXI_ARADDR                   :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal S_AXI_ARVALID                  :  std_logic;
    signal S_AXI_RREADY                   :  std_logic;
    signal S_AXI_ARREADY                  : std_logic;
    signal S_AXI_RDATA                    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal S_AXI_RRESP                    : std_logic_vector(1 downto 0);
    signal S_AXI_RVALID                   : std_logic;
    signal S_AXI_WREADY                   : std_logic;
    signal S_AXI_BRESP                    : std_logic_vector(1 downto 0);
    signal S_AXI_BVALID                   : std_logic;
    signal S_AXI_AWREADY                  : std_logic;
    signal S_AXI_AWPROT                   : std_logic_vector(2 downto 0);
    signal S_AXI_ARPROT                   : std_logic_vector(2 downto 0);

	signal i_rmii_crs_dv_net0			:	std_logic;
	signal i_rmii_rxd_net0				:	std_logic;
	signal o_rmii_tx_en_net0			:	std_logic;
	signal o_rmii_txd_net0				:	std_logic;
	signal i_ingress_ser_link_ok_net0	:	std_logic;
	signal i_latched_bel_status_net0	:	std_logic;
	signal i_latched_mel_status_net0	:	std_logic;
	signal i_bel_in_cable_ok_net0		:	std_logic;
	signal i_mel_in_cable_ok_net0		:	std_logic;
	signal i_subsys_enable_net0			:	std_logic;
	signal i_fpga_config_ok_net0		:	std_logic;
	signal i_pwr_off_req_net0			:	std_logic;
	signal o_clear_bel_status_net0		:	std_logic;
	signal o_clear_mel_status_net0		:	std_logic;
	signal o_subsys_critical_fault_net0	:	std_logic;
	signal o_pwr_off_ack_net0			:	std_logic;
	signal o_heartbeat_net0				:	std_logic;

	-- Users to add ports here
	signal o_AC_EN_PRI_CH_BUS :  STD_LOGIC_VECTOR (4 downto 0);
	signal o_AC_EN_SEC_CH_BUS :  STD_LOGIC_VECTOR (4 downto 0);
			
		    --signal from the SafeOp PCA
	signal i_SAFEOP_HB           :  STD_LOGIC;
	signal i_LATCHED_MEL_FAULT_n :  STD_LOGIC;
	signal i_LATCHED_BEL_FAULT_n :  STD_LOGIC;
	signal i_SUBSYS_ENABLE       :  STD_LOGIC;
	signal i_PWR_OFF_REQ         :  STD_LOGIC;
	signal i_BEL_IN_24V_PRSNT    :  STD_LOGIC; 
	signal i_MEL_IN_24V_PRSNT    :  STD_LOGIC; 
	signal i_INGR_SER_LINK_OK        :  STD_LOGIC;                 
		
		    --RMII signal from the SafeOp PCA
	signal i_RMII_CRS_DV    :  STD_LOGIC;
	signal i_RMII_RXD       :  STD_LOGIC_VECTOR(1 downto 0);              
		              
		    -- RMII signal to the SafeOp PCA
	signal o_RMII_REF_CLK :  STD_LOGIC;
	signal o_RMII_TX_EN   :  STD_LOGIC;
	signal o_RMII_TXD     :  STD_LOGIC_VECTOR(1 downto 0);
		      
		    -- signal to the SafeOp PCA
	signal o_CONTROLLER_HB       :  STD_LOGIC;
	signal o_CLR_MEL_FAULT       :  STD_LOGIC;
	signal o_CLR_BEL_FAULT       :  STD_LOGIC;
	signal o_MEL_IMPACT          :  STD_LOGIC;
	signal o_BEL_IMPACT          :  STD_LOGIC;
	signal o_SUBSYS_CRIT_FAULT_n :  STD_LOGIC;
	
    
    Constant ClockPeriod : TIME := 20 ns;
    Constant ClockPeriod2 : TIME := 40 ns;
    shared variable ClockCount : integer range 0 to 50_000 := 10;
    signal sendIt : std_logic := '0';
    signal readIt : std_logic := '0';

begin

 i_RMII_RXD 	<= o_RMII_TXD;
 i_RMII_CRS_DV 	<= o_RMII_TX_EN;
 
-- Instantiation of dut
rm_PwrMgmt_SafeOp_Interface_v1_0_S00_AXI_inst : 
	entity work.rm_PwrMgmt_SafeOp_Interface_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_ADDR_WIDTH
	)
	port map (
	
	o_AC_EN_PRI_CH_BUS => o_AC_EN_PRI_CH_BUS ,
    o_AC_EN_SEC_CH_BUS => o_AC_EN_SEC_CH_BUS,
  
    --signal from the SafeOp PCA
    i_SAFEOP_HB           => i_SAFEOP_HB,
    i_LATCHED_MEL_FAULT_n => i_LATCHED_MEL_FAULT_n,
    i_LATCHED_BEL_FAULT_n => i_LATCHED_BEL_FAULT_n,
    i_SUBSYS_ENABLE       => i_SUBSYS_ENABLE,
    i_PWR_OFF_REQ         => i_PWR_OFF_REQ,
    i_BEL_in_24V_PRSNT    => i_BEL_in_24V_PRSNT,
    i_MEL_in_24V_PRSNT    => i_MEL_in_24V_PRSNT,
    i_INGR_SER_LINK_OK    => i_INGR_SER_LINK_OK,

    --RMII signal from the SafeOp PCA
    i_RMII_CRS_DV    => i_RMII_CRS_DV,
    i_RMII_RXD       => i_RMII_RXD,
              
    -- RMII signal to the SafeOp PCA
    o_RMII_REF_CLK => o_RMII_REF_CLK,
    o_RMII_TX_EN   => o_RMII_TX_EN,
    o_RMII_TXD     => o_RMII_TXD,
      
    -- signal to the SafeOp PCA
    o_CONTROLLER_HB    		=> o_CONTROLLER_HB,
    o_CLR_MEL_FAULT    		=> o_CLR_MEL_FAULT,
    o_CLR_BEL_FAULT    		=> o_CLR_BEL_FAULT,
    o_MEL_IMPACT       		=> o_MEL_IMPACT,
    o_BEL_IMPACT       		=> o_BEL_IMPACT,
    o_SUBSYS_CRIT_FAULT_n 	=> o_SUBSYS_CRIT_FAULT_n,	
	
	S_AXI_ACLK		=>	S_AXI_ACLK,
	S_AXI_ARESETN	=>	S_AXI_ARESETN,
	S_AXI_AWADDR	=>	S_AXI_AWADDR,
	S_AXI_AWPROT	=>	S_AXI_AWPROT,
	S_AXI_AWVALID	=>	S_AXI_AWVALID,
	S_AXI_AWREADY	=>	S_AXI_AWREADY,
	S_AXI_WDATA		=>	S_AXI_WDATA,
	S_AXI_WSTRB		=>	S_AXI_WSTRB,
	S_AXI_WVALID	=>	S_AXI_WVALID,
	S_AXI_WREADY	=>	S_AXI_WREADY,
	S_AXI_BRESP		=>	S_AXI_BRESP,
	S_AXI_BVALID	=>	S_AXI_BVALID,
	S_AXI_BREADY	=>	S_AXI_BREADY,
	S_AXI_ARADDR	=>	S_AXI_ARADDR,
	S_AXI_ARPROT	=>	S_AXI_ARPROT,
	S_AXI_ARVALID	=>	S_AXI_ARVALID,
	S_AXI_ARREADY	=>	S_AXI_ARREADY,
	S_AXI_RDATA		=>	S_AXI_RDATA,
	S_AXI_RRESP		=>	S_AXI_RRESP,
	S_AXI_RVALID	=>	S_AXI_RVALID,
	S_AXI_RREADY	=>	S_AXI_RREADY
	
	);

 -- Generate S_AXI_ACLK signal
 GENERATE_REFCLOCK : process
 begin
	S_AXI_ACLK <= '0';
   wait for (ClockPeriod / 2);
   ClockCount:= ClockCount+1;
   S_AXI_ACLK <= '1';
   wait for (ClockPeriod / 2);
   S_AXI_ACLK <= '0';
 end process;

 -- Initiate process which simulates a master wanting to write.
 -- This process is blocked on a "Send Flag" (sendIt).
 -- When the flag goes to 1, the process exits the wait state and
 -- execute a write transaction.
 send : process
 begin
    S_AXI_AWVALID	<='0';
    S_AXI_WVALID	<='0';
    S_AXI_BREADY	<='0';
	S_AXI_AWPROT	<=	b"000";
	
    loop
        wait until sendIt 		= '1';
        wait until S_AXI_ACLK	= '0';
            S_AXI_AWVALID		<='1';
            S_AXI_WVALID		<='1';
        wait until (S_AXI_AWREADY and S_AXI_WREADY) = '1';  --Client ready to read address/data        
            S_AXI_BREADY		<='1';
        wait until S_AXI_BVALID = '1';  -- Write result valid
            assert S_AXI_BRESP = "00" report "AXI data not written" severity failure;
            S_AXI_AWVALID		<='0';
            S_AXI_WVALID		<='0';
            S_AXI_BREADY		<='1';
        wait until S_AXI_BVALID = '0';  -- All finished
            S_AXI_BREADY		<='0';
    end loop;
 end process send;

  -- Initiate process which simulates a master wanting to read.
  -- This process is blocked on a "Read Flag" (readIt).
  -- When the flag goes to 1, the process exits the wait state and
  -- execute a read transaction.
  read : process
  begin
    S_AXI_ARVALID		<='0';
    S_AXI_RREADY		<='0';
	S_AXI_ARPROT		<=	b"000";
     loop
         wait until readIt 		= 	'1';
         wait until S_AXI_ACLK	= 	'0';
             S_AXI_ARVALID		<=	'1';
             S_AXI_RREADY		<=	'1';
         wait until (S_AXI_RVALID ) = '1'; 
		 wait until (S_AXI_ARREADY) = '1';  --Client provided data
            assert S_AXI_RRESP = "00" report "AXI data not written" severity failure;
            S_AXI_ARVALID		<=	'0';
            S_AXI_RREADY		<=	'0';
     end loop;
  end process read;


 -- address':
 -- slv_reg8	0x20
 -- slv_reg9	0x24
 -- slv_reg10	0x28
 -- slv_reg11	0x2c

 tb : process
 begin
        S_AXI_AWADDR	<=x"00";
        S_AXI_WDATA		<=x"00000000";
        S_AXI_WSTRB		<=b"0000";

		S_AXI_ARESETN		<='1';
    wait for 50 ns;
        S_AXI_ARESETN		<='0';
        sendIt				<='0';
    wait for 150 ns;
        S_AXI_ARESETN		<='1';
    wait for 150 ns;

		S_AXI_WSTRB		<=b"0000";
            
        S_AXI_AWADDR	<=x"24";
        S_AXI_WDATA		<=x"00000301";
        S_AXI_WSTRB		<=b"1111";
        sendIt			<='1';          --Start AXI Write to Slave
        wait for 1 ns; 
		sendIt		<='0'; 				--Clear Start Send Flag
    wait until S_AXI_BVALID = '1';
    wait until S_AXI_BVALID = '0';  	--AXI Write finished

        S_AXI_AWADDR	<=x"20";
        S_AXI_WDATA		<=x"00000020";
        S_AXI_WSTRB		<=b"1111";
        sendIt			<='1';          --Start AXI Write to Slave
        wait for 1 ns; 
		sendIt			<='0'; 			--Clear Start Send Flag
    wait until S_AXI_BVALID = '1';
    wait until S_AXI_BVALID = '0';		--AXI Write finished
	
        S_AXI_AWADDR	<=x"20";
        S_AXI_WDATA		<=x"00000021";
        S_AXI_WSTRB		<=b"1111";
        sendIt			<='1';          --Start AXI Write to Slave
        wait for 1 ns; 
		sendIt			<='0'; 			--Clear Start Send Flag
    wait until S_AXI_BVALID = '1';
    wait until S_AXI_BVALID = '0';		--AXI Write finished
	
        S_AXI_ARADDR	<=x"20";
        readIt			<='1';			--Start AXI Read from Slave
        wait for 1 ns; 
		readIt			<='0'; 			--Clear "Start Read" Flag
    wait until S_AXI_RVALID = '1';
    wait until S_AXI_RVALID = '0';

		S_AXI_WSTRB		<=b"0000";
            
        S_AXI_AWADDR	<=x"24";
        S_AXI_WDATA		<=x"00000024";
        S_AXI_WSTRB		<=b"1111";
        sendIt			<='1';          --Start AXI Write to Slave
        wait for 1 ns; 
		sendIt		<='0'; 				--Clear Start Send Flag
    wait until S_AXI_BVALID = '1';
    wait until S_AXI_BVALID = '0';  	--AXI Write finished

		S_AXI_ARADDR	<=x"24";
        readIt			<='1';			--Start AXI Read from Slave
        wait for 1 ns; 
		readIt			<='0'; 			--Clear "Start Read" Flag
    wait until S_AXI_RVALID = '1';
    wait until S_AXI_RVALID = '0';

		S_AXI_WSTRB		<=b"0000";
        
        S_AXI_AWADDR	<=x"28";
        S_AXI_WDATA		<=x"00000028";
        S_AXI_WSTRB		<=b"1111";
        sendIt			<='1';          --Start AXI Write to Slave
        wait for 1 ns; 
		sendIt		<='0'; 				--Clear Start Send Flag
    wait until S_AXI_BVALID = '1';
    wait until S_AXI_BVALID = '0';  	--AXI Write finished
	
		S_AXI_ARADDR	<=x"28";
        readIt			<='1';			--Start AXI Read from Slave
        wait for 1 ns; 
		readIt			<='0'; 			--Clear "Start Read" Flag
    wait until S_AXI_RVALID = '1';
    wait until S_AXI_RVALID = '0';
	
        S_AXI_WSTRB		<=b"0000";
        
        S_AXI_AWADDR	<=x"2c";
        S_AXI_WDATA		<=x"0000002C";
        S_AXI_WSTRB		<=b"1111";
        sendIt			<='1';			--Start AXI Write to Slave
        wait for 1 ns; 
		sendIt		<='0'; 				--Clear Start Send Flag
    wait until S_AXI_BVALID = '1';
    wait until S_AXI_BVALID = '0';  	--AXI Write finished
	
        S_AXI_WSTRB		<=b"0000";
        
        S_AXI_ARADDR	<=x"28";
        readIt			<='1';			--Start AXI Read from Slave
        wait for 1 ns; 
		readIt		<='0'; 				--Clear "Start Read" Flag
    wait until S_AXI_RVALID = '1';
    wait until S_AXI_RVALID = '0';
	
        S_AXI_ARADDR	<=x"2c";
        readIt			<='1';			--Start AXI Read from Slave
        wait for 1 ns; 
		readIt		<='0'; 				--Clear "Start Read" Flag
    wait until S_AXI_RVALID = '1';
    wait until S_AXI_RVALID = '0';
        
     wait; -- will wait forever
 end process tb;

end Behavioral;
