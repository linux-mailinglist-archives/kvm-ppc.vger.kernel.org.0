Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67D3192512
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 Mar 2020 11:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgCYKGS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 Mar 2020 06:06:18 -0400
Received: from ozlabs.org ([203.11.71.1]:58727 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgCYKGR (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 25 Mar 2020 06:06:17 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48nP074DpDz9sSG;
        Wed, 25 Mar 2020 21:06:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1585130775;
        bh=P2gxQmg+cxzQG5Rvyt/Ge2uunIuPebrJxXqaog9ZXWg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=VsqtAJpLV8InkfQtJFq43SwrUdqeZlcTPDYSIJwtXb57yMvPKeptufbT/50XKin4Z
         SgxPgzNxE0q2+XKr6O6Pk0dnEOhw5zTmSvZDTsj+SwITJBtqwKz7gukINm2l5LZ3Wo
         y6rQBGlNgrCUFq7Vzkah+dNWq5CAUUB3n5s6tFq5+gFGucwVWk5lU16CsFuoZgCFfX
         3/e7b7qCrbXj9ocA3IKOl39QoEwZKCSY5Cro4ZRcHtqjH+Jv2wMct9IpAnrwfDv8I8
         rhCESx/jg2iihXkIhSR8/EJmH/im76NzZbxTM2W8ZgG9EupYDEIzfgJZ6P4/jrcW0b
         kBoS8hnlp37nA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, paulus@samba.org, linuxram@us.ibm.com
Subject: Re: [PATCH] powerpc/prom_init: Include the termination message in ibm,os-term RTAS call
In-Reply-To: <20200324201211.1055236-1-farosas@linux.ibm.com>
References: <20200324201211.1055236-1-farosas@linux.ibm.com>
Date:   Wed, 25 Mar 2020 21:06:22 +1100
Message-ID: <87zhc4wxy9.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fabiano Rosas <farosas@linux.ibm.com> writes:

> QEMU can now print the ibm,os-term message[1], so let's include it in
> the RTAS call. E.g.:
>
>   qemu-system-ppc64: OS terminated: Switch to secure mode failed.
>
> 1- https://git.qemu.org/?p=qemu.git;a=commitdiff;h=a4c3791ae0
>
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kernel/prom_init.c | 3 +++
>  1 file changed, 3 insertions(+)

I have this queued:
  https://patchwork.ozlabs.org/patch/1253390/

Which I think does the same thing?

cheers

> diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
> index 577345382b23..d543fb6d29c5 100644
> --- a/arch/powerpc/kernel/prom_init.c
> +++ b/arch/powerpc/kernel/prom_init.c
> @@ -1773,6 +1773,9 @@ static void __init prom_rtas_os_term(char *str)
>  	if (token == 0)
>  		prom_panic("Could not get token for ibm,os-term\n");
>  	os_term_args.token = cpu_to_be32(token);
> +	os_term_args.nargs = cpu_to_be32(1);
> +	os_term_args.args[0] = cpu_to_be32(__pa(str));
> +
>  	prom_rtas_hcall((uint64_t)&os_term_args);
>  }
>  #endif /* CONFIG_PPC_SVM */
> -- 
> 2.23.0
