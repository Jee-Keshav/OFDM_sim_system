function map = map_mod(bits,n,type)
switch(type)
    case 0 
        map = zeros(1,n);    
        map = (1/sqrt(2))*((1-2*bits) + i*(1-2*bits));
    case 1 
        map = zeros(1,2*n);
        for k=1:2*n
            map(k) = (1/sqrt(2))*((1-2*bits(2*k-1))+i*(1-2*bits(2*k)));
        end
        
    case 2 
        map = zeros(1,4*n);s
        for k=1:4*n
            map(k) = (1/sqrt(10))*((1-2*bits(4*k-1))*(2-(1-2*bits(4*k+1)))+i*(1-2*bits(4*k))*(2-(1-2*bits(4*k+2))));
        end
        
    otherwise
        map =0;
end
       
end