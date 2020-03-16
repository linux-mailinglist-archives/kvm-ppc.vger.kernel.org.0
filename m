Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52A118735C
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 20:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732474AbgCPTc2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 15:32:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41536 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732472AbgCPTc1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Mar 2020 15:32:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=mCPVZu9Y0wI9P/gu6FWuMiisXEan/deVgoJ1QqH1xfI=; b=gEHRVS7/1IB1I1Bcqu60/ysHwQ
        hu8vocPqQs6HMaM/YrXs8t5bDUIpRWD04Vy9VaLMHmpkBkSdPfZQK4wQmFMkpRoS1eaRJoWJbbO3t
        BP4lQpXVqQzaU4hOe6DccRInDc1AQpGM0WNzaRtUq0nV5kY4TanXjO2iDWBBBcrOz9keFeyhhw8U8
        CQ8ZJKhtZ886ACZaAa9kpoBgNZJTkLTXRoqTcYWK+GlPFTcaRE/qfqZmlCdLw046fkbPE8FePEG9s
        Vc11Su5XoJs+Jzt4PfNYDOv/lJu67ed5nNHyl2MuELPRjNpEYY95rFP0Gt6TXiO+Z+dbEd+YNMh8F
        ARvDfViA==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDvTG-0003b4-7H; Mon, 16 Mar 2020 19:32:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>
Cc:     Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: ensure device private pages have an owner v2
Date:   Mon, 16 Mar 2020 20:32:12 +0100
Message-Id: <20200316193216.920734-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When acting on device private mappings a driver needs to know if the
device (or other entity in case of kvmppc) actually owns this private
mapping.  This series adds an owner field and converts the migrate_vma
code over to check it.  I looked into doing the same for
hmm_range_fault, but as far as I can tell that code has never been
wired up to actually work for device private memory, so instead of
trying to fix some unused code the second patch just remove the code.
We can add it back once we have a working and fully tested code, and
then should pass the expected owner in the hmm_range structure.

Changes since v1:
 - split out the pgmap->owner addition into a separate patch
 - check pgmap->owner is set for device private mappings
 - rename the dev_private_owner field in struct migrate_vma to src_owner
 - refuse to migrate private pages if src_owner is not set
 - keep the non-fault device private handling in hmm_range_fault
