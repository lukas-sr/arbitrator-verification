-- arb_tb.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity arb_tb2 is
end;

architecture bhv of arb_tb2 is

    signal clk, cmd, rst_n, protocol_violation : std_logic :='0';
    signal req      : std_logic_vector(0 to 2) := "000";
    signal gnt      : std_logic_vector(0 to 2);
    signal fails    : std_logic_vector(0 to 3);
    signal n1,n2,n3 : signed (0 to 1);

    constant clk_period : time := 10 ns;

begin

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;


    m_arbiter : entity work.arb(Behavioral)
        port map(
            clk => clk,
            cmd => cmd,
            rst_n => rst_n,
            req => req,
            N1 => n1, N2 => n2, N3 => n3,
            gnt => gnt
        );

    m_property_checker : entity work.property_checker(bhv)
        port map(
            clk  => clk,
            cmd  => cmd,
            req  => req,
            gnt  => gnt,
            fails => fails
        );

    m_protocol_checker : entity work.protocol_checker(bhv)
        port map(
            clk => clk,
            cmd => cmd,
	    req => req,
	    protocol_violation => protocol_violation
        );

    stim_proc: process
    begin
        rst_n <= '0', '1' after 20 ns;

        cmd <= '1';
        req <= "001";
        wait for 20 ns;
        cmd <= '0';
        req <= "000";
        wait for 60 ns;

        cmd <= '1';
        req <= "011";   
        wait for 20 ns;
        cmd <= '0';
        req <= "000";
        wait for 80 ns;

        cmd <= '1';
        req <= "101";
        wait for 20 ns;
        cmd <= '0';
        req <= "000";
        wait for 80 ns;

        cmd <= '1';
        req <= "010";
        wait for 20 ns;

        -- introducing a protocol violation: req changes when cmd is high
        cmd <= '0';
        req <= "000";
        wait for 20 ns;

        cmd <= '0';
        req <= "000";
        wait for 60 ns;

        -- introducing a protocol violation: req changes when cmd is high
        cmd <= '1';
        req <= "001";
        wait for 20 ns;

        cmd <= '0';
        req <= "000";
        wait for 60 ns;

        cmd <= '1';
        req <= "001";    
        wait for 20 ns;

        cmd <= '0';
        req <= "000";

        -- here we see fail(2)
        wait for 30 ns;
        req <= "000";     
        wait for 60 ns;

        wait;
    end process;
end bhv;