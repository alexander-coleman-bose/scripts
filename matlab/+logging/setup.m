function obj = setup(varargin)
    %SETUP Returns the Logger, and adds a StreamHandler if there isn't one yet.
    %
    %   This function is the quickest way to configure the logging package and
    %   start logging messages. It is not recommended to use this function in
    %   classes or in multiple places, since it will overwrite the properties
    %   of any existing StreamHandlers, but it can be very helpful in scripts
    %   or other entrypoints.
    %
    %   The most convenient way to get access to the Logger without changing
    %   any properties of the Logger and its Handlers is to use
    %   logging.getLogger().
    %
    %Usage
    %   Get the Logger and a StreamHandler so that logged messages will go to
    %   the Command Window
    %       logger = logging.setup;
    %
    %   Get the Logger and a StreamHandler that will only log messages of
    %   Warning-level and above.
    %       logger = logging.setup('warning');
    %
    %   Get the Logger and a StreamHandler that display the message dates and
    %   times
    %       logger = logging.setup('info', 'dd-mmm-yyyy HH:MM:SS')
    %
    %Optional Arguments
    %   logLevel (string-like): Sets the Logger and the StreamHandler to this Level. (Default: "Info")
    %   dateFormat (string-like): Sets the StreamHandler to this date format. See datetime.Format. (Default: "HH:MM:SS")
    %
    %See also: logging, logging.getLogger,
    %   logging.Logger, datetime.Format

    % Alex St. Amour

    parser = inputParser;
    parser.addOptional('logLevel', string(logging.LogLevel.Info), @validators.mustBeStringLike);
    parser.addOptional('dateFormat', 'HH:MM:SS', @validators.mustBeStringLike);
    parser.parse(varargin{:});
    logLevelString = parser.Results.logLevel;
    dateFormat = string(parser.Results.dateFormat);

    obj = logging.Logger.getLogger;
    obj.LogLevel = logLevelString;

    % Only add a new StreamHandler if there isn't one already.
    handlerTypes = arrayfun(@class, obj.Handlers, 'UniformOutput', false);
    streamHandlerMask = contains(handlerTypes, 'Stream');
    if ~any(streamHandlerMask)
        obj.addHandler('stream', ...
            'LogLevel', logLevelString, ...
            'DateFormat', dateFormat);
    else
        obj.Handlers(streamHandlerMask).LogLevel = logLevelString;
    end
end % function
