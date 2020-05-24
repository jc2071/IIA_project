function view_bl(xs, ys, ipstag, iunt, iuls, iutr, iuts, ilnt, ills, iltr, ilts)
% xs and ys are vectors, everything else is single value
% this isn't done yet i need ot have a think about this properly. I am not
% sure quite how/what I want to do.

%Convert BL coords into foil geometry coords
np = length(xs) - 1;

% iunt
if iunt == 0
    iunt = 1;
else
    iunt = ipstag + 1 - iunt;
end

%iuls
if iuls == 0
    iuls = 1;
else
    iuls = ipstag + 1 - iuls;
end

%iutr
if iutr == 0
    iutr = 1;
else
    iutr = ipstag + 1 - iutr;
end

%iuts
if iuts == 0
    iuts = 1;
else
    iuts = ipstag + 1 - iunt;
end

%ilnt
if ilnt == 0
    ilnt = np+1;
else
    ilnt = ipstag + ilnt;
end

%ills
if ills == 0
    ills = np+1;
else
    ills = ipstag + ills;
end

%iltr
if iltr == 0
    iltr = np+1;
else
    iltr = ipstag + iltr;
end

%ilts
if ilts == 0
    ilts = np+1;
else
    ilts = ipstag + ilts;
end

% Plot results
hold on
plot(xs(1:iunt), ys(1:iunt), 'r')
plot(xs(1:iunt), ys(1:iunt), 'y')
plot(xs(1:iunt), ys(1:iunt), 'o')
plot(xs(1:iunt), ys(1:iunt), 'g')
plot(xs(1:iunt), ys(1:iunt), 'g')
plot(xs(1:iunt), ys(1:iunt), 'o')
plot(xs(1:iunt), ys(1:iunt), 'y')
plot(xs(1:iunt), ys(1:iunt), 'r')

axis('equal')