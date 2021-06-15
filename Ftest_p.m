function P = Ftest_p(chia,dfa,chib,dfb)
% calculate the probability that error improvement between 2 models could
% have occurred by random chance

ChiA = chia/dfa;
ChiB = chib/dfb;

Fobs = ChiA/ChiB;
% fprintf('1/F %f F %f\n', 1/Fobs, Fobs);
if( Fobs<1 )
    Fobs=1/Fobs;
end
P = 1 - (fcdf(Fobs,dfa,dfb)-fcdf(1/Fobs,dfa,dfb));
fprintf('This improvement could have occured by random chance with probability %f\n',P)


end