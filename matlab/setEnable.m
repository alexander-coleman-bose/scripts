function setEnable(obj, onOff)
    %SETENABLE Set 'Enable' for every property of this App.
    %
    %   With App Designer Apps, every UIFigure element is stored as a property of
    %   the App.
    %
    %Usage:
    %   app = MyApp;
    %   setEnable(app, true);
    %
    %Required Positional Arguments:
    %   obj (matlab.apps.AppBase): App to set Enable for.
    %   onOff (logical): True or False, sets Enable to this value.

    % Alex St. Amour

    narginchk(2, 2);
    mustBeNumericOrLogical(onOff);

    % Conversion to char required for UITables in R2018b
    onOff = logical(onOff);
    if onOff
        onOff = 'on';
    else
        onOff = 'off';
    end

    for indObj = 1:numel(obj)
        if isvalid(obj(indObj))
            objProperties = properties(obj(indObj));
            for indProp = 1:numel(objProperties)
                isProp = isprop(obj(indObj).(objProperties{indProp}), 'Enable');
                if ~isempty(isProp) && all(isProp(:))
                    obj(indObj).(objProperties{indProp}).Enable = onOff;
                end
            end % for every property
        end
    end % for every app

    % Drawnow to immediately show the disabled/enabled elements
    drawnow; %FIXME(ALEX): limitrate?
end % function
