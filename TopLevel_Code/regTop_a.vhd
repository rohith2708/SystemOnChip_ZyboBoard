----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2023 00:04:42
-- Design Name: 
-- Module Name: regTop_a - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity regTop_a is
--  Port ( );
end regTop_a;

architecture regTop_a of regTop_e is

--Register signals--
TYPE dat_t IS ARRAY (32-1 DOWNTO 0) OF std_logic_vector(32-1 DOWNTO 0);
SIGNAL dat_s  : dat_t;

SIGNAL tdi_s, tdo_s, se_s : std_logic;
SIGNAL ser_s : std_logic_vector(32 DOWNTO 0);

 
-- fsm to ir --
--signal update_connection_fsm : std_logic;
--signal shift_connection_fsm : std_logic;
--signal clock_connection_fsm : std_logic;

-----------------------------------------------------------------
--Component Initiation ----
---------------------------------------------------------------

COMPONENT register_e
GENERIC(addr_g : std_logic_vector(4 DOWNTO 0));    
PORT(clk_i     : IN  std_logic; --input clock
     rst_n_i   : IN  std_logic; --asynchronous active low reset
     wren_i    : IN  std_logic; --write enable
     adr_i     : IN  std_logic_vector(4 DOWNTO 0);
     data_i    : IN  std_logic_vector(32-1 DOWNTO 0);
     data_o    : OUT std_logic_vector(32-1 DOWNTO 0);
     se_i      : IN  std_logic; --! Test shift enable
     sc_i     : IN  std_logic; --! Test data in
     sc_o     : OUT std_logic  --! Test data out
     );
END COMPONENT;


BEGIN
  
---------------------------------------------------------------
-- Signal mappings
---------------------------------------------------------------
  se_s     <= se_i;
  tdi_s    <= sc_i;
  ser_s(0) <= tdi_s;
  sc_o    <= ser_s(32);
---------------------------------------------------------------
-- Registers and Scan Chain
---------------------------------------------------------------
  genRegs : FOR i IN 0 TO 32-1 GENERATE
    asReg00 : register_e GENERIC MAP (addr_g  => std_logic_vector(to_unsigned(i,5)))
                             PORT MAP(clk_i   => clk_i,
                                      rst_n_i => rst_n_i,
                                      wren_i  => reg_write_i,
                                      adr_i   => reg_wr_adr_i,
                                      data_i  => reg_data_result_i,
                                      data_o  => dat_s(i),
                                      se_i    => se_s,
                                      sc_i   => ser_s(i),
                                      sc_o   => ser_s(i+1)
                                      );
  END GENERATE genRegs;

---------------------------------------------------------------
-- Output Mux; reading
---------------------------------------------------------------
  reg1_data_o <= dat_s(to_integer(unsigned(reg1_rd_adr_i)));
  reg2_data_o <= dat_s(to_integer(unsigned(reg2_rd_adr_i)));
  
END regtop_a;