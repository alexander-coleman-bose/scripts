classdef Logger < handle
    %LOGGER Logging class for MATLAB.
    %
    %   This class provides basic logging functionality in MATLAB, and can be used
    %   to send log messages of various levels to multiple endpoints, including
    %   GUIs, files, and the MATLAB Command Window.
    %
    %   Additionally, this class follows a "Singleton" pattern, meaning that no
    %   matter where it is instantiated, all instantiations of this class point to
    %   the same object, meaning that once a Logger is created and Handlers are
    %   attached to it, any MATLAB class can use the Logger without having to setup
    %   the handlers every time.
    %
    %GETTING STARTED
    %
    %   To start using the Logging module, run the following command, which will
    %   give you access to the logger and add a StreamHandler, which will send log
    %   messages to the MATLAB Command Window. The input argument to logging.setup
    %   sets the level of the Logger to "Info". See "LOGGING LEVELS" below for an
    %   explanation of how levels control the flow of messages.
    %
    %       logger = logging.setup('info');
    %
    %   Once you have a handle to the Logger, you can send messages using the
    %   "debug", "info", "warning", and "error" methods. The method used determines
    %   the level of the message sent to the Logger.
    %
    %       logger.info('This is an Info-level message');
    %       logger.debug('This is a Debug-level message, and will be ignored if the Logger level is Info or above');
    %       logger.warning('This is a Warning-level message');
    %
    %   The "error" method is special in that it can also take an MException object
    %   as an additional argument. Depending on the Handler that processes the
    %   message, additional information about the MException object.
    %
    %       mError = MException('error:id', 'error message');
    %       logger.error('This is an Error-level message', mError);
    %
    %   You can also add Handlers to a Logger. When a message is logged, it is sent
    %   to all Handlers to be handled. The lines below add a File Handler so that
    %   log messages can be sent to a file called "test.log".
    %
    %       logger.addHandler('file', 'Name', 'test');
    %
    %LOGGING LEVELS
    %
    %   Debug < Info < Warning < Error
    %
    %   The Logger, Handlers, and log messages have "Levels", which allow messages
    %   to be filtered so that only messages of a certain level/priority will be
    %   handled by certain handlers. For example, you might want every message
    %   including debug messages to be written to a log file, while only displaying
    %   warnings and errors in the Command Window. When a message is logged, the
    %   message's level is compared to that of the Logger. If the message's level
    %   is less than that of the Logger, it is not logged. The message is then sent
    %   to the Handlers attached to the Logger. For any Handler, if the message is
    %   less than the level of the Handler, it will not be handled by that Handler.
    %
    %See also: logging, logging.setup,
    %   logging.getLogger, logging.Logger.addHandler,
    %   logging.LogLevel

    % Alex Coleman

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PROPERTIES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Access = public)
        LogLevel(1,1) logging.LogLevel = logging.LogLevel.Info % Messages below this level will be ignored
    end % Public Properties

    properties (GetAccess = public, SetAccess = protected)
        Handlers(:,1) logging.Handler = logging.StreamHandler % An array of Handlers currently attached to the Logger
        Messages(:,1) struct = struct('Timestamp', {}, 'Level', {}, 'Message', {}, 'Error', {}) % An array of all messages received since the beginning of the log
    end % Get-Public, Set-Protected properties

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % EVENTS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    events
        LogCleared % Sent when the log is deleted or when cleared by clearLog()
        HandlersCleared % Sent when the log is deleted or when the Handlers are cleared by clearHandlers()
    end % Events

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PUBLIC METHODS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = public)
        function thisHandler = addHandler(obj, handlerType, varargin)
            %ADDHANDLER Adds a Handler to the Logger.
            %
            %   Constructs a Handler of the specified type, checks to see if it is unique
            %   for this Logger, then adds it to the Logger if it is unique by Handler.Name
            %   and handlerType.
            %
            %Usage:
            %   Add a StreamHandler
            %       logger = logging.getLogger;
            %       logger.addHandler('stream');
            %
            %   Add a FileHandler to write to "test.log" and return the Handler
            %       logger = logging.getLogger;
            %       handler = logger.addHandler('file', 'Name', 'test');
            %
            %Required Positional Arguments:
            %   handlerType (string-like): The name of a type of handler.
            %
            %Optional Positional Arguments:
            %   Additional arguments are passed to the Handler constructor.
            %
            %See also: logging.Logger, logging.HandlerType

            parser = inputParser;
            parser.addRequired('handlerType', ...
                               @validators.mustBeStringLike);
            parser.parse(handlerType);
            handlerType = ...
                logging.HandlerType(parser.Results.handlerType);

            % Check all Handlers for validity, and remove invalid Handlers
            validHandlers = arrayfun(@isValid, obj.Handlers);
            arrayfun(@delete, obj.Handlers(~validHandlers), 'UniformOutput', false);
            obj.Handlers = obj.Handlers(validHandlers);

            % Only add the handler to the logger if it has a unique name.
            % FileHandlers to different files should have different names.
            thisHandler = feval(handlerType.Constructor, varargin{:});
            matchingHandler = strcmp([obj.Handlers.Name], thisHandler.Name);
            if ~any(matchingHandler)
                obj.Handlers = [obj.Handlers; thisHandler];
            else
                if isvalid(thisHandler)
                    delete(thisHandler);
                end
                thisHandler = obj.Handlers(matchingHandler);
            end
        end % addHandler

        function clearLog(obj)
            %CLEARLOG Clears all log messages stored in the Logger, sends LogCleared event.
            %
            %Events
            %   LogCleared - When this method is run.
            %
            %See also: logging.Logger

            obj.Messages(:) = [];
            notify(obj, 'LogCleared');
        end % clearLog

        function clearHandlers(obj)
            %CLEARHANDLERS Clears all Handlers attached to the Logger, sends HandlersCleared event.
            %
            %Events:
            %   HandlersCleared - When this method is run.
            %
            %See also: logging.Logger

            arrayfun(@delete, obj.Handlers, 'UniformOutput', false);
            obj.Handlers = logging.Handler.empty;
            notify(obj, 'HandlersCleared');
        end % clearHandlers

        function delete(obj)
            %DELETE logging.Logger destructor.
            %
            %Events
            %   LogCleared      - When this method is run.
            %   HandlersCleared - When this method is run.
            %
            %See also: logging.Logger
            notify(obj, 'LogCleared');
            notify(obj, 'HandlersCleared');
        end % delete

        function log(obj, varargin)
            %LOG Logs a message of a given type.
            %
            %   This function is a generic interface to log messages, and is used by
            %   the debug(), info(), warning(), and error() methods.
            %
            %   If an MException is attached to the log message, it is thrown or rethrown
            %   as appropriate after the message has been sent to all Handlers.
            %
            %   When log() is called, the message is passed on to all valid Handlers
            %   attached to the Logger. If an invalid Handler is found, it is removed from
            %   the Logger.
            %
            %Usage:
            %   Send an info-level message
            %       logger = logging.getLogger;
            %       logger.log(logging.LogLevel.Info, 'info-level message');
            %
            %   Send an error-level message with attached error
            %       logger = logging.getLogger;
            %       mError = MException('error:id', 'error message');
            %       logger.log(logging.LogLevel.Error, 'error-level message', mError);
            %
            %Required Positional Arguments:
            %   LogLevel (logging.LogLevel): The level of the message.
            %   Message (string-like): The log message.
            %
            %Optional Positional Arguments:
            %   Error (MException): An error to attach to the log message that will be
            %       thrown at the end of the method. (Default: MException.empty)
            %
            %See also: logging.Logger, logging.getLogger,
            %   logging.Logger.debug, logging.Logger.info,
            %   logging.Logger.warning, logging.Logger.error

            parser = inputParser;
            parser.addRequired('LogLevel');
            parser.addRequired('Message', @validators.mustBeStringLike);
            parser.addOptional('Error', MException.empty);
            parser.parse(varargin{:});

            % If the log message is a lower level that the logger, skip the message.
            if parser.Results.LogLevel < obj.LogLevel
                return
            end

            newMessage = struct( ...
                'Timestamp', now, ...
                'Level', parser.Results.LogLevel, ...
                'Message', parser.Results.Message, ...
                'Error', parser.Results.Error ...
            );
            obj.Messages = [obj.Messages; newMessage];

            % Check all Handlers for validity, and remove invalid Handlers
            validHandlers = arrayfun(@isValid, obj.Handlers);
            arrayfun(@delete, obj.Handlers(~validHandlers), 'UniformOutput', false);
            obj.Handlers = obj.Handlers(validHandlers);

            % For every handler, process the message
            arrayfun(@(x)processMessage(x, newMessage), obj.Handlers);
        end % log

        function debug(obj, message)
            %DEBUG Log a debug-level message.
            %
            %   Uses logging.Logger.log to log a debug-level message.
            %
            %Usage:
            %   Log a message with a level of Debug
            %       logger = logging.getLogger;
            %       logger.debug('Message here');
            %
            %Required Positional Arguments:
            %   message (string-like): The log message.
            %
            %See also: logging.Logger, logging.getLogger,
            %   logging.Logger.log

            obj.log(logging.LogLevel.Debug, message);
        end % debug

        function info(obj, message)
            %INFO Log an info-level message.
            %
            %   Uses logging.Logger.log to log an info-level message.
            %
            %Usage:
            %   Log a message with a level of Info
            %       logger = logging.getLogger;
            %       logger.info('Message here');
            %
            %Required Positional Arguments:
            %   message (string-like): The log message.
            %
            %See also: logging.Logger, logging.getLogger,
            %   logging.Logger.log

            obj.log(logging.LogLevel.Info, message);
        end % info

        function warning(obj, message)
            %WARNING Log a warning-level message.
            %
            %   Uses logging.Logger.log to log a warning-level message.
            %
            %Usage:
            %   Log a message with a level of Warning
            %       logger = logging.getLogger;
            %       logger.warning('Message here');
            %
            %Required Positional Arguments:
            %   message (string-like): The log message.
            %
            %See also: logging.Logger, logging.getLogger,
            %   logging.Logger.log

            obj.log(logging.LogLevel.Warning, message);
        end % warning

        function error(obj, message, varargin)
            %ERROR Log an error-level message.
            %
            %   Uses logging.Logger.log to log an error-level message. If an
            %   MException object is attached it will be thrown after the message is sent
            %   to all Handlers.
            %
            %Usage:
            %   Log a message with a level of Error
            %       logger = logging.getLogger;
            %       logger.error('Message here', mError);
            %
            %   Log a message with an attached MException to throw
            %       logger = logging.getLogger;
            %       mError = MException('error:id', 'error message');
            %       logger.error('Message here', mError);
            %
            %Required Positional Arguments:
            %   message (string-like): The log message.
            %
            %Optional Positional Arguments:
            %   mError (MException): A MATLAB error to (re)throw after logging the message.
            %
            %See also: logging.Logger, logging.getLogger,
            %   logging.Logger.log

            parser = inputParser;
            parser.addOptional('mError', MException.empty);
            parser.parse(varargin{:});
            mError = parser.Results.mError;

            obj.log(logging.LogLevel.Error, message, mError);

            % If an error is attached, throw it as appropriate
            if ~isempty(mError)
                try
                    rethrow(mError);
                catch ME
                    if strcmp(ME.identifier, 'MATLAB:MException:rethrow:uncaughtException')
                        throwAsCaller(mError);
                    else
                        ME = ME.addCause(mError);
                        rethrow(ME);
                    end
                end %try/catch
            end % ~isempty(parser.Results.Error)
        end % error
    end % Public methods

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PROTECTED CONSTRUCTOR
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = protected)
        function obj = Logger
            %LOGGER Returns a logging.Logger object.
            %
            %See also: logging.Logger,
            %   logging.Logger.getLogger
        end % Constructor
    end % Protected constructor

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % STATIC CONSTRUCTOR
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Static)
        function obj = getLogger
            %GETLOGGER Returns a handle to the unique, Singleton Logger object.
            %
            %See also: logging.Logger
            persistent uniqueInstance

            if isempty(uniqueInstance) || ~isvalid(uniqueInstance)
                uniqueInstance = logging.Logger;
            end

            obj = uniqueInstance;
        end % getLogger
    end % Static constructor
end % classdef
