#!/usr/bin/env bash
#
# Yamada Hayao
# Twitter: @Hayao0819
# Email  : hayao@fascode.net
#
# (c) 2019-2021 Fascode Network.
#
#shellcheck disable=SC2001

set -e -u

aur_username="aurbuild"
pacman_debug=false
pacman_args=()
failedpkg=()
remove_list=()
aur_helper_depends=("go")
aur_helper_command="yay"
aur_helper_package="yay"
aur_helper_args=()
pkglist=()

set -x 
cat /etc/pacman.conf 
cat /etc/pacman.d/mirrorlist

cat>/etc/pacman.conf<<EOF
#
# /etc/pacman.conf
#
# See the pacman.conf(5) manpage for option and repository directives

#
# GENERAL OPTIONS
#
[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir    = /var/cache/pacman/pkg/
#LogFile     = /var/log/pacman.log
#GPGDir      = /etc/pacman.d/gnupg/
#HookDir     = /etc/pacman.d/hooks/
HoldPkg     = pacman glibc
#XferCommand = /usr/bin/curl -L -C - -f -o %o %u
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
Architecture = auto

# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
#IgnorePkg   =
#IgnoreGroup =

#NoUpgrade   =
#NoExtract   =

# Misc options
#UseSyslog
#Color
#NoProgressBar
CheckSpace
#VerbosePkgLists
#ParallelDownloads = 5

# By default, pacman accepts packages signed by keys that its local keyring
# trusts (see pacman-key and its man page), as well as unsigned packages.
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
#RemoteFileSigLevel = Required

# NOTE: You must run `pacman-key --init` before first using pacman; the local
# keyring can then be populated with the keys of all official Arch Linux
# packagers with `pacman-key --populate archlinux`.

#
# REPOSITORIES
#   - can be defined here or included from another file
#   - pacman will search repositories in the order defined here
#   - local/custom mirrors can be added here or in separate files
#   - repositories listed first will take precedence when packages
#     have identical names, regardless of version number
#   - URLs will have \$repo replaced by the name of the current repo
#   - URLs will have \$arch replaced by the name of the architecture
#
# Repository entries are of the format:
#       [repo-name]
#       Server = ServerName
#       Include = IncludePath
#
# The header [repo-name] is crucial - it must be present and
# uncommented to enable the repo.
#

# The testing repositories are disabled by default. To enable, uncomment the
# repo name header and Include lines. You can add preferred servers immediately
# after the header, and they will be used before the default mirrors.

#[testing]
#Include = /etc/pacman.d/mirrorlist

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

#[community-testing]
#Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist


# If you want to run 32 bit applications on your x86_64 system,
# enable the multilib repositories as required here.

#[multilib-testing]
#Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist


# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
#[custom]
#SigLevel = Optional TrustAll
#Server = file:///home/custompkgs
EOF


cat>/etc/pacman.d/mirrorlist<<EOF
Server = https://mirrors.kernel.org/archlinux/\$repo/os/\$arch
Server = https://america.mirror.pkgbuild.com/\$repo/os/\$arch
Server = https://mirror.pkgbuild.com/\$repo/os/\$arch
Server = https://america.mirror.pkgbuild.com/\$repo/os/\$arch

EOF

pacman -Syyu --noconfirm

pacman-key --init
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman --noconfirm -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

cat>/etc/pacman.conf<<EOF
#
# /etc/pacman.conf
#
# See the pacman.conf(5) manpage for option and repository directives

#
# GENERAL OPTIONS
#
[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir    = /var/cache/pacman/pkg/
#LogFile     = /var/log/pacman.log
#GPGDir      = /etc/pacman.d/gnupg/
#HookDir     = /etc/pacman.d/hooks/
HoldPkg     = pacman glibc
#XferCommand = /usr/bin/curl -L -C - -f -o %o %u
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
Architecture = auto

# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
#IgnorePkg   =
#IgnoreGroup =

#NoUpgrade   =
#NoExtract   =

# Misc options
#UseSyslog
#Color
#NoProgressBar
CheckSpace
#VerbosePkgLists
#ParallelDownloads = 5

# By default, pacman accepts packages signed by keys that its local keyring
# trusts (see pacman-key and its man page), as well as unsigned packages.
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
#RemoteFileSigLevel = Required

# NOTE: You must run `pacman-key --init` before first using pacman; the local
# keyring can then be populated with the keys of all official Arch Linux
# packagers with `pacman-key --populate archlinux`.

#
# REPOSITORIES
#   - can be defined here or included from another file
#   - pacman will search repositories in the order defined here
#   - local/custom mirrors can be added here or in separate files
#   - repositories listed first will take precedence when packages
#     have identical names, regardless of version number
#   - URLs will have \$repo replaced by the name of the current repo
#   - URLs will have \$arch replaced by the name of the architecture
#
# Repository entries are of the format:
#       [repo-name]
#       Server = ServerName
#       Include = IncludePath
#
# The header [repo-name] is crucial - it must be present and
# uncommented to enable the repo.
#

# The testing repositories are disabled by default. To enable, uncomment the
# repo name header and Include lines. You can add preferred servers immediately
# after the header, and they will be used before the default mirrors.

#[testing]
#Include = /etc/pacman.d/mirrorlist

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

#[community-testing]
#Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist


# If you want to run 32 bit applications on your x86_64 system,
# enable the multilib repositories as required here.

#[multilib-testing]
#Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist

# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
#[custom]
#SigLevel = Optional TrustAll
#Server = file:///home/custompkgs
EOF
pacman -Syyu --noconfirm

trap 'exit 1' 1 2 3 15

_help() {
    echo "usage ${0} [option] [aur helper args] ..."
    echo
    echo "Install aur packages with ${aur_helper_command}" 
    echo
    echo " General options:"
    echo "    -a [command]             Set the command of aur helper"
    echo "    -c                       Enable pacman debug message"
    echo "    -e [pkg]                 Set the package name of aur helper"
    echo "    -d [pkg1,pkg2...]        Set the oackage of the depends of aur helper"
    echo "    -p [pkg1,pkg2...]        Set the AUR package to install"
    echo "    -u [user]                Set the user name to build packages"
    echo "    -x                       Enable bash debug message"
    echo "    -h                       This help message"
}

while getopts "a:cd:e:p:u:xh" arg; do
    case "${arg}" in
        a) aur_helper_command="${OPTARG}" ;;
        c) pacman_debug=true ;;
        e) aur_helper_package="${OPTARG}" ;;
        p) readarray -t pkglist < <(sed "s|,$||g" <<< "${OPTARG}" | tr "," "\n") ;;
        d) readarray -t aur_helper_depends < <(sed "s|,$||g" <<< "${OPTARG}" | tr "," "\n") ;;
        u) aur_username="${OPTARG}" ;;
        x) set -xv ;;
        h) 
            _help
            exit 0
            ;;
        *)
            _help
            exit 1
            ;;
    esac
