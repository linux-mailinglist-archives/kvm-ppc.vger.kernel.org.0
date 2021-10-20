Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A8D4344AA
	for <lists+kvm-ppc@lfdr.de>; Wed, 20 Oct 2021 07:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhJTF2y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 20 Oct 2021 01:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhJTF2y (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 20 Oct 2021 01:28:54 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A5DC06161C
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Oct 2021 22:26:40 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o133so1939445pfg.7
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Oct 2021 22:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:references:in-reply-to:mime-version:message-id
         :content-transfer-encoding;
        bh=6qWZfrGs7oeJrH8rUBe+od/K5rWX/np8V/rd+gFV3vc=;
        b=NMi4ITa5qstI/mFhZpzOKZO+q03++HJxWYwrh6VPKQxyclL/d0fGA4dDYmiZToHXdv
         fiiIafYGbn7LQd0OuEOj2+U6pWQOK4pVcLR2xdqfKMDtSgHetX+aIBFaScjRjxICinVI
         jB67w/Ghc4HxD3Ks0iTiFsl0HDk/lUUehDD7t3za8sj/nWSJfRcDluNTgHDc1xTWLUjx
         2YKjtdpGOxrH+MLYWW0P7aGHHSct88IJLYI3hZODPbnefYBi33qdle3LlrSRD75MNYCN
         G3/3QDEOL/4C9NINLEIHvJFJNzXqZVgpAYrQAfL0UPyOmg8qdiNaKZ8POmbYFwOZQ/fE
         8+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=6qWZfrGs7oeJrH8rUBe+od/K5rWX/np8V/rd+gFV3vc=;
        b=NoMIKWBeriIEsmUJ3HaCCabTEYxdNSlve1yG0DC5/Iw5olInA/WDcFkZFFux4d2jxc
         bgWVrnUwGUMUcKD5ohviqHOPGc/LUQtZi/bkv6B6uvZb3Ladvw8qsZTiONyn25BsOuY+
         9r/HiW/x4B1hZ2yJ46C0up/ECg3RknCVNwIey/ZPCrIe3PcZnH6SXllEEUWOhYmIbRow
         /6V4HKj4W7P3R6e6KwULowkiYCqo8ZD3fiL4DdSlsUK3jgxKo06H5mSr2k4K647pXCJd
         DWohzZncQgOC4wkXxm2cCxgiKYimDwhuZhg+bRJx/3viynXdlGKMNw14BI0bgBx9YAKs
         Wh7w==
X-Gm-Message-State: AOAM533LBxwq68sUKR3kbajRHTyinp98jqt2dIjrvynXtVhAnDO/qsSz
        bjtEHV+d2fdNXTBUbU9UiZo=
X-Google-Smtp-Source: ABdhPJyhdt5eR6Y5Y7k4CuwOlG7GPT4/03CZ77FtCzpWxAEqCQw4YTOWJ+ldivqr2o0PUy6SgHI6VQ==
X-Received: by 2002:aa7:9ec6:0:b0:44d:6650:c1ff with SMTP id r6-20020aa79ec6000000b0044d6650c1ffmr4159417pfq.15.1634707600104;
        Tue, 19 Oct 2021 22:26:40 -0700 (PDT)
Received: from localhost (14-203-144-177.static.tpgi.com.au. [14.203.144.177])
        by smtp.gmail.com with ESMTPSA id c8sm887520pjr.38.2021.10.19.22.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 22:26:39 -0700 (PDT)
Date:   Wed, 20 Oct 2021 15:26:35 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 10/52] KVM: PPC: Book3S HV: Don't always save PMU for
 guest capable of nesting
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20211004160049.1338837-1-npiggin@gmail.com>
        <20211004160049.1338837-11-npiggin@gmail.com> <87zgr9w3dp.fsf@linux.ibm.com>
In-Reply-To: <87zgr9w3dp.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1634707495.9zbufpkpoy.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of October 16, 2021 10:38 pm:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> Provide a config option that controls the workaround added by commit
>> 63279eeb7f93 ("KVM: PPC: Book3S HV: Always save guest pmu for guest
>> capable of nesting"). The option defaults to y for now, but is expected
>> to go away within a few releases.
>>
>> Nested capable guests running with the earlier commit ("KVM: PPC: Book3S
>> HV Nested: Indicate guest PMU in-use in VPA") will now indicate the PMU
>=20
> I think the commit reference is now: 178266389794 (KVM: PPC: Book3S HV
> Nested: Reflect guest PMU in-use to L0 when guest SPRs are live)

Ah yes good point, would be good to that in the changelog. I guess we
can add a References: tag as well, just in case anybody mines this=20
stuff.

>=20
>> in-use status of their guests, which means the parent does not need to
>> unconditionally save the PMU for nested capable guests.
>>
>> After this latest round of performance optimisations, this option costs
>> about 540 cycles or 10% entry/exit performance on a POWER9 nested-capabl=
e
>> guest.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/kvm/Kconfig     | 15 +++++++++++++++
>>  arch/powerpc/kvm/book3s_hv.c | 10 ++++++++--
>>  2 files changed, 23 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
>> index ff581d70f20c..1e7aae522be8 100644
>> --- a/arch/powerpc/kvm/Kconfig
>> +++ b/arch/powerpc/kvm/Kconfig
>> @@ -130,6 +130,21 @@ config KVM_BOOK3S_HV_EXIT_TIMING
>>
>>  	  If unsure, say N.
>>
>> +config KVM_BOOK3S_HV_NESTED_PMU_WORKAROUND
>> +	bool "Nested L0 host workaround for L1 KVM host PMU handling bug" if E=
XPERT
>> +	depends on KVM_BOOK3S_HV_POSSIBLE
>> +	default !EXPERT
>> +	help
>> +	  Old nested HV capable Linux guests have a bug where the don't
>=20
> s/the/they/
>=20
> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
>=20

Good catch.

Thanks,
Nick
