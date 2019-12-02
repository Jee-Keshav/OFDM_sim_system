function Grid_tx = data_add(Grid_dmrs,type,n_data,n)

%% Generating bits
if type==0
    bits = randi([0,1],1,n_data*(2*type+1));
else
    bits = randi([0,1],1,n_data*2*type);
end

%% Mapping bits

    map = zeros(1,n_data);
switch (type)
    case 0 
        map = (1/sqrt(2))*((1-2*bits) + i*(1-2*bits));
    case 1 
        for k=1:n
            map(k) = (1/sqrt(2))*((1-2*bits(2*k-1))+i*(1-2*bits(2*k)));
        end     
    case 2 
%         for k=1:n
%            map(k) = (1/sqrt(10))*((1-2*bits(4*k-3))*(2-(1-2*bits(4*k+2-3)))+i*(1-2*bits(4*k+1-3))*(2-(1-2*bits(4*k+3-3))));   
%         end
         map = wlanConstellationMap(bits',4);
    otherwise
        map =wlanConstellationMap(bits',2*type);
end

%% Making grid
p=1;
Grid_tx = Grid_dmrs;
for k=1:n
   if( Grid_dmrs(k) == 0 )
       Grid_tx(k) = map(p);
       p=p+1;
   end
end

end