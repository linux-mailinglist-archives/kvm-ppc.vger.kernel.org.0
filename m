Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28203EAF25
	for <lists+kvm-ppc@lfdr.de>; Fri, 13 Aug 2021 06:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhHMEYw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 13 Aug 2021 00:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbhHMEYw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 13 Aug 2021 00:24:52 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8C8C061756
        for <kvm-ppc@vger.kernel.org>; Thu, 12 Aug 2021 21:24:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so9969881pje.0
        for <kvm-ppc@vger.kernel.org>; Thu, 12 Aug 2021 21:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=ZG8u5JqkaCnIFNbp9FOjbtT2z+Th7vXD/EU3z+QFY98=;
        b=l4uYoKlwfge+Ua9qjkcGwl6t940v791ZXgaj6649PPh/h+wW77+hnapqHapJitBZkY
         iHeUkamfAbooqiKTeae6BOCzGIC0dLEpjthCH7GJCL6v+MzjrAE0qLGmiV6Ne3nTaPC6
         LqSpUg0Absi3pP+EQPvnZvSTJ60kk/5hAT5bXn5Mf81wC0Nb2pYbgfEqN7cgFxDHoiU5
         pDHd1+KuZUxYoJqEAINiBMySj2BaTlKpox1UtscdFJDhQdSFBXm8FsFSRWkeopK2OS+I
         6o9m12DGboWm+vDoBTaZ72w0wcdCrZkQUybQiByGsqvbMR1dQx/T6Hl2mzBptlunjDDZ
         HQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=ZG8u5JqkaCnIFNbp9FOjbtT2z+Th7vXD/EU3z+QFY98=;
        b=F+I0FI83TAO4Bi4M6GqhiZGOkSXdeqE6foLpGgcR3BdNYXPAlkluTlhn1mnRqNYX37
         YuYBEC7KR5uPVxcF78D4b1got0YVvV7WdHfIMPGHMJzixRo0aSAaH4lFVeem/1z5wlP2
         A2t8jdxd3Z26C/yZ5mpPLC76jn3M3fXZMPS8Wef0Cp0SRiMy1CFXW0WQP1Zsbp3nUSzQ
         nuoFwnVdXQ/bP7/4WRmTOGzLqGMv86Il0ZA/c8e/fEGr1A5fyxNIrPVQLXirEhCyEmpY
         AI9IzMfFQ34ICswH8xTNzU+ADwiAbAM7PwciDCWTOe2H1MBYPxbsFlMTDV5vFZY0tMR6
         fbYw==
X-Gm-Message-State: AOAM530fZJmjDdhRqhEBoerPd2Km+X6cb0fjswODFG8lBlDkWp5XQxUW
        qNbwo5d3djI1S+lfmIXz5AM=
X-Google-Smtp-Source: ABdhPJy9lc+QRcGeoR3JvdGwr2//OMVgkrnWgjE152qfYG4Cmk82H5ah8+NnPzV9Pfbqd7dALyDd3w==
X-Received: by 2002:a17:90b:3144:: with SMTP id ip4mr604052pjb.42.1628828664801;
        Thu, 12 Aug 2021 21:24:24 -0700 (PDT)
Received: from localhost (60-242-208-220.static.tpgi.com.au. [60.242.208.220])
        by smtp.gmail.com with ESMTPSA id ca7sm337700pjb.11.2021.08.12.21.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 21:24:24 -0700 (PDT)
Date:   Fri, 13 Aug 2021 14:24:19 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v1 17/55] KVM: PPC: Book3S HV P9: Implement PMU
 save/restore in C
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20210726035036.739609-1-npiggin@gmail.com>
        <20210726035036.739609-18-npiggin@gmail.com>
        <1A47BBEF-FC8C-4C4D-8393-9DE66B7FF96C@linux.vnet.ibm.com>
In-Reply-To: <1A47BBEF-FC8C-4C4D-8393-9DE66B7FF96C@linux.vnet.ibm.com>
MIME-Version: 1.0
Message-Id: <1628827731.ai2zz7xxwa.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Athira Rajeev's message of August 9, 2021 1:03 pm:
>=20
>=20
>> On 26-Jul-2021, at 9:19 AM, Nicholas Piggin <npiggin@gmail.com> wrote:


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
>> +
>> +do_freeze:
>> +	mmcr0 =3D MMCR0_FC;
>> +	mmcra =3D 0;
>> +	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
>> +		mmcr0 |=3D MMCR0_PMCCEXT;
>> +		mmcra =3D MMCRA_BHRB_DISABLE;
>> +	}
>> +
>> +	mtspr(SPRN_MMCR0, mmcr0);
>> +	mtspr(SPRN_MMCRA, mmcra);
>> +	isync();
>> +}
>> +
> Hi Nick,
>=20
> After feezing pmu, do we need to clear =E2=80=9Cpmcregs_in_use=E2=80=9D a=
s well?

Not until we save the values out of the registers. pmcregs_in_use =3D 0=20
means our hypervisor is free to clear our PMU register contents.

> Also can=E2=80=99t we unconditionally do the MMCR0/MMCRA/ freeze settings=
 in here ? do we need the if conditions for FC/PMCCEXT/BHRB ?

I think it's possible, but pretty minimal advantage. I would prefer to=20
set them the way perf does for now. If we can move this code into perf/
it should become easier for you to tweak things.

Thanks,
Nick
