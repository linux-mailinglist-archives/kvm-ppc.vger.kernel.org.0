Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C90345BBE
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 11:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCWKNY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 06:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCWKNR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 06:13:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B67C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 03:13:17 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id w8so9868545pjf.4
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 03:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=S0VXCg+nlzBozrdWHXgTNulRU5+BlACmvhzlexa5ah8=;
        b=MqCkGTz40Bz/d4qLMARgRqU1nV/4StH8XiyPZEAUr/RQZG5lkVX2RmS3LgykzG70Ug
         IocoZD2rifEiFsAWdKpE989Ee1TlxCMIXDCVylJrw169vOvrQaLOjTob1l/I3wzg7q/b
         Pl8t+waZGyOwrosjJfXFkOC2aS8+9L/3MNexdzFzjYZV/tNTokRREGSTdG7hS7rzB0wK
         EJf5frdhAM2v4lpvkglfsQN+CRLjunlNwE6IbUufScfhIvoHBVfxIF21Rpk1XoGXzRSN
         VtHE+I5PeQBzUJnkHGYlwQPDDGBM8Bgcthp0WytoWAQEl5TEbbbeoG1932UvPBGrSHon
         mu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S0VXCg+nlzBozrdWHXgTNulRU5+BlACmvhzlexa5ah8=;
        b=uH6tA10/qcxexiTE9Juq8c9CK9LZI7psIu6QDkp5wk5o+VILoApiV/UV76/lwNNAil
         SgWldzvU9tIIsk1CLDdnKkSwFVkkFHhVpSjiIsf6fheC/pwS8pn9eV9GdqdaVysDtem/
         6fiJcmlZWE1ZxDEjR6H4HEgxVNdYWGyI9fO71hauzIpIPGOJ+/9wuh3VZbLzALKRleau
         4+/eGmvG5bBt6RC8McsY6mjMlinRkqynv/HhVLzytXEB9jbVuflR5SqleE2cfoJFEgxY
         VvHjvzQAZkOerhNH3XOA6FqQfWIU8FwQKe0KNjIJurrZcMdPhC6/tCCnynxJCB8eP8wt
         dhBA==
X-Gm-Message-State: AOAM5327CxkmVNqcJo7cTz6/C01qkvHCigXvqoa+1ovPp3wChkhUtxzD
        QPSAp3k65rPabczwLOKMkS1F7g==
X-Google-Smtp-Source: ABdhPJze4HUPAcXMoEk5PkqyXQzhctwqxPR2w4c2vUnIWIqZAwgYV1xsV8DH8J/nVKtG8Bw/NpX9Nw==
X-Received: by 2002:a17:90b:903:: with SMTP id bo3mr3949176pjb.198.1616494396659;
        Tue, 23 Mar 2021 03:13:16 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id x4sm15730543pfn.134.2021.03.23.03.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 03:13:16 -0700 (PDT)
Message-ID: <3ca0e504-70df-2a25-12af-a1addac842b6@ozlabs.ru>
Date:   Tue, 23 Mar 2021 21:13:12 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v4 28/46] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest
 decrementer races
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-29-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210323010305.1045293-29-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 23/03/2021 12:02, Nicholas Piggin wrote:
> irq_work's use of the DEC SPR is racy with guest<->host switch and guest
> entry which flips the DEC interrupt to guest, which could lose a host
> work interrupt.
> 
> This patch closes one race, and attempts to comment another class of
> races.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   arch/powerpc/kvm/book3s_hv.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 1f38a0abc611..989a1ff5ad11 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3745,6 +3745,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>   	if (!(vcpu->arch.ctrl & 1))
>   		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
>   
> +	/*
> +	 * When setting DEC, we must always deal with irq_work_raise via NMI vs
> +	 * setting DEC. The problem occurs right as we switch into guest mode
> +	 * if a NMI hits and sets pending work and sets DEC, then that will
> +	 * apply to the guest and not bring us back to the host.
> +	 *
> +	 * irq_work_raise could check a flag (or possibly LPCR[HDICE] for
> +	 * example) and set HDEC to 1? That wouldn't solve the nested hv
> +	 * case which needs to abort the hcall or zero the time limit.
> +	 *
> +	 * XXX: Another day's problem.
> +	 */
>   	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
>   
>   	if (kvmhv_on_pseries()) {
> @@ -3879,7 +3891,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>   	vc->entry_exit_map = 0x101;
>   	vc->in_guest = 0;
>   
> -	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
> +	set_dec_or_work(local_paca->kvm_hstate.dec_expires - tb);


set_dec_or_work() will write local_paca->kvm_hstate.dec_expires - tb - 1 
to SPRN_DEC which is not exactly the same, is this still alright?

I asked in v3 but it is probably lost :)

> +
>   	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
>   
>   	kvmhv_load_host_pmu();
> 

-- 
Alexey
