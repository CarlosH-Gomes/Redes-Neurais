%%SCRIPT DE VALIDAÇÃO DE REDE REDES NEURAIS
%ADAPTADO POR: ADRIANO DE SOUZA MARQUES
%adriano.marques@ifsp.edu.br
clear;
%V3-19/11/17
clear; close; clc;

%============================PARÂMETROS A SEREM ALTERADOS
%ARQUIVO DE DADOS TREINADOS
load('3_T05__MLP_5_KD_.mat');
%NOME DO ARQUIVO COM OS DADOS DE VALIDAÇÃO
NomeArquivoVALIDA = 'v-30.csv';
%TIPO VALIDAÇÃO (EXEMPLO - AT PARA ANOS TIPICOS)
TIPO_VALIDA = '_T05';
%=========================FIM PARÂMETROS A SEREM ALTERADOS



%======================NÃO FAZER ALTERAÇÕES NAS LINHAS ABAIXO!!!
b1 = mat2dataset(bias1);
b2 = mat2dataset(bias2);
p1 = mat2dataset(pesos1);
p2 = mat2dataset(pesos2);
ep = tr.best_epoch;
perf = tr.best_perf;
perfv = tr.best_vperf;
perft = tr.best_tperf;


%PARÂMETROS E ARQUIVO DE DADOS DA VALIDAÇÃO
    VColIn = NUM_VAR_IN;            %QTD DADO(S) ENTRADA(S)
    COL_OUT = NUM_VAR_OUT;          %POSIÇÃO DADO(S) SAIDA(S)
    VColOut = 1;                    %QTD DADOS SAÍDA
    TipoValida = TIPO_VALIDA;       %ANOS PARA VALIDAÇÃO

NomeArquivoSaida = strcat(inc,VAR_ENTRADA,neuronios1,TIPO_RNA,neuronios2,VAR_SAIDA,TipoValida);
NomeArquivoSaidaCSV = strcat(inc,VAR_ENTRADA,neuronios1,TIPO_RNA,neuronios2,TipoValida);
BIAS1 = 'BIAS1'; BIAS2 = 'BIAS2'; PESOS1 = 'PESOS1'; PESOS2 = 'PESOS2';
NomeArquivoSaidaCSVBias1 = strcat(inc,BIAS1,VAR_ENTRADA,neuronios1,TIPO_RNA,neuronios2,TipoValida);
NomeArquivoSaidaCSVPesos1 = strcat(inc,PESOS1,VAR_ENTRADA,neuronios1,TIPO_RNA,neuronios2,TipoValida);
NomeArquivoSaidaCSVBias2 = strcat(inc,BIAS2,VAR_ENTRADA,neuronios1,TIPO_RNA,neuronios2,TipoValida);
NomeArquivoSaidaCSVPesos2 = strcat(inc,PESOS2,VAR_ENTRADA,neuronios1,TIPO_RNA,neuronios2,TipoValida);


dados = csvread(NomeArquivoVALIDA);
num_saida = VColOut;
num_ent = VColIn;
[amostra,coluna] = size(dados);
ent = dados(:,1:num_ent);
saida = dados(:,COL_OUT:coluna);
saida_rede = sim(net,ent');
saida_rede = saida_rede';
erro_relat = 0;
variancia = 0;

for i=1:num_saida
    for j=1:amostra
        erro_relat = erro_relat + (abs(saida(j,i)-saida_rede(j,i))/saida_rede(j,i));
        variancia = variancia + (saida_rede(j,i)-saida(j,i));
        %if (saida(j,i)==saida_rede(j,i))
        %    acerto = acerto + 1;
        %    disp(acerto);
        %end
        disp(saida_rede(j,i)-saida(j,i));
    end
end

erm = (erro_relat/amostra)*100;
variancia = (variancia/amostra)*100;

%MBE
MBE=(mean(mean(saida_rede-saida)));
R=(mean(saida));
rMBE=(100*MBE)/R;
%MSE - mean squared error - Performance da Rede
MSE=mean(mean((saida_rede-saida).^2));
%RMSE - root mean squared error
RMSE=sqrt(MSE);
R=(mean(saida));
rRMSE=(100*RMSE)/R;
%MRE - mean relative error
MRE=mean(mean(((saida_rede-saida)/(saida_rede)).^2));
%R2
Ymean = mean(saida);
SSt = sum((saida-Ymean).^2);
SSr = sum((saida-saida_rede).^2);
r2 = 1-(SSr/SSt);
%d(Willmott)
v1 = (mean((saida_rede-saida).^2));
HMmed = mean(saida);
HElinha = abs(saida_rede-HMmed);
HMlinha = abs(saida-HMmed);
v2 = (mean((HElinha+HMlinha).^2));
dWillmott = 1-(v1/v2);
%R(Coeficiente de Correlação Linear)
R = sqrt(r2);

clc;
disp('-- RMSE% ou rRMSE -- ');
disp(rRMSE);
disp('-- MBE% ou rMBE -- ');
disp(rMBE);
disp('-- r² -- ');
disp(r2);
disp('-- R -- ');
disp(R);

%GERA ARQUIVOS DE RESULTADOS
save(NomeArquivoSaida,'net','saida','saida_rede','TIPO_RNA','TipoValida','RMSE','rRMSE','MBE','rMBE','r2','R','dWillmott','erm','variancia','MSE','MRE','Tt','b1','p1','b2','p2','ep','perf','perfv','perft','R2t','CCt');
indices = {'TIPO_RNA','ANO','VAR_ENTRADA','neuronios1','neuronios2','RMSE','rRMSE','MBE','rMBE','R2','r','dWillmott','erm','variancia','MSE','MRE','Tt','MSEt','RMSEt','rRMSEt','ep','perf','perfv','perft','R2t','rt';TIPO_RNA,TipoValida,VAR_ENTRADA,neuronios1,neuronios2,RMSE,rRMSE,MBE,rMBE,r2,R,dWillmott,erm,variancia,MSE,MRE,Tt,perfMSE,RMSEt,rRMSEt,ep,perf,perfv,perft,R2t,CCt};
sheet = 1;
xlRange = 'A1';
xlswrite(NomeArquivoSaida,indices,sheet,xlRange);
csvwrite(NomeArquivoSaidaCSV,saida_rede);
csvwrite(NomeArquivoSaidaCSVBias1,bias1');
csvwrite(NomeArquivoSaidaCSVBias2,bias2');
csvwrite(NomeArquivoSaidaCSVPesos1,pesos1');
csvwrite(NomeArquivoSaidaCSVPesos2,pesos2');