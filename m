Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36EFB1872FA
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 20:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732400AbgCPTEp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 15:04:45 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:38190 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732298AbgCPTEp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Mar 2020 15:04:45 -0400
Received: by mail-qv1-f68.google.com with SMTP id p60so9480528qva.5
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Mar 2020 12:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BWUlD7DMxUCjadcoWlHWZLSyInqh6sPVvbrJFhGcEXw=;
        b=b4PO6Gx41wgIvNR75/iEEHqP7YeAWOo5I4vM1hYEixFuze+GD6DaYqoq6TC5z6ZmrJ
         Ay/5Z5n3+GxgulTlewop2xKyUtwkOsk/3xSb3Dci9QGrROQg0xNI4SUrd6gZB6+izdNe
         N1pEZM8nEhG8cFaafaI7oaJVEsr/RZaSPAOGp/dvEqzcI/FlL1EmhGf5oLnxpn5fsFMX
         0vDAhrju1L63wESfxt4lt2sv7hw8jBZVFlY4uyOJvCMiAZXPlnY61hAjM+L2/9omI9RE
         eSIpwURT9g78RsWcH396M8bdPtPAtYe5mLGXoaunFXluYfTsfHTzArNAe1Kq2Vj3zALv
         DJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BWUlD7DMxUCjadcoWlHWZLSyInqh6sPVvbrJFhGcEXw=;
        b=R+qefCfEj4G9NTFIYimV3UjONa50GO8lRKne3ejKNoK9Gz+iVNBKFg775PwGe+Zh4O
         TpdDtTXQw9daUcTsbHkE16X5CbJniOSpC5t7nYZPKowb6VS47EGkeyMNNnR4zo0ix/0/
         tV4yxnmKKKkhiopyc4qNU3RoYv/FVLrP1Y1Lrs5e1hTxY5dPADGEiawXlWYGDrMiUMkF
         0h/zON+02o2vDNSgqHQ7PYKujl0P4ddLZqCuOBhOTfqlsQvnso8viq9R8JXl4FmTDeYI
         OVBMSjs6C4bgCA4T+0pYl+hBEoe9ZXhpUh7keupPGw0nNqyukouIMzYdglN9vNvMtkS/
         q7EA==
X-Gm-Message-State: ANhLgQ1zvAZuYLmlvh6atkV++zfSsSrXsLMgWoFC7D9fenGQNySn77+e
        ZF6hm2cMGxO8/nIuUd363MMZYQ==
X-Google-Smtp-Source: ADFU+vupCuGjSfz+zG9xNUf8/b9EmEfqnAO4l1aoYhG7XjmfvRH/QvbrSw7U+oPGZcF3Uap4STtBfQ==
X-Received: by 2002:ad4:4847:: with SMTP id t7mr1236975qvy.237.1584385484358;
        Mon, 16 Mar 2020 12:04:44 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id x19sm407776qtm.47.2020.03.16.12.04.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Mar 2020 12:04:43 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jDv2Z-0006k6-7W; Mon, 16 Mar 2020 16:04:43 -0300
Date:   Mon, 16 Mar 2020 16:04:43 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm: remove device private page support from
 hmm_range_fault
Message-ID: <20200316190443.GM20941@ziepe.ca>
References: <20200316175259.908713-1-hch@lst.de>
 <20200316175259.908713-3-hch@lst.de>
 <c099cc3c-c19f-9d61-4297-2e83df899ca4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c099cc3c-c19f-9d61-4297-2e83df899ca4@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 11:42:19AM -0700, Ralph Campbell wrote:
> 
> On 3/16/20 10:52 AM, Christoph Hellwig wrote:
> > No driver has actually used properly wire up and support this feature.
> > There is various code related to it in nouveau, but as far as I can tell
> > it never actually got turned on, and the only changes since the initial
> > commit are global cleanups.
> 
> This is not actually true. OpenCL 2.x does support SVM with nouveau and
> device private memory via clEnqueueSVMMigrateMem().
> Also, Ben Skeggs has accepted a set of patches to map GPU memory after being
> migrated and this change would conflict with that.

Other than the page_to_dmem() possibly doing container_of on the wrong
type pgmap, are there other bugs here to fix?

Something like this is probably close to the right thing to fix that
and work with Christoph's 1/2 patch - Ralph can you check, test, etc?

diff --git a/mm/hmm.c b/mm/hmm.c
index 9e8f68eb83287a..9fa4748da1b779 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -300,6 +300,20 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 				range->flags[HMM_PFN_DEVICE_PRIVATE];
 			cpu_flags |= is_write_device_private_entry(entry) ?
 				range->flags[HMM_PFN_WRITE] : 0;
+
+			/*
+			 * If the caller understands this kind of device_private
+			 * page, then leave it as is, otherwise fault it.
+			 */
+			hmm_vma_walk->pgmap = get_dev_pagemap(
+				device_private_entry_to_pfn(entry),
+				hmm_vma_walk->pgmap);
+			if (!unlikely(!pgmap))
+				return -EBUSY;
+			if (hmm_vma_walk->pgmap->owner !=
+			    hmm_vma_walk->dev_private_owner)
+				cpu_flags = 0;
+
 			hmm_pte_need_fault(hmm_vma_walk, orig_pfn, cpu_flags,
 					   &fault, &write_fault);
 			if (fault || write_fault)

Jason
