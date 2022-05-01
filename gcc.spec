Name:           gcc
Version:        4.9.4
Release:        1%{?dist}
Summary:        gcc
Group:          fjzhang
License:        GPL
URL:            https://github.com/fjzhangZzzzzz
Prefix:         %{_prefix}
Packager:       fjzhang
BuildRoot:      %{_tmppath}/%{name}-buildroot
Source0:        %{name}-%{version}.tar.gz

%description
gnu %{name}-%{version}

%prep
%setup -q -n %{name}-%{version}

%build
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
chmod u+x contrib/download_prerequisites && ./contrib/download_prerequisites
CFLAGS="$RPM_OPT_FLAGS" ./configure --prefix=%{_prefix} --mandir=%{_mandir} --enable-checking=release --enable-languages=c,c++ \
              --disable-multilib --enable-libstdcxx-allocator --enable-threads \
              --enable-libstdcxx-threads --enable-long-long --enable-threads=posix \
              --enable-tls --enable-libsanitizer --enable-default-pie --enable-default-ssp
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