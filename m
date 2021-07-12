Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648193C414F
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Jul 2021 04:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGLCwW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Jul 2021 22:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLCwW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Jul 2021 22:52:22 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D973FC0613DD
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Jul 2021 19:49:33 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bt15so4187109pjb.2
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Jul 2021 19:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=SNO1KimycIzKpt5Apyoty4HeLUuDV+TjJEXeIogdbvE=;
        b=BKehAuhbcq54ppez/+TFzzsO+x1UFuoOgwS4+TBBBQ7jrSHYIHtgzVCwGFmneIWEk/
         4QrK6KtcusgWU3EBbm58/5+ogKMvRzhys+xT2CJnkXqIUuyoR/5zkIW4mq0Om3tHYUzl
         /BKwzPirkhh5C8OATGbeMB+wCPUv8DEAYGAIVajB8FhBLjqQlpzhWHw30KcFjuWTCisZ
         4jxNOI48saYRCTPXwDZe91E1Yc8ew6g2MGjMCVtsjPzhLP1wzDS8pYCobEJbOf5qCECt
         zfEhzGcsTq9yvglEHYJ1K4utKer0z1tVuguaxGP+2pQe9rNT8ynxPVRkU/WWXUVMuCB2
         ugQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=SNO1KimycIzKpt5Apyoty4HeLUuDV+TjJEXeIogdbvE=;
        b=HnrdpXUCsEC2GDnGkBkklxn9kbr+ngo9ikKNA9e/vKDdVUmrgUWeca6taKpMtRJl/9
         Hwyib6PwLSJkD3hVjnOGAUWYlO6fC6HUXvEsXi3SHB+mmS7YMCyX7van2l2JBDyNNWxM
         x+4FeAv362wwSq9pI6cHyoziAPHfWV4ZjjJ1C7S9G5A6SQRF18MCZLyK7CjYH9Sk9wZ7
         MdcSoJ/wr+OCDxFgW6l51OQv1YNatBtmCM8dWPcR7r4PebV3CBtpvhnWxooq9IiLXRHR
         UCZflmbF615LaHzVsnTKe6B7RiU1Ic43jOts7vVJ9823pN693fnCpbld7iABdmKBREhI
         XamA==
X-Gm-Message-State: AOAM530d3DT8ajAkjFgD+OwfJj1mSTC5YIAacv/fnZprSWw8/5Q2kSv+
        XTaj1eWFqpvU7Df4yIFQPiM=
X-Google-Smtp-Source: ABdhPJwpBi7gJS3g4qVNqz79SV6nITfMUOcG/gU7gdW5uwHe0FPJdsAq0kTFwM/IZodoSsYOc6Z6yg==
X-Received: by 2002:a17:90a:b28a:: with SMTP id c10mr11641822pjr.59.1626058173348;
        Sun, 11 Jul 2021 19:49:33 -0700 (PDT)
Received: from localhost (203-219-181-43.static.tpgi.com.au. [203.219.181.43])
        by smtp.gmail.com with ESMTPSA id x40sm531402pfu.176.2021.07.11.19.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 19:49:32 -0700 (PDT)
Date:   Mon, 12 Jul 2021 12:49:28 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 11/43] KVM: PPC: Book3S HV P9: Implement PMU
 save/restore in C
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210622105736.633352-1-npiggin@gmail.com>
        <20210622105736.633352-12-npiggin@gmail.com>
        <A647F37A-F32C-46B7-8A2E-C4D7CDB012E3@linux.vnet.ibm.com>
