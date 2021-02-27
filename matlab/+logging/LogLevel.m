classdef LogLevel
    %LogLevel Enumeration to define valid log message priorities.
    %
    %   LogLevels are used to control the flow of messages. If the message to
    %   be logged has a level that is lower than the level of the Logger or a
    %   Handler, it will be ignored. For example, we could configure our Logger
    %   and Handlers to send all log messages -- including debug messages -- to
    %   a file, while only sending messages of Warning-level and above to the
    %   Command Window.
    %
    %   LogLevels have an associated numeric value, so comparative logical
    %   operators like eq (==), lt (<), and gt (>) can be used to compare
    %   multiple LogLevel objects.
    %
    %Enumeration Members
    %   Debug (10)
    %   Info (20)
    %   Warning (30)
    %   Error (40)
    %
    %See also: logging

    % Alex Coleman

    properties (GetAccess = public, SetAccess = immutable)
        Value(1,1) double % The numeric value of the LogLevel.
    end % Get-Public, Set-Immutable properties

    methods (Access = public)
        function obj = LogLevel(thisValue)
            obj.Value = thisValue;
        end

        function results = eq(obj, comparedObj)
            [thisValue, comparedValue] = local_prepBoolFunction(obj, comparedObj);
            results = thisValue == comparedValue;
        end

        function results = ne(obj, comparedObj)
            [thisValue, comparedValue] = local_prepBoolFunction(obj, comparedObj);
            results = thisValue ~= comparedValue;
        end

        function results = lt(obj, comparedObj)
            [thisValue, comparedValue] = local_prepBoolFunction(obj, comparedObj);
            results = thisValue < comparedValue;
        end

        function results = le(obj, comparedObj)
            [thisValue, comparedValue] = local_prepBoolFunction(obj, comparedObj);
            results = thisValue <= comparedValue;
        end

        function results = gt(obj, comparedObj)
            [thisValue, comparedValue] = local_prepBoolFunction(obj, comparedObj);
            results = thisValue > comparedValue;
        end

        function results = ge(obj, comparedObj)
            [thisValue, comparedValue] = local_prepBoolFunction(obj, comparedObj);
            results = thisValue >= comparedValue;
        end
    end % Public properties

    methods (Access = public, Static)
        function obj = fromValue(values)
            %FROMVALUE Returns a LogLevel that most closely matches a value.
            %
            %   The given value is rounded down to the nearest valid Level.
            %
            %Required Arguments
            %   values (numeric): Return a LogLevel that most closely matches this value.
            %
            %See also: logging.LogLevel

            values = double(values);

            validEnums = enumeration('logging.LogLevel');
            validValues = [validEnums.Value];

            obj = logging.LogLevel.empty;
            for indValue = 1:numel(values)
                enumMask = validValues == 10*floor(values(indValue)/10);
                levelName = string(validEnums(enumMask));
                logLevel = logging.LogLevel(levelName);
                obj = [obj; logLevel];
            end
        end % fromValue
    end % Public, Static methods

    enumeration
        % Trace(0)
        Debug(10)
        Info(20)
        Warning(30)
        Error(40)
        % Critical(50)
    end % enumeration
end % classdef

function [thisValue, comparedValue] = local_prepBoolFunction(obj, comparedObj)
    %LOCAL_PREPBOOLFUNCTION Allows ambiguity between numerics/LogLevels in logical comparison operators.

    if isa(obj, 'logging.LogLevel')
        thisValue = [obj.Value];
    else
        thisValue = obj;
    end
    if isa(comparedObj, 'logging.LogLevel')
        comparedValue = [comparedObj.Value];
    else
        comparedValue = comparedObj;
    end
end % local_prepBoolFunction
