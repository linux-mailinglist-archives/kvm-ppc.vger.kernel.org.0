Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68FD463C0B
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Jul 2019 21:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfGITl2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Jul 2019 15:41:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21734 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbfGITl1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Jul 2019 15:41:27 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69JdIJc049634
        for <kvm-ppc@vger.kernel.org>; Tue, 9 Jul 2019 15:41:27 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tmy5dd8t7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Jul 2019 15:41:26 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <janani@linux.ibm.com>;
        Tue, 9 Jul 2019 20:41:25 +0100
Received: from b03cxnp08025.gho.boulder.ibm.com (9.17.130.17)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 9 Jul 2019 20:41:21 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69JfKmc43123054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 19:41:20 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18BBBC605B;
        Tue,  9 Jul 2019 19:41:20 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8560C6055;
        Tue,  9 Jul 2019 19:41:19 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jul 2019 19:41:19 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 09 Jul 2019 14:43:47 -0500
From:   janani <janani@linux.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linuxram@us.ibm.com,
        cclaudio@linux.ibm.com, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, jglisse@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, paulus@au1.ibm.com,
        sukadev@linux.vnet.ibm.com,
        Linuxppc-dev 
        <linuxppc-dev-bounces+janani=linux.ibm.com@lists.ozlabs.org>
Subject: Re: [PATCH v5 4/7] kvmppc: Handle memory plug/unplug to secure VM
Organization: IBM
Reply-To: janani@linux.ibm.com
Mail-Reply-To: janani@linux.ibm.com
In-Reply-To: <20190709102545.9187-5-bharata@linux.ibm.com>
References: <20190709102545.9187-1-bharata@linux.ibm.com>
 <20190709102545.9187-5-bharata@linux.ibm.com>
X-Sender: janani@linux.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
x-cbid: 19070919-8235-0000-0000-00000EB44E59
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011401; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01229823; UDB=6.00647720; IPR=6.01011082;
 MB=3.00027657; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-09 19:41:23
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070919-8236-0000-0000-000046546CF6
Message-Id: <730f4bbd1be9abae7640ddc7366b0beb@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=978 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090232
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 2019-07-09 05:25, Bharata B Rao wrote:
> Register the new memslot with UV during plug and unregister
> the memslot during unplug.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
  Reviewed-by: Janani Janakiraman <janani@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/ultravisor-api.h |  1 +
>  arch/powerpc/include/asm/ultravisor.h     |  7 +++++++
>  arch/powerpc/kvm/book3s_hv.c              | 19 +++++++++++++++++++
>  3 files changed, 27 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/ultravisor-api.h
> b/arch/powerpc/include/asm/ultravisor-api.h
> index 07b7d638e7af..d6d6eb2e6e6b 100644
> --- a/arch/powerpc/include/asm/ultravisor-api.h
> +++ b/arch/powerpc/include/asm/ultravisor-api.h
> @@ -21,6 +21,7 @@
>  #define UV_WRITE_PATE			0xF104
>  #define UV_RETURN			0xF11C
>  #define UV_REGISTER_MEM_SLOT		0xF120
> +#define UV_UNREGISTER_MEM_SLOT		0xF124
>  #define UV_PAGE_IN			0xF128
>  #define UV_PAGE_OUT			0xF12C
> 
> diff --git a/arch/powerpc/include/asm/ultravisor.h
> b/arch/powerpc/include/asm/ultravisor.h
> index b46042f1aa8f..fe45be9ee63b 100644
> --- a/arch/powerpc/include/asm/ultravisor.h
> +++ b/arch/powerpc/include/asm/ultravisor.h
> @@ -70,6 +70,13 @@ static inline int uv_register_mem_slot(u64 lpid,
> u64 start_gpa, u64 size,
>  	return ucall(UV_REGISTER_MEM_SLOT, retbuf, lpid, start_gpa,
>  		     size, flags, slotid);
>  }
> +
> +static inline int uv_unregister_mem_slot(u64 lpid, u64 slotid)
> +{
> +	unsigned long retbuf[UCALL_BUFSIZE];
> +
> +	return ucall(UV_UNREGISTER_MEM_SLOT, retbuf, lpid, slotid);
> +}
>  #endif /* !__ASSEMBLY__ */
> 
>  #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
> diff --git a/arch/powerpc/kvm/book3s_hv.c 
> b/arch/powerpc/kvm/book3s_hv.c
> index b8f801d00ad4..7cbb5edaed01 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -77,6 +77,7 @@
>  #include <asm/hw_breakpoint.h>
>  #include <asm/kvm_host.h>
>  #include <asm/kvm_book3s_hmm.h>
> +#include <asm/ultravisor.h>
> 
>  #include "book3s.h"
> 
> @@ -4504,6 +4505,24 @@ static void
> kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
>  	if (change == KVM_MR_FLAGS_ONLY && kvm_is_radix(kvm) &&
>  	    ((new->flags ^ old->flags) & KVM_MEM_LOG_DIRTY_PAGES))
>  		kvmppc_radix_flush_memslot(kvm, old);
> +	/*
> +	 * If UV hasn't yet called H_SVM_INIT_START, don't register memslots.
> +	 */
> +	if (!kvm->arch.secure_guest)
> +		return;
> +
> +	/*
> +	 * TODO: Handle KVM_MR_MOVE
> +	 */
> +	if (change == KVM_MR_CREATE) {
> +		uv_register_mem_slot(kvm->arch.lpid,
> +					   new->base_gfn << PAGE_SHIFT,
> +					   new->npages * PAGE_SIZE,
> +					   0,
> +					   new->id);
> +	} else if (change == KVM_MR_DELETE) {
> +		uv_unregister_mem_slot(kvm->arch.lpid, old->id);
> +	}
>  }
> 
>  /*

