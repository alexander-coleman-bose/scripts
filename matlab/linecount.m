function n = linecount(fileName)
    %LINECOUNT Counts the number of lines in a file.
    %
    %   Inspired by https://www.mathworks.com/matlabcentral/answers/81137-pre-determining-the-number-of-lines-in-a-text-file#answer_90858

    fid = fopen(fileName, 'r');
    n = 0;
    tline = fgetl(fid);
    while ischar(tline)
        tline = fgetl(fid);
        n = n+1;
    end
    fclose(fid);
end % function
