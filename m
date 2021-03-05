Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48BE32E0DC
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 05:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhCEEvE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Mar 2021 23:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEEvE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Mar 2021 23:51:04 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7293FC061574
        for <kvm-ppc@vger.kernel.org>; Thu,  4 Mar 2021 20:51:03 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so1585518pjb.1
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Mar 2021 20:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=cHJA7XXCkOA4RpRrDF/FKM/MmiWjavpSM2NvYG4D2wQ=;
        b=Xo/K8eOmuSXEX1HyZoNj7cXac1Emjbumjpe9gAquyuxsVXJ2Whi9gtRLWPg4gvifQn
         0V0G8rgX0kPR9j8EvPd/9g5n4vdNr24AN99H1GUsi0BWzOYyT/kTx5/q2JJywGY7jmdC
         wnuwqCK5JTAUlry1fzBzApKrau701fhKxTL7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cHJA7XXCkOA4RpRrDF/FKM/MmiWjavpSM2NvYG4D2wQ=;
        b=sFQ/MNhRLYd6gGMmCd4rvf1mzU3dvnJncAoLtS90gKvkt6baxgHdSAXesKxE0FoXtf
         Tq0omK+Lb2Fbus7w+pNNIyS+asbbSWnLOfJ5bOt23xCJcDKipo8r357B6JgGOI70/+CV
         nE0wn3D50baiYjp55RHl1A1xmN5NTSYTLb9Ss4nET9Wr96nLnLWZK6MBJ/i5x9k/Agil
         wuBNK16jntR0tEd3sc8jWX19TmQ9MT6lVZOqnyroMLWZSKcaSXZ81EKVvCYUvv1HgYPE
         h4tU1vgH8he8P9uTEj5iI3nGZx3S4Z7RBcbbYusCO7oQAE4lD5ViDe3e4tGVdwGn4gBG
         kJAQ==
X-Gm-Message-State: AOAM5322vQHI1TrwALPqKMOdAgVpFn7gHTHaeS6pUKTNRDYbHUOJpv9B
        Tj3OUYXZUjmCXAdEeuYrSOEC+Q==
X-Google-Smtp-Source: ABdhPJzUYGpICJTnnsHgEKR9D838ntdPons8hBy3Dwiz2M3cJDcCF9au2GZdK60Bf4RJP+UKuYwHlw==
X-Received: by 2002:a17:90a:4a93:: with SMTP id f19mr8228810pjh.41.1614919863016;
        Thu, 04 Mar 2021 20:51:03 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id p8sm914342pff.79.2021.03.04.20.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:51:02 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 05/37] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
In-Reply-To: <1614383549.rxe6rxw7w8.astroid@bobo.none>
References: <20210225134652.2127648-1-npiggin@gmail.com> <20210225134652.2127648-6-npiggin@gmail.com> <87zgzr8is2.fsf@linkitivity.dja.id.au> <1614383549.rxe6rxw7w8.astroid@bobo.none>
Date:   Fri, 05 Mar 2021 15:50:59 +1100
Message-ID: <87tupq8aq4.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

>> This 'if' is technically redundant but you mention a future patch warning
>> on !(msr & MSR_ME) so I'm holding off on any judgement about the 'if' until
>> I get to that patch :)
>
> That's true. The warning is actually further down when we're setting up 
> the msr to run in guest mode. At this point the MSR I think comes from
> qemu (and arguably the guest setup code shouldn't need to know about HV
> specific MSR bits) so a warning here wouldn't be appropriate.
>
> I could remove the if, although the compiler might already do that.

Yes, I think the compiler is almost certainly going to remove that.

I'd probably not include the 'if' statement even though it probably gets
removed by the compiler but I think that's more a matter of taste than
anything else.

Kind regards,
Daniel

>
>> 
>> The patch seems sane to me, I agree that we don't want guests running with
>> MSR_ME=0 and kvmppc_set_msr_hv already ensures that the transactional state is
>> sane so this is another sanity-enforcement in the same sort of vein.
>> 
>> All up:
>> Reviewed-by: Daniel Axtens <dja@axtens.net>
>
> Thanks,
> Nick
