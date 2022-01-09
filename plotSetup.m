function plotSetup()
%% Plot parameters
set(0, 'defaultFigurePosition',  [100, 100, 1400, 800])

myred           = [216 30 49]/255;
myblue          = [27 99 157]/255;
myblack         = [0 0 0]/255;
mygreen         = [0 128 0]/255;
mycyan          = [2 169 226]/255;
myyellow        = [251 194 13]/255;
mygray          = [89 89 89]/255;
set(groot,'defaultAxesColorOrder',[myblack;myred;myblue;mygreen;myyellow;mycyan;mygray]);
alw             = 1;                        % AxesLineWidth
fsz             = 30;                       % Fontsize
lw              = 2;                     % LineWidth
msz             = 30;                       % MarkerSize
ga              = 0.25;                     % Grid line transparency
set(0,'defaultLineLineWidth',lw);           % set the default line width to lw
set(0,'defaultLineMarkerSize',msz);         % set the default line marker size to msz
set(0,'defaultAxesLineWidth',alw);          % set the default line width to lw
set(0,'defaultAxesFontSize',fsz);           % set the default line marker size to msz
set(groot,'DefaultAxesGridAlpha',ga);
set(0,'defaulttextinterpreter','latex');  
set(0, 'defaultLegendInterpreter','latex');
set(0, 'defaultAxesTickLabelInterpreter','latex');
set(0, 'defaultColorbarTickLabelInterpreter','latex');
set(0, 'defaultPolaraxesTickLabelInterpreter','latex');
set(0, 'defaultTextInterpreter','latex');
set(0, 'defaultTextboxshapeInterpreter','latex');

% opengl hardware
set(0,'DefaultLineLineSmoothing','on');
set(0,'DefaultPatchLineSmoothing','on');
opengl('OpenGLLineSmoothingBug',1);

end

