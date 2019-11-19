clear all;
load('pilots.mat');
load('preamble.mat');

%Tx chain
subcarriers     = 4096;                 %Total no. of sub-carriers
u_subcarriers   = 3072;                 %No. of useful sub-carriers
symbols         = 14;
n=u_subcarriers * symbols;              %No. of bits in PRB
type=2;                                 %type 0/1/2/3/4 -> BPSK/QPSK/16QAM/64QAM
bits = gen_bits(n,type);                %generate bits
tx_map=map_mod(bits,n,type);               %Modulation
val = reshape(tx_map,[u_subcarriers,symbols]);

%DMRS addition
for k = 1:2:3072
    val(k,3) = pilot1(k);
    val(k,10)= pilot2(k);
end

tx_grid = ifft(val, subcarriers);
%tx_ch = reshape(tx_grid,[1,numel(tx_grid)]);

%Preamble addition
tx_val = sequence_snc;
%CP_addition
tx_val = [tx_val tx_grid((4096-351):4096,1).' tx_grid(:,1).'];
for k = 2:14
    tx_val = [tx_val tx_grid((4096-287):4096,k).' tx_grid(:,k).'];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Receiver Chain%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rx_val      = tx_val;
%CP_strip
rx_cp = rx_val((1:4096)+352);
for k= 2:14
    rx_cp = [rx_cp rx_val((352+4384*(k-1))+(1:4096))];
end

rx_grid     = reshape(rx_cp,[subcarriers,symbols]);
rx_fft      = fft(rx_grid,subcarriers);
rx_u_val    = rx_fft(1:u_subcarriers,:);

rx_map = reshape(rx_u_val,[1,numel(rx_u_val)]);
rx_demap_int=map_demod(rx_map,type);
rx_demap = reshape(rx_demap_int,[1,numel(rx_demap_int)]);
unique(rx_demap == bits)

