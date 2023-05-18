function mustBeUiListbox(obj)
    %MUSTBEUILISTBOX Error if the input is not a 'matlab.ui.control.ListBox'.
    %
    %Throws:
    %   InvalidInput - When the input isn't a matlab.ui.control.ListBox.
    %
    %See also: validators, validators.mustBeListbox

    % Alex St. Amour

    if ~isa(obj, 'matlab.ui.control.ListBox')
        errorId = 'validators:mustBeUiListbox:InvalidInput';
        error(errorId, 'Input must be a ''matlab.ui.controll.ListBox''.');
    end
end
