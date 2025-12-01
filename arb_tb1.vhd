
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
ENTITY arb_tb1 IS
END;
 
ARCHITECTURE behavior OF arb_tb1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT arb
    PORT(
         clk : IN  std_logic;
         cmd : IN  std_logic;
         rst_n : IN  std_logic;
         req : IN  std_logic_vector(0 to 2);
	    N1 : out signed(0 to 1);
	    N2 : out signed(0 to 1);
	    N3 : out signed(0 to 1);
         gnt : INOUT  std_logic_vector(0 to 2)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal cmd : std_logic := '0';
   signal rst_n : std_logic := '0';
   signal req : std_logic_vector(0 to 2) := (others => '0');

	--BiDirs
     signal gnt : std_logic_vector(0 to 2);
	signal N1 : signed(0 to 1);
	signal N2 : signed(0 to 1);
	signal N3 : signed(0 to 1);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: arb PORT MAP (
          clk => clk,
          cmd => cmd,
          rst_n => rst_n,
          req => req,
	     N1 => N1,
	     N2 => N2,
	     N3 => N3,
          gnt => gnt
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
   	rst_n <= '0', '1' after 20 ns;
	
	cmd <= '0', '1' after 35 ns, '0' after 45 ns, 
	       '1' after 85 ns,  '0' after 95 ns,
	       '1' after 125 ns, '0' after 135 ns,
	       '1' after 175 ns, '0' after 185 ns,
	       '1' after 225 ns, '0' after 235 ns,
	       '1' after 315 ns, '0' after 325 ns;
	
	req <= "000", "001" after 35 ns, "000" after 45 ns, 
	       "011" after 85 ns, "000" after 95 ns,
	       "111" after 125 ns, "000" after 135 ns,
	       "101" after 175 ns, "000" after 185 ns,
	       "111" after 225 ns, "000" after 235 ns,
	       "101" after 315 ns, "000" after 325 ns; 
	wait;
	
   end process;

END;
