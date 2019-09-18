Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 171BBB5DEB
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Sep 2019 09:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfIRHV2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Sep 2019 03:21:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726077AbfIRHV2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Sep 2019 03:21:28 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8I7HMFn016442
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Sep 2019 03:21:27 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v3cdhpqj3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Sep 2019 03:21:26 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Wed, 18 Sep 2019 08:21:24 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Sep 2019 08:21:22 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8I7LKup34537650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 07:21:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 606124C058;
        Wed, 18 Sep 2019 07:21:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2FFB4C046;
        Wed, 18 Sep 2019 07:21:18 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.59.145])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 18 Sep 2019 07:21:18 +0000 (GMT)
Date:   Wed, 18 Sep 2019 12:51:16 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v8 7/8] kvmppc: Support reset of secure guest
Reply-To: bharata@linux.ibm.com
References: <20190910082946.7849-1-bharata@linux.ibm.com>
 <20190910082946.7849-8-bharata@linux.ibm.com>
 <20190917232736.GA27932@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917232736.GA27932@us.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19091807-0028-0000-0000-0000039F601E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091807-0029-0000-0000-000024616278
Message-Id: <20190918072116.GC11675@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-18_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=929 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909180077
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Sep 17, 2019 at 04:27:36PM -0700, Sukadev Bhattiprolu wrote:
> > +
> > +	if (kvmppc_is_guest_secure(kvm)) {
> 
> Nit: Since this entire function only applies to secure guests we could
> return here for normal guests.

Yes, can be done.

> >  bool kvmppc_is_guest_secure(struct kvm *kvm)
> >  {
> > -	return !!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE);
> > +	return (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE);
> >  }
> 
> This change could be folded into PATCH 6?

That was the intention but looks like I 'pick'ed wrong commit during rebase.
Will fix this.

> > 
> >  unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
> > @@ -85,9 +86,68 @@ unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
> >  		return H_UNSUPPORTED;
> > 
> >  	kvm->arch.secure_guest |= KVMPPC_SECURE_INIT_DONE;
> > +	if (kvm_is_radix(kvm)) {
> > +		kvmppc_free_radix(kvm);
> > +		pr_info("LPID %d went secure, freed HV side radix pgtables\n",
> > +			kvm->arch.lpid);
> > +	}
> >  	return H_SUCCESS;
> >  }
> > 
> > +/*
> > + * Drop device pages that we maintain for the secure guest
> > + *
> > + * We first mark the pages to be skipped from UV_PAGE_OUT when there
> > + * is HV side fault on these pages. Next we *get* these pages, forcing
> 
> Is that get page implicit? there is no explicit "get" in this 
> function?

gfn_to_pfn does get_user_pages eventually.

> 
> > + * fault on them, do fault time migration to replace the device PTEs in
> > + * QEMU page table with normal PTEs from newly allocated pages.
> > + */
> > +static void kvmppc_uvmem_drop_pages(struct kvm_memory_slot *free,
> > +				   struct kvm *kvm)
> > +{
> > +	int i;
> > +	struct kvmppc_uvmem_page_pvt *pvt;
> > +	unsigned long pfn;
> > +
> > +	for (i = 0; i < free->npages; i++) {
> > +		unsigned long *rmap = &free->arch.rmap[i];
> > +		struct page *uvmem_page;
> > +
> > +		if (kvmppc_rmap_type(rmap) == KVMPPC_RMAP_UVMEM_PFN) {
> > +			uvmem_page = pfn_to_page(*rmap &
> > +						 ~KVMPPC_RMAP_UVMEM_PFN);
> > +			pvt = (struct kvmppc_uvmem_page_pvt *)
> > +				uvmem_page->zone_device_data;
> > +			pvt->skip_page_out = true;
> > +
> > +			pfn = gfn_to_pfn(kvm, pvt->gpa >> PAGE_SHIFT);

Regards,
Bharata.

