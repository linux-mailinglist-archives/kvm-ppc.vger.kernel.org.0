Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A8B32C8D0
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Mar 2021 02:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243117AbhCDAwq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 3 Mar 2021 19:52:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6732 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1387986AbhCCUKu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 3 Mar 2021 15:10:50 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123K4wlP111324;
        Wed, 3 Mar 2021 15:10:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=9OGhEF+1wp+X6aXCnnJbnniVj4hg4lKLvZGOTuhrFbo=;
 b=Qi+3cdUTQtgMNHO5WCs81Nq9V6LF7YVFj5pPZZBBusPbG2fCB7oG+9MPvI/+thN3yUut
 0cn74yDuVn0Vbg6RCQH2w+qclPYxt/A+0eXmB7T/lTeRhjtZV9ZQJt9qs4mO2CQcbi3y
 lD+RRMALRqx75HExfdEDMD3Szm3cBRrIm6OMapcZrsmzs+2qMfKRk21eW2WljRKV95CN
 lhN3XvtAhWlYvs1yYHP+zOijvwclLBhePKpfdjUBoly3pgj6ZhOm+sfxzLKgxPbHt1E+
 e0rO/liWG9VCvJFCVlM7qd18XJgHvBSsuAiZWg1qqEtiRv8W3beO6fkycrU5p01vN7up 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372f99434y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 15:10:02 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123K8bpa131425;
        Wed, 3 Mar 2021 15:10:02 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372f99434k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 15:10:02 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 123K3cFF020048;
        Wed, 3 Mar 2021 20:10:01 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 3711dx26mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 20:10:01 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 123KA1Au15466856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Mar 2021 20:10:01 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 521E5112062;
        Wed,  3 Mar 2021 20:10:01 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D38B112063;
        Wed,  3 Mar 2021 20:09:59 +0000 (GMT)
Received: from localhost (unknown [9.160.139.191])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed,  3 Mar 2021 20:09:59 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 34/37] KVM: PPC: Book3S HV: add virtual mode handlers
 for HPT hcalls and page faults
In-Reply-To: <20210225134652.2127648-35-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
 <20210225134652.2127648-35-npiggin@gmail.com>
