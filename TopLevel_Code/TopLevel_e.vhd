----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2023 20:25:53
-- Design Name: 
-- Module Name: TopLevel_e - Behavioral
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

entity TopLevel_e is
PORT(clk_i                  : IN std_logic;
     rst_n_i                : IN std_logic;
     reg_write_i            : IN std_logic;
     reg1_rd_adr_i          : IN std_logic_vector(4 downto 0);
     reg2_rd_adr_i          : IN std_logic_vector(4 downto 0);
     reg_wr_adr_i           : IN std_logic_vector(4 downto 0);
     reg_data_result_i      : IN std_logic_vector(31 downto 0);
     reg1_data_o            : OUT std_logic_vector(31 downto 0);
     reg2_data_o            : OUT std_logic_vector(31 downto 0);
     tck_i                  : IN std_logic;
     trst_n_i               : IN std_logic;
     tms_i                  : IN std_logic;
     tdi_i                  : IN std_logic;
     tdo_o                  : OUT std_logic
     );
end TopLevel_e;

