function H = ch_est(H_symbol,rx_u_val,u_subcarriers,dmrs_symbol1,dmrs_symbol2,pilot1,pilot2,tsymbols)

H = zeros(u_subcarriers,tsymbols);
H(1:2:u_subcarriers,dmrs_symbol1+1) = rx_u_val(1:2:u_subcarriers,dmrs_symbol1+1);
H(1:2:u_subcarriers,dmrs_symbol2+1) = rx_u_val(1:2:u_subcarriers,dmrs_symbol2+1);

for sym=1:dmrs_symbol1
    H(1:u_subcarriers,sym) = H_symbol;
end
    H_symbol(1:2:u_subcarriers-1,1) = rx_u_val(1:2:u_subcarriers-1,dmrs_symbol1+1)./ pilot1(1:2:u_subcarriers-1,1);

for k=2:2:u_subcarriers-1
    H_symbol(k,1)       = (H_symbol(k-1,1)+H_symbol(k+1,1))/2;
end
    H_symbol(u_subcarriers,1)     = H_symbol(u_subcarriers-1,1);

for sym = dmrs_symbol1+1 : dmrs_symbol2
    H(1:u_subcarriers,sym) = H_symbol;
end
    H_symbol(1:2:u_subcarriers-1,1) = rx_u_val(1:2:u_subcarriers-1,dmrs_symbol2+1)./ pilot2(1:2:u_subcarriers-1,1);
    
for k=2:2:u_subcarriers-1
    H_symbol(k,1)       = (H_symbol(k-1,1)+H_symbol(k+1,1))/2;
end
    H_symbol(u_subcarriers,1)     = H_symbol(u_subcarriers-1,1);

for sym = dmrs_symbol2+1 : tsymbols
    H(1:u_subcarriers,sym) = H_symbol;
end
end