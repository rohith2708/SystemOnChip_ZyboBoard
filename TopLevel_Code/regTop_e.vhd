----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2023 00:01:54
-- Design Name: 
-- Module Name: regTop_e - Behavioral
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

entity regTop_e is
--  Port ( );
PORT(clk_i             : IN  std_logic; --! clock
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
     sc_o             : OUT std_logic;  --! Test data out
     trst_n_o          : in STD_LOGIC;
     tck_o             : in STD_LOGIC;
     tms_o             : in STD_LOGIC
     );
end regTop_e;

