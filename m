Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE89220435
	for <lists+kvm-ppc@lfdr.de>; Wed, 15 Jul 2020 07:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgGOFGI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 15 Jul 2020 01:06:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725917AbgGOFGH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 15 Jul 2020 01:06:07 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06F52NW0165566;
        Wed, 15 Jul 2020 01:05:52 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 329apx5g0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 01:05:52 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06F55oWS024510;
        Wed, 15 Jul 2020 05:05:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 327527j219-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 05:05:50 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06F55ln555115782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 05:05:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63ECBA4040;
        Wed, 15 Jul 2020 05:05:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EDB8A4055;
        Wed, 15 Jul 2020 05:05:44 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.39.1])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 15 Jul 2020 05:05:44 +0000 (GMT)
Date:   Tue, 14 Jul 2020 22:05:41 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, cclaudio@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [v3 3/5] KVM: PPC: Book3S HV: migrate remaining normal-GFNs to
 secure-GFNs in H_SVM_INIT_DONE
Message-ID: <20200715050541.GC7339@oc0525413822.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1594458827-31866-1-git-send-email-linuxram@us.ibm.com>
 <1594458827-31866-4-git-send-email-linuxram@us.ibm.com>
 <20200713094506.GG7902@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713094506.GG7902@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_02:2020-07-14,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150037
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jul 13, 2020 at 03:15:06PM +0530, Bharata B Rao wrote:
> On Sat, Jul 11, 2020 at 02:13:45AM -0700, Ram Pai wrote:
> > The Ultravisor is expected to explicitly call H_SVM_PAGE_IN for all the pages
> >  
> >  	if (!(*mig.src & MIGRATE_PFN_MIGRATE)) {
> > -		ret = -1;
> > +		ret = -2;
> 
> migrate_vma_setup() has marked that this pfn can't be migrated. What
> transient errors are you observing which will disappear within 10
> retries?
> 
> Also till now when UV used to pull in all the pages, we never seemed to
> have hit these transient errors. But now when HV is pushing the same
> pages, we see these errors which are disappearing after 10 retries.
> Can you explain this more please? What sort of pages are these?

We did see them even before this patch. The retry alleviates the
problem, but does not entirely eliminate it. If the chance of seeing
the issue without the patch is 1%,  the chance of seeing this issue
with this patch becomes 0.25%.

> 
> >  		goto out_finalize;
> >  	}
> > +	bool retry = 0;
...snip...
> > +
> > +	*ret = 0;
> > +	while (kvmppc_next_nontransitioned_gfn(memslot, kvm, &gfn)) {
> > +
> > +		down_write(&kvm->mm->mmap_sem);
> 
> Acquiring and releasing mmap_sem in a loop? Any reason?
> 
> Now that you have moved ksm_madvise() calls to init time, any specific
> reason to take write mmap_sem here?

The semaphore protects the vma. right?

And its acquired/released in the loop, to provide the ability to relinquish
the cpu without getting into a tight loop and cause softlockups.

> 
> > +		start = gfn_to_hva(kvm, gfn);
> > +		if (kvm_is_error_hva(start)) {
> > +			*ret = H_STATE;
> > +			goto next;
> > +		}
> > +
> > +		end = start + (1UL << PAGE_SHIFT);
> > +		vma = find_vma_intersection(kvm->mm, start, end);
> > +		if (!vma || vma->vm_start > start || vma->vm_end < end) {
> > +			*ret = H_STATE;
> > +			goto next;
> > +		}
> > +
> > +		mutex_lock(&kvm->arch.uvmem_lock);
> > +		*ret = kvmppc_svm_migrate_page(vma, start, end,
> > +				(gfn << PAGE_SHIFT), kvm, PAGE_SHIFT, false);
> > +		mutex_unlock(&kvm->arch.uvmem_lock);
> > +
> > +next:
> > +		up_write(&kvm->mm->mmap_sem);
> > +
> > +		if (*ret == -2) {
> > +			retry = 1;
> 
> Using true or false assignment makes it easy to understand the intention
> of this 'retry' variable.

ok. next version will have that change.

Thanks for the comments,
RP
