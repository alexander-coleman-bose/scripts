function result = isStringLike(obj)
    %ISSTRINGLIKE Returns true if input is a string, char, or cellstr.
    %
    %See also: validators

    result = isstring(obj) || ischar(obj) || iscellstr(obj);
end
