Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B275B50A
	for <lists+kvm-ppc@lfdr.de>; Mon,  1 Jul 2019 08:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbfGAGbD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Jul 2019 02:31:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41122 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfGAGbD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Jul 2019 02:31:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id q4so4024902pgj.8
        for <kvm-ppc@vger.kernel.org>; Sun, 30 Jun 2019 23:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IjQwBjCAhzO/QrxPRbpKnAiaGj530gG6/spPVS2bWns=;
        b=ZwrXanjbID17D/EiZuxyJz9ujFjWmJ3qyaNVGOeK+zSgl/mTx+OUYWW3slwn453jXV
         GM/3ebyvyyvw+YN/PWlOnZyy7fNTgqTGyYLWD7E5cgLPAkhxSWMzksyJn3DS9oR03ZON
         IgLh9ssCaxFf/U/JwWSzHN2M+WzJoc2F3PDNuGaubTbKFOkIfNKMV/hplhuipj2nn/NZ
         aYHg4atVfwSv5UtUYdqfmciPa02/xKcTahjnGxiTwwaM65OJws1lQG1gmKlefs2fNmcW
         ZZnaud+oGMwYhtfG+N5sIMOy1am/zPtWGTEig5wm7f1Zy/92bjZn65OEQMxj6iocgbNk
         zo1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=IjQwBjCAhzO/QrxPRbpKnAiaGj530gG6/spPVS2bWns=;
        b=Lt89ep2fxts2X9gIoGUDQlMYW4o/b3XStvX816x+AzUO9YM6GcUTVwAk+KCJqP2pCI
         0muUx3lfsXsUEYKEdAeMLcSwNYAVoeMLRV82+dgTU/6M1Q4wK1Z5NhFpy5X1C0WICDd3
         4KdkPxvs6JPc8IjH7cKfsI//Q4SBf7lULm8b2HrbAITL99m2l9YEA6Fiwg0O58Zl8QSU
         s0uqYUcABP/OjUQRALK6AsD/ltFmGC11Gn6VA3nrN7KtcznfPgroBpDsJRjkmTrSYXf3
         0P8QyBzraA+Xs0ORrG9u0RLBDceRXAuNZx5HK+ZZ9yV8QNwygZPHDQ/GWZuLWvMrsuTT
         24zg==
X-Gm-Message-State: APjAAAXbBzT8wqKG451yJbCo2TGWHJiBbGlVrMETUW8hDmNRW98d6AWG
        AAOLZKYQ9FWSubPPJ/TnjWLHCw==
X-Google-Smtp-Source: APXvYqwK454k2s0eG1SR+Ihj8tTtX3YYD+aZpcof1pVhmvr6mhosSf43j+DLLOAGhzMnoQ6EAPUCkQ==
X-Received: by 2002:a63:4f46:: with SMTP id p6mr23709954pgl.268.1561962662230;
        Sun, 30 Jun 2019 23:31:02 -0700 (PDT)
Received: from [10.61.2.175] ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id n89sm24431278pjc.0.2019.06.30.23.30.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 23:31:01 -0700 (PDT)
Subject: Re: [PATCH v4 6/8] KVM: PPC: Ultravisor: Restrict LDBAR access
To:     maddy <maddy@linux.vnet.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-7-cclaudio@linux.ibm.com>
 <f153b6bf-4661-9dc0-c28f-076fc8fe598e@ozlabs.ru>
 <1e7f702a-c0cd-393d-934e-9e1a1234fe28@linux.vnet.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Openpgp: preference=signencrypt
Autocrypt: addr=aik@ozlabs.ru; keydata=
 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
Message-ID: <abe23edf-e593-ca98-8047-39ecb6cf16b5@ozlabs.ru>
Date:   Mon, 1 Jul 2019 16:30:55 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1e7f702a-c0cd-393d-934e-9e1a1234fe28@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 01/07/2019 16:17, maddy wrote:
> 
> On 01/07/19 11:24 AM, Alexey Kardashevskiy wrote:
>>
>> On 29/06/2019 06:08, Claudio Carvalho wrote:
>>> When the ultravisor firmware is available, it takes control over the
>>> LDBAR register. In this case, thread-imc updates and save/restore
>>> operations on the LDBAR register are handled by ultravisor.
>> What does LDBAR do? "Power ISA™ Version 3.0 B" or "User’s Manual POWER9
>> Processor" do not tell.
> LDBAR is a per-thread SPR used by thread-imc pmu to dump the counter
> data into memory.
> LDBAR contains memory address along with few other configuration bits
> (it is populated
> by the thread-imc pmu driver). It is populated and enabled only when any
> of the thread
> imc pmu events are monitored.


