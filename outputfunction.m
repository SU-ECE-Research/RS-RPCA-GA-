function [state, options,optchanged] = outputfunction(options,state,flag)
%displays the function eval value at each iteration. You can change this
%disp(state.FunEval);
assignin('base','fcnStatus',state)
dt = datestr(now,'mmmm-dd-yyyy_HH_MM_SS');
name = strcat('/Log/',dt,'_Generation');
Filename = sprintf('%s_%d',[pwd name],state.Generation);
save(Filename,'state')
optchanged = false;
switch flag
 case 'init'
        disp('Starting the algorithm');
    case {'iter','interrupt'}
        disp('Iterating ... generation');
        disp( state.Generation);
    case 'done'
        disp('Performing final task');
end