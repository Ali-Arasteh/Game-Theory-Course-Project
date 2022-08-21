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
pa = 0.2;
pb = 0.3;
pc = 0.5;
percents = zeros(3,3);
for i=1:3
    percents(i,:) = circshift([0.8 0.5 0.2],i-1,2);
end
landa = [0.1 0.2];
syms t f1(t) f2(t)
f1(t) = 0.5*exp(-0.5*t);
f2(t) = exp(-t);
patients = [];
hospitalsIncome = zeros(3,1);
patientsPayment = zeros(2,1);
numberOfPatients = zeros(2,1);
N = 100;
for i=1:N
    r1 = rand();
    if r1 < p1
        value = exprnd(1/landa(1));
        insuranceR1 = rand();
        if insuranceR1 < pa
            type = 1;
        elseif insuranceR1 < pa+pb
            type = 2;
        elseif insuranceR1 < pa+pb+pc
            type = 3;
        end
        patients = [1,type,value;patients];
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
        value = exprnd(1/landa(2));
        insuranceR2 = rand();
        if insuranceR2 < pa
            type = 1;
        elseif insuranceR2 < pa+pb
            type = 2;
        elseif insuranceR2 < pa+pb+pc
            type = 3;
        end
        patients = [2,type,value;patients];
        for j=1:size(patients,+1)-1
            if patients(j,3) < patients(j+1,3)
                temp = patients(j,3);
                patients(j,3) = patients(j+1,3);
                patients(j+1,3) = temp;
            else
                break;
            end
        end
    end
    counter = 0;
    emptyBeds = [];
    n = zeros(3,1);
    for j=1:size(nABC,1)
        if nABC(j,2) == 0
            counter = counter + 1;
            emptyBeds = [emptyBeds,j];
            n(nABC(j,1)) = n(nABC(j,1)) + 1;
        end
    end
    if counter <= size(patients,1)
        last = counter;
    else
        last = size(patients,1);
    end
    for j=1:last
        if patients(j,1) == 1
            numberOfPatients(1) = numberOfPatients(1) + 1;
        elseif patients(j,1) == 2
            numberOfPatients(2) = numberOfPatients(2) + 1;
        end
        if patients(j,2) == 1
            temp = circshift(emptyBeds,n(1)+n(2)+n(3));
        elseif patients(j,2) == 2
            temp = circshift(emptyBeds,n(2)+n(3));
        elseif patients(j,2) == 3
            temp = circshift(emptyBeds,n(3));
        end
        matchedBed = temp(1);
        emptyBeds(find(emptyBeds == matchedBed,1)) = [];
        n(nABC(matchedBed,1)) = n(nABC(matchedBed,1)) - 1;
        percent = percents(patients(j,2),nABC(matchedBed,1));
        hospitalsIncome(nABC(matchedBed,1)) = hospitalsIncome(nABC(matchedBed,1)) + patients(j,3);
        patientsPayment(patients(j,1)) = patientsPayment(patients(j,1)) + patients(j,3)*(1-percent);
        nABC(matchedBed,2) = patients(j,1);
    end
    patients(1:last,:) = [];
    for j=1:size(nABC,1)
        if nABC(j,2) && (rand() < 1-exp(-landa(nABC(j,2))))
            nABC(j,2) = 0;
        end
    end
    for j=1:size(patients,1)
        if patients(j,1) == 1
            value = exprnd(1/landa(1));
            patients(j,:) = [patients(j,1),patients(j,2),value];
        elseif patients(j,1) == 2
            value = exprnd(1/landa(2));
            patients(j,:) = [patients(j,1),patients(j,2),value];
        end
    end
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
pa = 0.2;
pb = 0.3;
pc = 0.5;
percents = zeros(3,3);
for i=1:3
    percents(i,:) = circshift([0.8 0.5 0.2],i-1,2);
end
landa = [0.1 0.2];
syms t f1(t) f2(t)
f1(t) = 0.5*exp(-0.5*t);
f2(t) = exp(-t);
stride = 10;
hospitalsIncomeMatrix = zeros(stride+1,stride+1,4);
patientsPaymentMatrix = zeros(stride+1,stride+1,3);
for p1=0:1/stride:1
    for p2=0:1/stride:1
        patients = [];
        hospitalsIncome = zeros(3,1);
        patientsPayment = zeros(2,1);
        numberOfPatients = zeros(2,1);
        N = 1000;
        for i=1:N
            r1 = rand();
            if r1 < p1
                value = exprnd(1/landa(1));
                insuranceR1 = rand();
                if insuranceR1 < pa
                    type = 1;
                elseif insuranceR1 < pa+pb
                    type = 2;
                elseif insuranceR1 < pa+pb+pc
                    type = 3;
                end
                patients = [1,type,value;patients];
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
                value = exprnd(1/landa(2));
                insuranceR2 = rand();
                if insuranceR2 < pa
                    type = 1;
                elseif insuranceR2 < pa+pb
                    type = 2;
                elseif insuranceR2 < pa+pb+pc
                    type = 3;
                end
                patients = [2,type,value;patients];
                for j=1:size(patients,+1)-1
                    if patients(j,3) < patients(j+1,3)
                        temp = patients(j,3);
                        patients(j,3) = patients(j+1,3);
                        patients(j+1,3) = temp;
                    else
                        break;
                    end
                end
            end
            counter = 0;
            emptyBeds = [];
            n = zeros(3,1);
            for j=1:size(nABC,1)
                if nABC(j,2) == 0
                    counter = counter + 1;
                    emptyBeds = [emptyBeds,j];
                    n(nABC(j,1)) = n(nABC(j,1)) + 1;
                end
            end
            if counter <= size(patients,1)
                last = counter;
            else
                last = size(patients,1);
            end
            for j=1:last
                if patients(j,1) == 1
                    numberOfPatients(1) = numberOfPatients(1) + 1;
                elseif patients(j,1) == 2
                    numberOfPatients(2) = numberOfPatients(2) + 1;
                end
                if patients(j,2) == 1
                    temp = circshift(emptyBeds,n(1)+n(2)+n(3));
                elseif patients(j,2) == 2
                    temp = circshift(emptyBeds,n(2)+n(3));
                elseif patients(j,2) == 3
                    temp = circshift(emptyBeds,n(3));
                end
                matchedBed = temp(1);
                emptyBeds(find(emptyBeds == matchedBed,1)) = [];
                n(nABC(matchedBed,1)) = n(nABC(matchedBed,1)) - 1;
                percent = percents(patients(j,2),nABC(matchedBed,1));
                hospitalsIncome(nABC(matchedBed,1)) = hospitalsIncome(nABC(matchedBed,1)) + patients(j,3);
                patientsPayment(patients(j,1)) = patientsPayment(patients(j,1)) + patients(j,3)*(1-percent);
                nABC(matchedBed,2) = patients(j,1);
            end
            patients(1:last,:) = [];
            for j=1:size(nABC,1)
                if nABC(j,2) && (rand() < 1-exp(-landa(nABC(j,2))))
                    nABC(j,2) = 0;
                end
            end
            for j=1:size(patients,1)
                if patients(j,1) == 1
                    value = exprnd(1/landa(1));
                    patients(j,:) = [patients(j,1),patients(j,2),value];
                elseif patients(j,1) == 2
                    value = exprnd(1/landa(2));
                    patients(j,:) = [patients(j,1),patients(j,2),value];
                end
            end
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