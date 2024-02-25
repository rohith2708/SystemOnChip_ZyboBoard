LIBRARY IEEE;
  USE IEEE.STD_LOGIC_1164.all;
  USE IEEE.NUMERIC_STD.all;
  USE work.as_p.all;

ENTITY register_e IS
generic(addr_g : std_logic_vector(4 DOWNTO 0));    
PORT(clk_i     : IN  std_logic; --input clock
     rst_n_i   : IN  std_logic; --asynchronous active low reset
     wren_i    : IN  std_logic; --write enable
     adr_i     : IN  std_logic_vector(4 DOWNTO 0);
     data_i    : IN  std_logic_vector(31 DOWNTO 0);
     data_o    : OUT std_logic_vector(31 DOWNTO 0);
     se_i              : IN  std_logic; --! Test shift enable
     sc_i             : IN  std_logic; --! Test data in
     sc_o             : OUT std_logic  --! Test data out
     );
END register_e;
