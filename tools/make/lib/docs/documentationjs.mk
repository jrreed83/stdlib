
# VARIABLES #

# Define the command for removing files and directories:
DELETE ?= -rm
DELETE_FLAGS ?= -rf

# Determine the host kernel:
KERNEL ?= $(shell uname -s)

# Based on the kernel, determine the `open` command:
ifeq ($(KERNEL), Darwin)
	OPEN ?= open
else
	OPEN ?= xdg-open
endif
# TODO: add Windows command

# Define the command for recursively creating directories (WARNING: possible portability issues on some systems!):
MKDIR ?= mkdir
MKDIR_FLAGS ?= -p

# Define the path of the documentation.js executable:
DOCUMENTATIONJS ?= $(BIN_DIR)/documentation

# Define the path to JSDoc type definitions:
DOCUMENTATIONJS_TYPEDEF ?= $(TOOLS_DIR)/docs/jsdoc/typedefs/*.js

# Define the output directory for documentation.js:
DOCUMENTATIONJS_OUT ?= $(DOCS_DIR)/documentationjs

# Define the output directory for documentation.js JSON:
DOCUMENTATIONJS_JSON_OUT ?= $(DOCUMENTATIONJS_OUT)/json

# Define the output filepath for documentation.js JSON:
DOCUMENTATIONJS_JSON ?= $(DOCUMENTATIONJS_JSON_OUT)/documentationjs.json

# Define the output directory for documentation.js HTML documentation:
DOCUMENTATIONJS_HTML_OUT ?= $(DOCUMENTATIONJS_OUT)/static

# Define the output filepath for HTML documentation:
DOCUMENTATIONJS_HTML ?= $(DOCUMENTATIONJS_HTML_OUT)/index.html

# Define command-line options to be used when invoking the documentation.js executable to generate HTML documentation:
DOCUMENTATIONJS_HTML_FLAGS ?= --format html \
	--output $(DOCUMENTATIONJS_HTML_OUT)

# Define command-line options to be used when invoking the documentation.js executable to generate JSON:
DOCUMENTATIONJS_JSON_FLAGS ?= --format json


# TARGETS #

# Generate HTML documentation.
#
# This target generates source HTML documentation from [JSDoc][1]-style comments using [documentation.js][2].
#
# To install documentation.js:
#     $ npm install documentation
#
# [1]: http://usejsdoc.org/
# [2]: https://github.com/documentationjs/documentation

documentationjs-html: $(NODE_MODULES)
	$(DELETE) $(DELETE_FLAGS) $(DOCUMENTATIONJS_HTML_OUT)
	$(MKDIR) $(MKDIR_FLAGS) $(DOCUMENTATIONJS_HTML_OUT)
	$(DOCUMENTATIONJS) $(DOCUMENTATIONJS_HTML_FLAGS) $(DOCUMENTATIONJS_TYPEDEF) $(SOURCES)

.PHONY: documentationjs-html


# Generate JSDoc JSON.
#
# This target generates JSDoc JSON from [JSDoc][1]-style comments.
#
# To install documentation.js:
#     $ npm install documentation
#
# [1]: http://usejsdoc.org/
# [2]: https://github.com/documentationjs/documentation

documentationjs-json: $(NODE_MODULES)
	$(DELETE) $(DELETE_FLAGS) $(DOCUMENTATIONJS_JSON)
	$(MKDIR) $(MKDIR_FLAGS) $(DOCUMENTATIONJS_JSON_OUT)
	$(DOCUMENTATIONJS) $(DOCUMENTATIONJS_JSON_FLAGS) $(DOCUMENTATIONJS_TYPEDEF) $(SOURCES) > $(DOCUMENTATIONJS_JSON)

.PHONY: documentationjs-json


# View HTML documentation.
#
# This target opens documentation.js HTML documentation in a local web browser.

view-documentationjs-html:
	$(OPEN) $(DOCUMENTATIONJS_HTML)

.PHONY: view-documentationjs-html


# Remove a documentation.js output directory.
#
# This target cleans up a documentation.js output directory by removing it entirely.

clean-documentationjs:
	$(DELETE) $(DELETE_FLAGS) $(DOCUMENTATIONJS_OUT)

.PHONY: clean-documentationjs


# Rebuild HTML documentation.
#
# This target removes any current documentation and regenerates source HTML documentation from [JSDoc][1]-style comments using [documentation.js][2].
#
# To install documentation.js:
#     $ npm install documentation
#
# [1]: http://usejsdoc.org/
# [2]: https://github.com/documentationjs/documentation

rebuild-documentationjs-html:
	@$(MAKE) -f $(this_file) clean-documentationjs
	@$(MAKE) -f $(this_file) documentationjs-html

.PHONY: rebuild-documentationjs-html

