-- arb_tb.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity arb_tb2 is
end;

architecture bhv of arb_tb2 is

signal clk, cmd, protocol_violation, rst_n : std_logic :='0';
signal req, gnt : std_logic_vector(0 to 2);
signal fails    : std_logic_vector(0 to 3);
signal n1,n2,n3 : signed (0 to 1);
begin

rst_n <= '1'; --activation des assertions
clk <= not(clk) after 10 ns;

m_arbiter : entity work.arb(rtl)
port map (cmd, clk, rst_n, req,n1,n2,n3,gnt);

m_property_checker : entity work.property_checker(bhv)
port map(clk, cmd, req, gnt, fails);

m_protocol_checker : entity work.protocol_checker(bhv)
port map(clk, cmd, req, protocol_violation);

-- To be completed :

end bhv;
