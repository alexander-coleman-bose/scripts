function obj = getLogger
    %GETLOGGER Returns a handle to the unique, Singleton Logger object.
    %
    %   This function is a convenience function that calls
    %   logging.Logger.getLogger and returns the Logger;
    %
    %See also: logging, logging.Logger.getLogger

    % Alex Coleman

    obj = logging.Logger.getLogger;
end % function
