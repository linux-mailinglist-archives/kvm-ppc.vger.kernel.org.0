Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4211522DF88
	for <lists+kvm-ppc@lfdr.de>; Sun, 26 Jul 2020 15:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgGZNrV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 26 Jul 2020 09:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgGZNrV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 26 Jul 2020 09:47:21 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6922C0619D2
        for <kvm-ppc@vger.kernel.org>; Sun, 26 Jul 2020 06:47:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BF44P6nZFz9sPf;
        Sun, 26 Jul 2020 23:47:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1595771238;
        bh=q3BkqJblFZLbFVD43sGIBhbWqSe5Y3XVkMWMw/GH8xE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=VNyKa+oAomJJjyVxGTna1G9YsgIszk6k6EaVtNIq1sTb30u7Yg+RPLyIHDJO2CiQT
         jMt4K4SIA/K56C5RFftW1e0rZV0XPM/ctHyxpO/wEa3PsCapFW6K/snqXARQrkNIm4
         DdZsU87rrkoIBFw15LVWkrrM5BXBGiLtzKu/zG0cU9rLUevPf44Kop/4sFWlyDT7JP
         GkQPmrewkXeA0CgE9ztdLi1FrkPRHEM1A63Sy4ajJHnyaTTdmLWAE7pnoh9TWe3Da0
         KmBTrZbJmxZxMKQdqe+3jzLbhuCgXbf8deroZSscEvqzxWFwW9+pfCrmNuSHtIgXUu
         hDkPhkUFSFxng==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v3 1/3] powerpc: inline doorbell sending functions
In-Reply-To: <20200726035155.1424103-2-npiggin@gmail.com>
References: <20200726035155.1424103-1-npiggin@gmail.com> <20200726035155.1424103-2-npiggin@gmail.com>
Date:   Sun, 26 Jul 2020 23:47:16 +1000
Message-ID: <875zaagzh7.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:
> diff --git a/arch/powerpc/include/asm/dbell.h b/arch/powerpc/include/asm/dbell.h
> index 4ce6808deed3..1f04f3de96ba 100644
> --- a/arch/powerpc/include/asm/dbell.h
> +++ b/arch/powerpc/include/asm/dbell.h
> @@ -100,4 +102,63 @@ static inline void ppc_msgsnd(enum ppc_dbell type, u32 flags, u32 tag)
>  	_ppc_msgsnd(msg);
>  }
>  
> +#ifdef CONFIG_SMP
> +
> +/*
> + * Doorbells must only be used if CPU_FTR_DBELL is available.
> + * msgsnd is used in HV, and msgsndp is used in !HV.
> + *
> + * These should be used by platform code that is aware of restrictions.
> + * Other arch code should use ->cause_ipi.
> + *
> + * doorbell_global_ipi() sends a dbell to any target CPU.
> + * Must be used only by architectures that address msgsnd target
> + * by PIR/get_hard_smp_processor_id.
> + */
> +static inline void doorbell_global_ipi(int cpu)
> +{
> +	u32 tag = get_hard_smp_processor_id(cpu);
> +
> +	kvmppc_set_host_ipi(cpu);
> +	/* Order previous accesses vs. msgsnd, which is treated as a store */
> +	ppc_msgsnd_sync();
> +	ppc_msgsnd(PPC_DBELL_MSGTYPE, 0, tag);
> +}
> +
> +/*
> + * doorbell_core_ipi() sends a dbell to a target CPU in the same core.
> + * Must be used only by architectures that address msgsnd target
> + * by TIR/cpu_thread_in_core.
> + */
> +static inline void doorbell_core_ipi(int cpu)
> +{
> +	u32 tag = cpu_thread_in_core(cpu);

corenet64_smp_defconfig gives me:

  In file included from /linux/arch/powerpc/kernel/asm-offsets.c:38:
  /linux/arch/powerpc/include/asm/dbell.h: In function 'doorbell_core_ipi':
  /linux/arch/powerpc/include/asm/dbell.h:135:12: error: implicit declaration of function 'cpu_thread_in_core' [-Werror=implicit-function-declaration]
    135 |  u32 tag = cpu_thread_in_core(cpu);
        |            ^~~~~~~~~~~~~~~~~~


Fixed by including cputhreads.h, but then that results in errors due to
your addition of kvmppc_set_host_ipi().

Removing that gets us back to the fault_dear error.

I think I see a way around it, will do some build tests.

cheers
