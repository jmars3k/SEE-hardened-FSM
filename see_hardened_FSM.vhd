library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity see_hardened_FSM is 
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		step		: in std_logic;
		sec 		: out std_logic;
		d			: out std_logic_vector(3 downto 0));

end see_hardened_FSM;
	
architecture behavior of see_hardened_FSM is

	constant state0 : std_logic_vector(6 downto 0) := "0000000";
	constant state1 : std_logic_vector(6 downto 0) := "0000111";
	constant state2 : std_logic_vector(6 downto 0) := "0011001";
	constant state3 : std_logic_vector(6 downto 0) := "0011110";
	constant state4 : std_logic_vector(6 downto 0) := "0101010";
	constant state5 : std_logic_vector(6 downto 0) := "0101101";
	constant state6 : std_logic_vector(6 downto 0) := "0110011";
	constant state7 : std_logic_vector(6 downto 0) := "0110100";
	constant state8 : std_logic_vector(6 downto 0) := "1001011";
	constant state9 : std_logic_vector(6 downto 0) := "1001100";
	constant state10 : std_logic_vector(6 downto 0) := "1010010";
	constant state11 : std_logic_vector(6 downto 0) := "1010101";
	constant state12 : std_logic_vector(6 downto 0) := "1100001";
	constant state13 : std_logic_vector(6 downto 0) := "1100110";
	constant state14 : std_logic_vector(6 downto 0) := "1111000";
	constant state15 : std_logic_vector(6 downto 0) := "1111111";	


	attribute syn_keep : boolean;
	signal next_state, state, corrected_state : std_logic_vector(6 downto 0);
