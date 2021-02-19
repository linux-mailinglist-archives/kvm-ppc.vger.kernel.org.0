Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F177831F578
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 08:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBSHy3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 02:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhBSHy1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 02:54:27 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19857C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 23:53:47 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id p21so3238856pgl.12
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 23:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=MVbZ8wWeXK4mKt0FDnIsVjHfDjUPC/AonkPo50DERmU=;
        b=J1DgzqzZ9LJF1vU7jzT1alSndglPmtTubVdvorRlBogGbXxIBWXOzUsmYVtPPOkbtA
         nBmH2ur/Ia0xVshpTTd50K4kiZKmqMPpErARB4eH9ImQOGxDvftlUOwOGDYmRrfXDpw5
         Gkm6LNXDwMQeUkz8o9GbKB65Fu4xvzWAxuioffFrzjxbtwXB4/mSsC1YyhwyBGIl8QeE
         hsXmG6AHSLqcY4Pv9iF1hNGqSarDXbSb9x1IUwfVLsFsdt0FBgHm1p+Gj2OKOjwYAK3k
         cQqq0lMzGBVfI8jjQwpdcMX0xk+tprkUOfLsIxigJcVR6/8sZEXCTElbJ7lg7blq0oQY
         bpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=MVbZ8wWeXK4mKt0FDnIsVjHfDjUPC/AonkPo50DERmU=;
        b=I6xM0C0FJHh9YXK+qB5xVDb0wLpbHRNLLfpO3gePTeqCi4CCMBWsHxWjLJw25dNW0z
         Bx9s2ifxDX94LDWUvhKTPK2NuehbCvwwAGx4ABmbumnmmFHSNGTZ5m9of2pi/8DvCVsW
         8Ldwhs/gsXxZyp9tKqbbYda63gpHk5MX/NVGASo4BMhpLkzV94WOBWx8VMI7cQAcDiY3
         3QaIr1Ty1KVRlEVbR84ubv1UHHvJe16z6CWUv5SvJ4rCrZ7afGTQnyRWP/U0P9Ujuumq
         qHwgT3hHX4gtRe/rBc+oiIC0OD+xVE/G5BQ8Nzi60fQRkFJfZCAeEg3R779fGHwxNfLP
         Glzw==
X-Gm-Message-State: AOAM530rs2yNJJQSgx0K5YjWjsqBZAkva7thWXO7BHM6GCUdDLr1yfML
        6UepZMdYZnCrwMFJ3lxwMpY=
X-Google-Smtp-Source: ABdhPJx3VO2cY7orZDKXRSXv0vR6GXUieSy9Y0LgkAERz+JrqHz7jFXKMFxFromnW9yQlpSyp3hBNg==
X-Received: by 2002:a63:1524:: with SMTP id v36mr7476851pgl.383.1613721226763;
        Thu, 18 Feb 2021 23:53:46 -0800 (PST)
Received: from localhost (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id y67sm8297845pfb.71.2021.02.18.23.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 23:53:46 -0800 (PST)
Date:   Fri, 19 Feb 2021 17:53:40 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 2/9] KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test
 into KVM
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210202030313.3509446-1-npiggin@gmail.com>
        <20210202030313.3509446-3-npiggin@gmail.com> <87tuqhxc01.fsf@linux.ibm.com>
In-Reply-To: <87tuqhxc01.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1613721057.j3az02k29i.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of February 13, 2021 6:33 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> Move the GUEST_MODE_SKIP logic into KVM code. This is quite a KVM
>> internal detail that has no real need to be in common handlers.
>=20
> LGTM,
>=20
>>
>> (XXX: Need to confirm CBE handlers etc)
>=20
> Do these interrupts exist only in Cell? I see that they set HSRRs and
> MSR_HV, but CPU_FTRS_CELL does not contain CPU_HVMODE. So I don't get
> why they use the KVM macros.

Good question, I asked Michael Ellerman and he said there is a bare=20
metal Cell which predates or otherwise does not define HVMODE.

However it does not support KVM. So I think we can remove it.

> And for the instruction_breakpoint (0x1300) I think it would help if we
> could at least restrict when it is built. But I don't know what
> ISA/processor version it is from.

Yeah we should be documenting these non-architected handlers a little=20
better IMO.

I think we can get rid of the kvm skip from this one though. I've done=20
that in a separate patch in the next series.

Thanks,
Nick
