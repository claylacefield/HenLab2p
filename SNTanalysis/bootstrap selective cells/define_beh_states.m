

function [beh_states_matrix,numb_beh,beh_lengths]= define_beh_states(behavior,type)
%this function will generate a cell array with the row indices for
%different behavior states based on logical scoring. These indices will be
%used in other functions for running analyses in diff behavioral states
%specified
%'EPM'=elevated plus
%'EPMC'=EPM w center and open arms counted as one compartment
%'EZM'= elevated zero maze
%'OFT'= open field test
%'NOVEL'= novel object task

if strcmpi(type,'EPM')==1
    numb_beh=3;
    beh1=find(behavior(:,16)==1); %closed arms
    beh2=find(behavior(:,15)==1);%open arms
    beh3=find(behavior(:,17)==1); %center
    %beh4=find(behavior(:,18)==1); %headdips
    %beh5=find(behavior(:,15)==1 & behavior(:,18)==0); % open arms no headdips
    beh_states_matrix{numb_beh}=NaN;
    beh_states_matrix={beh1, beh2, beh3};
    
    beh_lengths(numb_beh)=NaN;
    beh_lengths=horzcat(length(beh1), length(beh2), length(beh3));
    
elseif strcmpi(type,'EPMC')==1    
    numb_beh=2;
    beh1=find(behavior(:,16)==1); %closed arms
    beh2=find(behavior(:,15)==1| behavior(:,17)==1);%open arms & center counted together
    beh_states_matrix{numb_beh}=NaN;
    beh_states_matrix={beh1, beh2};
    
    beh_lengths(numb_beh)=NaN;
    beh_lengths=horzcat(length(beh1), length(beh2));
    
elseif strcmpi(type,'OFT')==1
    numb_beh=2;
    beh1=find(behavior(:,15)==0); %periphery
    beh2=find(behavior(:,15)==1); %center
    beh_states_matrix{numb_beh}=NaN;
    beh_states_matrix={beh1, beh2};
    
    beh_lengths(numb_beh)=NaN;
    beh_lengths=horzcat(length(beh1), length(beh2));
    
elseif strcmpi(type,'NOVEL')==1
    numb_beh=3;
    beh1=find(behavior(:,16)==1); %opp field
    beh2=find(behavior(:,15)==1); %novelob zone
    beh3=find(behavior(:,15)==0 & behavior(:,16)==0);%arena
    beh_states_matrix{numb_beh}=NaN;
    beh_states_matrix={beh1, beh2, beh3};
    
    beh_lengths(numb_beh)=NaN;
    beh_lengths=horzcat(length(beh1), length(beh2), length(beh3));
    
elseif strcmpi(type,'EZM')==1
    numb_beh=2;
    beh1=find(behavior(:,16)==1); %closed arms
    beh2=find(behavior(:,15)>0);%open arms
    %beh3=find(behavior(:,17)==1); headdips
    %beh4=find(behavior(:,15)==1 & behavior(:,17)==0); open arms no headdips
    beh_states_matrix{numb_beh}=NaN;
    beh_states_matrix={beh1, beh2};
    
    beh_lengths(numb_beh)=NaN;
    beh_lengths=horzcat(length(beh1), length(beh2));
end