% mpm2segy : converts output data to Segy formatted data.
% 
% mpm2segy(segyfile,mpmfile,varargin);
%
% Defaults to saving SEGY files (Revision 1.00, IEEE)
% IF segyfile-name extension is '.su' a CWP SU style formatted file is written
%
% NOTE : This function makes use of SegyMAT, a free matlab toolbox for handling
%        the SEG Y format from within data.
%        Download it from http://segymat.sourceforge.net/
% 
% 

%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
function mpm2segy(segyfile,mpmfile,varargin);
NA=0;
NAS='0';


if nargin==0,
  mpm2segy('u.su','geou.f77');
  mpm2segy('w.su','geow.f77');
  return
end

if exist('ReadSegy')~=2
  disp(['the SegyMAT-toolbox must be installed to be able to export SU/SEGY files '])
  help mpm2segy
  return
end

for i=1:2:length(varargin)
  var=varargin{i};
  val=varargin{i+1};
  eval([var,'=[',num2str(val),'];']);
end  


[p,f,ext]=fileparts(segyfile);
if strcmp(lower(ext),'.su');
  MakeSU=1;
else
  MakeSU=0;
end

[bignx,dt,tmax,pulsedelay,dx,xs]=read_mpm_par('bignx','dt','tmax','pulsedelay','dx','xs');
load modelpadding.asc;

ntraces=bignx+modelpadding(1)+modelpadding(3);
ntraces=bignx;
ns=floor(tmax/dt);

% IF DATA HAVE BEEN SKIPPED THEN ADJUST
%
[traceskip,tskip]=read_mpm_par('traceskip','tskip');
ntraces=floor(ntraces/traceskip);
ns=floor(ns/tskip);
dx=dx*traceskip;
dt=dt*tskip;
disp(['Apparently ns=',num2str(ns),' and ntraces=',num2str(ntraces)])

%%%%%%%%%%
% SET UP SegyHeader structure.
if exist('TextualFileHeader'),
    SegyHeader.TextualFileHeader=sprintf('%3200s',TexturalFileHeader);
else
    SegyHeader.TextualFileHeader=sprintf('%3200s','RESULT FROM Main Phase Modeling');
end
if exist('dt')==1, SegyHeader.dt=dt.*1e+6; end
if exist('dtOrig')==1, SegyHeader.dtOrig=dtOrig; end
if exist('ns')==1, SegyHeader.ns=ns; end
if exist('nsOrig')==1, SegyHeader.nsOrig=nsOrig; end

SegyHeader.DataSampleFormat=1; 

SegyHeader.Rev=GetSegyHeaderBasics;
SegyHeader.DataSampleFormat=5; % '5'->4-byte IEEE floating point 
SegyHeader.SegyFormatRevisionNumber=100;


mpmdata=f77strip('geou.f77');
[dnsamples,dntraces]=size(mpmdata);

if MakeSU==0
  segyid = fopen(segyfile,'w','b');   % ALL DISK FILES ARE IN BIG
                                    % ENDIAN FORMAT, ACCORDING SEG
                                    % Y rev 1

  PutSegyHeader(segyid,SegyHeader);
else
  segyid = fopen(segyfile,'w'); % SU format os not endiac specific
end

    
for i=1:dntraces;
    if ((i/100)==round(i/100)) 
      disp(['writing trace ',num2str(i),' of ',num2str(ntraces),', filepos=',num2str(ftell(segyid))])
    end
    SegyTraceHeader.ns=ns;
    SegyTraceHeader.dt=dt*1e+6;
    SegyTraceHeader.offset=i*dx-xs;
    SegyTraceHeader.DelayRecordingTime=-pulsedelay*(dt/tskip).*1000;
    %disp(['DelayRecordingTime ',num2str(SegyTraceHeader.DelayRecordingTime)])
    %disp([num2str(pulsedelay),' - PULSEDELAY'])
    %disp([num2str(dt),' - DT'])
    %    disp(SegyTraceHeader.DelayRecordingTime)


    if exist('cdpX')==1,SegyTraceHeader.cdpX = cdpX(i);end
    if exist('cdpY')==1,SegyTraceHeader.cdpY = cdpY(i);end
    if exist('Inline3D')==1,SegyTraceHeader.Inline3D = Inline3D(i);end
    if exist('Crossline3D')==1,SegyTraceHeader.Crossline3D=Crossline3D(i);end

    % GET TRACE DATA


    PutSegyTrace(segyid,mpmdata(1:1:ns,i),SegyTraceHeader,SegyHeader);
end




                                    
                                    
                                    
fclose(segyid);                                  