done

shift "$((OPTIND - 1))"
aur_helper_args=("${@}")
eval set -- "${pkglist[@]}"

# Show message when file is removed
# remove <file> <file> ...
remove() {
    local _file
    for _file in "${@}"; do echo "Removing ${_file}" >&2; rm -rf "${_file}"; done
}

# user_check <name>
user_check () {
    if [[ ! -v 1 ]]; then return 2; fi
    getent passwd "${1}" > /dev/null
}

installpkg(){
    yes | sudo -u "${aur_username}" \
        "${aur_helper_command}" -S \
            --color always \
            --cachedir "/var/cache/pacman/pkg/" \
            "${pacman_args[@]}" \
            "${aur_helper_args[@]}" \
            "${@}" || true
}

installpkg2(){
    cat /etc/alteriso-pacman.conf
    cat /etc/pacman.conf
    # Install
    if ! pacman -Qq "${1}" 1> /dev/null 2>&1; then
        _oldpwd="$(pwd)"
        # Build
        sudo -u "${aur_username}" git clone --depth=1 -b $1 "https://github.com/archlinux/aur.git" "/tmp/${1}"
        cd "/tmp/${1}"
        sudo -u "${aur_username}" makepkg --ignorearch --clean --cleanbuild --force --skippgpcheck --noconfirm --syncdeps

        # Install
        for _pkg in $(cd "/tmp/${1}"; sudo -u "${aur_username}" makepkg --packagelist); do
            pacman "${pacman_args[@]}" -U "${_pkg}"
        done

        # Remove debtis
        cd ..
        remove "/tmp/${1}"
        cd "${_oldpwd}"
    fi
}

