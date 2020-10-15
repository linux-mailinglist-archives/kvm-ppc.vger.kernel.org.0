Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9151828EDD7
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Oct 2020 09:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgJOHo1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Oct 2020 03:44:27 -0400
Received: from verein.lst.de ([213.95.11.211]:59457 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728634AbgJOHo1 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 15 Oct 2020 03:44:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0DBFA68AFE; Thu, 15 Oct 2020 09:44:24 +0200 (CEST)
Date:   Thu, 15 Oct 2020 09:44:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        Linux MM <linux-mm@kvack.org>, kvm-ppc@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm/hmm: make device private reference counts zero
 based
Message-ID: <20201015074423.GC14082@lst.de>
References: <20201012174540.17328-1-rcampbell@nvidia.com> <CAPcyv4ijD+=3rje1CfSG4XKuRNfuAWOui93NQV09NmBte_gc0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ijD+=3rje1CfSG4XKuRNfuAWOui93NQV09NmBte_gc0w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Oct 12, 2020 at 02:14:07PM -0700, Dan Williams wrote:
> > ZONE_DEVICE struct pages have an extra reference count that complicates the
> > code for put_page() and several places in the kernel that need to check the
> > reference count to see that a page is not being used (gup, compaction,
> > migration, etc.). Clean up the code so the reference count doesn't need to
> > be treated specially for device private pages, leaving DAX as still being
> > a special case.
> 
> Please no half-step to removing the special casing...

Agreed.  I really like where the refcount changes are heading, but
I don't think this half-step is helpful.
