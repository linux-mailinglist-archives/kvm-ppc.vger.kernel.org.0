Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00FE49573D
	for <lists+kvm-ppc@lfdr.de>; Tue, 20 Aug 2019 08:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbfHTGWX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 20 Aug 2019 02:22:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43148 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbfHTGWX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 20 Aug 2019 02:22:23 -0400
Received: by mail-pf1-f196.google.com with SMTP id v12so2725607pfn.10
        for <kvm-ppc@vger.kernel.org>; Mon, 19 Aug 2019 23:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LsEyAPx89vt71C2UmHMLuXRw1EoaUy3zZsSSBMjTLq4=;
        b=IuNT+1bUdIOlhn7H8uUFCTAobEvaJBujn3erlMwDQC4XnfPp941Brrlh4bOm1JIb6C
         YQbCY4ZrSrv0PBkJqivNVgfv5FSUMyTCduQzs6Qv0iBt10S4ljTiS36YU4zSsp2I83Qa
         OYfWzh3nwz6xFWE7zBeeYmcioTJA0LhMSr1QAa5RkZ1xoZDOv4+VO8M7OWDQ6q1x9Xu6
         hFmFOsWsGwP7DidMrLTUjR5Tq7Cq3egd3vGVKflW8ipMFBVe24yWNkjOGhfX+wj8aMN6
         kJ7wvRSxdSvDoOYU1vX2fWS6bDlJ/mA1rgJXkfgcLcvkkmon8T1cNVY5Xxefi09QLIZ5
         xtrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LsEyAPx89vt71C2UmHMLuXRw1EoaUy3zZsSSBMjTLq4=;
        b=V4PJJIMsH4sR41PwZ1LAfCNvhusVBMsZAgSnFhLyEph3LRrqkPPbAmom2z5EWxQbSf
         J4vN/ZLkw1V7EfINRZtAQ88UdWmq+s9eWZPjw7pvDRloQ+z6bcPji3HOjUDGFhEc/4H9
         XSW426CTtxNBX38eeFZ30nDedQOZwos1q61j+MXs4szTQVfaDRxhQhGdyjUtoL8kviZI
         S1QzUbBqrDiHUse8aPlGyTz3C+3uwcY8L7xCGwdi4EW+TfdiSM3PHTZrCMU1T5wV4oYW
         zKABvlv18+phUNIdRTKhhkA43ZPCqMC5CVH4z4Qzxw6YKR0zDfHo2cnr1dhR+feauTvX
         0Xyg==
X-Gm-Message-State: APjAAAXYUOSyLOKvbpqaz/zgf+85KF4M1/CZNnoLmU6SVAdxd4G1RhEH
        pDt260ibZGr+Qx1GXODggyQ=
X-Google-Smtp-Source: APXvYqzExR/3Tv53UARjp6aMbWOaY9pNVjpL0tL+F1uW6x15j6WkwwSDnJHx07vWyy0iTH4pbvRfFA==
X-Received: by 2002:a63:fc09:: with SMTP id j9mr22343328pgi.377.1566282141988;
        Mon, 19 Aug 2019 23:22:21 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.googlemail.com with ESMTPSA id 2sm24482074pjh.13.2019.08.19.23.22.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Aug 2019 23:22:21 -0700 (PDT)
Message-ID: <1566282135.2166.6.camel@gmail.com>
Subject: Re: [PATCH v6 1/7] kvmppc: Driver to manage pages of secure guest
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Bharata B Rao <bharata@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de
Date:   Tue, 20 Aug 2019 16:22:15 +1000
In-Reply-To: <20190809084108.30343-2-bharata@linux.ibm.com>
References: <20190809084108.30343-1-bharata@linux.ibm.com>
         <20190809084108.30343-2-bharata@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 2019-08-09 at 14:11 +0530, Bharata B Rao wrote:
> KVMPPC driver to manage page transitions of secure guest
> via H_SVM_PAGE_IN and H_SVM_PAGE_OUT hcalls.
> 
> H_SVM_PAGE_IN: Move the content of a normal page to secure page
> H_SVM_PAGE_OUT: Move the content of a secure page to normal page
> 
> Private ZONE_DEVICE memory equal to the amount of secure memory
> available in the platform for running secure guests is created
> via a char device. Whenever a page belonging to the guest becomes
> secure, a page from this private device memory is used to
> represent and track that secure page on the HV side. The movement
> of pages between normal and secure memory is done via
> migrate_vma_pages() using UV_PAGE_IN and UV_PAGE_OUT ucalls.

Hi Bharata,

please see my patch where I define the bits which define the type of
the rmap entry:
https://patchwork.ozlabs.org/patch/1149791/

Please add an entry for the devm pfn type like:
#define KVMPPC_RMAP_PFN_DEVM 0x0200000000000000 /* secure guest devm
pfn */

