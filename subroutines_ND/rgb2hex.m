% (c) JN Kather 2015

function hex = rgb2hex(rgb)

% expects a vector of three elements of RGB color values between 0 and 1.
% Returns a string containing the hex code of the color.

    r = uint8(rgb(1)*255);
    g = uint8(rgb(2)*255);
    b = uint8(rgb(3)*255);
    
    hex = strcat(dec2hex(r,2), dec2hex(g,2), dec2hex(b,2));

end