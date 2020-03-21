Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A095818E141
	for <lists+kvm-ppc@lfdr.de>; Sat, 21 Mar 2020 13:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgCUMiH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 21 Mar 2020 08:38:07 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37778 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgCUMiH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 21 Mar 2020 08:38:07 -0400
Received: by mail-qt1-f196.google.com with SMTP id d12so5087155qtj.4
        for <kvm-ppc@vger.kernel.org>; Sat, 21 Mar 2020 05:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g+X9axIFKiWeeLdgLNKPr3c4V/oqgekJuwFhbkyQ++0=;
        b=YDGwjbkAmGbRPiuztvMLIJR+RwawI4R9lJXPH7QbDer2L1eqjxZOfSzYRCCj4dQ5h8
         LNYL0Qb6QIV4gt87dOC0YK5+NDHpJGtkgCpJBFSFWnHUJCpL6bA/zH6X2PbD4oba5F9X
         4lF2ePGxbLhqL7Avh2Kbh5MuaD//GpzLoKkm1KR91LzlOKe5zf8jp3fXJVkuXqFT0LLH
         i/29ilqiHUkbjkkIoZmdWorukI0/POVB5ozTft4Y6Cw9/PlM+vmj2AY/0dCrZCVNzgv4
         H8QgXPaP1swxfNMMnqoy+V3apr+4E00PTyGnIvPuh+MDi0XALGpCfRy6FNa8JnL1/fVU
         GasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g+X9axIFKiWeeLdgLNKPr3c4V/oqgekJuwFhbkyQ++0=;
        b=AM4KWhswVg78D+pqq6jRvhA0f9Nh6pChqWemoFqls2HlA58zDUGeJAACcHNW+YYOIO
         kRlL4PgBp4GWOjVBoQGj2hrOF6J5k4z24jni1aRy+6u3grTLDcm7Ol4XwFdOL6rwwjHP
         WMunMRa3lXrtiOpOdtUfZMxnEU+BbD5qOqYDuTWflBJchDIbG+BEkb33WrhEOmrKbJ84
         pwYOo6Y3gm+eu4K5Pc8u0uIVm53QqvQt2eT+8u2uslbSeE6nPp5fapEWxQ/vGreF+b7G
         BTanNkwXgrilH2ToqEM8sBfYvplKvJdYfeN56TCdgtAPz+wP3OLAENsfpgK5GpB96PUH
         cPWg==
X-Gm-Message-State: ANhLgQ28iR3pIfZWdLWHcMJcdmbdyuiUR68Cz6DxPuixhnL6cBZELoK4
        U9gECnHpkP4KDTingxa+z4NzsDQVeDBAcQ==
X-Google-Smtp-Source: ADFU+vszEC65qtGCdETefXI+dh5dGaMDFaODrGKKrJmVGUsFuszKPiaO8AXtfztZJoZUFwabBOS2GA==
X-Received: by 2002:ac8:b8d:: with SMTP id h13mr13019242qti.298.1584794285323;
        Sat, 21 Mar 2020 05:38:05 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id u40sm7435378qtc.62.2020.03.21.05.38.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 05:38:04 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jFdO8-0008OQ-7G; Sat, 21 Mar 2020 09:38:04 -0300
Date:   Sat, 21 Mar 2020 09:38:04 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: check the device private page owner in
 hmm_range_fault
Message-ID: <20200321123804.GV20941@ziepe.ca>
References: <20200316193216.920734-1-hch@lst.de>
 <20200316193216.920734-5-hch@lst.de>
 <20200320134109.GA30230@ziepe.ca>
 <20200321082236.GB28613@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321082236.GB28613@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Mar 21, 2020 at 09:22:36AM +0100, Christoph Hellwig wrote:
> On Fri, Mar 20, 2020 at 10:41:09AM -0300, Jason Gunthorpe wrote:
> > Thinking about this some more, does the locking work out here?
> > 
> > hmm_range_fault() runs with mmap_sem in read, and does not lock any of
> > the page table levels.
> > 
> > So it relies on accessing stale pte data being safe, and here we
> > introduce for the first time a page pointer dereference and a pgmap
> > dereference without any locking/refcounting.
> > 
> > The get_dev_pagemap() worked on the PFN and obtained a refcount, so it
> > created safety.
> > 
> > Is there some tricky reason this is safe, eg a DEVICE_PRIVATE page
> > cannot be removed from the vma without holding mmap_sem in write or
> > something?
> 
> I don't think there is any specific protection.  Let me see if we
> can throw in a get_dev_pagemap here

The page tables are RCU protected right? could we do something like

 if (is_device_private_entry()) {
       rcu_read_lock()
       if (READ_ONCE(*ptep) != pte)
           return -EBUSY;
       hmm_is_device_private_entry()
       rcu_read_unlock()
 }

?

Then pgmap needs a synchronize_rcu before the struct page's are
destroyed (possibly gup_fast already requires this?)

I've got some other patches trying to close some of these styles of
bugs, but 

> note that current mainline doesn't even use it for this path..

Don't follow?

Jason
