library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity arb_tb1 is
end;
 
architecture behavior of arb_tb1 is 
   component arb
   port(
      clk, cmd, rst_n : in  std_logic;
      req : in  std_logic_vector(0 to 2);
      N1, N2, N3 : out signed(0 to 1);
      gnt : inout  std_logic_vector(0 to 2)
      );
   end component;

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
	
      cmd <= '0', '1' after 29 ns, '0' after 41 ns, 
            '1' after 79 ns,  '0' after 91 ns,
            '1' after 119 ns, '0' after 131 ns,
            '1' after 169 ns, '0' after 181 ns,
            '1' after 219 ns, '0' after 231 ns,
            '1' after 309 ns, '0' after 321 ns;
      
            req <= "000", "001" after 30 ns, "000" after 40 ns, 
            "011" after 80 ns, "000" after 90 ns,
            "111" after 120 ns, "000" after 130 ns,
            "101" after 170 ns, "000" after 180 ns,
            "111" after 220 ns, "000" after 230 ns,
            "101" after 310 ns, "000" after 320 ns; 
          
	wait;
	
   end process;

END;
