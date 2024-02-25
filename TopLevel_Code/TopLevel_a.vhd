----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2023 20:26:41
-- Design Name: 
-- Module Name: TopLevel_a - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


architecture TopLevel_a of TopLevel_e is
-- outside main signal--
--signal tdi_i : std_logic;

-- connections ---
signal tdo_connection : std_logic;
signal vectordowntoconnector1 : std_logic_vector(31 downto 0);
signal vectordowntoconnector2 : std_logic_vector(2 downto 0);
--- fsm signals -----
signal clock_dr_i : STD_LOGIC;
signal shift_dr_i : STD_LOGIC;
signal update_dr_i : STD_LOGIC;
signal clock_ir_i : STD_LOGIC;
signal shift_ir_i : STD_LOGIC;
signal update_ir_i : STD_LOGIC;
signal irdr_selet_o : STD_LOGIC;
signal tdo_ena_o : std_logic;
signal trst_i :std_logic;

 
 -- decoder and bypass --
 signal clock_connection : std_logic;
 signal shift_connection : std_logic;
 
 -- mux and decoder --
 signal sel_mux_decoder :std_logic;
 
 -- bypass to mux --
 signal tdo_dr_by_s : std_logic; 
 
 -- fsm related signals --

signal tck_i_fsm : std_logic;
signal tdi_i_external : std_logic;  
signal tdo_dr_id_s : std_logic;

-- dr and ir register --
signal trst_combined_s : std_logic;
signal register_clk : std_logic; 
signal tdo_ir_s: std_logic;
signal dr_clock_connection: std_logic;
-- ir register to decoder -- 
signal id_reg_out_s : std_logic_vector(31 downto 0);
 
-- fsm to ir --
--signal update_connection_fsm : std_logic;
--signal shift_connection_fsm : std_logic;
--signal clock_connection_fsm : std_logic;


signal dir_tdi_s : std_logic_vector(4 downto 0);
signal dir_tdo_s : std_logic_vector(4 downto 0);
signal scan_en_s : std_logic;
-- fsm to ir --
--signal update_connection_fsm : std_logic;
--signal shift_connection_fsm : std_logic;
--signal clock_connection_fsm : std_logic;

component regtop_e
port(
     clk_i             : IN  std_logic; --! clock
     rst_n_i           : IN  std_logic; --! reset
     reg_write_i       : IN  std_logic; --! write cmd
     reg1_rd_adr_i     : IN  std_logic_vector(4 DOWNTO 0); --! address for source op1
     reg2_rd_adr_i     : IN  std_logic_vector(4 DOWNTO 0); --! address for source op2
     reg_wr_adr_i      : IN  std_logic_vector(4 DOWNTO 0); --! address for result
     reg_data_result_i : IN  std_logic_vector(31 DOWNTO 0); --! result/destination
     reg1_data_o       : OUT std_logic_vector(31 DOWNTO 0); --! source op1
     reg2_data_o       : OUT std_logic_vector(31 DOWNTO 0); --! source op2
     se_i              : IN  std_logic; --! Test shift enable
     sc_i             : IN  std_logic; --! Test data in
     sc_o             : OUT std_logic  --! Test data out
);
end component;

-- tap decoder component ---
 component tapc_fsm
 port(   
        tck_i, tms_i, trst_i : in std_logic;
        tdo_o : out std_logic;
        tapState_v : out STD_LOGIC_VECTOR (3 downto 0);
        signal testLogicReset_O: out std_logic;
        signal capture_dr_o, update_dr_o, shift_dr_o, dr_clock: out std_logic;
        signal capture_ir_o, update_ir_o, shift_ir_o, ir_clock: out std_logic;
        signal tdo_ena: out std_logic;
        signal irdr_select_O: out std_logic
 );
 end component;
 
 
 component tap_decoder
 port(      clk_dr_i : in STD_LOGIC;
           shift_dr_i : in STD_LOGIC;
           update_dr_i : in STD_LOGIC;
           ir_i : in std_logic_vector(31 downto 0);
           test_mode_o : out STD_LOGIC;
           select_tdo_o : out STD_LOGIC;
           clk_by_o : out STD_LOGIC;
           shift_by_o : out STD_LOGIC;
           clk_bs_o : out STD_LOGIC;
           shift_bs_o : out STD_LOGIC;
           upd_bs_o : out STD_LOGIC;
           test_code_o : out std_logic_vector(2 downto 0);
           dbg0_mode_o : out STD_LOGIC;
           dbg0_clk_o : out STD_LOGIC;
           dbg0_shift_o : out STD_LOGIC;
           dbg0_upd_o : out STD_LOGIC);
end component;

-- bypass component --
 
component Bypass_Reg
Port ( trst_i : in STD_LOGIC;
          tck_i : in STD_LOGIC;
          dr_clock_i : in STD_LOGIC;
          dr_shift_i : in STD_LOGIC;
          td_i : in STD_LOGIC;
          tdo_o : out STD_LOGIC);
end component;


