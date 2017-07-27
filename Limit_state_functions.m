% LIMIT STATE FUNCTIONS AND PARTIAL DERIVATIVES
%% LC1 - only Q1
gfundata(1).parameter = 'yes';
gfundata(1).expression = 'gfundata(1).thetag(1)*gfundata(1).thetag(4)*x(1)*x(2)-gfundata(1).thetag(2)*x(3)-(1-gfundata(1).thetag(2))*(gfundata(1).thetag(3)*x(4)*x(6))';
% Give explicit gradient expressions with respect to the involved quantities (in the order x(1), x(2), ...) if DDM is used:
gfundata(1).dgdq = { 'gfundata(1).thetag(1)*gfundata(1).thetag(4)*x(2)' ;
    'gfundata(1).thetag(1)*gfundata(1).thetag(4)*x(1)';
    '-gfundata(1).thetag(2)';
    '-(1-gfundata(1).thetag(2))*gfundata(1).thetag(3)*x(6)';
    '0';
    '-(1-gfundata(1).thetag(2))*gfundata(1).thetag(3)*x(4)';
    '0';
    '0';
    '0';
    '0';
    '0'};
% Give explicit gradient expressions with respect to the limit-state function parameters
%(in the order thetag(1), thetag(2), ...) if DDM is used:
gfundata(1).dgthetag = {'gfundata(1).thetag(4)*x(1)*x(2)';
    'gfundata(1).thetag(3)*x(4)*x(6)-x(3)';
    '-(1-gfundata(1).thetag(2))*x(6)*x(4)';
    'gfundata(1).thetag(1)*x(1)*x(2)'};
%% LC2 - only Q2
gfundata(2).parameter = 'yes';
gfundata(2).expression = 'gfundata(2).thetag(1)*gfundata(2).thetag(4)*x(1)*x(2)-gfundata(2).thetag(2)*x(3)-(1-gfundata(2).thetag(2))*((1-gfundata(2).thetag(3))*x(5)*x(7))';
% Give explicit gradient expressions with respect to the involved quantities (in the order x(1), x(2), ...) if DDM is used:
gfundata(2).dgdq = { 'gfundata(2).thetag(1)*gfundata(2).thetag(4)*x(2)' ;
    'gfundata(2).thetag(1)*gfundata(2).thetag(4)*x(1)';
    '-gfundata(2).thetag(2)';
    '0';
    '-(1-gfundata(2).thetag(2))*(1-gfundata(2).thetag(3))*x(7)';
    '0';
    '-(1-gfundata(2).thetag(2))*(1-gfundata(2).thetag(3))*x(5)';
    '0';
    '0';
    '0';
    '0'};
% Give explicit gradient expressions with respect to the limit-state function parameters
%(in the order thetag(1), thetag(2), ...) if DDM is used:
gfundata(2).dgthetag = {'gfundata(2).thetag(4)*x(1)*x(2)';
    '(1-gfundata(2).thetag(3))*x(5)*x(7)-x(3)';
    '(1-gfundata(2).thetag(2))*x(5)*x(7)';
    'gfundata(2).thetag(1)*x(1)*x(2)'};
%% LC3 - Q1 leading Q2 accompanying
gfundata(3).parameter = 'yes';
gfundata(3).expression = 'gfundata(3).thetag(1)*gfundata(3).thetag(4)*x(1)*x(2)-gfundata(3).thetag(2)*x(3)-(1-gfundata(3).thetag(2))*(  gfundata(3).thetag(3)*x(4)*x(8) + (1-gfundata(3).thetag(3))*x(5)*x(9)   )';
% Give explicit gradient expressions with respect to the involved quantities (in the order x(1), x(2), ...) if DDM is used:
gfundata(3).dgdq = { 'gfundata(3).thetag(1)*gfundata(3).thetag(4)*x(2)' ;
    'gfundata(3).thetag(1)*gfundata(3).thetag(4)*x(1)';
    '-gfundata(3).thetag(2)';
    '-(1-gfundata(3).thetag(2))*gfundata(3).thetag(3)*x(8)';
    '-(1-gfundata(3).thetag(2))*(1-gfundata(3).thetag(3))*x(9)';
    '0';
    '0';
    '-(1-gfundata(3).thetag(2))*gfundata(3).thetag(3)*x(4)';
    '-(1-gfundata(3).thetag(2))*(1-gfundata(3).thetag(3))*x(5)';
    '0';
    '0'};
