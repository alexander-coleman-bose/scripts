function mustBeListbox(obj)
    %MUSTBELISTBOX Error if the input is not a non-empty uicontrol of style 'listbox'.
    %
    %Throws:
    %   InvalidInput - When the input isn't a matlab.ui.control.UIControl of Style "listbox"
    %
    %See also: validators, validators.mustBeUiListbox

    % Alex St. Amour

    if isempty(obj) || ~isa(obj, 'matlab.ui.control.UIControl') || ~strcmp(obj.Style, 'listbox')
        errorId = 'validators:mustBeListbox:InvalidInput';
        error(errorId, 'Input must be a non-empty uicontrol of style listbox.');
    end
end
