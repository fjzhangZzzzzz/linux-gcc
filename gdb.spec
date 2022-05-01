Name:           gdb
Version:        7.12
Release:        1%{?dist}
Summary:        gdb
Group:          fjzhang
License:        GPL
URL:            https://github.com/fjzhangZzzzzz
Prefix:         %{_prefix}
Packager:       fjzhang
BuildRoot:      %{_tmppath}/%{name}-buildroot
Source0:        %{name}-%{version}.tar.xz

%description
gnu %{name}-%{version}

%prep
%setup -q -n %{name}-%{version}

%build
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
CFLAGS="$RPM_OPT_FLAGS" ./configure --prefix=%{_prefix} --mandir=%{_mandir}
make

%install
make DESTDIR=$RPM_BUILD_ROOT install

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

%files
%{_prefix}/*

%changelog
* Sat Apr 30 2022 fjzhang fjzhang<fjzhang_@outlook.com> - 1.0.0
- Initial rpm release