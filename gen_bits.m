function bits=gen_bits(n,type)
if type==0
    bits = randi([0,1],1,n*(2*type+1));
else
    bits = randi([0,1],1,n*2*type);
end
end
