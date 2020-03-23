Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DB718F68F
	for <lists+kvm-ppc@lfdr.de>; Mon, 23 Mar 2020 15:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgCWOJz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 23 Mar 2020 10:09:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54904 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728378AbgCWOJz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 23 Mar 2020 10:09:55 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02NE7ClM195877;
        Mon, 23 Mar 2020 10:09:41 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywdr51t8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 10:09:40 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02NE93fE026135;
        Mon, 23 Mar 2020 14:09:39 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 2ywaw9gw76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 14:09:39 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02NE9cXc57934080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 14:09:38 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CA20C6055;
        Mon, 23 Mar 2020 14:09:38 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCC4CC6057;
        Mon, 23 Mar 2020 14:09:36 +0000 (GMT)
Received: from localhost (unknown [9.85.135.158])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 23 Mar 2020 14:09:36 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Laurent Dufour <ldufour@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     Bharata B Rao <bharata@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 2/2] KVM: PPC: Book3S HV: H_SVM_INIT_START must call UV_RETURN
In-Reply-To: <20200320102643.15516-3-ldufour@linux.ibm.com>
References: <20200320102643.15516-1-ldufour@linux.ibm.com> <20200320102643.15516-3-ldufour@linux.ibm.com>
Date:   Mon, 23 Mar 2020 11:09:33 -0300
Message-ID: <87wo7bgo2q.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_05:2020-03-21,2020-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 clxscore=1011 suspectscore=5 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003230078
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Laurent Dufour <ldufour@linux.ibm.com> writes:

> When the call to UV_REGISTER_MEM_SLOT is failing, for instance because
> there is not enough free secured memory, the Hypervisor (HV) has to call
> UV_RETURN to report the error to the Ultravisor (UV). Then the UV will call
> H_SVM_INIT_ABORT to abort the securing phase and go back to the calling VM.
>
> If the kvm->arch.secure_guest is not set, in the return path rfid is called
> but there is no valid context to get back to the SVM since the Hcall has
> been routed by the Ultravisor.
>
> Move the setting of kvm->arch.secure_guest earlier in
> kvmppc_h_svm_init_start() so in the return path, UV_RETURN will be called
> instead of rfid.
>
> Cc: Bharata B Rao <bharata@linux.ibm.com>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> ---

I tested this along with the code that rejects the secure transition
when it is not enabled in KVM.

I have also forced a KVM_PPC_SVM_OFF (via system_reset) right after
setting kvm->arch.secure_guest and nothing bad happened.

Tested-by: Fabiano Rosas <farosas@linux.ibm.com>


>  arch/powerpc/kvm/book3s_hv_uvmem.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index 79b1202b1c62..68dff151315c 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -209,6 +209,8 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
>  	int ret = H_SUCCESS;
>  	int srcu_idx;
>
> +	kvm->arch.secure_guest = KVMPPC_SECURE_INIT_START;
> +
>  	if (!kvmppc_uvmem_bitmap)
>  		return H_UNSUPPORTED;
>
> @@ -233,7 +235,6 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
>  			goto out;
>  		}
>  	}
> -	kvm->arch.secure_guest |= KVMPPC_SECURE_INIT_START;
>  out:
>  	srcu_read_unlock(&kvm->srcu, srcu_idx);
>  	return ret;
