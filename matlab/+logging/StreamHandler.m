classdef StreamHandler < logging.Handler
    %STREAMHANDLER Logs to the MATLAB Command Window and inherits from logging.Handler.
    %
    %   Handlers are not meant to be used on their own, use Logger.addHandler
    %   to add a Handler to a Logger.
    %
    %Usage
    %   Add a StreamHandler to the Logger
    %       logger = logging.getLogger;
    %       logger.addHandler('stream');
    %
    %   Add a StreamHandler ('StreamHandler1') that only handles messages of
    %   Warning-level and above
    %       logger = logging.getLogger;
    %       logger.addHandler('stream', 'Name', 'StreamHandler1', 'Level', 'warning')
    %
    %   Add a StreamHandler that the dates and times of messages
    %       logger = logging.getLogger;
    %       logger.addHandler('stream', 'Format', 'dd-mmm-yyy HH:MM:SS');
    %
    %See also: logging, logging.StreamHandler.StreamHandler,
    %   logging.Handler, logging.Logger.addHandler

    % Alex St. Amour

    properties (Access = public)
        Name = mfilename('class') % The Name of the Handler, used to determine whether a Handler is unique. (Default: "StreamHandler")
        LogLevel = logging.LogLevel.Info % The level of the Handler. Messages below this level will be ignored by this Handler. (Default: "Info")
        DateFormat = "HH:MM:SS" % Controls the format of how the log's datetime is written to the Command Window. See also: datetime.Format. (Default: "HH:MM:SS")
    end

    methods (Access = public)
        function obj = StreamHandler(varargin)
            %STREAMHANDLER Returns a logging.StreamHandler object.
            %
            %Parameter Arguments
            %   Name (string-like): The Name of the Handler, used to determine whether a Handler is unique. (Default: "StreamHandler")
            %   LogLevel (string-like): The level of the Handler. Messages below this level will be ignored by this Handler. (Default: "Info")
            %   DateFormat (string-like): Controls the format of how the log's datetime is written to the Command Window. See also: datetime.Format (Default: "HH:MM:SS")
            %
            %See also: logging.StreamHandler,
            %   logging.Logger.addHandler, datetime.Format

            parser = inputParser;
            parser.addParameter('Name', obj.Name, @validators.mustBeStringLike);
            parser.addParameter('LogLevel', string(obj.LogLevel), @validators.mustBeStringLike);
            parser.addParameter('DateFormat', obj.DateFormat, @validators.mustBeStringLike);
            parser.parse(varargin{:});
            obj.Name = string(parser.Results.Name);
            obj.LogLevel = logging.LogLevel(parser.Results.LogLevel);
            obj.DateFormat = string(parser.Results.DateFormat);
        end % Constructor

        function tfResult = isValid(obj)
            %ISVALID Returns true if the object is valid.
            %
            %See also: logging.StreamHandler, isvalid

            tfResult = isvalid(obj);
        end % isValid

        function processMessage(obj, msg)
            %PROCESSMESSAGE Called by Logger.log to write the message to the Command Window.
            %
            %   Messages of Warning-level and above are sent to the second
            %   stream of the Command Window, which colors the text the same as
            %   MATLAB errors.
            %
            %Required Arguments
            %   msg (struct)                            - The message struct
            %       .Level (logging.LogLevel)  - The level of the message
            %       .Timestamp (double)                 - Time in Epoch seconds when the message was logged
            %       .Message (string)                   - The message content
            %       .Error (MException)                 - An attached error, if any
            %
            %See also: logging.StreamHandler

            % Loop over every message in the given order
            for indMsg = 1:numel(msg)
                msgLevel = msg(indMsg).Level;
                if msgLevel >= obj.LogLevel
                    if msgLevel >= logging.LogLevel.Warning
                        fileId = 2;
                    else
                        fileId = 1;
                    end
                    fprintf(fileId, ...
                        '%s %s: %s\n', ...
                        datestr(msg(indMsg).Timestamp, obj.DateFormat), ...
                        upper(string(msgLevel)), ...
                        msg(indMsg).Message ...
                    );
                end
            end % For every message
        end % processMessage
    end % Public methods
end % classdef
