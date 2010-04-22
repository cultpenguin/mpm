Summary: 2D Elastic Main Phase Modeling
Name: mpm
Version: 1.1
Release: 1
Copyright: GPL
Group: Applications/Engineering
Source0: %{name}-%{version}.tar.gz

%description
Main Phase Modeling, MPM, is a implementation of a 2D staggered grid solution of the elastic waveequation, using a moving zone. This enables both efficient modeling of seismic wide angle data, and modeling of selected propagating phases.


%prep
%setup -q


%build
cd src
make


%install
install $RPM_BUILD_DIR/$RPM_PACKAGE_NAME-$RPM_PACKAGE_VERSION/src/mpm /usr/bin/mpm

%clean
rm -rf $RPM_BUILD_ROOT
rpm -fr /usr/bin/mpm



%files
%doc INSTALL LICENSE README TODO misc examples
/usr/bin/mpm
