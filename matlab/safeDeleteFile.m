function safeDeleteFile(fileName, varargin)
    %SAFEDELETEFILE Attempt to delete a file, but convert any errors to warnings.

    % Alex St. Amour

    parser = inputParser;
    parser.addRequired('fileName');
    parser.addOptional('fileHandle', []);
    parser.parse(fileName, varargin{:});
    fileName = parser.Results.fileName;
    fileHandle = parser.Results.fileHandle;

    % Try to close the file first if a file handle is given
    if ~isempty(fileHandle) && ismember(fileHandle, fopen('all'))
        try
            fclose(fileHandle);
        catch ME
            warning( ...
                'safeDeleteFile', ...
                'Could not close handle (%s) to file (%s): %s', ...
                fileHandle, ...
                fileName, ...
                ME.message ...
            );
        end
    end

    try
        delete(fileName);
    catch ME
        warning( ...
            'safeDeleteFile', ...
            'Could not delete %s: %s', ...
            fileName, ...
            ME.message ...
        );
    end
end % function
