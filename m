Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65261871A2
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 18:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732228AbgCPRzZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 13:55:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45182 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732187AbgCPRzZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Mar 2020 13:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Z99cTMvkUQzm/kuAU8ls0gB+Pxr5s790LKTiYsFOv1E=; b=j83dtT/LbWpAKlQLbxqMvJFIqx
        NTxVmpRITpn8foUwGy+v/BqcOqFhBaBCSjdUkbCBswYo6PUuMKDma+ZXqBE8HrvvEq/IQgrygWsC1
        6ADcRfwun6PEswhPV0aFEXbpdJVu+rlSHHyZ/JDFCpw1ClS+QyI5UrY+kRq/0KNzqG9EcmyqqaO6v
        uqUx9Bl7e0WQzOrBwrTr+NAfZWllh9bzRkS20adASiGmcwTP7xuyX8WSU+R32z2q1lVO99UgcmeF7
        RvbuWuYD+8wT4qmdkc+wOqB8BB+CB+fFn7stq0b7D4M72iWLlWMzaD6fJG7te+KWYISpATB6M6xAC
        /Qs0B5jw==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDtxJ-0000xY-GO; Mon, 16 Mar 2020 17:55:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>
Cc:     Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: ensure device private pages have an owner
Date:   Mon, 16 Mar 2020 18:52:57 +0100
Message-Id: <20200316175259.908713-1-hch@lst.de>
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
