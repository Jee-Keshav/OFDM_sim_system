function Grid_dmrs = dmrs_add(u_subcarriers, Grid_in, dmrs_symbol1, dmrs_symbol2,pilot1,pilot2)

Grid_in(1:2:u_subcarriers,dmrs_symbol1+1) = pilot1(1:2:u_subcarriers,1)
Grid_in(1:2:u_subcarriers,dmrs_symbol2+1) = pilot2(1:2:u_subcarriers,1)

Grid_dmrs = Grid_in;

end
