function decodedVal = decodeBase64(varargin)
    %DECODEBASE64 Decode a Base 64 string and typecast to a numeric type.
    %
    %Usage:
    %   Decode an array of doubles (Should return [1, 2, 3, 4])
    %
    %       decodeBase64('AAAAAAAA8D8AAAAAAAAAQAAAAAAAAAhAAAAAAAAAEEA=', 'double')
    %
    %Required Arguments:
    %   encodedVal (string-like): String to decode.
    %
    %Optional Arguments:
    %   varType (string-like): Type to typecast the decoded value to. (Default: 'double');
    %
    %See also: encodeBase64, typecast, matlab.net.base64decode

    % Alex St. Amour

    parser = inputParser;
    parser.addRequired('encodedVal', @validators.mustBeStringLike);
    parser.addOptional('varType', 'double', ...
        @validators.mustBeStringLike);
    parser.parse(varargin{:});
    encodedVal = string(parser.Results.encodedVal);
    varType = string(parser.Results.varType);
    decodedVal = typecast(matlab.net.base64decode(encodedVal), varType);
end % function
