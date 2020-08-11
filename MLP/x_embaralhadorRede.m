clear all; 
clc; 

disp('INICIO');
dados = csvread('dadosAdrianoFULL_KT-H0-HG-ZT_KD.csv');

%maior = max(max(dados(:,1:3)));

%dados(:,1:3)=dados(:,1:3)/maior;

%dados(:,3)=dados(:,3)/max(dados(:,3));

[linha,coluna]=size(dados);
emb = randperm(linha);
dados = dados(emb,:);

div_treina = round(linha*0.7);
div_valida = linha - div_treina;

csvwrite('t-70.csv',dados(1:div_treina,:));
csvwrite('v-30.csv',dados(div_treina:linha,:));

disp('FIM');

