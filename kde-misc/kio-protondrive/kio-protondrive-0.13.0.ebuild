# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Template: packaging/gentoo/make-overlay.sh fills CXXBRIDGE_PV and CRATES
# (and the crate part of LICENSE) from a freshly resolved Cargo.lock, since
# Cargo.lock isn't committed upstream.

EAPI=8

CXXBRIDGE_PV="1.0.202"
CRATES="
	aho-corasick@1.1.5
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	bitflags@1.3.2
	bitflags@2.13.2
	block@0.1.6
	bumpalo@3.20.3
	cc@1.6.0
	cfg-if@1.0.5
	clap@4.6.6
	clap@4.6.7
	clap_builder@4.6.6
	clap_builder@4.6.7
	clap_lex@1.1.0
	clap_lex@1.1.1
	codespan-reporting@0.13.1
	colorchoice@1.0.5
	cxx-build@1.0.202
	cxx@1.0.202
	cxxbridge-cmd@1.0.202
	cxxbridge-flags@1.0.202
	cxxbridge-macro@1.0.202
	defmt-macros@1.1.1
	defmt-parser@1.0.0
	defmt@1.1.1
	env_filter@2.0.0
	env_logger@0.11.11
	equivalent@1.0.2
	errno@0.3.14
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	fastrand@2.5.0
	file-id@0.2.3
	find-msvc-tools@0.1.14
	foldhash@0.2.0
	fsevent-sys@4.1.0
	getrandom@0.4.3
	gettext-rs@0.8.0
	gettext-sys@0.27.0
	hashbrown@0.16.1
	hashbrown@0.17.1
	hashlink@0.12.2
	indexmap@2.14.2
	inotify-sys@0.1.8
	inotify@0.11.5
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	jiff-core@0.1.1
	jiff-static@0.2.38
	jiff@0.2.38
	js-sys@0.3.106
	kqueue-sys@1.1.2
	kqueue@1.2.1
	lazy_static@1.5.1
	libc@0.2.190
	libsqlite3-sys@0.38.2
	link-cplusplus@1.0.12
	linux-raw-sys@0.12.1
	locale_config@0.3.0
	log@0.4.34
	malloc_buf@0.0.6
	memchr@2.8.3
	mio@1.2.4
	notify-debouncer-full@0.7.0
	notify-types@2.1.0
	notify@8.2.0
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	pkg-config@0.3.34
	portable-atomic-util@0.2.8
	portable-atomic@1.15.0
	proc-macro2@1.0.107
	quote@1.0.47
	r-efi@6.0.0
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	rsqlite-vfs@0.1.1
	rusqlite@0.40.2
	rustix@1.1.5
	rustversion@1.0.23
	same-file@1.0.6
	scratch@1.0.9
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.151
	serde_spanned@1.1.2
	shlex@2.0.1
	smallvec@1.16.2
	sqlite-wasm-rs@0.5.5
	strsim@0.11.1
	syn@2.0.119
	syn@3.0.5
	syn@3.0.6
	temp-dir@0.1.16
	tempfile@3.27.0
	termcolor@1.4.1
	thiserror-impl@2.0.21
	thiserror@2.0.21
	toml@1.1.8+spec-1.1.0
	toml_datetime@1.1.2+spec-1.1.0
	toml_parser@1.1.5+spec-1.1.0
	toml_writer@1.1.3+spec-1.1.0
	unicode-ident@1.0.24
	unicode-ident@1.0.26
	unicode-width@0.2.2
	utf8parse@0.2.2
	vcpkg@0.2.15
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasm-bindgen-macro-support@0.2.129
	wasm-bindgen-macro@0.2.129
	wasm-bindgen-shared@0.2.129
	wasm-bindgen@0.2.129
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.53.1
	winnow@1.0.4
	zmij@1.0.23
"
# Corrosion runs `cargo install cxxbridge-cmd` at configure time unless a
# cxxbridge of the exact cxx version is on PATH: build that one ourselves,
# offline, from its own published lock (whose crates are in CRATES too).
CRATES+=" cxxbridge-cmd@${CXXBRIDGE_PV}"

RUST_MIN_VER="1.93.0"
KFMIN=6.9.0
QTMIN=6.6.0
inherit cargo desktop ecm flag-o-matic optfeature qt-utils systemd xdg

