# $Id$
#
# @Copyright@
# @Copyright@
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

SEDSPEC += \
        -e 's%@LMHOME@%$(LMHOME)%g' \
        -e 's%@LMCOREDISK@%$(LMCOREDISK)%g' \
        -e 's%@SOLRDATA@%$(SOLRDATA)%g' \
        -e 's%@SOLRDIR@%$(SOLRDIR)%g' \
        -e 's%@SOLRUSER@%$(SOLRUSER)%g' \
        -e 's%@SOLR_PORT@%$(SOLR_PORT)%g' \
        -e 's%@ZK_HOST@%$(ZK_HOST)%g' \
        -e 's%@LMURL@%$(LMURL)%g' \
        -e 's%@ARCHIVENAME@%$(ARCHIVENAME)%g' \
        -e 's%@JTS@%$(JTS)%g' \
        -e 's%@JTSDIR@%$(JTSDIR)%g' \
        -e 's%@TARBALL_POSTFIX@%$(TARBALL_POSTFIX)%g' \
        -e 's%@VERSION@%$(VERSION)%g'

SCRIPTS = \
        solr.txt \
        solr-index

version.mk:
	cat ../version.mk version.mk.in > version.mk

solr.txt: solr.txt.in
	$(SED) $(SEDSPEC) $^ > $@

solr-index: solr-index.in
	$(SED) $(SEDSPEC) $^ > $@

prepSrc.sh: prepSrc.sh.in
	$(SED) $(SEDSPEC) $^ > $@
	chmod 755 $@

prep: prepSrc.sh
	rm -rf version.mk
	make version.mk
	make prepSrc.sh
	./prepSrc.sh

build: $(SCRIPTS)

install::
	mkdir -p $(ROOT)/$(SOLRDIR)
	tar -xzf  $(ARCHIVENAME)-$(VERSION).tgz  -C  $(ROOT)/$(SOLRDIR) --strip 1 --exclude docs --exclude contrib	
	
	mkdir -p $(ROOT)/$(SOLRDATA)/data
	mkdir -p $(ROOT)/$(SOLRDATA)/cores
	mkdir -p $(ROOT)/$(SOLRDATA)/logs
	cp $(ROOT)/$(SOLRDIR)/server/solr/solr.xml $(ROOT)/$(SOLRDATA)/data
	cp $(ROOT)/$(SOLRDIR)/server/solr/zoo.cfg $(ROOT)/$(SOLRDATA)/data
	cp $(ROOT)/$(SOLRDIR)/server/resources/log4j2.xml  $(ROOT)/$(SOLRDATA)/log4j2.xml
	
	mkdir -p $(ROOT)/etc/default
	cat $(ROOT)/$(SOLRDIR)/bin/solr.in.sh solr.txt > solrenv.tmp	
	cp solrenv.tmp $(ROOT)/etc/default/solr.in.sh
	chmod 755 $(ROOT)/etc/default/solr.in.sh
	cp solrenv.tmp  $(ROOT)/$(SOLRDIR)/bin/solr.in.sh
	chmod 755  $(ROOT)/$(SOLRDIR)/bin/solr.in.sh
	
	mkdir -p $(ROOT)/$(JTSDIR)
	cp  $(JTS)  $(ROOT)/$(JTSDIR)/
	
	mkdir -p $(ROOT)/etc/security/limits.d/
	install -m 644 lifemapper.solr.conf $(ROOT)/etc/security/limits.d
	
	# Use defaults for SOLR_INSTALL_DIR, SOLR_ENV, and RUNAS, so no var substitution here
	mkdir -p $(ROOT)/etc/rc.d/init.d
	install -m 755 $(ROOT)/$(SOLRDIR)/bin/init.d/solr  $(ROOT)/etc/rc.d/init.d
	
	mkdir -p $(ROOT)/$(LMHOME)/rocks/bin
	install -m 755 solr-index $(ROOT)/$(LMHOME)/rocks/bin
	
	mkdir -p $(ROOT)/$(LMHOME)/rocks/etc
	install -m 644 pysolr*tar.gz $(ROOT)/$(LMHOME)/rocks/etc

clean::
	rm -rf $(ARCHIVENAME)-$(VERSION) 
	rm -rf version.mk  prepSrc.sh *sha512
	rm -rf $(SCRIPTS) 