I was actually looking for a spec for this register, what is the
document name?


> 
> Maddy
>>
>>
>>> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
>>> Reviewed-by: Ram Pai <linuxram@us.ibm.com>
>>> Reviewed-by: Ryan Grimm <grimm@linux.ibm.com>
>>> Acked-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
>>> Acked-by: Paul Mackerras <paulus@ozlabs.org>
>>> ---
>>>   arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 2 ++
>>>   arch/powerpc/platforms/powernv/idle.c     | 6 ++++--
>>>   arch/powerpc/platforms/powernv/opal-imc.c | 4 ++++
>>>   3 files changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>>> b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>>> index f9b2620fbecd..cffb365d9d02 100644
>>> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>>> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>>> @@ -375,8 +375,10 @@ BEGIN_FTR_SECTION
>>>       mtspr    SPRN_RPR, r0
>>>       ld    r0, KVM_SPLIT_PMMAR(r6)
>>>       mtspr    SPRN_PMMAR, r0
>>> +BEGIN_FW_FTR_SECTION_NESTED(70)
>>>       ld    r0, KVM_SPLIT_LDBAR(r6)
>>>       mtspr    SPRN_LDBAR, r0
>>> +END_FW_FTR_SECTION_NESTED(FW_FEATURE_ULTRAVISOR, 0, 70)
>>>       isync
>>>   FTR_SECTION_ELSE
>>>       /* On P9 we use the split_info for coordinating LPCR changes */
>>> diff --git a/arch/powerpc/platforms/powernv/idle.c
>>> b/arch/powerpc/platforms/powernv/idle.c
>>> index 77f2e0a4ee37..5593a2d55959 100644
>>> --- a/arch/powerpc/platforms/powernv/idle.c
>>> +++ b/arch/powerpc/platforms/powernv/idle.c
>>> @@ -679,7 +679,8 @@ static unsigned long power9_idle_stop(unsigned
>>> long psscr, bool mmu_on)
>>>           sprs.ptcr    = mfspr(SPRN_PTCR);
>>>           sprs.rpr    = mfspr(SPRN_RPR);
>>>           sprs.tscr    = mfspr(SPRN_TSCR);
>>> -        sprs.ldbar    = mfspr(SPRN_LDBAR);
>>> +        if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
>>> +            sprs.ldbar    = mfspr(SPRN_LDBAR);
>>>             sprs_saved = true;
>>>   @@ -762,7 +763,8 @@ static unsigned long power9_idle_stop(unsigned
>>> long psscr, bool mmu_on)
>>>       mtspr(SPRN_PTCR,    sprs.ptcr);
>>>       mtspr(SPRN_RPR,        sprs.rpr);
>>>       mtspr(SPRN_TSCR,    sprs.tscr);
>>> -    mtspr(SPRN_LDBAR,    sprs.ldbar);
>>> +    if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
>>> +        mtspr(SPRN_LDBAR,    sprs.ldbar);
>>>         if (pls >= pnv_first_tb_loss_level) {
>>>           /* TB loss */
>>> diff --git a/arch/powerpc/platforms/powernv/opal-imc.c
>>> b/arch/powerpc/platforms/powernv/opal-imc.c
>>> index 1b6932890a73..5fe2d4526cbc 100644
>>> --- a/arch/powerpc/platforms/powernv/opal-imc.c
>>> +++ b/arch/powerpc/platforms/powernv/opal-imc.c
>>> @@ -254,6 +254,10 @@ static int opal_imc_counters_probe(struct
>>> platform_device *pdev)
>>>       bool core_imc_reg = false, thread_imc_reg = false;
>>>       u32 type;
>>>   +    /* Disable IMC devices, when Ultravisor is enabled. */
>>> +    if (firmware_has_feature(FW_FEATURE_ULTRAVISOR))
>>> +        return -EACCES;
>>> +
>>>       /*
>>>        * Check whether this is kdump kernel. If yes, force the
>>> engines to
>>>        * stop and return.
>>>
> 

-- 
Alexey
