function mustBeStringLike(obj)
    %MUSTBESTRINGLIKE Error if the input is not a string, char, or cellstr.
    %
    %Throws:
    %   InvalidInput - When the input isn't a cellstr, char, or string.
    %
    %See also: validators, validator.isStringLike

    if ~isStringLike(obj)
        errorId = 'validators:mustBeStringLike:InvalidInput';
        error(errorId, 'Input must be a string, char, or cellstr.');
    end
end
