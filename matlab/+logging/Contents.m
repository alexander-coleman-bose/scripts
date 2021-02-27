%logging Library
%
%   Logging classes.
%
%Classes
%   FileHandler      - Logs to a file and inherits from logging.Handler.
%   Handler          - Abstract, Heterogeneous base class for determining how messages are processed.
%   HandlerType      - Enumeration to specify valid types of Handler classes.
%   ListboxHandler   - Logs to a listbox uicontrol element and inherits from logging.Handler.
%   Logger           - Logging class for MATLAB.
%   LogLevel         - Enumeration to define valid log message priorities.
%   StreamHandler    - Logs to the MATLAB Command Window and inherits from logging.Handler.
%   UiListboxHandler - Logs to a uilistbox element and inherits from logging.Handler.
%
%Functions
%   getLogger       - Returns a handle to the unique, Singleton Logger object.
%   setup           - Returns the Logger, and adds a StreamHandler if there isn't one yet.
