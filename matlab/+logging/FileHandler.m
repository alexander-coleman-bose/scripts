classdef FileHandler < logging.Handler
    %FILEHANDLER Logs to a file and inherits from logging.Handler.
    %
    %   Handlers are not meant to be used on their own, use Logger.addHandler
    %   to add a Handler to a Logger.
    %
    %Usage
    %   Add a FileHandler to the Logger that will write to a file called "test.log"
    %       logger = logging.getLogger;
    %       logger.addHandler('file', 'Name', 'test');
    %
    %   Add a FileHandler that only handles messages of Warning-level and above
    %       logger = logging.getLogger;
    %       logger.addHandler('file', 'Name', 'test', 'Level', 'warning')
    %
    %   Add a FileHandler that only writes the time of the message, not the date
    %       logger = logging.getLogger;
    %       logger.addHandler('file', 'Format', 'HH:MM:SS');
    %
    %See also: logging, logging.FileHandler.FileHandler,
    %   logging.Handler, logging.Logger.addHandler

    % Alex St. Amour

    properties (Access = public)
        Name = mfilename('class') % The name of the Handler; determines the name of the file to write to. (Default: "FileHandler")
        LogLevel = logging.LogLevel.Info % The level of the Handler. Messages below this level will be ignored by this Handler. (Default: "Info")
        DateFormat = "dd-mmm-yyyy HH:MM:SS" % Controls the format of how the log's datetime is written to the file. See also: datetime.Format. (Default: "dd-mmm-yyyy HH:MM:SS")
    end % Public properties

    properties (Access = public, Constant)
        LogExtension(1,1) string = "log" % The extension added to the Name of the Handler to determine the path of the log file. "log"
    end % Public, Constant properties

    properties (Access = public, Dependent)
        LogFile(1,1) string % [FileHandler.Name + '.' + FileHandler.LogExtension]
    end % Public, Dependent properties

    properties (GetAccess = public, SetAccess = protected)
        FileHandle % The file handle to the log file.
    end % Get-Public, Set-Protected properties

    methods (Access = public)
        function obj = FileHandler(varargin)
            %FILEHANDLER Returns a logging.FileHander object.
            %
            %Parameter Arguments
            %   Name (string-like): The name of the Handler; determines the name of the file to write to. (Default: "FileHandler")
            %   LogLevel (string-like): The level of the Handler. Messages below this level will be ignored by this Handler. (Default: "Info")
            %   DateFormat (string-like): Controls the format of how the log's datetime is written to the file. See also: datetime.Format (Default: "dd-mmm-yyyy HH:MM:SS")
            %
            %See also: logging.FileHandler,
            %   logging.Logger.addHandler, datetime.Format

            parser = inputParser;
            parser.addParameter('Name', obj.Name, @validators.mustBeStringLike);
            parser.addParameter('LogLevel', string(obj.LogLevel), @validators.mustBeStringLike);
            parser.addParameter('DateFormat', obj.DateFormat, @validators.mustBeStringLike);
            parser.parse(varargin{:});
            obj.Name = string(parser.Results.Name);
            obj.LogLevel = logging.LogLevel(parser.Results.LogLevel);
            obj.DateFormat = string(parser.Results.DateFormat);

            [obj.FileHandle, msg] = fopen(obj.LogFile, 'a');

            if obj.FileHandle == -1 || ~isempty(msg)
                error('logging:UnableToOpenFile', ...
                      'Unable to open log file (%s): %s.', obj.LogFile, msg);
            end
        end % Constructor

        function tfResult = isValid(obj)
            %ISVALID Returns true if the object is valid.
            %
            %See also: logging.FileHandler, isvalid

            tfResult = isvalid(obj) && ~isempty(obj.FileHandle) && ismember(obj.FileHandle, fopen('all'));
        end % isValid

        function processMessage(obj, msg)
            %PROCESSMESSAGE Called by Logger.log to write the message to a file.
            %
            %Required Arguments
            %   msg (struct)                            - The message struct
            %       .Level (logging.LogLevel)  - The level of the message
            %       .Timestamp (double)                 - Time in Epoch seconds when the message was logged
            %       .Message (string)                   - The message content
            %       .Error (MException)                 - An attached error, if any
            %
            %See also: logging.FileHandler

            % If the LogFile isn't open, delete this handler.
            if ~ismember(obj.FileHandle, fopen('all')) || ~isfile(obj.LogFile)
                delete(obj);
                return;
            end

            % Loop over every message in the given order
            for indMsg = 1:numel(msg)
                msgLevel = msg(indMsg).Level;
                if msgLevel >= obj.LogLevel
                    fprintf(obj.FileHandle, ...
                        '%s %s: %s\n', ...
                        datestr(msg(indMsg).Timestamp, obj.DateFormat), ...
                        upper(string(msgLevel)), ...
                        msg(indMsg).Message ...
                    );
                    if ~isempty(msg.Error)
                        fprintf(obj.FileHandle, ...
                            'ID: %s, MSG: "%s"\n', ...
                            msg.Error.identifier, ...
                            msg.Error.message ...
                        );
                        for indStack = 1:numel(msg.Error.stack)
                            fprintf(obj.FileHandle, ...
                                'FILE: %s, NAME: %s, LINE: %.0f\n', ...
                                msg.Error.stack(indStack).file, ...
                                msg.Error.stack(indStack).name, ...
                                msg.Error.stack(indStack).line ...
                            );
                        end % For the entire stack
                    end % If we have an attached error
                end % If the message satisfies the level
            end % For every message
        end % processMessage

        function delete(obj)
            %DELETE Deconstructor
            %
            %   Closes the file handle when the Handler is destroyed if it is
            %   still open.
            %
            %See also: logging.FileHandler
            if ~isempty(obj.FileHandle) && ismember(obj.FileHandle, fopen('all'))
                status = fclose(obj.FileHandle);
                if status ~= 0
                    warning( ...
                        'logging:UnableToCloseFile', ...
                        'Unable to close the log file (%s).', ...
                        obj.LogFile ...
                    );
                end
            end
        end % delete
    end % Public methods

    methods
        function val = get.LogFile(obj)
            val = string(zeros(size(obj)));
            for indObj = 1:numel(obj)
                val(indObj) = obj(indObj).Name + "." + obj(indObj).LogExtension;
            end
        end % get.LogFile
    end % Get methods
end % classdef
