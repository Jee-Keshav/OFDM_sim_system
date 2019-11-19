clear all;

%Tx chain
subcarriers     = 4096;                 %Total no. of sub-carriers
u_subcarriers   = 3072;                 %No. of useful sub-carriers
symbols         = 14;
n=u_subcarriers * symbols;              %No. of bits in PRB
type=0;                                 %type 0/1/2/3/4 -> BPSK/QPSK/16QAM/64QAM
bits = gen_bits(n,type);                %generate bits
tx_map=map_mod(bits,n,type);               %Modulation
val = reshape(tx_map,[u_subcarriers,symbols]);
tx_grid = ifft(val, subcarriers);
tx_val = reshape(tx_grid,[1,subcarriers*symbols]);



%Rx chain

rx_val      = tx_val;
rx_grid     = reshape(rx_val,[subcarriers,symbols]);
rx_fft      = fft(rx_grid,subcarriers);
rx_u_val    = rx_fft(1:u_subcarriers,:);

rx_map = reshape(rx_u_val,[1,numel(rx_u_val)]);
rx_demap_int=map_demod(rx_map,type);
rx_demap = reshape(rx_demap_int,[1,numel(rx_demap_int)]);
unique(rx_demap == bits)

