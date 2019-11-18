function demap = map_demod(const,n,type)
switch(type)
    case 0 
        for k=1:2
            map(k) = (1/sqrt(2))*((1-2*k) + i*(1-2*k));
        end
        demap = zeros(1,n);    
        for p=1:m
            for q=1:n
                
            end
        end
            
            demap(m) = (1/sqrt(2))*((1-2*) + i*(1-2*bits));
        end
    case 1 
        demap = zeros(1,2*n);
        for k=1:2*n
            demap(k) = (1/sqrt(2))*((1-2*bits(2*k-1))+i*(1-2*bits(2*k)));
        end
        
    case 2 
        demap = zeros(1,4*n);
        for k=1:4*n
            demap(k) = (1/sqrt(10))*((1-2*bits(4*k-1))*(2-(1-2*bits(4*k+1)))+i*(1-2*bits(4*k))*(2-(1-2*bits(4*k+2))));
        end
        
    otherwise
        demap =0;
end
       
end