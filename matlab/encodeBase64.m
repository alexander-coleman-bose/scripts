function encodedVal = encodeBase64(varargin)
    %ENCODEBASE64 Encode a numeric into a Base 64 string.
    %
    %Usage:
    %   Encode an array of doubles (Should return 'AAAAAAAA8D8AAAAAAAAAQAAAAAAAAAhAAAAAAAAAEEA=')
    %
    %       encodeBase64([1, 2, 3, 4])
    %
    %Required Arguments:
    %   decodedVal (string-like): String to encode.
    %
    %See also: decodeBase64, typecast, matlab.net.base64encode

    % Alex St. Amour

    parser = inputParser;
    parser.addRequired('decodedVal', @mustBeReal);
    parser.addOptional('varType', 'double', ...
        @validators.mustBeStringLike);
    parser.parse(varargin{:});
    decodedVal = typecast(parser.Results.decodedVal, 'uint8');
    encodedVal = matlab.net.base64encode(decodedVal);
end % function
