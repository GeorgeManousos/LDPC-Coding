EbNodB = 0;
EbNo = 10^(EbNodB/10);
MaxItrs = 1;
load BASE_MATRICES/ILS_0_FILES/NR_2_16.txt
Base = NR_2_16;

%Expansion factor Z calculation
[m, n] = size(Base);
Z = expan_calc(Base);

Slen = sum(Base(:)~=-1); %number of non -1 in Base matrix
treg = zeros(max(sum(Base~=-1, 2)), Z); %register storage for minsum

k = 10*Z; %message bits
n = n*Z;  %codeword bits
R = k/n;
sigma = sqrt(1/(2*R*EbNo)); %assuming that absolute value of symbol is 1

Nbiterrs = 0; 
Nblkerrs = 0;
Nblocks = 100;
for i = 1:Nblocks
    msg = randi([0 1], 1, k);
    cword = nrldpc_encode(Base, Z, msg);
    out = check_cword(Base, Z, cword);
    s = 1 - 2*cword;
    r = s + sigma*rand(1, n);

    %Soft-decision, iterative message-passing layered decoding
    
    L = 2*r/(sigma^2); %total belief
    itr = 0; %iteration number
    R = zeros(Slen, Z);  %storage for row processing
    while itr < MaxItrs
          Ri = 0;
          for lyr = 1:m
              ti = 0; %number of non -1 in row-lyr
              for col = find(Base(lyr, :) ~= -1)
              ti = ti + 1;
              Ri = Ri + 1;
              %subtraction
              L((col-1)*Z+1:col*Z) = L((col-1)*Z+1:col*Z) - R(Ri,:);
              %Row alignment and store in treg
              treg(ti,:) = mul_sh(L((col-1)*Z+1:col*Z), Base(lyr, col));
              end

           %minsum on treg: ti x Z
           for i1 = 1:Z %treg(1:ti, i1)
           [min1, pos] = min(abs(treg(1:ti,i1))); %first minimum
           min2 = min(abs(treg([1:pos-1 pos+1:ti],i1))); %second minimum
           S = sign(treg(1:ti,i1));
           parity = prod(S);
           treg(1:ti,i1) = min1; %absolute value for all
           treg(pos,i1) = min2; %absolute value for min1 position
           treg(1:ti,i1) = parity*S.*treg(1:ti,i1); %assign signs
           end

           %column alignment, addition and store in R
           Ri = Ri - ti; %reset the storage counter
           ti = 0;
           for col = find(Base(lyr,:) ~= -1)
                   Ri = Ri + 1;
                   ti = ti + 1;
           %Column alignment
           R(Ri,:) = mul_sh(treg(ti,:),Z-Base(lyr,col));
           %Addition
           L((col-1)*Z+1:col*Z) = L((col-1)*Z+1:col*Z) + R(Ri,:);
           end
          end
          msg_cap = L(1:k) < 0; %decision
          Biterrsinrep = sum(msg ~= msg_cap); %errors in each repetition - must reduce as repetitions continue
          itr = itr + 1;
    end
 
%counting errors
    
    Nerrs = sum(msg ~= msg_cap); %errors in each block
    if Nerrs > 0
    Nbiterrs = Nbiterrs + Nerrs;
    Nblkerrs = Nblkerrs + 1;  
    end
end
BER_sim = Nbiterrs/k/Nblocks;
FER_sim = Nblkerrs/Nblocks;
v = [EbNodB FER_sim BER_sim Nblkerrs Nbiterrs Nblocks k*Nblocks];
fprintf('%.4f\n', v)