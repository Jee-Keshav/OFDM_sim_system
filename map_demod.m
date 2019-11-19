function demap = map_demod(const,type)
    if(type == 0)
        demap = ~wlanConstellationDemap(const,0,2*type+1, 'hard');
    else if(type == 1)
            demap = ~wlanConstellationDemap(const,0,2*type, 'hard');
    else
        demap = wlanConstellationDemap(const,0,(2*type), 'hard');
    end
end