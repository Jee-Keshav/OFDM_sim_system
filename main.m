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
n_sf = 10;                              %No. of slots per frame

H_symbol = ones(u_subcarriers,1);       %Initializing H_matrix for a symbol with ones

%%
%%Tx chain
tx_bits = zeros(1,0);
Frame = sequence_snc;
for slot = 1:10
%1 slot
Grid_in = zeros(u_subcarriers,tsymbols);       %Grid initialization
Grid_dmrs = dmrs_add(u_subcarriers, Grid_in, dmrs_symbol1, dmrs_symbol2,pilot1,pilot2);       %DMRS addition
[bits map Grid_data] = data_add(Grid_dmrs,type,n_data,n);                                  %Transmitter Grid

tx_bits = [tx_bits bits];

Grid_tx = ifft(Grid_data, subcarriers);

%CP_addition
tx_val = [Grid_tx((4096-351):4096,1).' Grid_tx(:,1).'];
for k = 2:14
    tx_val = [tx_val Grid_tx((4096-287):4096,k).' Grid_tx(:,k).'];
end

Frame = [Frame tx_val];
end

%% Receiver

rx_val_preamble      = Frame;
Ind = 64;
rx_val = rx_val_preamble(Ind+1:numel(rx_val_preamble));


%% CP_strip
rx_frame = zeros(1,0);
for slot=0:9
    rx_cp = rx_val((1:4096)+352+61440*slot);
    for k= 2:14
        rx_cp = [rx_cp rx_val((352+4384*(k-1))+(1:4096)+61440*slot)];
    end
    rx_frame = [rx_frame rx_cp];
end

%% fft
rx_grid     = reshape(rx_frame,[subcarriers,tsymbols,n_sf]);
rx_fft      = fft(rx_grid,subcarriers);
rx_u_val    = rx_fft(1:u_subcarriers,:,:);

%% Channel Estimation and Interpolation
H = ch_est(H_symbol,rx_u_val,u_subcarriers,dmrs_symbol1,dmrs_symbol2,pilot1,pilot2,tsymbols);
H = repmat(H,[1,1,n_sf]);

%% Equalized grid
rx_eq = rx_u_val./H;

%% Read data

for slot = 1:10
    rx_data = rx_eq(1:u_subcarriers,1,slot).';
    for k=2:tsymbols
        if(k==dmrs_symbol1+1)
            rx_data = [rx_data rx_eq(2:2:u_subcarriers,k,slot).'];
        elseif(k==dmrs_symbol2+1)
            rx_data = [rx_data rx_eq(2:2:u_subcarriers,k,slot).'];
        else
            rx_data = [rx_data rx_eq(1:u_subcarriers,k,slot).'];
        end
    end
end

rx_map = reshape(rx_data,[1,numel(rx_data)]);
rx_demap_int=map_demod(rx_map,type);
rx_bits = reshape(rx_demap_int,[1,numel(rx_demap_int)]);
check = rx_bits == bits;
unique(check)
c=find(check==0);