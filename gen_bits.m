function bits=gen_bits(n,type)
bits = randi([0,1],1,n*(2^type));
end
