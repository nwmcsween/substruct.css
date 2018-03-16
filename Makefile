MAKEFLAGS := -r

ANALYZE := node_modules/.bin/parker
FORMAT := node_modules/.bin/prettier
POSTCSS := node_modules/.bin/postcss
POSTCSS_OPTS ?=

COMPRESS ?= zopfli
COMPRESS_OPTS ?= -c

SRC_DIR := lib
WORK_DIR := build

ALL_SRC := $(sort $(wildcard $(SRC_DIR)/*.css))
ALL_DST := $(addprefix $(WORK_DIR)/, $(ALL_SRC:$(SRC_DIR)/%=%))
ALL_DST_MIN := $(ALL_DST:.css=.min.css)
ALL_DST_MIN_COMPRESS := $(ALL_DST_MIN:=.gz)
ALL_DST_MERGE := $(WORK_DIR)/substruct.css
ALL_DST_MERGE_MIN := $(ALL_DST_MERGE:.css=.min.css)
ALL_DST_MERGE_MIN_COMPRESS := $(ALL_DST_MERGE_MIN:=.gz)

WORK_DIRS := $(sort $(dir $(ALL_DST)))

.PHONY: all analyze clean compress format unformatted min

all: $(ALL_DST) min compress

analyze: $(ALL_SRC)
	$(ANALYZE) $^

clean:
	rm -rf $(WORK_DIR)

format:
	$(FORMAT) --write $(SRC_DIR)/*/*.css $(SRC_DIR)/*/*/*.css

unformatted: 
	$(FORMAT) -l $(SRC_DIR)/*/*.css $(SRC_DIR)/*/*/*.css

min: $(ALL_DST_MIN) $(ALL_DST_MERGE_MIN)

compress: $(ALL_DST_MIN_COMPRESS) $(ALL_DST_MERGE_MIN_COMPRESS)

$(WORK_DIR)/%.css: $(SRC_DIR)/%.css | $(WORK_DIRS)
	$(POSTCSS) $(POSTCSS_OPTS) $< -o $@

%.min.css: %.css
	$(POSTCSS) -e production $(POSTOPT) $< -o $@

%.min.css.gz: %.min.css
	$(COMPRESS) $(COMPRESS_OPTS) $< > $@

$(ALL_DST_MERGE): $(ALL_DST)
	cat $^ > $@
	$(POSTCSS) $@ -o $@

$(WORK_DIRS):
	@mkdir -p $@
