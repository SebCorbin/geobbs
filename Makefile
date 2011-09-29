TESTS = $(shell find server/test/ -name '*.test.js')


build:
	find . -name '*.coffee' -exec coffee -c '{}' \;

test:
	@NODE_ENV=test expresso \
		-I lib \
		-I support \
		-I support/should.js/lib \
		-I support/cli-table/lib \
		$(TESTFLAGS) \
		$(TESTS)

#clear && find . -name "*.test.js" -exec expresso -c '{}' \;

test-cov:
	@TESTFLAGS=--cov $(MAKE) test

docclean:
	rm -f docs/*.{1,html}

.PHONY: test test-cov docs docclean