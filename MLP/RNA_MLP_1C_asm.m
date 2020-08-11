%%SCRIPT DE TREINAMENTO DA REDE MLP COM 1 CAMADA OCULTA
%ADAPTADO POR: ADRIANO DE SOUZA MARQUES
%adriano.marques@ifsp.edu.br
%V2-19/11/17
clear; close; clc;

%============================PARÂMETROS A SEREM ALTERADOS
%GERAR O ARQUIVO DE TREINO
TIPO_RNA = '_MLP_';
VAR_SAIDA = '_KD_';

%COMBINAÇAO A SER TREINADA
VAR_ENTRADA = '_T05_';
%NOME DO ARQUIVO COM A BASE DE TREINO
NomeArquivoTREINAMENTO = 't-70.csv';
%NUMERO DE VARIÁVEIS DE ENTRADA
NUM_VAR_IN = 4;
%NUMERO DE VARIÁVEIS DE SAIDA
NUM_VAR_OUT = 5;
%NUMERO DE NEURÔNIOS 1ª CO
NUM_NEURONIOS1 = 5;
%NUMERO MÁXIMO DE ÉPOCAS
N_Epocas = 1000;
%TAXA DE APRENDIZADO
%LR = 0.01;
%MOMENTUM
%MC = 0.9;
%=========================FIM PARÂMETROS A SEREM ALTERADOS





%======================NÃO FAZER ALTERAÇÕES NAS LINHAS ABAIXO!!!
%PARÂMETROS DO TREINO
TColIn = NUM_VAR_IN;     %COLUNA(S) DADO(S) ENTRADA(S)
TColOut = NUM_VAR_OUT;     %COLUNA(S) DADO(S) SAIDA(S)
%TColOut = TColIn+1;    %COLUNA DADO SAÍDA
%N_Epocas = 1000; %Número de Épocas para o Treino
camada0 = NUM_NEURONIOS1;   %Numero de Neuronios na Camada Oculta 1
neuronios1 = num2str(camada0);
%camada1 = NUM_NEURONIOS2;   %Numero de Neuronios na Camada Oculta 1
neuronios2 = num2str(0);

%TREINAMENTO
dados = csvread(NomeArquivoTREINAMENTO);
[linha,coluna] = size(dados);
P = dados(:,1:TColIn);
T = dados(:,TColOut);   

   
for i=1:5
inc = num2str(i);
tic;
net = feedforwardnet(camada0,'trainlm');
%net = feedforwardnet([camada0 camada1],'trainlm');
net.trainParam.epochs = N_Epocas;
%net.trainParam.lr = LR;
%net.trainParam.mc = MC;
net.performFcn;
net.performParam;
net.layers{1}.transferFcn = 'tansig';
[net,tr]=train(net,P',T');
Tt = toc;
y1 = net(P');
%saida_treino = (y1');
perfMSE = mse(net,T',y1'); %Mean squared normalized error performance function
pesos_bias(:,i) = getwb(net);
pesos1 = net.IW{1};
pesos2 = net.LW{2};
bias1 = net.b{1};
bias2 = net.b{2};

%RMSE Treino
Rt = (mean(T));
RMSEt = sqrt(perfMSE);
rRMSEt = (100*RMSEt)/Rt;

%R2
Ymean = mean(T);
SSt = sum((T-Ymean).^2);
SSr = sum((T-(y1')).^2);
R2t = 1-(SSr/SSt);
%R(Coeficiente de Correlação Linear)
CCt = sqrt(R2t);


%ARQUIVO DE SAIDA DO TREINO
NomeArquivoTreino = strcat(inc,VAR_ENTRADA,TIPO_RNA,neuronios1,VAR_SAIDA);
save(NomeArquivoTreino,'neuronios1','neuronios2','inc','net','pesos1','pesos2','bias1','bias2','pesos_bias','tr','perfMSE','RMSEt','rRMSEt','P','T','TIPO_RNA','VAR_SAIDA','VAR_ENTRADA','Tt','NUM_VAR_IN','NUM_VAR_OUT','R2t','CCt');
i
%pause;
end
