Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8FE343767
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 04:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCVD1W (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 21 Mar 2021 23:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCVD1Q (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 21 Mar 2021 23:27:16 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FFBC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 20:27:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so9700534pjc.2
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 20:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=G/MrW95o3wTpkGn3xBSw1QV9Ky7pWJ39YmqwrFHA0kE=;
        b=YrsobDmXdbZYfK5pANFSFVISLsbol5RaLwiqY0BID97Issa2mmCzMfqj53xQS6bou/
         iH9xlStOPyRd7f6ikx9I/AquNTaARyWwYC+XTj0tq6Ya0+/pgSpWC77C2BD+0awvA6+b
         EsNKg11DKqIAxQFXafnzKbWH9NZ4S/zehUe6QgcHxHsqZ27aXAd/kzK+Sylg9av0FECQ
         HLbGRJ5aLoIjXWsNjeMlKdPtOfw82nJ5wih987tH1HaEvVl0GVP/c/2IhRYIOYIfEWsi
         4Zd+snqGn+9bhNd4qgnYocVHASI7yZRi8/qw0/nfjRLIqyAUHSXiBRn9WuQgbKJIzlv/
         D90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=G/MrW95o3wTpkGn3xBSw1QV9Ky7pWJ39YmqwrFHA0kE=;
        b=ilAjlP3dDuU1wbZYybYsll++IgD4Zv0Dj3AxQ9Hh03O0H/B+gb2fgHqk0/VPdenieu
         Jm6QVG5JCz10Ezh3EvlLdcZPdoOE52Ac+FqpCA9bJN4cFEwj8PKNxU5C80/TIIDa3z8T
         HsRdOqS/ZXNX4FMrPsIFqH9mIWl2dOpcsnWvQPQprwuB8fj+WAi++fpwmYTtm9lYCQ+A
         Bme1FV9m6EHZFY3BgRulqmumrj27w/MEmYwudvCyojFCLKCwBYPoSuin2ovWBN25wOzL
         vSHXt211YPdYQesYWXe92/3TSRcdOHZD0n3akifwEuXb/8mVF21Rj7otMKjYzCWmf7BL
         mCpw==
X-Gm-Message-State: AOAM5306uENjNJDJ+Y4O6PKzQ0bWaRqnv2bzMMM8w6aLCW39cC9RwhvP
        rKbPgU+BbLQ1M1vdxM4aWbU=
X-Google-Smtp-Source: ABdhPJyI7hkhuRRyFmuikHycx7qL5FUFckW3Lw//9yrzFtlVzh49hYOs3AVH4Qs9Ug7hl9htoZh8Bg==
X-Received: by 2002:a17:902:c382:b029:e4:7015:b646 with SMTP id g2-20020a170902c382b02900e47015b646mr25634069plg.83.1616383635752;
        Sun, 21 Mar 2021 20:27:15 -0700 (PDT)
Received: from localhost ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id gz4sm12631722pjb.0.2021.03.21.20.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 20:27:15 -0700 (PDT)
Date:   Mon, 22 Mar 2021 13:27:09 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 34/41] KVM: PPC: Book3S HV: Remove support for
 dependent threads mode on P9
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
        <20210305150638.2675513-35-npiggin@gmail.com> <87ft0tzug8.fsf@linux.ibm.com>
In-Reply-To: <87ft0tzug8.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1616383211.2tllx3llud.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Aneesh Kumar K.V's message of March 18, 2021 1:11 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> Radix guest support will be removed from the P7/8 path, so disallow
>> dependent threads mode on P9.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/include/asm/kvm_host.h |  1 -
>>  arch/powerpc/kvm/book3s_hv.c        | 27 +++++----------------------
>>  2 files changed, 5 insertions(+), 23 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/=
asm/kvm_host.h
>> index 05fb00d37609..dd017dfa4e65 100644
>> --- a/arch/powerpc/include/asm/kvm_host.h
>> +++ b/arch/powerpc/include/asm/kvm_host.h
>> @@ -304,7 +304,6 @@ struct kvm_arch {
>>  	u8 fwnmi_enabled;
>>  	u8 secure_guest;
>>  	u8 svm_enabled;
>> -	bool threads_indep;
>>  	bool nested_enable;
>>  	bool dawr1_enabled;
>>  	pgd_t *pgtable;
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index cb428e2f7140..928ed8180d9d 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -103,13 +103,9 @@ static int target_smt_mode;
>>  module_param(target_smt_mode, int, 0644);
>>  MODULE_PARM_DESC(target_smt_mode, "Target threads per core (0 =3D max)"=
);
>> =20
>> -static bool indep_threads_mode =3D true;
>> -module_param(indep_threads_mode, bool, S_IRUGO | S_IWUSR);
>> -MODULE_PARM_DESC(indep_threads_mode, "Independent-threads mode (only on=
 POWER9)");
>> -
>>  static bool one_vm_per_core;
>>  module_param(one_vm_per_core, bool, S_IRUGO | S_IWUSR);
>> -MODULE_PARM_DESC(one_vm_per_core, "Only run vCPUs from the same VM on a=
 core (requires indep_threads_mode=3DN)");
>> +MODULE_PARM_DESC(one_vm_per_core, "Only run vCPUs from the same VM on a=
 core (requires POWER8 or older)");
>=20
> Isn't this also a security feature, where there was an ask to make sure
> threads/vCPU from other VM won't run on this core? In that context isn't
> this applicable also for P9?

I'm not sure about an ask, but it is a possible security feature that=20
would be relevant to all SMT CPUs running KVM guests.

It doesn't make much sense to plumb P9 support all through the P8 path=20
just for that though, in my opinion? Is it tested? Who uses it? It's
lacking features of the P9 path.

It would be better added to KVM/QEMU in general (or until that is=20
available, disable SMT, or use CPU pinning and isolcpus to prevent host=20
code running on secondaries, and isolating VMs from one another, etc).

I think it's quite possible to rendezvous threads in kernel, move them
onto the threads of a core, and then have them all running in KVM code=20
before they enter the guest, without disabling SMT in the host.

You could do it with kernel threads on the secondaries even, but I=20
wouldn't like to have to plumb the vcore concept entirely through=20
everywhere so I would actually prefer to see QEMU grow an understanding=20
of it so it would know it has to call the ioctl on every guest SMT=20
thread.

Thanks,
Nick
