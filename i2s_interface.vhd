library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_interface is
	port (
    	-- on partirait sur un bit rate de freq 44 kHz
        mclk        : in std_logic; --master clock, 22,579 MHz
        --counter_mclk 		: in std_logic; --bit clock, toggles once per 8 MCLK periods / 2,82 MHz
        rst 		: in std_logic;
        din         : in std_logic;
        dout        : out std_logic_vector(23 downto 0);
        valid       : out std_logic
        -- pas besoin d'implémenter les canaux gauche droite
        --r_out       : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
end i2s_interface;

-- décalage bit à bit
--s <= s(22 downto 0) & din;

architecture rtl of i2s_interface is
    signal counter_mclk : integer :=0;
    signal counter_sclk : integer :=0;
    signal counter_data : integer :=0;
    signal get_data : std_logic :='0';
    --signal lrck : std_logic; --also wselect, toggles once per 64 counter_mclk periods /0,35 MHz
    signal sortie : std_logic_vector(23 downto 0) :="000000000000000000000000";
    
begin
    serial_data : process(mclk, rst)
    begin
        if rst = '1' then
            counter_mclk <= 0;
            counter_sclk <= 0;
            --lrck <= '0'; --on commence par la gauche
            sortie <= (others => '0');
            get_data <= '0';
            counter_data <= 0;
            valid <= '0';
        elsif rising_edge(mclk) then
            counter_mclk <= counter_mclk + 1;
            if counter_mclk = 7 then
                counter_sclk <= counter_sclk + 1;
                counter_mclk <= 0;
                if counter_sclk = 63 then
                    counter_sclk <= 0;
                    get_data <= '1';
                end if;
                --assign bit of din
                if get_data = '1' then
                    if counter_data = 24 then
                        counter_data <= 0;
                        dout <= sortie;
                        get_data <= '0';
                            valid <= '1';
                    else
                        sortie(counter_data) <= din;    
                        counter_data <= counter_data + 1;
                    end if;
                    
                end if;
            end if;
        end if;
    end process;
end rtl;