component tdo_mux 
port(
trst_i : in STD_LOGIC;
           tck_i : in STD_LOGIC;
           tdo_ir_i : in STD_LOGIC;
           tdo_dr_i : in STD_LOGIC;
           irdr_select_i : in STD_LOGIC;
           tdo_ena_i : in STD_LOGIC;
           sel_dr_i : in STD_LOGIC;
           tdo_o : out STD_LOGIC
           );
           end component;

-- register irdr component
component register_dr
port(      trst_i : in STD_LOGIC;
           clk_i : in STD_LOGIC;
           ser_in_i : in STD_LOGIC;
           clock_dr_i : in STD_LOGIC;
           shift_dr_i : in STD_LOGIC;
           mode_i : in STD_LOGIC;
           upd_dr_i : in STD_LOGIC;
           data_in_i : in STD_LOGIC;
           data_out_o : out STD_LOGIC;
           test_code_i :in std_logic_vector(2 downto 0);
           ser_out_o : out STD_LOGIC  
                     );
end component;


component register_ir
port(trst_i : in STD_LOGIC;
           clk_i : in STD_LOGIC;
           ser_in_i : in STD_LOGIC;
           clock_ir_i : in STD_LOGIC;
           shift_ir_i : in STD_LOGIC;
           ir_rst_i : in STD_LOGIC;
           upd_ir_i : in STD_LOGIC;
           data_in_i : in STD_LOGIC;
           ir_pardata_c : out STD_LOGIC;
           ir_reg_out_s : out std_logic_vector(31 downto 0);
           tdo_ir_s: out STD_LOGIC
         );
 end component;


begin
reg_instance: regtop_e
Port map( 
      clk_i => clk_i,
      rst_n_i => rst_n_i,
      reg_write_i => reg_write_i,
      reg1_rd_adr_i => reg1_rd_adr_i ,
      reg2_rd_adr_i  => reg2_rd_adr_i ,
      reg_wr_adr_i  => reg_wr_adr_i ,
      reg_data_result_i  => reg_data_result_i ,
      reg1_data_o  => reg1_data_o ,
      reg2_data_o  => reg2_data_o ,
      se_i  => scan_en_s ,
      sc_i  => tdi_i ,
      sc_o  => tdo_o
         );

tapc_fsm_instance: tapc_fsm
        port map(
        tck_i => tck_i,
        tms_i => tms_i,
        trst_i => trst_n_i,
        update_dr_o => update_dr_i,
         shift_dr_o => shift_dr_i, 
         dr_clock=> clock_dr_i,
        update_ir_o => update_ir_i,
        shift_ir_o => shift_ir_i, 
        ir_clock => clock_ir_i,
        tdo_ena => tdo_ena_o,
        irdr_select_O => irdr_selet_o
            );



    tapdecoder_instance : tap_decoder
    port map( 
            clk_dr_i => clock_dr_i,
           shift_dr_i => shift_dr_i,
           update_dr_i => update_dr_i,
           ir_i(31 downto 0) => vectordowntoconnector1(31 downto 0),
           test_mode_o => open,
           select_tdo_o => sel_mux_decoder,
           clk_by_o => dr_clock_connection,
           shift_by_o => shift_connection,
           test_code_o => vectordowntoconnector2(2 downto 0),
           clk_bs_o => open,
           shift_bs_o => open,
           upd_bs_o => open,
           dbg0_mode_o => open,
           dbg0_clk_o => open,
           dbg0_shift_o => open,
           dbg0_upd_o => open
           );
           
      
bypass_reg_instance : Bypass_Reg
port map( 
            trst_i  => trst_combined_s,
            tck_i  =>  tck_i,
            dr_clock_i  =>  dr_clock_connection,
            dr_shift_i  =>  shift_connection,
            td_i  =>  tdi_i,
            tdo_o  =>  tdo_dr_by_s
         );
              
     tdo_mux_instance : tdo_mux 
     port map(
           trst_i => trst_n_i,
           tck_i => tck_i,
           tdo_ir_i => tdo_ir_s,
           tdo_dr_i => tdo_dr_by_s,
           irdr_select_i => irdr_selet_o,
           tdo_ena_i => tdo_ena_o,
           sel_dr_i => tdi_i,
           tdo_o => tdo_o );
    
    
     
    register_dr_instance : register_dr
    port map(
            trst_i => trst_combined_s,
           clk_i => tck_i_fsm,
           ser_in_i => tdi_i,
           clock_dr_i => clock_dr_i,
           shift_dr_i => shift_dr_i,
           mode_i => '1',
           upd_dr_i => update_dr_i,
           data_in_i => '1',
           data_out_o => open,
           test_code_i(2 downto 0) => vectordowntoconnector2(2 downto 0),
           ser_out_o => tdo_dr_id_s
                );
    
 
    register_ir_instance : register_ir
    port map(
           trst_i => trst_combined_s,
           clk_i => tck_i_fsm,
           ser_in_i  => tdi_i,
           clock_ir_i => clock_ir_i,
           shift_ir_i => shift_ir_i,
           ir_rst_i => '0',
           upd_ir_i => update_ir_i,
           data_in_i => '1',
           ir_pardata_c => open,
           ir_reg_out_s(31 downto 0) => vectordowntoconnector1(31 downto 0),
           tdo_ir_s => tdo_ir_s
    );

end TopLevel_a;
