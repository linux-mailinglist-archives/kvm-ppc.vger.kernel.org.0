Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDB0A2D81
	for <lists+kvm-ppc@lfdr.de>; Fri, 30 Aug 2019 05:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfH3DnO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 29 Aug 2019 23:43:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727213AbfH3DnO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 29 Aug 2019 23:43:14 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7U3gZ1o050497
        for <kvm-ppc@vger.kernel.org>; Thu, 29 Aug 2019 23:43:12 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ups69n7nw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 29 Aug 2019 23:43:12 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Fri, 30 Aug 2019 04:43:11 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 30 Aug 2019 04:43:08 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7U3h6ef12386482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 03:43:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99C19AE055;
        Fri, 30 Aug 2019 03:43:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD879AE053;
        Fri, 30 Aug 2019 03:43:02 +0000 (GMT)
Received: from in.ibm.com (unknown [9.109.246.128])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 30 Aug 2019 03:43:02 +0000 (GMT)
Date:   Fri, 30 Aug 2019 09:12:59 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [PATCH v7 1/7] kvmppc: Driver to manage pages of secure guest
Reply-To: bharata@linux.ibm.com
References: <20190822102620.21897-1-bharata@linux.ibm.com>
 <20190822102620.21897-2-bharata@linux.ibm.com>
 <20190829083810.GA13039@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829083810.GA13039@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19083003-0020-0000-0000-000003657EEF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19083003-0021-0000-0000-000021BAD9A1
Message-Id: <20190830034259.GD31913@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=843 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300036
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Aug 29, 2019 at 10:38:10AM +0200, Christoph Hellwig wrote:
> On Thu, Aug 22, 2019 at 03:56:14PM +0530, Bharata B Rao wrote:
> > +/*
> > + * Bits 60:56 in the rmap entry will be used to identify the
> > + * different uses/functions of rmap.
> > + */
> > +#define KVMPPC_RMAP_DEVM_PFN	(0x2ULL << 56)
> 
> How did you come up with this specific value?

Different usage types of RMAP array are being defined.
https://patchwork.ozlabs.org/patch/1149791/

The above value is reserved for device pfn usage.

> 
> > +
> > +static inline bool kvmppc_rmap_is_devm_pfn(unsigned long pfn)
> > +{
> > +	return !!(pfn & KVMPPC_RMAP_DEVM_PFN);
> > +}
> 
> No need for !! when returning a bool.  Also the helper seems a little
> pointless, just opencoding it would make the code more readable in my
> opinion.

I expect similar routines for other usages of RMAP to come up.

> 
> > +#ifdef CONFIG_PPC_UV
> > +extern int kvmppc_devm_init(void);
> > +extern void kvmppc_devm_free(void);
> 
> There is no need for extern in a function declaration.
> 
> > +static int
> > +kvmppc_devm_migrate_alloc_and_copy(struct migrate_vma *mig,
> > +				   unsigned long *rmap, unsigned long gpa,
> > +				   unsigned int lpid, unsigned long page_shift)
> > +{
> > +	struct page *spage = migrate_pfn_to_page(*mig->src);
> > +	unsigned long pfn = *mig->src >> MIGRATE_PFN_SHIFT;
> > +	struct page *dpage;
> > +
> > +	*mig->dst = 0;
> > +	if (!spage || !(*mig->src & MIGRATE_PFN_MIGRATE))
> > +		return 0;
> > +
> > +	dpage = kvmppc_devm_get_page(rmap, gpa, lpid);
> > +	if (!dpage)
> > +		return -EINVAL;
> > +
> > +	if (spage)
> > +		uv_page_in(lpid, pfn << page_shift, gpa, 0, page_shift);
> > +
> > +	*mig->dst = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
> > +	return 0;
> > +}
> 
> I think you can just merge this trivial helper into the only caller.

Yes I can, but felt it is nicely abstracted out to a function right now.

> 
> > +static int
> > +kvmppc_devm_fault_migrate_alloc_and_copy(struct migrate_vma *mig,
> > +					 unsigned long page_shift)
> > +{
> > +	struct page *dpage, *spage;
> > +	struct kvmppc_devm_page_pvt *pvt;
> > +	unsigned long pfn;
> > +	int ret;
> > +
> > +	spage = migrate_pfn_to_page(*mig->src);
> > +	if (!spage || !(*mig->src & MIGRATE_PFN_MIGRATE))
> > +		return 0;
> > +	if (!is_zone_device_page(spage))
> > +		return 0;
> > +
> > +	dpage = alloc_page_vma(GFP_HIGHUSER, mig->vma, mig->start);
> > +	if (!dpage)
> > +		return -EINVAL;
> > +	lock_page(dpage);
> > +	pvt = spage->zone_device_data;
> > +
> > +	pfn = page_to_pfn(dpage);
> > +	ret = uv_page_out(pvt->lpid, pfn << page_shift, pvt->gpa, 0,
> > +			  page_shift);
> > +	if (ret == U_SUCCESS)
> > +		*mig->dst = migrate_pfn(pfn) | MIGRATE_PFN_LOCKED;
> > +	else {
> > +		unlock_page(dpage);
> > +		__free_page(dpage);
> > +	}
> > +	return ret;
> > +}
> 
> Here we actually have two callers, but they have a fair amount of
> duplicate code in them.  I think you want to move that common
> code (including setting up the migrate_vma structure) into this
> function and maybe also give it a more descriptive name.

Sure, I will give this a try. The name is already very descriptive, will
come up with an appropriate name.

BTW this file and the fuction prefixes in this file started out with
kvmppc_hmm, switched to kvmppc_devm when HMM routines weren't used anymore.
Now with the use of only non-dev versions, planning to swtich to
kvmppc_uvmem_

> 
> > +static void kvmppc_devm_page_free(struct page *page)
> > +{
> > +	unsigned long pfn = page_to_pfn(page);
> > +	unsigned long flags;
> > +	struct kvmppc_devm_page_pvt *pvt;
> > +
> > +	spin_lock_irqsave(&kvmppc_devm_pfn_lock, flags);
> > +	pvt = page->zone_device_data;
> > +	page->zone_device_data = NULL;
> > +
> > +	bitmap_clear(kvmppc_devm_pfn_bitmap,
> > +		     pfn - (kvmppc_devm_pgmap.res.start >> PAGE_SHIFT), 1);
> 
> Nit: I'd just initialize pfn to the value you want from the start.
> That makes the code a little easier to read, and keeps a tiny bit more
> code outside the spinlock.
> 
> 	unsigned long pfn = page_to_pfn(page) -
> 			(kvmppc_devm_pgmap.res.start >> PAGE_SHIFT);
> 
> 	..
> 
> 	 bitmap_clear(kvmppc_devm_pfn_bitmap, pfn, 1);

Sure.

> 
> 
> > +	kvmppc_devm_pgmap.type = MEMORY_DEVICE_PRIVATE;
> > +	kvmppc_devm_pgmap.res = *res;
> > +	kvmppc_devm_pgmap.ops = &kvmppc_devm_ops;
> > +	addr = memremap_pages(&kvmppc_devm_pgmap, -1);
> 
> This -1 should be NUMA_NO_NODE for clarity.

Right.

Regards,
Bharata.