% Give explicit gradient expressions with respect to the limit-state function parameters
%(in the order thetag(1), thetag(2), ...) if DDM is used:
gfundata(3).dgthetag = {'gfundata(3).thetag(4)*x(1)*x(2)';
    '(1-gfundata(3).thetag(3))*x(5)*x(9)-x(3)+gfundata(3).thetag(3)*x(4)*x(8)';
    '(1-gfundata(3).thetag(2))*(x(4)*x(8)-x(5)*x(9))';
    'gfundata(3).thetag(1)*x(1)*x(2)'};
%% LC4 - Q2 leading Q1 accompanying
gfundata(4).parameter = 'yes';
gfundata(4).expression = 'gfundata(4).thetag(1)*gfundata(4).thetag(4)*x(1)*x(2)-gfundata(4).thetag(2)*x(3)-(1-gfundata(4).thetag(2))*(  gfundata(4).thetag(3)*x(4)*x(10) + (1-gfundata(4).thetag(3))*x(5)*x(11)   )';
% Give explicit gradient expressions with respect to the involved quantities (in the order x(1), x(2), ...) if DDM is used:
gfundata(4).dgdq = { 'gfundata(4).thetag(1)*gfundata(4).thetag(4)*x(2)' ;
    'gfundata(4).thetag(1)*gfundata(4).thetag(4)*x(1)';
    '-gfundata(4).thetag(2)';
    '-(1-gfundata(4).thetag(2))*gfundata(4).thetag(3)*x(10)';
    '-(1-gfundata(4).thetag(2))*(1-gfundata(4).thetag(3))*x(11)';
    '0';
    '0';
    '0';
    '0';
    '-(1-gfundata(4).thetag(2))*gfundata(4).thetag(3)*x(4)';
    '-(1-gfundata(4).thetag(2))*(1-gfundata(4).thetag(3))*x(5)'};
% Give explicit gradient expressions with respect to the limit-state function parameters
%(in the order thetag(1), thetag(2), ...) if DDM is used:
gfundata(4).dgthetag = {'gfundata(4).thetag(4)*x(1)*x(2)';
    '(1-gfundata(4).thetag(3))*x(5)*x(11)-x(3)+gfundata(4).thetag(3)*x(4)*x(10)';
    '-(1-gfundata(4).thetag(2))*(x(4)*x(10)-x(5)*x(11))';
    'gfundata(4).thetag(1)*x(1)*x(2)'};
%% LC5 - only G
gfundata(5).parameter = 'yes';
gfundata(5).expression = 'gfundata(5).thetag(1)*gfundata(5).thetag(4)*x(1)*x(2)-gfundata(5).thetag(2)*x(3)';
% Give explicit gradient expressions with respect to the involved quantities (in the order x(1), x(2), ...) if DDM is used:
gfundata(5).dgdq = { 'gfundata(5).thetag(1)*gfundata(5).thetag(4)*x(2)' ;
    'gfundata(5).thetag(1)*gfundata(5).thetag(4)*x(1)';
    '-gfundata(5).thetag(2)';
    '0';
    '0';
    '0';
    '0';
    '0';
    '0';
    '0';
    '0'};
% Give explicit gradient expressions with respect to the limit-state function parameters
%(in the order thetag(1), thetag(2), ...) if DDM is used:
gfundata(5).dgthetag = {'gfundata(5).thetag(4)*x(1)*x(2)';
    '-x(3)';
    '0';
    'gfundata(5).thetag(1)*x(1)*x(2)'};