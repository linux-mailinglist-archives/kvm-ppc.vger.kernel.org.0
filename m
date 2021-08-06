Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173133E28A2
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Aug 2021 12:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245080AbhHFKdD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 Aug 2021 06:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245115AbhHFKdC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 6 Aug 2021 06:33:02 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2D1C061798
        for <kvm-ppc@vger.kernel.org>; Fri,  6 Aug 2021 03:32:46 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j3so6489390plx.4
        for <kvm-ppc@vger.kernel.org>; Fri, 06 Aug 2021 03:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=FY9wGttQOvoswk4T19oVTWVLvt0qApUxTXdsanwYGM4=;
        b=udTY6LYcGvag50UNK8icCVl2/hUtd+ibX7PRLRDjYmiSDsPcw5IV1b46Do9sUSubWr
         xivqS+R0ePIp2Yy6YuFdaIl7TPesFQsUMxYl3RX5tFT6CpS2q+VcCxDuP533HwUIjofq
         8DocgNH4UShWtP2aMAPacVrQJhvK80dpsEfyo+eINmem4kV8qxctoKKaT/B7OR7iTNQa
         KfCVeAJ1Bf0kSnGE1a5/Slt50M5+wq8x6DTiVaM7Q8Qj70FJK8BneYdAw9OLc0eASY1j
         DeSLQJGsaJ78IzuInVFqRwxsMrlsObSEJFENE1z5IN/YjlpwT4vdSM9ofhaYtYgbv2eG
         0G8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=FY9wGttQOvoswk4T19oVTWVLvt0qApUxTXdsanwYGM4=;
        b=n0yIZrcCHwPQee7TBVj2y5DWwexM7Ct7AE6NpIVkFb0Ix2+W9nMLew6imwaye9ULmI
         zAeW9nXzux4cGNWc0lOq/O1PDHChoKjMgBN5YNvifF47v4nmu8M2zsFHAEA6UmeKd/EK
         fLRlSRkKM8134IA7e/TJOBZRtBciw9Aq9kOw2KeSimmhQPFQAzZATBUPlnBoZ4asGPg0
         QY4QVdagCcFWDksyEY+zKt+Ilmgd1vJkMNTPxWmqN7Rn3Dq6IN/G/E4Kcdxc5rWmpzuu
         6SMv1PXwQZrD/HFtxBF8iXL8Mf7qQzpGp/O8+QsllykWS+6xJX6RSZoMuV6lZmRdTOp7
         ANCQ==
X-Gm-Message-State: AOAM533X59SCbyD6OP1u2TxtJuBf4k69PUQlexP3orCoE9h7B3HM7TOg
        QjDY11bcsH+mxBUxUosk9zf/RSD5MWs=
X-Google-Smtp-Source: ABdhPJyy5l8Ku5yxRyZJNOY07SANGOLCpqkmGWuYVEauPmOHmjBl7NFXhsGcgNp6PAuCWBC2NB+xzQ==
X-Received: by 2002:a17:90a:e38b:: with SMTP id b11mr9806787pjz.70.1628245965861;
        Fri, 06 Aug 2021 03:32:45 -0700 (PDT)
Received: from localhost ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id 20sm12630150pgg.36.2021.08.06.03.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 03:32:45 -0700 (PDT)
Date:   Fri, 06 Aug 2021 20:32:40 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v1 14/55] KVM: PPC: Book3S HV: Don't always save PMU for
 guest capable of nesting
To:     kvm-ppc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210726035036.739609-1-npiggin@gmail.com>
        <20210726035036.739609-15-npiggin@gmail.com>
        <871r77ni1g.fsf@mpe.ellerman.id.au>
In-Reply-To: <871r77ni1g.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Message-Id: <1628245856.8cocc7zj8u.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Michael Ellerman's message of August 6, 2021 5:34 pm:
> Nicholas Piggin <npiggin@gmail.com> writes:
>> Revert the workaround added by commit 63279eeb7f93a ("KVM: PPC: Book3S
>> HV: Always save guest pmu for guest capable of nesting").
>>
>> Nested capable guests running with the earlier commit ("KVM: PPC: Book3S
>> HV Nested: Indicate guest PMU in-use in VPA") will now indicate the PMU
>> in-use status of their guests, which means the parent does not need to
>> unconditionally save the PMU for nested capable guests.
>>
>> This will cause the PMU to break for nested guests when running older
>> nested hypervisor guests under a kernel with this change. It's unclear
>> there's an easy way to avoid that, so this could wait for a release or
>> so for the fix to filter into stable kernels.
>=20
> I'm not sure PMU inside nested guests is getting much use, but I don't
> think we can break this quite so casually :)
>=20
> Especially as the failure mode will be PMU counts that don't match
> reality, which is hard to diagnose. It took nearly a year for us to find
> the original bug.
>=20
> I think we need to hold this back for a while.
>=20
> We could put it under a CONFIG option, and then flip that option to off
> at some point in the future.

Okay that might be a good compromise, I'll do that.

Thanks,
Nick