DESCRIPTION="KIO worker for Proton Drive: browse, download and upload files from Dolphin"
HOMEPAGE="https://github.com/Aarklendoia/kio-protondrive"
SRC_URI="
	https://github.com/Aarklendoia/kio-protondrive/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 CC0-1.0 ISC MIT Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+daemon +wizard"
# The wizard writes the daemon's configuration (it links the daemon crate).
REQUIRED_USE="wizard? ( daemon )"

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,widgets]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	dev-db/sqlite:3
"
DEPEND="${COMMON_DEPEND}"
# curl: proton-drive CLI update checks (core). The wizard's UI runs in Qt's
# own qml6 runtime, with the org.kde.desktop Controls style forced.
RDEPEND="${COMMON_DEPEND}
	net-misc/curl
	wizard? (
		>=dev-qt/qtdeclarative-${QTMIN}:6
		>=kde-frameworks/kirigami-${KFMIN}:6
		>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
	)
"
BDEPEND="
	>=dev-build/corrosion-0.6
	sys-devel/gettext
	wizard? ( >=dev-qt/qttools-${QTMIN}:6[linguist] )
"

pkg_setup() {
	rust_pkg_setup
}

src_unpack() {
	cargo_src_unpack
}

src_configure() {
	# The cc crate honors CFLAGS, so with -flto the C++ part of core/ (cxx's
	# runtime) becomes LTO bytecode that neither the Rust link nor the CMake
	# link of the plugins resolves (upstream #111).
	# cargo_env filters it for its own calls, not for Corrosion's.
	filter-lto

	cargo_env "${CARGO}" install --offline --locked \
		--path "${ECARGO_VENDOR}/cxxbridge-cmd-${CXXBRIDGE_PV}" \
		--target-dir "${T}/cxxbridge-target" \
		--root "${T}/cxxbridge" || die "building cxxbridge failed"
	export PATH="${T}/cxxbridge/bin:${PATH}"

	local mycmakeargs=(
		-DRust_COMPILER="${RUSTC}"
		-DRust_CARGO="${CARGO}"
	)
	ecm_src_configure

	local myargs=()
	use daemon && myargs+=( --package kio-protondrive-daemon )
	use wizard && myargs+=( --package kio-protondrive-wizard )
	cargo_src_configure "${myargs[@]}"
}

src_compile() {
	cmake_src_compile

	use daemon && cargo_src_compile

	if use wizard; then
		local ts
		for ts in wizard/translations/*.ts; do
			"$(qt_get_broot_binary 6 lrelease)" "${ts}" -qm "${ts%.ts}.qm" || die
		done
	fi
}

src_test() {
	cargo_src_test --workspace
	ecm_src_test
}

src_install() {
	ecm_src_install

	if use daemon; then
		dobin "$(cargo_target_dir)"/kio-protondrive-daemon
		systemd_newuserunit debian/kio-protondrive-sync-daemon.user.service \
			kio-protondrive-sync-daemon.service
	else
		# Pin/unpin menu: only useful with the daemon.
		find "${ED}" \( -name 'protondrive_fileitemaction.so' \
			-o -name 'kio_protondrive_daemon.mo' \) -delete || die
	fi

	if use wizard; then
		dobin "$(cargo_target_dir)"/kio-protondrive-wizard
		domenu wizard/kio-protondrive-wizard.desktop
		insinto /usr/share/metainfo
		doins wizard/kio-protondrive-wizard.metainfo.xml
		insinto /usr/share/kio-protondrive-wizard/qml
		doins wizard/qml/*.qml
		insinto /usr/share/kio-protondrive-wizard/translations
		doins wizard/translations/*.qm
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "kio-protondrive drives Proton's own proton-drive CLI, which is not"
	elog "packaged in Gentoo: install it from https://proton.me/drive/download"
	use wizard && elog "or let kio-protondrive-wizard install it for you."
	if use daemon; then
		elog
		elog "Start the sync daemon for your user with:"
		elog "  systemctl --user enable --now kio-protondrive-sync-daemon.service"
	fi
	optfeature "pin/unpin progress notifications" x11-libs/libnotify
	use wizard && optfeature "GPG-encrypted session storage" app-admin/pass
}
