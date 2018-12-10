function varargout = fourier(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fourier_OpeningFcn, ...
                   'gui_OutputFcn',  @fourier_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function fourier_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = fourier_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function carregar_Callback(hObject, eventdata, handles)
% --- Botao Carregar

global imagem;

[imagem, user_cance] = imgetfile();
    if user_cance
        msgbox(sprintf('Selecione uma Imagem!'),'Erro!','Error');
        return
    end   
imagem = imread(imagem);

axes(handles.quadrofoto);
imshow(imagem);

global original;
original = imagem;


function resetar_Callback(hObject, eventdata, handles)
% --- Botao Resetar

global imagem;
global original;

imagem = original;

axes(handles.quadrofoto);
imshow(imagem);

function dessaturar_Callback(hObject, eventdata, handles)
% --- Botao Desaturar

global imagem;

imagem = rgb2gray(imagem);

axes(handles.quadrofoto);
imshow(imagem);

function negativo_Callback(hObject, eventdata, handles)
% --- Botao Negativo

global imagem;

imagem = imcomplement(imagem);

axes(handles.quadrofoto);
imshow(imagem);

function contraste_Callback(hObject, eventdata, handles)

global imagem;

 imagem = imadjust(imagem,[.4 .4 .4; .7 .7 .7],[0 0 0; 1 1 1]);

%  imagem = imadjust(imagem);



 


axes(handles.quadrofoto);
imshow(imagem);


function f1_Callback(hObject, eventdata, handles)

global imagem;

a = fft2(double(imagem));
a1 = fftshift(a);

%escolha do filtro de Gaussian
[m n] = size(a);
p = 10;
x = 0 : n-1;
y = 0 : m-1;
[x y] = meshgrid(x,y);
cx = 0.5*n;
cy = 0.5*m;

passaB = exp(-((x-cx).^2+(y-cy).^2)./(2*p).^2);
passaA = 1-passaB; 

j = a1.*passaB;
j1 = ifftshift(j);
b1 = ifft2(j1);
k = a1.*passaA;
k1 = ifftshift(k);
b2 = ifft2(k1);

% imagem = b2;

 imagem = im2double(abs(b2));

 imagem = uint8(abs(b2));

axes(handles.quadrofoto);
imshow(imagem);

function reconhecimento_Callback(hObject, eventdata, handles)

global imagem;

clc

% x1 = 548.7338;
% y1 = 630.3219;
% x2 = 819.0683;   % PLACA
% y2 = 883.4011;

% x1 = 1.7496e+03;
% y1 = 45.7003;       
% x2 = 3.1632e+03;    % Blade
% y2 = 144.1148;


[x1,y1] = ginput(1);  %Pega as coordenadas do click primeiro no topo esquerdo, depois baixo direita TA OK???
[x2,y2] = ginput(1);


letras = ocr(imagem,[x1,y1,x2-x1,y2 - y1]);   %letras.Words pega as "palavras encontradas

% x1
% y1
% x2
% y2

letras.Words

set(handles.texto, 'String', letras.Words);
drawnow;


function pushbutton12_Callback(hObject, eventdata, handles)

global imagem;

imagem = imbinarize(imagem, graythresh(imagem));

axes(handles.quadrofoto);
imshow(imagem);





function pushbutton13_Callback(hObject, eventdata, handles)

global imagem;

imagem = adapthisteq(imagem);

axes(handles.quadrofoto);
imshow(imagem);


function ff1_Callback(hObject, eventdata, handles)

global imagem;

% Fourier da imagem

imagem = rgb2gray(imagem);

imagem = fft2(imagem);

%gera o valor absoluto
ABS = abs(imagem);


axes(handles.quadrofoto);
imshow(ABS,[]);


function ff2_Callback(hObject, eventdata, handles)

global imagem;

% Centraliza as frequencias 0 do espectro
imagem = fftshift(imagem);

axes(handles.quadrofoto);
imshow(abs(imagem),[]);


function ff3_Callback(hObject, eventdata, handles)

global imagem

%Aplicar LOG

axes(handles.quadrofoto);
imshow(log(1+abs(imagem)),[]);


function ff4_Callback(hObject, eventdata, handles)

global imagem

%remonta a imagem

imagem = ifftshift(imagem);
imagem = ifft2(imagem);

imshow(log(1+abs(imagem)),[]);

axes(handles.quadrofoto);
imshow(abs(imagem),[]);



