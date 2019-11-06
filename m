Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60176F0E8D
	for <lists+kvm-ppc@lfdr.de>; Wed,  6 Nov 2019 06:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbfKFF63 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 6 Nov 2019 00:58:29 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:58849 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbfKFF63 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 6 Nov 2019 00:58:29 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 477G6q4LWfz9sPv; Wed,  6 Nov 2019 16:58:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573019907; bh=qi+bi8MVZoNDV18JpOPasJiz17z6ctI9/w/JfB9116Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CYz/tUuXCmy6vBZ6hJN1l6iLFQ0ubQUmYKLik3gSraoou1tPe7wu+yYwuJ8fD9jbX
         c31BBrd+vXDBwWO19GvgVFQtA0hLdcCK+jkpdcRHH/z/UPpMziyXFvT/le5vMTpowQ
         Mt91jTijH39WVp8VweQDXJiLsC7A1b9qxURh0mlK4Ksldg6v3iPNPNmaXummCzs664
         DAVi66wTllKw/ok+EJVMgVRKAnG6o2i9bdX9pKTGAsb9EIrb8twFuiqyeTxNS0SZaH
         oCoS6kJZaBQidJAeF5lvSopmrhFJqzTUQ0qLoosonMQFbse4NlGr4riXisiWaDPQtg
         50iFa8T/7W67w==
Date:   Wed, 6 Nov 2019 15:52:38 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 3/8] KVM: PPC: Shared pages support for secure guests
Message-ID: <20191106045238.GD12069@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-4-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104041800.24527-4-bharata@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 04, 2019 at 09:47:55AM +0530, Bharata B Rao wrote:
> A secure guest will share some of its pages with hypervisor (Eg. virtio
> bounce buffers etc). Support sharing of pages between hypervisor and
> ultravisor.
> 
> Shared page is reachable via both HV and UV side page tables. Once a
> secure page is converted to shared page, the device page that represents
> the secure page is unmapped from the HV side page tables.

I'd like to understand a little better what's going on - see below...

> +/*
> + * Shares the page with HV, thus making it a normal page.
> + *
> + * - If the page is already secure, then provision a new page and share
> + * - If the page is a normal page, share the existing page
> + *
> + * In the former case, uses dev_pagemap_ops.migrate_to_ram handler
> + * to unmap the device page from QEMU's page tables.
> + */
> +static unsigned long
> +kvmppc_share_page(struct kvm *kvm, unsigned long gpa, unsigned long page_shift)
> +{
> +
> +	int ret = H_PARAMETER;
> +	struct page *uvmem_page;
> +	struct kvmppc_uvmem_page_pvt *pvt;
> +	unsigned long pfn;
> +	unsigned long gfn = gpa >> page_shift;
> +	int srcu_idx;
> +	unsigned long uvmem_pfn;
> +
> +	srcu_idx = srcu_read_lock(&kvm->srcu);
> +	mutex_lock(&kvm->arch.uvmem_lock);
> +	if (kvmppc_gfn_is_uvmem_pfn(gfn, kvm, &uvmem_pfn)) {
> +		uvmem_page = pfn_to_page(uvmem_pfn);
> +		pvt = uvmem_page->zone_device_data;
> +		pvt->skip_page_out = true;
> +	}
> +
> +retry:
> +	mutex_unlock(&kvm->arch.uvmem_lock);
> +	pfn = gfn_to_pfn(kvm, gfn);

At this point, pfn is the value obtained from the page table for
userspace (e.g. QEMU), right?  I would think it should be equal to
uvmem_pfn in most cases, shouldn't it?  If not, what is it going to
be?

> +	if (is_error_noslot_pfn(pfn))
> +		goto out;
> +
> +	mutex_lock(&kvm->arch.uvmem_lock);
> +	if (kvmppc_gfn_is_uvmem_pfn(gfn, kvm, &uvmem_pfn)) {
> +		uvmem_page = pfn_to_page(uvmem_pfn);
> +		pvt = uvmem_page->zone_device_data;
> +		pvt->skip_page_out = true;
> +		kvm_release_pfn_clean(pfn);

This is going to do a put_page(), unless pfn is a reserved pfn.  If it
does a put_page(), where did we do the corresponding get_page()?
However, since kvmppc_gfn_is_uvmem_pfn() returned true, doesn't that
mean that pfn here should be a device pfn, and in fact should be the
same as uvmem_pfn (possibly with some extra bit(s) set)?  What does
kvm_is_reserved_pfn() return for a device pfn?

Paul.
