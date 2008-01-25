#
# spec file for gnome-keyring-sharp
#

# norootforbuild

Name:           gnome-keyring-sharp
Group:          Development/Libraries/Other
Summary:        Managed implementation of libgnome-keyring
Version:        0.1.0
Release:        16.8
License:        X11/MIT
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildRequires:  gnome-keyring gnome-keyring-devel gtk2-devel mono-devel ndesk-dbus
Requires:       ndesk-dbus gnome-keyring
Source:         %{name}-%{version}.tar.bz2
Source1:        Gnome.Keyring.key
Patch:          gnome-keyring-sharp-gacutil.patch
Patch1:         gnome-keyring-sharp-makefix.patch
Autoreqprov:    on


%description
When the gnome-keyring-daemon is running, you can use this to retrive/store confidential information such as passwords, notes or network services user information.


%prep
%setup -n Gnome.Keyring-%{version}
cp %{S:1} .
%patch
%patch1

%build
autoreconf -f -i
%configure\
        --disable-scrollkeeper
make %{?jobs:-j%jobs}

%install
make -C src install DESTDIR="$RPM_BUILD_ROOT" prefix=%{_prefix}

%clean
rm -rf "$RPM_BUILD_ROOT"

%files
%defattr(-,root,root)
%dir %{_prefix}/lib/Gnome.Keyring
%{_prefix}/lib/Gnome.Keyring/Gnome.Keyring.dll
%{_libdir}/pkgconfig/gnome-keyring-sharp.pc
%{_prefix}/lib/mono/gac/Gnome.Keyring

