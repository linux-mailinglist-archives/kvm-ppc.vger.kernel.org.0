Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65496318B76
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Feb 2021 14:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhBKNE2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Feb 2021 08:04:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231447AbhBKNBk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Feb 2021 08:01:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613048413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=INAHfmtIEGnguojwVLsOWi/AuzVJ2a1LEBIEt+WJHHk=;
        b=BMYQljX4yar9e+Ot+wTfDVjzVw0msmiQCwrq8H93rmwWoJ01IXJ3/td4Vy83MOuubQNRrd
        6W+IynML4AZLyi7HeevZnTRT10qBbhYkTEVUoq9gCfhobtXQwuzOytknlg1s/l/8aaGHBx
        gQCfu/nVXGfNkwMOOWHAOuN1mksIpoM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-Fgbb8x9xPGW5unzNWaieoA-1; Thu, 11 Feb 2021 08:00:12 -0500
X-MC-Unique: Fgbb8x9xPGW5unzNWaieoA-1
Received: by mail-wr1-f69.google.com with SMTP id c1so2476684wrx.2
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Feb 2021 05:00:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=INAHfmtIEGnguojwVLsOWi/AuzVJ2a1LEBIEt+WJHHk=;
        b=g9RU/fde3WA+OW5VUPvEmiHOyf9nDBRlIaDeNRqCnKHzbllTINzf06r1jxqe1BJ2bY
         94A9AT9ukaH3epoMzzQ63ALVS/QpGanihjq7fp5X3AdR7UJO6gkNaTik/05i32p1/kpM
         UwXegc5TrF65OEG6CbYlrJqdPUgQSuEqlFhohdudR9tPC6/XkW/d3Qv8dQl08NB6D//S
         /s8GgAxCUZgeR6PR8LYQKpcOzu4FbKl3G/97u6s/XMNy+1O831l2C64FxMS0F9AovIEA
         ytPh52dy0UmI454gHB+s40Ise29fhvLc0tAbhl8szOIBBwwLZGu89keSkFUHCX/6r4a9
         opKA==
X-Gm-Message-State: AOAM5310lT7Z84G2h3HkhsmdIo0iSBIjVrMV9AsXWIbDAHrnoPM2jZ9/
        Dx90SjhUx7iAaw3ADV58KpoiAyH+V0X7DwvLSBFQSDqLlizNX4nvnOp/sDJDOtELXeCLDOnhmzG
        wPOYPhGXokDhRSntxLukE3V+gppkuPsPKs9cCLcwp0eQIUTJkb3SzZ4koYALjGEB0eRLFag==
X-Received: by 2002:adf:e511:: with SMTP id j17mr5785513wrm.251.1613048410494;
        Thu, 11 Feb 2021 05:00:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxSWnA3HIAAlozOKrW4ge/Bh5KEzG9RkV/rrmUb/VthvmslA6Ibdmm0IEfbmO9Msm3VsJ7Bvw==
X-Received: by 2002:adf:e511:: with SMTP id j17mr5785473wrm.251.1613048410203;
        Thu, 11 Feb 2021 05:00:10 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j40sm9058088wmp.47.2021.02.11.05.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 05:00:09 -0800 (PST)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.12-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20210211072553.GA2877131@thinks.paulus.ozlabs.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eb082e35-e202-633d-d3e1-8a2eafcda68d@redhat.com>
Date:   Thu, 11 Feb 2021 14:00:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210211072553.GA2877131@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 11/02/21 08:25, Paul Mackerras wrote:
> Paolo,
> 
> Please do a pull from my kvm-ppc-next-5.12-1 tag to get a PPC KVM
> update for 5.12.  This one is quite small, with just one new feature,
> support for the second data watchpoint in POWER10.
> 
> Thanks,
> Paul.
> 
> The following changes since commit 9294b8a12585f8b4ccb9c060b54bab0bd13f24b9:
> 
>    Documentation: kvm: fix warning (2021-02-09 08:42:10 -0500)
> 
> are available in the git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.12-1
> 
> for you to fetch changes up to 72476aaa469179222b92c380de60c76b4cb9a318:
> 
>    KVM: PPC: Book3S HV: Fix host radix SLB optimisation with hash guests (2021-02-11 17:28:15 +1100)
> 
> ----------------------------------------------------------------
> PPC KVM update for 5.12
> 
> - Support for second data watchpoint on POWER10, from Ravi Bangoria
> - Remove some complex workarounds for buggy early versions of POWER9
> - Guest entry/exit fixes from Nick Piggin and Fabiano Rosas
> 
> ----------------------------------------------------------------
> Fabiano Rosas (2):
>        KVM: PPC: Book3S HV: Save and restore FSCR in the P9 path
>        KVM: PPC: Don't always report hash MMU capability for P9 < DD2.2
> 
> Nicholas Piggin (5):
>        KVM: PPC: Book3S HV: Remove support for running HPT guest on RPT host without mixed mode support
>        KVM: PPC: Book3S HV: Fix radix guest SLB side channel
>        KVM: PPC: Book3S HV: No need to clear radix host SLB before loading HPT guest
>        KVM: PPC: Book3S HV: Use POWER9 SLBIA IH=6 variant to clear SLB
>        KVM: PPC: Book3S HV: Fix host radix SLB optimisation with hash guests
> 
> Paul Mackerras (1):
>        KVM: PPC: Book3S HV: Ensure radix guest has no SLB entries
> 
> Ravi Bangoria (4):
>        KVM: PPC: Book3S HV: Allow nested guest creation when L0 hv_guest_state > L1
>        KVM: PPC: Book3S HV: Rename current DAWR macros and variables
>        KVM: PPC: Book3S HV: Add infrastructure to support 2nd DAWR
>        KVM: PPC: Book3S HV: Introduce new capability for 2nd DAWR
> 
> Yang Li (1):
>        KVM: PPC: remove unneeded semicolon
> 
>   Documentation/virt/kvm/api.rst            |  12 ++
>   arch/powerpc/include/asm/hvcall.h         |  25 ++++-
>   arch/powerpc/include/asm/kvm_book3s_asm.h |  11 --
>   arch/powerpc/include/asm/kvm_host.h       |   7 +-
>   arch/powerpc/include/asm/kvm_ppc.h        |   2 +
>   arch/powerpc/include/uapi/asm/kvm.h       |   2 +
>   arch/powerpc/kernel/asm-offsets.c         |   9 +-
>   arch/powerpc/kvm/book3s_hv.c              | 149 +++++++++++++++----------
>   arch/powerpc/kvm/book3s_hv_builtin.c      | 108 +-----------------
>   arch/powerpc/kvm/book3s_hv_nested.c       |  70 +++++++++---
>   arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 175 ++++++++++++++++--------------
>   arch/powerpc/kvm/booke.c                  |   2 +-
>   arch/powerpc/kvm/powerpc.c                |  14 ++-
>   include/uapi/linux/kvm.h                  |   1 +
>   tools/arch/powerpc/include/uapi/asm/kvm.h |   2 +
>   tools/include/uapi/linux/kvm.h            |   1 +
>   16 files changed, 309 insertions(+), 281 deletions(-)
> 

Pulled, thanks.

Paolo

