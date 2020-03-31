Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7BD19A29F
	for <lists+kvm-ppc@lfdr.de>; Wed,  1 Apr 2020 01:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbgCaXxc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 31 Mar 2020 19:53:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731647AbgCaXxb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 31 Mar 2020 19:53:31 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VNqjrT014915;
        Tue, 31 Mar 2020 19:53:19 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 301yfg84w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Mar 2020 19:53:19 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02VNcR31031806;
        Tue, 31 Mar 2020 23:53:18 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 301x76kxh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Mar 2020 23:53:18 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02VNrGIb56492462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 23:53:16 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B880AC6059;
        Tue, 31 Mar 2020 23:53:16 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A35FC6055;
        Tue, 31 Mar 2020 23:53:13 +0000 (GMT)
Received: from morokweng.localdomain (unknown [9.85.192.10])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue, 31 Mar 2020 23:53:13 +0000 (GMT)
References: <1585211927-784-1-git-send-email-linuxram@us.ibm.com>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org,
        groug@kaod.org, clg@fr.ibm.com, david@gibson.dropbear.id.au
Subject: Re: [PATCH v2] powerpc/XIVE: SVM: share the event-queue page with the Hypervisor.
In-reply-to: <1585211927-784-1-git-send-email-linuxram@us.ibm.com>
Date:   Tue, 31 Mar 2020 20:53:07 -0300
Message-ID: <87r1x86pzw.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_07:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=2 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1011
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=827 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003310188
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Hi Ram,

Ram Pai <linuxram@us.ibm.com> writes:

> diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
> index 55dc61c..608b52f 100644
> --- a/arch/powerpc/sysdev/xive/spapr.c
> +++ b/arch/powerpc/sysdev/xive/spapr.c
> @@ -26,6 +26,8 @@
>  #include <asm/xive.h>
>  #include <asm/xive-regs.h>
>  #include <asm/hvcall.h>
> +#include <asm/svm.h>
> +#include <asm/ultravisor.h>
>  
>  #include "xive-internal.h"
>  
> @@ -501,6 +503,9 @@ static int xive_spapr_configure_queue(u32 target, struct xive_q *q, u8 prio,
>  		rc = -EIO;
>  	} else {
>  		q->qpage = qpage;
> +		if (is_secure_guest())
> +			uv_share_page(PHYS_PFN(qpage_phys),
> +					1 << xive_alloc_order(order));

If I understand this correctly, you're passing the number of bytes of
the queue to uv_share_page(), but that ultracall expects the number of
pages to be shared.

>  	}
>  fail:
>  	return rc;
> @@ -534,6 +539,8 @@ static void xive_spapr_cleanup_queue(unsigned int cpu, struct xive_cpu *xc,
>  		       hw_cpu, prio);
>  
>  	alloc_order = xive_alloc_order(xive_queue_shift);
> +	if (is_secure_guest())
> +		uv_unshare_page(PHYS_PFN(__pa(q->qpage)), 1 << alloc_order);
>  	free_pages((unsigned long)q->qpage, alloc_order);
>  	q->qpage = NULL;
>  }

Same problem here.

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
