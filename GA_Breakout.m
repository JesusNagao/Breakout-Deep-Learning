close all force; clc; clear

n_p = 20;                   %Individuos en población                
elitismo = 0.1;             %radio de Elitismo/población
padres = 0.3;               %radio Padres/población

p_mut = 0.6;
poblacion = zeros(n_p,3,3);
hijos = zeros(n_p,3,3);
pesos = zeros(3,3);
gen = 0;
%----------------------------Población Inicial----------------------------
for pob = 1:n_p
    for i = 1:3
        for n = 1:3
            poblacion(pob,i,n) = randn();
        end
    end
end

%----------------------------------LOOP-----------------------------------
fin = false;
while ~fin
%-----------------------------Evaluar Fitness-----------------------------
    for pob = 1:n_p
        pesos(:,:) = poblacion(pob,:,:);
        save("pesos","pesos")
        breakout_neuronas('init');
        x = ans;
        eval(pob) = x;
        close all force
        fprintf("%f  ",x)
    end
    [maximo,mejor] = max(eval);
    [minimo,peor] = min(eval);
    eval2 = eval;
%-----------------------------Elitismo------------------------------------
    for i = 1:floor(n_p*elitismo)+1
        hijos(i,:,:) = poblacion(mejor,:,:);
        poblacion(peor,:,:) = poblacion(mejor,:,:);
        eval(mejor) = [];
        [maximo,mejor] = max(eval);
    end
%------------------------------Padres-------------------------------------
    [minimo,peor] = min(eval2);
    eval2 = (eval2 - minimo);
    [maximo,mejor] = max(eval2);
    eval2 = eval2./maximo;
    for i = floor(n_p*elitismo)+2:n_p
        aceptado = false;
        while ~aceptado
            prop = randi(n_p);
            if rand < eval2(prop)
                hijos(i,:,:) = poblacion(prop,:,:);
                aceptado = true;
            end
        end
%----------------------------Mutaciones-----------------------------------
        for n = 1:3
            for m = 1:3
                if rand < p_mut
                	hijos(i,n,m) = randn();
                end
            end
        end
    end
%--------------------------------Preparar---------------------------------
    gen = gen + 1;
    fprintf("\nGeneración %i\n",gen)
    poblacion = hijos;
    if sum(eval) < 0
        p_mut = 0.6;
    elseif sum(eval) < 10
        p_mut = 0.4;
    end
end