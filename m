Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9E7193DB4
	for <lists+kvm-ppc@lfdr.de>; Thu, 26 Mar 2020 12:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgCZLNu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 26 Mar 2020 07:13:50 -0400
Received: from 8.mo179.mail-out.ovh.net ([46.105.75.26]:41134 "EHLO
        8.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgCZLNu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 26 Mar 2020 07:13:50 -0400
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2020 07:13:49 EDT
Received: from player691.ha.ovh.net (unknown [10.108.57.14])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id C7A861605E5
        for <kvm-ppc@vger.kernel.org>; Thu, 26 Mar 2020 09:46:05 +0100 (CET)
Received: from kaod.org (82-64-250-170.subs.proxad.net [82.64.250.170])
        (Authenticated sender: clg@kaod.org)
        by player691.ha.ovh.net (Postfix) with ESMTPSA id 439AE10E299E8;
        Thu, 26 Mar 2020 08:45:53 +0000 (UTC)
Subject: Re: [PATCH v2] powerpc/XIVE: SVM: share the event-queue page with the
 Hypervisor.
To:     Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org,
        groug@kaod.org, david@gibson.dropbear.id.au
References: <1585211927-784-1-git-send-email-linuxram@us.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <9d597905-ca7f-0daf-abaf-93ed88846c70@kaod.org>
Date:   Thu, 26 Mar 2020 09:45:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1585211927-784-1-git-send-email-linuxram@us.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 7767864933461887974
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedrudehhedguddulecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucfkpheptddrtddrtddrtddpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrheiledurdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 3/26/20 9:38 AM, Ram Pai wrote:
> XIVE interrupt controller use an Event Queue (EQ) to enqueue event

The XIVE interrupt controller uses ... (my bad)

> notifications when an exception occurs. The EQ is a single memory page
> provided by the O/S defining a circular buffer, one per server and
> priority couple.
> 
> On baremetal, the EQ page is configured with an OPAL call. On pseries,
> an extra hop is necessary and the guest OS uses the hcall
> H_INT_SET_QUEUE_CONFIG to configure the XIVE interrupt controller.
> 
> The XIVE controller being Hypervisor privileged, it will not be allowed
> to enqueue event notifications for a Secure VM unless the EQ pages are
> shared by the Secure VM.
> 
> Hypervisor/Ultravisor still requires support for the TIMA and ESB page
> fault handlers. Until this is complete, QEMU can use the emulated XIVE
> device for Secure VMs, option "kernel_irqchip=off" on the QEMU pseries
> machine.
> 
> Cc: kvm-ppc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
> Cc: Michael Anderson <andmike@linux.ibm.com>
> Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: Greg Kurz <groug@kaod.org>
> Cc: Cedric Le Goater <clg@fr.ibm.com>

clg@fr.ibm.com is insecure. Please use clg@kaod.org.

> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>

Reviewed-by: Cedric Le Goater <clg@kaod.org>

Thanks,

C.

> 
> v2: better description of the patch from Cedric.
> ---
>  arch/powerpc/sysdev/xive/spapr.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
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
> 