#-- main funtions --#
prepare_env(){
    # Creating a aur user.
    if ! user_check "${aur_username}"; then
        useradd -m -d "/aurbuild_temp" "${aur_username}"
    fi
    mkdir -p "/aurbuild_temp"
    chmod 700 -R "/aurbuild_temp"
    chown "${aur_username}:${aur_username}" -R "/aurbuild_temp"
    echo "${aur_username} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/aurbuild"

    # Setup keyring
    pacman-key --init
    pacman-key --populate

    # Un comment the mirror list.
    #sed -i "s/#Server/Server/g" "/etc/pacman.d/mirrorlist"


    # Set pacman args
    pacman_args=("--config" "/etc/alteriso-pacman.conf" "--noconfirm")
    if [[ "${pacman_debug}" = true ]]; then
        pacman_args+=("--debug")
    fi
}

install_aur_helper(){
    # Install
    if ! pacman -Qq "${aur_helper_package}" 1> /dev/null 2>&1; then
        _oldpwd="$(pwd)"

        # Install depends
        for _pkg in "${aur_helper_depends[@]}"; do
            if ! pacman -Qq "${_pkg}" > /dev/null 2>&1 | grep -q "${_pkg}"; then
                # --asdepsをつけているのでaur.shで削除される --neededをつけているので明示的にインストールされている場合削除されない
                pacman -S --asdeps --needed "${pacman_args[@]}" "${_pkg}"
                #remove_list+=("${_pkg}")
            fi
        done

        # Build
        sudo -u "${aur_username}" git clone "https://aur.archlinux.org/${aur_helper_package}.git" "/tmp/${aur_helper_package}"
        cd "/tmp/${aur_helper_package}"
        sudo -u "${aur_username}" makepkg --ignorearch --clean --cleanbuild --force --skippgpcheck --noconfirm --syncdeps

        # Install
        for _pkg in $(cd "/tmp/${aur_helper_package}"; sudo -u "${aur_username}" makepkg --packagelist); do
            pacman "${pacman_args[@]}" -U "${_pkg}"
        done

        # Remove debtis
        cd ..
        remove "/tmp/${aur_helper_package}"
        cd "${_oldpwd}"
    fi

    if ! type -p "${aur_helper_command}" > /dev/null; then
        echo "Failed to install ${aur_helper_package}"
        exit 1
    fi
}

install_aur_pkgs(){
    # Update database
    pacman -Syy "${pacman_args[@]}"

    # Build and install
    chmod +s /usr/bin/sudo
    for _pkg in "${@}"; do
        pacman -Qq "${_pkg}" > /dev/null 2>&1  && continue
        installpkg2 "${_pkg}"

        if ! pacman -Qq "${_pkg}" > /dev/null 2>&1; then
            echo -e "\n[aur.sh] Failed to install ${_pkg}\n"
            failedpkg+=("${_pkg}")
        fi
    done

    # Reinstall failed package
    for _pkg in "${failedpkg[@]}"; do
        installpkg2 "${_pkg}"
        if ! pacman -Qq "${_pkg}" > /dev/null 2>&1; then
            echo -e "\n[aur.sh] Failed to install ${_pkg}\n"
            exit 1
        fi
    done
}

cleanup(){
    # Remove packages
    readarray -t -O "${#remove_list[@]}" remove_list < <(pacman -Qttdq)
    (( "${#remove_list[@]}" != 0 )) && pacman -Rsnc "${remove_list[@]}" "${pacman_args[@]}"

    # Clean up
    "${aur_helper_command}" -Sccc "${pacman_args[@]}" || true

    # remove user and file
    userdel "${aur_username}"
    remove /aurbuild_temp
    remove /etc/sudoers.d/aurbuild
    remove "/etc/alteriso-pacman.conf"
    remove "/var/cache/pacman/pkg/"
}


prepare_env
install_aur_helper
install_aur_pkgs "$@"
cleanup