Date:   Wed, 03 Mar 2021 17:09:57 -0300
Message-ID: <87im68vw16.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_06:2021-03-03,2021-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030142
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> In order to support hash guests in the P9 path (which does not do real
> mode hcalls or page fault handling), these real-mode hash specific
> interrupts need to be implemented in virt mode.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 118 +++++++++++++++++++++++++++++++++--
>  1 file changed, 113 insertions(+), 5 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 9d2fa21201c1..1bbc46f2cfbf 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -935,6 +935,52 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
>  		return RESUME_HOST;
>
>  	switch (req) {
> +	case H_REMOVE:
> +		ret = kvmppc_h_remove(vcpu, kvmppc_get_gpr(vcpu, 4),
> +					kvmppc_get_gpr(vcpu, 5),
> +					kvmppc_get_gpr(vcpu, 6));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_ENTER:
> +		ret = kvmppc_h_enter(vcpu, kvmppc_get_gpr(vcpu, 4),
> +					kvmppc_get_gpr(vcpu, 5),
> +					kvmppc_get_gpr(vcpu, 6),
> +					kvmppc_get_gpr(vcpu, 7));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_READ:
> +		ret = kvmppc_h_read(vcpu, kvmppc_get_gpr(vcpu, 4),
> +					kvmppc_get_gpr(vcpu, 5));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_CLEAR_MOD:
> +		ret = kvmppc_h_clear_mod(vcpu, kvmppc_get_gpr(vcpu, 4),
> +					kvmppc_get_gpr(vcpu, 5));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_CLEAR_REF:
> +		ret = kvmppc_h_clear_ref(vcpu, kvmppc_get_gpr(vcpu, 4),
> +					kvmppc_get_gpr(vcpu, 5));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_PROTECT:
> +		ret = kvmppc_h_protect(vcpu, kvmppc_get_gpr(vcpu, 4),
> +					kvmppc_get_gpr(vcpu, 5),
> +					kvmppc_get_gpr(vcpu, 6));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_BULK_REMOVE:
> +		ret = kvmppc_h_bulk_remove(vcpu);
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +

Some of these symbols need to be exported.

ERROR: modpost: "kvmppc_h_bulk_remove" [arch/powerpc/kvm/kvm-hv.ko] undefined!
ERROR: modpost: "kvmppc_h_clear_mod" [arch/powerpc/kvm/kvm-hv.ko] undefined!
ERROR: modpost: "kvmppc_xive_xics_hcall" [arch/powerpc/kvm/kvm-hv.ko] undefined!
ERROR: modpost: "kvmppc_h_remove" [arch/powerpc/kvm/kvm-hv.ko] undefined!
ERROR: modpost: "decrementers_next_tb" [arch/powerpc/kvm/kvm-hv.ko] undefined!
ERROR: modpost: "kvmppc_hpte_hv_fault" [arch/powerpc/kvm/kvm-hv.ko] undefined!
ERROR: modpost: "kvmppc_h_protect" [arch/powerpc/kvm/kvm-hv.ko] undefined!
ERROR: modpost: "kvmppc_h_enter" [arch/powerpc/kvm/kvm-hv.ko] undefined!
ERROR: modpost: "kvmppc_h_clear_ref" [arch/powerpc/kvm/kvm-hv.ko] undefined!
ERROR: modpost: "kvmppc_h_read" [arch/powerpc/kvm/kvm-hv.ko] undefined!

>  	case H_CEDE:
>  		break;
>  	case H_PROD:
> @@ -1134,6 +1180,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
>  	default:
>  		return RESUME_HOST;
>  	}
> +	WARN_ON_ONCE(ret == H_TOO_HARD);
>  	kvmppc_set_gpr(vcpu, 3, ret);
>  	vcpu->arch.hcall_needed = 0;
>  	return RESUME_GUEST;
> @@ -1420,19 +1467,80 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
>  	 * host page has been paged out.  Any other HDSI/HISI interrupts
>  	 * have been handled already.
>  	 */
> -	case BOOK3S_INTERRUPT_H_DATA_STORAGE:
> -		r = RESUME_PAGE_FAULT;
> -		if (vcpu->arch.fault_dsisr == HDSISR_CANARY)
> +	case BOOK3S_INTERRUPT_H_DATA_STORAGE: {
> +		unsigned long vsid;
> +		long err;
> +
> +		if (vcpu->arch.fault_dsisr == HDSISR_CANARY) {
>  			r = RESUME_GUEST; /* Just retry if it's the canary */
> +			break;
> +		}
> +
> +		if (kvm_is_radix(vcpu->kvm)) {
> +			r = RESUME_PAGE_FAULT;
> +			break;
> +		}
> +
> +		if (!(vcpu->arch.fault_dsisr & (DSISR_NOHPTE | DSISR_PROTFAULT))) {
> +			kvmppc_core_queue_data_storage(vcpu, vcpu->arch.fault_dar, vcpu->arch.fault_dsisr);
> +			r = RESUME_GUEST;
> +			break;
> +		}
> +		if (!(vcpu->arch.shregs.msr & MSR_DR)) {
> +			vsid = vcpu->kvm->arch.vrma_slb_v;
> +		} else {
> +			vsid = vcpu->arch.fault_gpa;
> +		}
> +		err = kvmppc_hpte_hv_fault(vcpu, vcpu->arch.fault_dar,
> +				vsid, vcpu->arch.fault_dsisr, true);
> +		if (err == 0) {
> +			r = RESUME_GUEST;
> +		} else if (err == -1 || err == -2) {
> +			r = RESUME_PAGE_FAULT;
> +		} else {
> +			kvmppc_core_queue_data_storage(vcpu, vcpu->arch.fault_dar, err);
> +			r = RESUME_GUEST;
> +		}
>  		break;
> -	case BOOK3S_INTERRUPT_H_INST_STORAGE:
> +	}
> +	case BOOK3S_INTERRUPT_H_INST_STORAGE: {
> +		unsigned long vsid;
> +		long err;
> +
>  		vcpu->arch.fault_dar = kvmppc_get_pc(vcpu);
>  		vcpu->arch.fault_dsisr = vcpu->arch.shregs.msr &
>  			DSISR_SRR1_MATCH_64S;
>  		if (vcpu->arch.shregs.msr & HSRR1_HISI_WRITE)
>  			vcpu->arch.fault_dsisr |= DSISR_ISSTORE;
> -		r = RESUME_PAGE_FAULT;
> +		if (kvm_is_radix(vcpu->kvm)) {
> +			r = RESUME_PAGE_FAULT;
> +			break;
> +		}
> +
> +		if (!(vcpu->arch.fault_dsisr & SRR1_ISI_NOPT)) {
> +			/* XXX: clear DSISR_ISSTORE? */
> +			kvmppc_core_queue_inst_storage(vcpu, vcpu->arch.fault_dsisr);
> +			r = RESUME_GUEST;
> +			break;
> +		}
> +		if (!(vcpu->arch.shregs.msr & MSR_DR)) {
> +			vsid = vcpu->kvm->arch.vrma_slb_v;
> +		} else {
> +			vsid = vcpu->arch.fault_gpa;
> +		}
> +		err = kvmppc_hpte_hv_fault(vcpu, vcpu->arch.fault_dar,
> +				vsid, vcpu->arch.fault_dsisr, false);
> +		if (err == 0) {
> +			r = RESUME_GUEST;
> +		} else if (err == -1) {
> +			r = RESUME_PAGE_FAULT;
> +		} else {
> +			kvmppc_core_queue_inst_storage(vcpu, err);
> +			r = RESUME_GUEST;
> +		}
>  		break;
> +	}
> +
>  	/*
>  	 * This occurs if the guest executes an illegal instruction.
>  	 * If the guest debug is disabled, generate a program interrupt
