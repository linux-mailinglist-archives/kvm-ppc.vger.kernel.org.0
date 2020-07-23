Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8887622A791
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Jul 2020 08:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgGWGLC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Jul 2020 02:11:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18632 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727779AbgGWGLC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Jul 2020 02:11:02 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N62FL0092520;
        Thu, 23 Jul 2020 02:10:48 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d91wxd30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 02:10:47 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06N67w6A002973;
        Thu, 23 Jul 2020 06:10:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 32brbgu1vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 06:10:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06N6AgCb32506242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 06:10:42 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4657E4204B;
        Thu, 23 Jul 2020 06:10:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A30C42042;
        Thu, 23 Jul 2020 06:10:40 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.75.152])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 23 Jul 2020 06:10:39 +0000 (GMT)
Date:   Thu, 23 Jul 2020 11:40:37 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, cclaudio@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [v4 3/5] KVM: PPC: Book3S HV: in H_SVM_INIT_DONE, migrate
 remaining normal-GFNs to secure-GFNs.
Message-ID: <20200723061037.GA1082478@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <1594972827-13928-1-git-send-email-linuxram@us.ibm.com>
 <1594972827-13928-4-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594972827-13928-4-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_01:2020-07-22,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 clxscore=1015
 mlxlogscore=472 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230044
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jul 17, 2020 at 01:00:25AM -0700, Ram Pai wrote:
>  
> +int kvmppc_uv_migrate_mem_slot(struct kvm *kvm,
> +		const struct kvm_memory_slot *memslot)

Don't see any callers for this outside of this file, so why not static?

> +{
> +	unsigned long gfn = memslot->base_gfn;
> +	struct vm_area_struct *vma;
> +	unsigned long start, end;
> +	int ret = 0;
> +
> +	while (kvmppc_next_nontransitioned_gfn(memslot, kvm, &gfn)) {

So you checked the state of gfn under uvmem_lock above, but release
it too.

> +
> +		mmap_read_lock(kvm->mm);
> +		start = gfn_to_hva(kvm, gfn);
> +		if (kvm_is_error_hva(start)) {
> +			ret = H_STATE;
> +			goto next;
> +		}
> +
> +		end = start + (1UL << PAGE_SHIFT);
> +		vma = find_vma_intersection(kvm->mm, start, end);
> +		if (!vma || vma->vm_start > start || vma->vm_end < end) {
> +			ret = H_STATE;
> +			goto next;
> +		}
> +
> +		mutex_lock(&kvm->arch.uvmem_lock);
> +		ret = kvmppc_svm_migrate_page(vma, start, end,
> +				(gfn << PAGE_SHIFT), kvm, PAGE_SHIFT, false);

What is the guarantee that the gfn is in the same earlier state when you do
do migration here?

Regards,
Bharata.
