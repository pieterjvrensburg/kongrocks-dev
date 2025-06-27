package = "cqueues"
version = "20161214.53-0"
source = {
	url = "https://github.com/wahern/cqueues/archive/rel-20161214.tar.gz";
	md5 = "9bf621290b1c152fbf5ba4bcc7eb9c3b";
	dir = "cqueues-rel-20161214";
}
description = {
	summary = "Continuation Queues: Embeddable asynchronous networking, threading, and notification framework for Lua on Unix.";
	homepage = "http://25thandclement.com/~william/projects/cqueues.html";
	license = "MIT/X11";
	maintainer = "Daurnimator <quae@daurnimator.com>";
}
supported_platforms = {
	"linux";
	"bsd";
	"solaris";
}
dependencies = {
	"lua == 5.3";
}
external_dependencies = {
	OPENSSL = {
		header = "openssl/ssl.h";
		library = "ssl";
	};
	CRYPTO = {
		header = "openssl/crypto.h";
		library = "crypto";
	};
}
build = {
	type = "make";
	makefile = "GNUmakefile";

	build_target = "all5.3";
	build_variables = {
		CPPFLAGS= '-I"$(OPENSSL_INCDIR)" -I"$(CRYPTO_INCDIR)"';
		CFLAGS = '$(CFLAGS)';
		LDFLAGS = '$(LIBFLAG) -L"$(OPENSSL_LIBDIR)" -L"$(CRYPTO_LIBDIR)"';
		bindir = "$(LUA_BINDIR)";
		includedir = "$(LUA_INCDIR)";
		libdir = "$(LUA_LIBDIR)";
	};

	install_target = "install5.3";
	install_variables = {
		prefix = "$(PREFIX)";
		lua53cpath = "$(LIBDIR)";
		lua53path = "$(LUADIR)";
		bindir = "$(BINDIR)";
	};
}
