nA = 2;
nB = 4;
nC = 3;
nABC = zeros(nA + nB + nC,2);
for i=1:size(nABC,1)
    if i <= nA
        nABC(i,1) = 1;
    elseif i <= nA+nB
        nABC(i,1) = 2;
    elseif i <= nA+nB+nC
        nABC(i,1) = 3;
    end
end
p1 = 1;
p2 = 1;
landa = [0.1 0.2];
syms t f1(t) f2(t) c1(t) c2(t) c1Inverse(t) c2Inverse(t)
f1(t) = landa(1)*exp(-landa(1)*t);
f2(t) = landa(2)*exp(-landa(2)*t);
c1(t) = t-(1-int(f1,t,0,t))/f1;
c2(t) = t-(1-int(f2,t,0,t))/f2;
c1Inverse(t) = finverse(c1);
c2Inverse(t) = finverse(c2);
patients = [];
hospitalsIncome = zeros(3,1);
patientsPayment = zeros(2,1);
numberOfPatients = zeros(2,1);
numberOfDeaths = 0;
N = 500;
for i=1:N
    r1 = rand();
    if r1 < p1
        value = exprnd(1/landa(1));
        c = eval(c1(value));
        patients = [1,value,c;patients];
        for j=1:size(patients,1)-1
            if patients(j,3) < patients(j+1,3)
                temp = patients(j,3);
                patients(j,3) = patients(j+1,3);
                patients(j+1,3) = temp;
            else
                break;
            end
        end
    end
    r2 = rand();
    if r2 < p2
        value = exprnd(1./landa(2));
        c = eval(c2(value));
        patients = [2,value,c;patients];
        for j=1:size(patients,1)-1
            if patients(j,3) < patients(j+1,3)
                temp = patients(j,3);
                patients(j,3) = patients(j+1,3);
                patients(j+1,3) = temp;
            else
                break;
            end
        end
    end
    emptyBeds = find(nABC(:,2) == 0);
    counter = length(emptyBeds);
    emptyBeds = emptyBeds(randperm(length(emptyBeds)));
    temp = [];
    if ~isempty(patients)
        temp = patients(patients(:,3) > 0,:);
    end
    edgeC = 0;
    if size(temp,1) >= counter + 1
        edgeC = temp(counter+1,3);
    end   
    if counter <= size(temp,1)
        last = counter;
    else
        last = size(temp,1);
    end
    for j=1:last
        if temp(j,1) == 1
            edgeValue = eval(c1Inverse(edgeC));
            numberOfPatients(1) = numberOfPatients(1) + 1;
        elseif temp(j,1) == 2
            edgeValue = eval(c2Inverse(edgeC));
            numberOfPatients(2) = numberOfPatients(2) + 1;
        end
        hospitalsIncome(nABC(emptyBeds(j),1),1) = hospitalsIncome(nABC(emptyBeds(j),1),1) + edgeValue;
        patientsPayment(temp(j,1)) = patientsPayment(temp(j,1)) + edgeValue;
        nABC(emptyBeds(j),2) = temp(j,1);
    end
    patients(1:last,:) = [];
    for j=1:size(nABC,1)
        if nABC(j,2) && (rand() < 1-exp(-landa(nABC(j,2))))
            nABC(j,2) = 0;
        end
    end
    temp = [];
    for j=1:size(patients,1)
        if rand() < 1-exp(-landa(patients(j,1)))
            temp = [temp, j];
        else
            if patients(j,1) == 1
                value = exprnd(1/landa(1));
                c = eval(c1(value));
                patients(j,:) = [patients(j,1),value,c];
            elseif patients(j,1) == 2
                value = exprnd(1/landa(2));
                c = eval(c2(value));
                patients(j,:) = [patients(j,1),value,c];
            end
        end
    end
    patients(temp,:) = [];
    numberOfDeaths = numberOfDeaths + length(temp);
    for j=1:size(patients,1)-1
        for k=1:size(patients,1)-j
            if patients(k,3) < patients(k+1,3)
                temp = patients(k,3);
                patients(k,3) = patients(k+1,3);
                patients(k+1,3) = temp;
            end
        end
    end
