% mpm_clean : delete output from MPM
%
%
%
function mpm_clean(del_level,wd)

if nargin < 1, del_level=2; end
if nargin < 2, wd=pwd; end

fclose all;

i=0;
i=i+1;A{i}='progress';
i=i+1;A{i}='geophoneposout.asc';
i=i+1;A{i}='sourceout.asc';
i=i+1;A{i}='waveposout.asc';
i=i+1;A{i}='modelpadding.asc';
i=i+1;A{i}='sourcepos.asc';
i=i+1;A{i}='tauxx.autosave';
i=i+1;A{i}='tauzz.autosave';
i=i+1;A{i}='ut.autosave';
i=i+1;A{i}='tauxz.autosave';
i=i+1;A{i}='time.autosave';
i=i+1;A{i}='wt.autosave';
i=i+1;A{i}='source.asc';

i=0;
i=i+1;B{i}='denu.mod';
i=i+1;B{i}='denw.mod';
i=i+1;B{i}='l.mod';
i=i+1;B{i}='mu.mod';
i=i+1;B{i}='l2mu.mod';
i=i+1;B{i}='l2mu_pad.mod';
i=i+1;B{i}='denu_pad.mod';
i=i+1;B{i}='denw_pad.mod';
i=i+1;B{i}='l_pad.mod';
i=i+1;B{i}='mu_pad.mod';
i=i+1;B{i}='div.snap';
i=i+1;B{i}='prt.snap';
i=i+1;B{i}='rot.snap';
i=i+1;B{i}='ut.snap';
i=i+1;B{i}='wt.snap';

i=0;
i=i+1;C{i}='geodiv.f77';
i=i+1;C{i}='georot.f77';
i=i+1;C{i}='geou.f77';
i=i+1;C{i}='geow.f77';

if (del_level>0)
    for i=1:length(A);
        f=[wd,filesep,A{i}];
        if exist(f)
            delete(f);
        end
    end
end

if (del_level>1)
    for i=1:length(B);
        f=[wd,filesep,B{i}];
        if exist(f)
            delete(f);
        end
    end
end

if (del_level>2)
    for i=1:length(C);
        f=[wd,filesep,C{i}];
        if exist(f)
            delete(f);
        end
    end
end





