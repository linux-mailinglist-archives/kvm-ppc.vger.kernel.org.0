Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F138A1222
	for <lists+kvm-ppc@lfdr.de>; Thu, 29 Aug 2019 08:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfH2G6U (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 29 Aug 2019 02:58:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49120 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfH2G6U (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 29 Aug 2019 02:58:20 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7T6vxFP027496
        for <kvm-ppc@vger.kernel.org>; Thu, 29 Aug 2019 02:58:19 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2up9f50ubp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 29 Aug 2019 02:58:19 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Thu, 29 Aug 2019 07:58:17 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 29 Aug 2019 07:58:14 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7T6wCV848496758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 06:58:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F4F1A4066;
        Thu, 29 Aug 2019 06:58:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEBDBA4054;
        Thu, 29 Aug 2019 06:58:10 +0000 (GMT)
Received: from in.ibm.com (unknown [9.124.35.109])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 29 Aug 2019 06:58:10 +0000 (GMT)
Date:   Thu, 29 Aug 2019 12:28:08 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v7 2/7] kvmppc: Shared pages support for secure guests
Reply-To: bharata@linux.ibm.com
References: <20190822102620.21897-1-bharata@linux.ibm.com>
 <20190822102620.21897-3-bharata@linux.ibm.com>
 <20190829030443.GB17497@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829030443.GB17497@us.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19082906-0012-0000-0000-00000344289D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082906-0013-0000-0000-0000217E67C1
Message-Id: <20190829065808.GB31913@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=714 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290075
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Aug 28, 2019 at 08:04:43PM -0700, Sukadev Bhattiprolu wrote:
> > A secure guest will share some of its pages with hypervisor (Eg. virtio
> > bounce buffers etc). Support sharing of pages between hypervisor and
> > ultravisor.
> > 
> > Once a secure page is converted to shared page, the device page is
> > unmapped from the HV side page tables.
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> > ---
> >  arch/powerpc/include/asm/hvcall.h |  3 ++
> >  arch/powerpc/kvm/book3s_hv_devm.c | 70 +++++++++++++++++++++++++++++--
> >  2 files changed, 69 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
> > index 2f6b952deb0f..05b8536f6653 100644
> > --- a/arch/powerpc/include/asm/hvcall.h
> > +++ b/arch/powerpc/include/asm/hvcall.h
> > @@ -337,6 +337,9 @@
> >  #define H_TLB_INVALIDATE	0xF808
> >  #define H_COPY_TOFROM_GUEST	0xF80C
> > 
> > +/* Flags for H_SVM_PAGE_IN */
> > +#define H_PAGE_IN_SHARED        0x1
> > +
> >  /* Platform-specific hcalls used by the Ultravisor */
> >  #define H_SVM_PAGE_IN		0xEF00
> >  #define H_SVM_PAGE_OUT		0xEF04
> > diff --git a/arch/powerpc/kvm/book3s_hv_devm.c b/arch/powerpc/kvm/book3s_hv_devm.c
> > index 13722f27fa7d..6a3229b78fed 100644
> > --- a/arch/powerpc/kvm/book3s_hv_devm.c
> > +++ b/arch/powerpc/kvm/book3s_hv_devm.c
> > @@ -46,6 +46,7 @@ struct kvmppc_devm_page_pvt {
> >  	unsigned long *rmap;
> >  	unsigned int lpid;
> >  	unsigned long gpa;
> > +	bool skip_page_out;
> >  };
> > 
> >  /*
> > @@ -139,6 +140,54 @@ kvmppc_devm_migrate_alloc_and_copy(struct migrate_vma *mig,
> >  	return 0;
> >  }
> > 
> > +/*
> > + * Shares the page with HV, thus making it a normal page.
> > + *
> > + * - If the page is already secure, then provision a new page and share
> > + * - If the page is a normal page, share the existing page
> > + *
> > + * In the former case, uses the dev_pagemap_ops migrate_to_ram handler
> > + * to unmap the device page from QEMU's page tables.
> > + */
> > +static unsigned long
> > +kvmppc_share_page(struct kvm *kvm, unsigned long gpa, unsigned long page_shift)
> > +{
> > +
> > +	int ret = H_PARAMETER;
> > +	struct page *devm_page;
> > +	struct kvmppc_devm_page_pvt *pvt;
> > +	unsigned long pfn;
> > +	unsigned long *rmap;
> > +	struct kvm_memory_slot *slot;
> > +	unsigned long gfn = gpa >> page_shift;
> > +	int srcu_idx;
> > +
> > +	srcu_idx = srcu_read_lock(&kvm->srcu);
> > +	slot = gfn_to_memslot(kvm, gfn);
> > +	if (!slot)
> > +		goto out;
> > +
> > +	rmap = &slot->arch.rmap[gfn - slot->base_gfn];
> > +	if (kvmppc_rmap_is_devm_pfn(*rmap)) {
> > +		devm_page = pfn_to_page(*rmap & ~KVMPPC_RMAP_DEVM_PFN);
> > +		pvt = (struct kvmppc_devm_page_pvt *)
> > +			devm_page->zone_device_data;
> > +		pvt->skip_page_out = true;
> > +	}
> > +
> > +	pfn = gfn_to_pfn(kvm, gpa >> page_shift);
> 
> Use 'gfn'?

Yes.

> 
> > +	if (is_error_noslot_pfn(pfn))
> > +		goto out;
> > +
> > +	ret = uv_page_in(kvm->arch.lpid, pfn << page_shift, gpa, 0, page_shift);
> > +	if (ret == U_SUCCESS)
> > +		ret = H_SUCCESS;
> > +	kvm_release_pfn_clean(pfn);
> 
> Nit: Blank line?
> > +out:
> > +	srcu_read_unlock(&kvm->srcu, srcu_idx);
> > +	return ret;
> > +}
> > +
> >  /*
> >   * Move page from normal memory to secure memory.
> >   */
> > @@ -159,9 +208,12 @@ kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
> >  	if (page_shift != PAGE_SHIFT)
> >  		return H_P3;
> > 
> > -	if (flags)
> > +	if (flags & ~H_PAGE_IN_SHARED)
> >  		return H_P2;
> > 
> > +	if (flags & H_PAGE_IN_SHARED)
> > +		return kvmppc_share_page(kvm, gpa, page_shift);
> > +
> >  	ret = H_PARAMETER;
> >  	down_read(&kvm->mm->mmap_sem);
> >  	srcu_idx = srcu_read_lock(&kvm->srcu);
> > @@ -211,7 +263,7 @@ kvmppc_devm_fault_migrate_alloc_and_copy(struct migrate_vma *mig,
> >  	struct page *dpage, *spage;
> >  	struct kvmppc_devm_page_pvt *pvt;
> >  	unsigned long pfn;
> > -	int ret;
> > +	int ret = U_SUCCESS;
> > 
> >  	spage = migrate_pfn_to_page(*mig->src);
> >  	if (!spage || !(*mig->src & MIGRATE_PFN_MIGRATE))
> > @@ -226,8 +278,18 @@ kvmppc_devm_fault_migrate_alloc_and_copy(struct migrate_vma *mig,
> >  	pvt = spage->zone_device_data;
> > 
> >  	pfn = page_to_pfn(dpage);
> > -	ret = uv_page_out(pvt->lpid, pfn << page_shift, pvt->gpa, 0,
> > -			  page_shift);
> > +
> > +	/*
> > +	 * This same function is used in two cases:
> 
> Nit: s/same//

Extra emphasis :)

> 
> > +	 * - When HV touches a secure page, for which we do page-out
> 
> Better to qualify page-out with "uv page-out"? its kind of counterintuitive
> to do a page-out on a fault!

Sure.

Regards,
Bharata.