--	mapping
--		state(6) = d4
--		state(5) = d3
--		state(4) = d2
--		state(3) = p3
--		state(2) = d1
--		state(1) = p2
--		state(0) = p1	
	signal p1, p2, p3 : std_logic;	
	attribute syn_keep of next_state, state, corrected_state, p1, p2, p3 : signal is true;
	
	signal pErrorSLV : std_logic_vector(2 downto 0);
	
	begin
	
		FSM : process (corrected_state, step) begin
		
			case corrected_state is
				
				when state0 =>
					if step = '1' then
						next_state <= state1;
					else
						next_state <= state0;
					end if;
					
				when state1 =>
					if step = '1' then
						next_state <= state2;
					else
						next_state <= state1;
					end if;				

				when state2 =>
					if step = '1' then
						next_state <= state3;
					else
						next_state <= state2;
					end if;
					
				when state3 =>
					if step = '1' then
						next_state <= state4;
					else
						next_state <= state3;
					end if;	

				when state4 =>
					if step = '1' then
						next_state <= state5;
					else
						next_state <= state4;
					end if;

				when state5 =>
					if step = '1' then
						next_state <= state6;
					else
						next_state <= state5;
					end if;

				when state6 =>
					if step = '1' then
						next_state <= state7;
					else
						next_state <= state6;
					end if;

				when state7 =>
					if step = '1' then
						next_state <= state8;
					else
						next_state <= state7;
					end if;

				when state8 =>
					if step = '1' then
						next_state <= state9;
					else
						next_state <= state8;
					end if;

				when state9 =>
					if step = '1' then
						next_state <= state10;
					else
						next_state <= state9;
					end if;

				when state10 =>
					if step = '1' then
						next_state <= state11;
					else
						next_state <= state10;
					end if;

				when state11 =>
					if step = '1' then
						next_state <= state12;
					else
						next_state <= state11;
					end if;

				when state12 =>
					if step = '1' then
						next_state <= state13;
					else
						next_state <= state12;
					end if;

				when state13 =>
					if step = '1' then
						next_state <= state14;
					else
						next_state <= state13;
					end if;

				when state14 =>
					if step = '1' then
						next_state <= state15;
					else
						next_state <= state14;
					end if;

				when state15 =>
					if step = '1' then
						next_state <= state0;
					else
						next_state <= state15;
					end if;

				when others =>
					next_state <= state0;
					
			end case;
		end process FSM;
		
		--calculate current even parities on state
				
		p1 <= '1' when 	((state(6) = '1') and (state(4) = '0') and (state(2) = '0')) or
						((state(6) = '0') and (state(4) = '1') and (state(2) = '0')) or
						((state(6) = '0') and (state(4) = '0') and (state(2) = '1')) or
						((state(6) = '1') and (state(4) = '1') and (state(2) = '1')) else '0';

		p2 <= '1' when  ((state(6) = '1') and (state(5) = '0') and (state(2) = '0')) or
						((state(6) = '0') and (state(5) = '1') and (state(2) = '0')) or
						((state(6) = '0') and (state(5) = '0') and (state(2) = '1')) or
						((state(6) = '1') and (state(5) = '1') and (state(2) = '1')) else '0'; 

		p3 <= '1' when 	((state(6) = '1') and (state(5) = '0') and (state(4) = '0')) or
						((state(6) = '0') and (state(5) = '1') and (state(4) = '0')) or
						((state(6) = '0') and (state(5) = '0') and (state(4) = '1')) or
						((state(6) = '1') and (state(5) = '1') and (state(4) = '1')) else '0';

		pErrorSLV(0) <= '1' when (p1 /= state(0)) else '0';
		pErrorSLV(1) <= '1' when (p2 /= state(1)) else '0';
		pErrorSLV(2) <= '1' when (p3 /= state(3)) else '0';	

		detectAndCorrect : process(pErrorSLV, state) begin

			case pErrorSLV is

				when "000" =>			--all parities match => no error
					sec <= '0';
					corrected_state(6) <= state(6);
					corrected_state(5) <= state(5);
					corrected_state(4) <= state(4);
					corrected_state(3) <= state(3);
					corrected_state(2) <= state(2);
					corrected_state(1) <= state(1);
					corrected_state(0) <= state(0);
				when "001" =>			--only p1, state(0) is in error => correct state(0)
					sec <= '1';
					corrected_state(6) <= state(6);
					corrected_state(5) <= state(5);
					corrected_state(4) <= state(4);
					corrected_state(3) <= state(3);
					corrected_state(2) <= state(2);
					corrected_state(1) <= state(1);
					corrected_state(0) <= not state(0);
				when "010" =>			--only p2, state(1), is in error => correct state(1)
					sec <= '1';
					corrected_state(6) <= state(6);
					corrected_state(5) <= state(5);
					corrected_state(4) <= state(4);
					corrected_state(3) <= state(3);
					corrected_state(2) <= state(2);
					corrected_state(1) <= state(1);
					corrected_state(0) <= state(0);
				when "011" =>			--p1 and p2 in error so d1, state(2), is wrong => correct state(2)
					sec <= '1';
					corrected_state(6) <= state(6);
					corrected_state(5) <= state(5);
					corrected_state(4) <= state(4);
					corrected_state(3) <= state(3);
					corrected_state(2) <= not state(2);
					corrected_state(1) <= state(1);
					corrected_state(0) <= state(0);
				when "100" =>			--only p3, state(3), is in error => correct state(3)
					sec <= '1';
					corrected_state(6) <= state(6);
					corrected_state(5) <= state(5);
					corrected_state(4) <= state(4);
					corrected_state(3) <= not state(3);
					corrected_state(2) <= state(2);
					corrected_state(1) <= state(1);
					corrected_state(0) <= state(0);
				when "101" =>			--p3 and p1 in error so d2, state(4), is wrong => correct state(4)
					sec <= '1';
					corrected_state(6) <= state(6);
					corrected_state(5) <= state(5);
					corrected_state(4) <= not state(4);
					corrected_state(3) <= state(3);
					corrected_state(2) <= state(2);
					corrected_state(1) <= state(1);
					corrected_state(0) <= state(0);
				when "110" =>			--p3 and p2 in error so d3, state(5), is wrong => correct state(5)
					sec <= '1';
					corrected_state(6) <= state(6);
					corrected_state(5) <= not state(5);
					corrected_state(4) <= state(4);
					corrected_state(3) <= state(3);
					corrected_state(2) <= state(2);
					corrected_state(1) <= state(1);
					corrected_state(0) <= state(0);
				when "111" =>			--p3, p2, and p1 in error so d4, state(6), is wrong => correct state(6)
					sec <= '1';
					corrected_state(6) <= not state(6);
					corrected_state(5) <= state(5);
					corrected_state(4) <= state(4);
					corrected_state(3) <= state(3);
					corrected_state(2) <= state(2);
					corrected_state(1) <= state(1);
					corrected_state(0) <= state(0);
				when others =>
					sec <= '0';
					corrected_state(6) <= state(6);
					corrected_state(5) <= state(5);
					corrected_state(4) <= state(4);
					corrected_state(3) <= state(3);
					corrected_state(2) <= state(2);
					corrected_state(1) <= state(1);
					corrected_state(0) <= state(0);
				
			end case;
		end process detectAndCorrect;		
						
						
		process(clk) begin
			if clk'event and clk = '1' then
				if reset = '1' then
					state <= state0;
				else
					state <= next_state;
				end if;
			end if;
		end	process;

		d(3) <= corrected_state(6);
		d(2) <= corrected_state(5);
		d(1) <= corrected_state(4);
		d(0) <= corrected_state(2);
		
end behavior;
