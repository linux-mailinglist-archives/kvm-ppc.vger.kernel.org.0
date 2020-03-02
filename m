Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1341176597
	for <lists+kvm-ppc@lfdr.de>; Mon,  2 Mar 2020 22:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgCBVK0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 2 Mar 2020 16:10:26 -0500
Received: from 1.mo69.mail-out.ovh.net ([178.33.251.173]:34303 "EHLO
        1.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgCBVK0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 2 Mar 2020 16:10:26 -0500
X-Greylist: delayed 941 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2020 16:10:23 EST
Received: from player726.ha.ovh.net (unknown [10.108.57.226])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 4B1EF86489
        for <kvm-ppc@vger.kernel.org>; Mon,  2 Mar 2020 21:54:41 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player726.ha.ovh.net (Postfix) with ESMTPSA id 3EA04FE49C0A;
        Mon,  2 Mar 2020 20:54:25 +0000 (UTC)
Date:   Mon, 2 Mar 2020 21:54:15 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org,
        clg@fr.ibm.com, david@gibson.dropbear.id.au
Subject: Re: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
Message-ID: <20200302215415.6a4ba5cf@bahia.home>
In-Reply-To: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8255379595624749515
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddtgedgudeggecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhepfffhvffukfgjfhfogggtgfesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejvdeirdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 28 Feb 2020 23:54:04 -0800
Ram Pai <linuxram@us.ibm.com> wrote:

> XIVE is not correctly enabled for Secure VM in the KVM Hypervisor yet.
> 

What exactly is "not correctly enabled" ?

> Hence Secure VM, must always default to XICS interrupt controller.
> 

So this is a temporary workaround until whatever isn't working with
XIVE and the Secure VM gets fixed. Maybe worth mentioning this in
some comment.

> If XIVE is requested through kernel command line option "xive=on",
> override and turn it off.
> 

There's no such thing as requesting XIVE with "xive=on". XIVE is
on by default if the platform and CPU support it BUT it can be
disabled with "xive=off" in which case the guest wont request
XIVE except if it's the only available mode.

> If XIVE is the only supported platform interrupt controller; specified
> through qemu option "ic-mode=xive", simply abort. Otherwise default to
> XICS.
> 

If XIVE is the only option and the guest requests XICS anyway, QEMU is
supposed to print an error message and terminate:

        if (!spapr->irq->xics) {
            error_report(
"Guest requested unavailable interrupt mode (XICS), either don't set the ic-mode machine property or try ic-mode=xics or ic-mode=dual");
            exit(EXIT_FAILURE);
        }

I think it would be better to end up there rather than aborting.

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
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> ---
>  arch/powerpc/kernel/prom_init.c | 43 ++++++++++++++++++++++++++++-------------
>  1 file changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
> index 5773453..dd96c82 100644
> --- a/arch/powerpc/kernel/prom_init.c
> +++ b/arch/powerpc/kernel/prom_init.c
> @@ -805,6 +805,18 @@ static void __init early_cmdline_parse(void)
>  #endif
>  	}
>  
> +#ifdef CONFIG_PPC_SVM
> +	opt = prom_strstr(prom_cmd_line, "svm=");
> +	if (opt) {
> +		bool val;
> +
> +		opt += sizeof("svm=") - 1;
> +		if (!prom_strtobool(opt, &val))
> +			prom_svm_enable = val;
> +		prom_printf("svm =%d\n", prom_svm_enable);
> +	}
> +#endif /* CONFIG_PPC_SVM */
> +
>  #ifdef CONFIG_PPC_PSERIES
>  	prom_radix_disable = !IS_ENABLED(CONFIG_PPC_RADIX_MMU_DEFAULT);
>  	opt = prom_strstr(prom_cmd_line, "disable_radix");
> @@ -823,23 +835,22 @@ static void __init early_cmdline_parse(void)
>  	if (prom_radix_disable)
>  		prom_debug("Radix disabled from cmdline\n");
>  
> -	opt = prom_strstr(prom_cmd_line, "xive=off");
> -	if (opt) {

A comment to explain why we currently need to limit ourselves to using
XICS would be appreciated.

> +#ifdef CONFIG_PPC_SVM
> +	if (prom_svm_enable) {
>  		prom_xive_disable = true;
> -		prom_debug("XIVE disabled from cmdline\n");
> +		prom_debug("XIVE disabled in Secure VM\n");
>  	}
> -#endif /* CONFIG_PPC_PSERIES */
> -
> -#ifdef CONFIG_PPC_SVM
> -	opt = prom_strstr(prom_cmd_line, "svm=");
> -	if (opt) {
> -		bool val;
> +#endif /* CONFIG_PPC_SVM */
>  
> -		opt += sizeof("svm=") - 1;
> -		if (!prom_strtobool(opt, &val))
> -			prom_svm_enable = val;
> +	if (!prom_xive_disable) {
> +		opt = prom_strstr(prom_cmd_line, "xive=off");
> +		if (opt) {
> +			prom_xive_disable = true;
> +			prom_debug("XIVE disabled from cmdline\n");
> +		}
>  	}
> -#endif /* CONFIG_PPC_SVM */
> +
> +#endif /* CONFIG_PPC_PSERIES */
>  }
>  
>  #ifdef CONFIG_PPC_PSERIES
> @@ -1251,6 +1262,12 @@ static void __init prom_parse_xive_model(u8 val,
>  		break;
>  	case OV5_FEAT(OV5_XIVE_EXPLOIT): /* Only Exploitation mode */
>  		prom_debug("XIVE - exploitation mode supported\n");
> +
> +#ifdef CONFIG_PPC_SVM
> +		if (prom_svm_enable)
> +			prom_panic("WARNING: xive unsupported in Secure VM\n");

Change the prom_panic() line into a break. The guest will ask XICS and QEMU
will terminate nicely. Maybe still print out a warning since QEMU won't mention
the Secure VM aspect of things.

> +#endif /* CONFIG_PPC_SVM */
> +
>  		if (prom_xive_disable) {
>  			/*
>  			 * If we __have__ to do XIVE, we're better off ignoring

