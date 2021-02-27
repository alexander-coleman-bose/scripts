classdef HandlerType
    %HANDLERTYPE Enumeration to specify valid types of Handler classes.
    %
    %   This class is used in Logger.addHandler to determine what Handler
    %   constructor to call.
    %
    %Enumeration Members
    %   File      - logging.FileHandler, logs to a file
    %   Listbox   - logging.ListboxHandler, logs to listbox uicontrol element
    %   Stream    - logging.Streamhandler, logs to the Command Window
    %   UIListbox - logging.UIListboxHandler, logs to uilistbox element
    %
    %See also: logging, logging.Handler,
    %   logging.Logger.addHandler, logging.StreamHandler,
    %   logging.FileHandler, logging.ListboxHandler,
    %   logging.UiListboxhandler

    % Alex Coleman

    properties (GetAccess = public, SetAccess = immutable)
        Constructor % A function handle to the constructor of the associated HandlerType
    end % Get-Public, Set-Immutable properties

    methods (Access = public)
        function obj = HandlerType(constructorHandle)
            obj.Constructor = constructorHandle;
        end % Constructor
    end % Public methods

    enumeration
        File(@logging.FileHandler) % logging.FileHandler, logs to a file
        Listbox(@logging.ListboxHandler) % logging.ListboxHandler, logs to listbox uicontrol element
        Stream(@logging.StreamHandler) % logging.Streamhandler, logs to the Command Window
        UiListbox(@logging.UiListboxHandler) % logging.UiListboxHandler, logs to uilistbox element
    end % Enumeration
end % classdef