end
hospitalsIncome = hospitalsIncome/N;
if numberOfPatients(1) == 0
    patientsPayment(1) = 0;
else
    patientsPayment(1) = patientsPayment(1)/numberOfPatients(1);
end
if numberOfPatients(2) == 0
    patientsPayment(2) = 0;
else
    patientsPayment(2) = patientsPayment(2)/numberOfPatients(2);
end
%%
nA = 2;
nB = 4;
nC = 3;
nABC = zeros(nA + nB + nC,2);
for i=1:size(nABC,1)
    if i <= nA
        nABC(i,1) = 1;
    elseif i <= nA+nB
        nABC(i,1) = 2;
    elseif i <= nA+nB+nC
        nABC(i,1) = 3;
    end
end
landa = [0.1 0.2];
syms t f1(t) f2(t) c1(t) c2(t) c1Inverse(t) c2Inverse(t)
f1(t) = landa(1)*exp(-landa(1)*t);
f2(t) = landa(2)*exp(-landa(2)*t);
c1(t) = t-(1-int(f1,t,0,t))/f1;
c2(t) = t-(1-int(f2,t,0,t))/f2;
c1Inverse(t) = finverse(c1);
c2Inverse(t) = finverse(c2);
stride = 5;
hospitalsIncomeMatrix = zeros(stride+1,stride+1,4);
patientsPaymentMatrix = zeros(stride+1,stride+1,3);
numberOfDeathsMatrix = zeros(stride+1,stride+1);
for p1=0:1/stride:1
    for p2=0:1/stride:1
        patients = [];
        hospitalsIncome = zeros(3,1);
        patientsPayment = zeros(2,1);
        numberOfPatients = zeros(2,1);
        numberOfDeaths = 0;
        N = 500;
        for i=1:N
            r1 = rand();
            if r1 < p1
                value = exprnd(1/landa(1));
                c = eval(c1(value));
                patients = [1,value,c;patients];
                for j=1:size(patients,1)-1
                    if patients(j,3) < patients(j+1,3)
                        temp = patients(j,3);
                        patients(j,3) = patients(j+1,3);
                        patients(j+1,3) = temp;
                    else
                        break;
                    end
                end
            end
            r2 = rand();
            if r2 < p2
                value = exprnd(1./landa(2));
                c = eval(c2(value));
                patients = [2,value,c;patients];
                for j=1:size(patients,1)-1
                    if patients(j,3) < patients(j+1,3)
                        temp = patients(j,3);
                        patients(j,3) = patients(j+1,3);
                        patients(j+1,3) = temp;
                    else
                        break;
                    end
                end
            end
            emptyBeds = find(nABC(:,2) == 0);
            counter = length(emptyBeds);
            emptyBeds = emptyBeds(randperm(length(emptyBeds)));
            temp = [];
            if ~isempty(patients)
                temp = patients(patients(:,3) > 0,:);
            end
            edgeC = 0;
            if size(temp,1) >= counter + 1
                edgeC = temp(counter+1,3);
            end   
            if counter <= size(temp,1)
                last = counter;
            else
                last = size(temp,1);
            end
            for j=1:last
                if temp(j,1) == 1
                    edgeValue = eval(c1Inverse(edgeC));
                    numberOfPatients(1) = numberOfPatients(1) + 1;
                elseif temp(j,1) == 2
                    edgeValue = eval(c2Inverse(edgeC));
                    numberOfPatients(2) = numberOfPatients(2) + 1;
                end
                hospitalsIncome(nABC(emptyBeds(j),1),1) = hospitalsIncome(nABC(emptyBeds(j),1),1) + edgeValue;
                patientsPayment(temp(j,1)) = patientsPayment(temp(j,1)) + edgeValue;
                nABC(emptyBeds(j),2) = temp(j,1);
            end
            patients(1:last,:) = [];
            for j=1:size(nABC,1)
                if nABC(j,2) && (rand() < 1-exp(-landa(nABC(j,2))))
                    nABC(j,2) = 0;
                end
            end
            temp = [];
            for j=1:size(patients,1)
                if rand() < 1-exp(-landa(patients(j,1)))
                    temp = [temp, j];
                else
                    if patients(j,1) == 1
                        value = exprnd(1/landa(1));
                        c = eval(c1(value));
                        patients(j,:) = [patients(j,1),value,c];
                    elseif patients(j,1) == 2
                        value = exprnd(1/landa(2));
                        c = eval(c2(value));
                        patients(j,:) = [patients(j,1),value,c];
                    end
                end
            end
            numberOfDeaths = numberOfDeaths + length(temp);
            patients(temp,:) = [];
            for j=1:size(patients,1)-1
                for k=1:size(patients,1)-j
                    if patients(k,3) < patients(k+1,3)
                        temp = patients(k,3);
                        patients(k,3) = patients(k+1,3);
                        patients(k+1,3) = temp;
                    end
                end
            end
        end
        hospitalsIncomeMatrix(floor(p1*stride+1),floor(p2*stride+1),1:3) = hospitalsIncome/N;
        if numberOfPatients(1) == 0
            patientsPaymentMatrix(floor(p1*stride+1),floor(p2*stride+1),1) = 0;
        else
            patientsPaymentMatrix(floor(p1*stride+1),floor(p2*stride+1),1) = patientsPayment(1)/numberOfPatients(1);
        end
        if numberOfPatients(2) == 0
            patientsPaymentMatrix(floor(p1*stride+1),floor(p2*stride+1),2) = 0;
        else
            patientsPaymentMatrix(floor(p1*stride+1),floor(p2*stride+1),2) = patientsPayment(2)/numberOfPatients(2);
        end
        if numberOfPatients == 0
            patientsPaymentMatrix(floor(p1*stride+1),floor(p2*stride+1),3) = 0;
        else
            patientsPaymentMatrix(floor(p1*stride+1),floor(p2*stride+1),3) = (patientsPaymentMatrix(floor(p1*stride+1),floor(p2*stride+1),1)*numberOfPatients(1)+patientsPaymentMatrix(floor(p1*stride+1),floor(p2*stride+1),2)*numberOfPatients(2))/sum(numberOfPatients);            
        end
        numberOfDeathsMatrix(floor(p1*stride+1),floor(p2*stride+1)) = numberOfDeaths;
        p1
        p2
    end
end
hospitalsIncomeMatrix(:,:,4) = (hospitalsIncomeMatrix(:,:,1)*nA+hospitalsIncomeMatrix(:,:,2)*nB+hospitalsIncomeMatrix(:,:,1)*nC)/(nA+nB+nC);
[X,Y] = meshgrid(0:1/stride:1,0:1/stride:1);
figure();
surf(X,Y,hospitalsIncomeMatrix(:,:,1));
title('Hospital A Average Income')
figure();
surf(X,Y,hospitalsIncomeMatrix(:,:,2));
title('Hospital B Average Income')
figure();
surf(X,Y,hospitalsIncomeMatrix(:,:,3));
title('Hospital C Average Income')
figure();
surf(X,Y,hospitalsIncomeMatrix(:,:,4));
title('Hospitals Average Income')
figure();
surf(X,Y,patientsPaymentMatrix(:,:,1));
title('Patients Type 1 Average Payment')
figure();
surf(X,Y,patientsPaymentMatrix(:,:,2));
title('Patients Type 2 Average Payment')
figure();
surf(X,Y,patientsPaymentMatrix(:,:,3));
title('Patients Average Payment')
figure();
surf(X,Y,numberOfDeathsMatrix);
title('Number Of Deads')