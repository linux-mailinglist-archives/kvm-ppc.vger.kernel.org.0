Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF3322A89D
	for <lists+kvm-ppc@lfdr.de>; Thu, 23 Jul 2020 08:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgGWGOH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 23 Jul 2020 02:14:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728198AbgGWGOF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 23 Jul 2020 02:14:05 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N63SFX140123;
        Thu, 23 Jul 2020 02:13:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32f1gxcbw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 02:13:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06N6BBid031555;
        Thu, 23 Jul 2020 06:13:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 32brq85u64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 06:13:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06N6DnUH56819898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 06:13:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54B8AAE053;
        Thu, 23 Jul 2020 06:13:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25E9FAE04D;
        Thu, 23 Jul 2020 06:13:47 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.75.152])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 23 Jul 2020 06:13:46 +0000 (GMT)
Date:   Thu, 23 Jul 2020 11:43:44 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, cclaudio@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [v4 4/5] KVM: PPC: Book3S HV: retry page migration before
 erroring-out
Message-ID: <20200723061344.GB1082478@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <1594972827-13928-1-git-send-email-linuxram@us.ibm.com>
 <1594972827-13928-5-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594972827-13928-5-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_01:2020-07-22,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=503
 suspectscore=1 mlxscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230048
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jul 17, 2020 at 01:00:26AM -0700, Ram Pai wrote:
> @@ -812,7 +842,7 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
>  	struct vm_area_struct *vma;
>  	int srcu_idx;
>  	unsigned long gfn = gpa >> page_shift;
> -	int ret;
> +	int ret, repeat_count = REPEAT_COUNT;
>  
>  	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
>  		return H_UNSUPPORTED;
> @@ -826,34 +856,44 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
>  	if (flags & H_PAGE_IN_SHARED)
>  		return kvmppc_share_page(kvm, gpa, page_shift);
>  
> -	ret = H_PARAMETER;
>  	srcu_idx = srcu_read_lock(&kvm->srcu);
> -	mmap_read_lock(kvm->mm);
>  
> -	start = gfn_to_hva(kvm, gfn);
> -	if (kvm_is_error_hva(start))
> -		goto out;
> -
> -	mutex_lock(&kvm->arch.uvmem_lock);
>  	/* Fail the page-in request of an already paged-in page */
> -	if (kvmppc_gfn_is_uvmem_pfn(gfn, kvm, NULL))
> -		goto out_unlock;
> +	mutex_lock(&kvm->arch.uvmem_lock);
> +	ret = kvmppc_gfn_is_uvmem_pfn(gfn, kvm, NULL);
> +	mutex_unlock(&kvm->arch.uvmem_lock);

Same comment as for the prev patch. I don't think you can release
the lock here.

> +	if (ret) {
> +		srcu_read_unlock(&kvm->srcu, srcu_idx);
> +		return H_PARAMETER;
> +	}
>  
> -	end = start + (1UL << page_shift);
> -	vma = find_vma_intersection(kvm->mm, start, end);
> -	if (!vma || vma->vm_start > start || vma->vm_end < end)
> -		goto out_unlock;
> +	do {
> +		ret = H_PARAMETER;
> +		mmap_read_lock(kvm->mm);
>  
> -	if (kvmppc_svm_migrate_page(vma, start, end, gpa, kvm, page_shift,
> -				true))
> -		goto out_unlock;
> +		start = gfn_to_hva(kvm, gfn);
> +		if (kvm_is_error_hva(start)) {
> +			mmap_read_unlock(kvm->mm);
> +			break;
> +		}
>  
> -	ret = H_SUCCESS;
> +		end = start + (1UL << page_shift);
> +		vma = find_vma_intersection(kvm->mm, start, end);
> +		if (!vma || vma->vm_start > start || vma->vm_end < end) {
> +			mmap_read_unlock(kvm->mm);
> +			break;
> +		}
> +
> +		mutex_lock(&kvm->arch.uvmem_lock);
> +		ret = kvmppc_svm_migrate_page(vma, start, end, gpa, kvm, page_shift, true);
> +		mutex_unlock(&kvm->arch.uvmem_lock);
> +
> +		mmap_read_unlock(kvm->mm);
> +	} while (ret == -2 && repeat_count--);
> +
> +	if (ret == -2)
> +		ret = H_BUSY;
>  
> -out_unlock:
> -	mutex_unlock(&kvm->arch.uvmem_lock);
> -out:
> -	mmap_read_unlock(kvm->mm);
>  	srcu_read_unlock(&kvm->srcu, srcu_idx);
>  	return ret;
>  }
> -- 
> 1.8.3.1
