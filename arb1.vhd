
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity arb is
port (clk		: in std_logic;
      cmd 		: in std_logic;
      rst_n 	: in std_logic;		
      req       : in std_logic_vector(0 to 2);
	  N1, N2, N3: out signed(0 to 1);
      gnt       : out std_logic_vector(0 to 2));
end arb;

architecture Behavioral of arb is
	signal gnt_temp : std_logic_vector(0 to 2);
	signal cmd_pending1 : std_logic :='0';
	signal cmd_pending2 : std_logic :='0';

begin
	process (clk, cmd, rst_n)

	variable count_N1 : signed(0 to 1) := (others => '0');
	variable count_N2 : signed(0 to 1) := (others => '0');
	variable count_N3 : signed(0 to 1) := (others => '0');
	variable count : integer := 0;

	begin
		if (rst_n = '0') then
		count := 0;
		count_N1 := (others=>'0'); -- Number of selection P1 in case of several contenders requesting communication 
		count_N2 := (others=>'0'); -- Number of selection P2 in case of several contenders requesting communication 
		count_N3 := (others=>'0'); -- Number of selection P3 in case of several contenders requesting communication 
		gnt <= "000";

		elsif (clk'event and clk='1') then
			if cmd = '1' then
				case req is
					when "001" => 
						gnt_temp <= "001"; 

					when "010" => 
						gnt_temp <= "010";

					when "100" => 
						gnt_temp <= "100";
							
			when "011" => if (count_N1 <= count_N2) then		-- priority to the less valued counter 
						gnt_temp <= "001";
						count_N1:= count_N1 + "01";
						count_N2:= count_N2 - "01";
					else
						gnt_temp <= "010";
						count_N1:= count_N1 - "01";
						count_N2:= count_N2 + "01";
					end if;

			when "101" => if (count_N1 <= count_N3) then
						gnt_temp <= "001";
						count_N1:= count_N1 + "01"; 
						count_N3:= count_N3 - "01";
					else
						gnt_temp <= "100";
						count_N1:= count_N1 - "01"; 
						count_N3:= count_N3 + "01";
					end if;	
											
			when "110" => if (count_N2 <= count_N3) then
						gnt_temp <= "010";
						count_N2:= count_N2 + "01"; 
						count_N3:= count_N3 - "01"; 
					else
						gnt_temp <= "100"; 
						count_N2:= count_N2 - "01"; 
						count_N3:= count_N3 + "01";
					end if;	

			when "111" =>  
				if count_N1 <= count_N2 and count_N1 <= count_N3 then
					gnt_temp <= "001";
					count_N1 := count_N1 + "01";
					count_N2 := count_N2 - "01";
					count_N3 := count_N3 - "01";
    			elsif count_N2 <= count_N3 then
					gnt_temp <= "010";
					count_N2 := count_N2 + "01";
					count_N1 := count_N1 - "01";
					count_N3 := count_N3 - "01";
    			else
					gnt_temp <= "100";
					count_N3 := count_N3 + "01";
					count_N1 := count_N1 - "01";
					count_N2 := count_N2 - "01";
    			end if;

				when others => gnt_temp <= "000";
				end case;
					cmd_pending1 <= '1';
					cmd_pending2 <= '0';
						count := 1;
		
			end if;
			
			if (cmd_pending1 = '1') then
					count := 2;
					cmd_pending2 <= '1';
						gnt <= gnt_temp;
			end if;
			
			if (cmd_pending2 = '1') then
					count := 3;
						cmd_pending1 <= '0';
		end if; 		 
		if (count = 3) then
			count := 0;		 
			gnt <= "000"; 
			cmd_pending2 <= '0';		  
			end if; 
					
		end if;
		N1 <= count_N1;
		N2 <= count_N2;
		N3 <= count_N3;

end process;

end Behavioral;

