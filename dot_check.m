delta = 8;
a = [zeros(1,delta) 1:32 1:32 ones(1,40)];
max=0;

for p=0:11
    b = dot(a((1:32)+p),a((33:64)+p));
    if b>max
        max = b;
        ind = p;
    end
end
max
ind
