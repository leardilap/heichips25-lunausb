all: macro copy-final

PDK_ROOT ?= ~/.ciel
PDK ?= ihp-sg13g2

RUN_TAG = $(shell ls runs/ -1 | tail -n 1)

# Macro - LibreLane

macro:
	librelane config.yaml --pdk $(PDK)
.PHONY: macro

macro-openroad:
	librelane config.yaml --pdk $(PDK) --last-run --flow OpenInOpenROAD
.PHONY: macro-openroad

macro-klayout:
	librelane config.yaml --pdk $(PDK) --last-run --flow OpenInKLayout
.PHONY: macro-klayout

copy-macro:
	mkdir -p macro/
	rm -rf macro/*
	cp -r runs/${RUN_TAG}/final/* macro/
.PHONY: copy-macro