And the following in the appropriate header file

static inline bool kvmppc_rmap_is_pfn_demv(unsigned long *rmapp)
{
	return !!((*rmapp & KVMPPC_RMAP_TYPE_MASK) ==
KVMPPC_RMAP_PFN_DEVM));
}

Also see comment below.

Thanks,
Suraj

> 
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/hvcall.h          |   4 +
>  arch/powerpc/include/asm/kvm_book3s_devm.h |  29 ++
>  arch/powerpc/include/asm/kvm_host.h        |  12 +
>  arch/powerpc/include/asm/ultravisor-api.h  |   2 +
>  arch/powerpc/include/asm/ultravisor.h      |  14 +
>  arch/powerpc/kvm/Makefile                  |   3 +
>  arch/powerpc/kvm/book3s_hv.c               |  19 +
>  arch/powerpc/kvm/book3s_hv_devm.c          | 492
> +++++++++++++++++++++
>  8 files changed, 575 insertions(+)
>  create mode 100644 arch/powerpc/include/asm/kvm_book3s_devm.h
>  create mode 100644 arch/powerpc/kvm/book3s_hv_devm.c
> 
[snip]
> +
> +struct kvmppc_devm_page_pvt {
> +	unsigned long *rmap;
> +	unsigned int lpid;
> +	unsigned long gpa;
> +};
> +
> +struct kvmppc_devm_copy_args {
> +	unsigned long *rmap;
> +	unsigned int lpid;
> +	unsigned long gpa;
> +	unsigned long page_shift;
> +};
> +
> +/*
> + * Bits 60:56 in the rmap entry will be used to identify the
> + * different uses/functions of rmap. This definition with move
> + * to a proper header when all other functions are defined.
> + */
> +#define KVMPPC_PFN_DEVM		(0x2ULL << 56)
> +
> +static inline bool kvmppc_is_devm_pfn(unsigned long pfn)
> +{
> +	return !!(pfn & KVMPPC_PFN_DEVM);
> +}
> +
> +/*
> + * Get a free device PFN from the pool
> + *
> + * Called when a normal page is moved to secure memory (UV_PAGE_IN).
> Device
> + * PFN will be used to keep track of the secure page on HV side.
> + *
> + * @rmap here is the slot in the rmap array that corresponds to
> @gpa.
> + * Thus a non-zero rmap entry indicates that the corresonding guest
> + * page has become secure, and is not mapped on the HV side.
> + *
> + * NOTE: In this and subsequent functions, we pass around and access
> + * individual elements of kvm_memory_slot->arch.rmap[] without any
> + * protection. Should we use lock_rmap() here?
> + */
> +static struct page *kvmppc_devm_get_page(unsigned long *rmap,
> +					unsigned long gpa, unsigned
> int lpid)
> +{
> +	struct page *dpage = NULL;
> +	unsigned long bit, devm_pfn;
> +	unsigned long nr_pfns = kvmppc_devm.pfn_last -
> +				kvmppc_devm.pfn_first;
> +	unsigned long flags;
> +	struct kvmppc_devm_page_pvt *pvt;
> +
> +	if (kvmppc_is_devm_pfn(*rmap))
> +		return NULL;
> +
> +	spin_lock_irqsave(&kvmppc_devm_lock, flags);
> +	bit = find_first_zero_bit(kvmppc_devm.pfn_bitmap, nr_pfns);
> +	if (bit >= nr_pfns)
> +		goto out;
> +
> +	bitmap_set(kvmppc_devm.pfn_bitmap, bit, 1);
> +	devm_pfn = bit + kvmppc_devm.pfn_first;
> +	dpage = pfn_to_page(devm_pfn);
> +
> +	if (!trylock_page(dpage))
> +		goto out_clear;
> +
> +	*rmap = devm_pfn | KVMPPC_PFN_DEVM;
> +	pvt = kzalloc(sizeof(*pvt), GFP_ATOMIC);
> +	if (!pvt)
> +		goto out_unlock;
> +	pvt->rmap = rmap;

Am I missing something, why does the rmap need to be stored in pvt?
Given the gpa is already stored and this is enough to get back to the
rmap entry, right?

> +	pvt->gpa = gpa;
> +	pvt->lpid = lpid;
> +	dpage->zone_device_data = pvt;
> +	spin_unlock_irqrestore(&kvmppc_devm_lock, flags);
> +
> +	get_page(dpage);
> +	return dpage;
> +
> +out_unlock:
> +	unlock_page(dpage);
> +out_clear:
> +	bitmap_clear(kvmppc_devm.pfn_bitmap,
> +		     devm_pfn - kvmppc_devm.pfn_first, 1);
> +out:
> +	spin_unlock_irqrestore(&kvmppc_devm_lock, flags);
> +	return NULL;
> +}
> +
> 
[snip]