In-Reply-To: <A647F37A-F32C-46B7-8A2E-C4D7CDB012E3@linux.vnet.ibm.com>
MIME-Version: 1.0
Message-Id: <1626057686.aeolnlaqjr.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Athira Rajeev's message of July 10, 2021 12:47 pm:
>=20
>=20
>> On 22-Jun-2021, at 4:27 PM, Nicholas Piggin <npiggin@gmail.com> wrote:
>>=20
>> Implement the P9 path PMU save/restore code in C, and remove the
>> POWER9/10 code from the P7/8 path assembly.
>>=20
>> -449 cycles (8533) POWER9 virt-mode NULL hcall
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>> arch/powerpc/include/asm/asm-prototypes.h |   5 -
>> arch/powerpc/kvm/book3s_hv.c              | 205 ++++++++++++++++++++--
>> arch/powerpc/kvm/book3s_hv_interrupts.S   |  13 +-
>> arch/powerpc/kvm/book3s_hv_rmhandlers.S   |  43 +----
>> 4 files changed, 200 insertions(+), 66 deletions(-)
>>=20
>> diff --git a/arch/powerpc/include/asm/asm-prototypes.h b/arch/powerpc/in=
clude/asm/asm-prototypes.h
>> index 02ee6f5ac9fe..928db8ef9a5a 100644
>> --- a/arch/powerpc/include/asm/asm-prototypes.h
>> +++ b/arch/powerpc/include/asm/asm-prototypes.h
>> @@ -136,11 +136,6 @@ static inline void kvmppc_restore_tm_hv(struct kvm_=
vcpu *vcpu, u64 msr,
>> 					bool preserve_nv) { }
>> #endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
>>=20
>> -void kvmhv_save_host_pmu(void);
>> -void kvmhv_load_host_pmu(void);
>> -void kvmhv_save_guest_pmu(struct kvm_vcpu *vcpu, bool pmu_in_use);
>> -void kvmhv_load_guest_pmu(struct kvm_vcpu *vcpu);
>> -
>> void kvmppc_p9_enter_guest(struct kvm_vcpu *vcpu);
>>=20
>> long kvmppc_h_set_dabr(struct kvm_vcpu *vcpu, unsigned long dabr);
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index f7349d150828..b1b94b3563b7 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -3635,6 +3635,188 @@ static noinline void kvmppc_run_core(struct kvmp=
pc_vcore *vc)
>> 	trace_kvmppc_run_core(vc, 1);
>> }
>>=20
>> +/*
>> + * Privileged (non-hypervisor) host registers to save.
>> + */
>> +struct p9_host_os_sprs {
>> +	unsigned long dscr;
>> +	unsigned long tidr;
>> +	unsigned long iamr;
>> +	unsigned long amr;
>> +	unsigned long fscr;
>> +
>> +	unsigned int pmc1;
>> +	unsigned int pmc2;
>> +	unsigned int pmc3;
>> +	unsigned int pmc4;
>> +	unsigned int pmc5;
>> +	unsigned int pmc6;
>> +	unsigned long mmcr0;
>> +	unsigned long mmcr1;
>> +	unsigned long mmcr2;
>> +	unsigned long mmcr3;
>> +	unsigned long mmcra;
>> +	unsigned long siar;
>> +	unsigned long sier1;
>> +	unsigned long sier2;
>> +	unsigned long sier3;
>> +	unsigned long sdar;
>> +};
>> +
>> +static void freeze_pmu(unsigned long mmcr0, unsigned long mmcra)
>> +{
>> +	if (!(mmcr0 & MMCR0_FC))
>> +		goto do_freeze;
>> +	if (mmcra & MMCRA_SAMPLE_ENABLE)
>> +		goto do_freeze;
>> +	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>> +		if (!(mmcr0 & MMCR0_PMCCEXT))
>> +			goto do_freeze;
>> +		if (!(mmcra & MMCRA_BHRB_DISABLE))
>> +			goto do_freeze;
>> +	}
>> +	return;
>=20
>=20
> Hi Nick
>=20
> When freezing the PMU, do we need to also set pmcregs_in_use to zero ?

Not immediately, we still need to save out the values of the PMU=20
registers. If we clear pmcregs_in_use, then our hypervisor can discard=20
the contents of those registers at any time.

> Also, why we need these above conditions like MMCRA_SAMPLE_ENABLE,  MMCR0=
_PMCCEXT checks also before freezing ?

Basically just because that's the condition we wnat to set the PMU to=20
before entering the guest if the guest does not have its own PMU=20
registers in use.

I'm not entirely sure this is correct / optimal for perf though, so we
should double check that. I think some of this stuff should be wrapped=20
up and put into perf/ subdirectory as I've said before. KVM shouldn't=20
need to know about exactly how PMU is to be set up and managed by
perf, we should just be able to ask perf to save/restore/switch state.

Thanks,
Nick
