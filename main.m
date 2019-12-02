clear all;
load('preamble.mat');
load('pilots.mat');

tsymbols = 14;
subcarriers     = 4096;                 %Total no. of sub-carriers
u_subcarriers   = 3072;                 %No. of useful sub-carriers
n = u_subcarriers * tsymbols;           %No. of bits in PRB
n_data = n - u_subcarriers;             % No. of data REs (excluding DMRS values)
dmrs_symbol1 = 2;
dmrs_symbol2 = 9;
type=2;                                 %type 0/1/2/3/4 -> BPSK/QPSK/16QAM/64QAM


H_symbol = ones(u_subcarriers,1);       %Initializing H_matrix for a symbol with ones

%%
%%Tx chain

%1 slot
Grid_in = zeros(u_subcarriers,tsymbols);       %Grid initialization
Grid_dmrs = dmrs_add(u_subcarriers, Grid_in, dmrs_symbol1, dmrs_symbol2,pilot1,pilot2);       %DMRS addition
Grid_data = data_add(Grid_dmrs,type,n_data,n);                                  %Transmitter Grid
Grid_tx = ifft(Grid_data, subcarriers);

%tx_ch = reshape(tx_grid,[1,numel(tx_grid)]);

%Preamble addition
tx_val = sequence_snc;
%CP_addition
tx_val = [tx_val Grid_tx((4096-351):4096,1).' Grid_tx(:,1).'];
for k = 2:14
    tx_val = [tx_val Grid_tx((4096-287):4096,k).' Grid_tx(:,k).'];
end



%% Receiver

rx_val_preamble      = tx_val;
Ind = 64;
rx_val = rx_val_preamble(Ind+1:numel(rx_val_preamble));
%CP_strip
rx_cp = rx_val((1:4096)+352);
for k= 2:14
    rx_cp = [rx_cp rx_val((352+4384*(k-1))+(1:4096))];
end

rx_grid     = reshape(rx_cp,[subcarriers,tsymbols]);
rx_fft      = fft(rx_grid,subcarriers);
rx_u_val    = rx_fft(1:u_subcarriers,:);

%% Channel Estimation

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
    H_symbol(u_subcarriers,1)     = H_symbol(u_subcarriers-1,dmrs_symbol1+1);

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





%%
rx_map = reshape(rx_u_val,[1,numel(rx_u_val)]);
rx_demap_int=map_demod(rx_map,type);
rx_demap = reshape(rx_demap_int,[1,numel(rx_demap_int)]);
unique(rx_demap == bits)

