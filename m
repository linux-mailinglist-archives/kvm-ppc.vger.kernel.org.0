Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC87B5DD0
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Sep 2019 09:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfIRHMU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Sep 2019 03:12:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38536 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725834AbfIRHMU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Sep 2019 03:12:20 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8I7C2EZ104115
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Sep 2019 03:12:18 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v3cjbp94s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 18 Sep 2019 03:12:18 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Wed, 18 Sep 2019 08:12:16 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Sep 2019 08:12:12 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8I7BiYT42664258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 07:11:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5EE94C04A;
        Wed, 18 Sep 2019 07:12:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FFE64C05A;
        Wed, 18 Sep 2019 07:12:09 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.59.145])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 18 Sep 2019 07:12:08 +0000 (GMT)
Date:   Wed, 18 Sep 2019 12:42:06 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v8 2/8] kvmppc: Movement of pages between normal and
 secure memory
Reply-To: bharata@linux.ibm.com
References: <20190910082946.7849-1-bharata@linux.ibm.com>
 <20190910082946.7849-3-bharata@linux.ibm.com>
 <20190917233139.GB27932@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917233139.GB27932@us.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19091807-4275-0000-0000-00000367EA5F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091807-4276-0000-0000-0000387A5211
Message-Id: <20190918071206.GA11675@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-18_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=724 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909180076
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Sep 17, 2019 at 04:31:39PM -0700, Sukadev Bhattiprolu wrote:
> 
> Minor: Can this allocation be outside the lock? I guess it would change
> the order of cleanup at the end of the function.

Cleanup has bitmap_clear which needs be under spinlock, so this order
of setup/alloc and cleanup will keep things simple is what I felt.

> 
> > +	spin_unlock(&kvmppc_uvmem_pfn_lock);
> > +
> > +	*rmap = uvmem_pfn | KVMPPC_RMAP_UVMEM_PFN;
> > +	pvt->rmap = rmap;
> > +	pvt->gpa = gpa;
> > +	pvt->lpid = lpid;
> > +	dpage->zone_device_data = pvt;
> > +
> > +	get_page(dpage);
> > +	return dpage;
> > +
> > +out_unlock:
> > +	unlock_page(dpage);
> > +out_clear:
> > +	bitmap_clear(kvmppc_uvmem_pfn_bitmap, uvmem_pfn - pfn_first, 1);
> 
> Reuse variable 'bit'  here?

Sure.

> 
> > +out:
> > +	spin_unlock(&kvmppc_uvmem_pfn_lock);
> > +	return NULL;
> > +}
> > +
> > +/*
> > + * Alloc a PFN from private device memory pool and copy page from normal
> > + * memory to secure memory using UV_PAGE_IN uvcall.
> > + */
> > +static int
> > +kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
> > +		   unsigned long end, unsigned long *rmap,
> > +		   unsigned long gpa, unsigned int lpid,
> > +		   unsigned long page_shift)
> > +{
> > +	unsigned long src_pfn, dst_pfn = 0;
> > +	struct migrate_vma mig;
> > +	struct page *spage;
> > +	unsigned long pfn;
> > +	struct page *dpage;
> > +	int ret = 0;
> > +
> > +	memset(&mig, 0, sizeof(mig));
> > +	mig.vma = vma;
> > +	mig.start = start;
> > +	mig.end = end;
> > +	mig.src = &src_pfn;
> > +	mig.dst = &dst_pfn;
> > +
> > +	ret = migrate_vma_setup(&mig);
> > +	if (ret)
> > +		return ret;
> > +
> > +	spage = migrate_pfn_to_page(*mig.src);
> > +	pfn = *mig.src >> MIGRATE_PFN_SHIFT;
> > +	if (!spage || !(*mig.src & MIGRATE_PFN_MIGRATE)) {
> > +		ret = 0;
> 
> Do we want to return success here (and have caller return H_SUCCESS) if
> we can't find the source page?

spage is NULL for zero page. In this case we return success but there is
no UV_PAGE_IN involved.

Absence of MIGRATE_PFN_MIGRATE indicates that the requested page
can't be migrated. I haven't hit this case till now. Similar check
is also present in the nouveau driver. I am not sure if this is strictly
needed here.

Christoph, Jason - do you know if !(*mig.src & MIGRATE_PFN_MIGRATE)
check is required and if so in which cases will it be true?

> > + * Fault handler callback when HV touches any page that has been
> 
>  Nit: s/callback/callback. Called /

Yeah will rephrase.

Regards,
Bharata.

