Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1387866337
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Jul 2019 03:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbfGLBDD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Jul 2019 21:03:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32844 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfGLBDD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Jul 2019 21:03:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so3543643pfq.0
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Jul 2019 18:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=CSOrids+2zioMvfSrWdODBWKmkYKely5eESzBsRD2Fo=;
        b=IwY/wWZghazMrD24ZcxIPxEqQ/52LXPX+fJHue9+6Ludf48g47R6bsPVbPmnjIsMff
         TTAnd6bfXiuTT8VjD2CIzx64n/Zc+r5OpV5Z5AzA23oLuvme01kLEMlMPOI7qEbEObXE
         SUjoJgCzwgfLTLO8yoNbzerkajENWMuqpps1qaBUHy2qM8kjqIJEWRzFjlBZcIAnHZNJ
         j55dG5vVpe6l49daWA1stV+3iNJWzk5KRuN5zx/AbFocIHyZKFkvbvbfpkJUWNkMYfv/
         bon4fVW2s8Xia/4sYDHPy39y3E1uDwEcTWts4YFJ3eo6jqBB0qDsn7cbStBF7UMoVTpD
         YpLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=CSOrids+2zioMvfSrWdODBWKmkYKely5eESzBsRD2Fo=;
        b=AUDBdhxAOWRbRpVQ9BXoI/ZZqCWvzIXcirnGLQScJXs3EsOQxkOkXCUdMi8m05yERt
         7M+LyP8YuoXKyu0cZgxVejzlIX3ktq7DL6MbNLf7/9cuDSCCRtW9ziUYziV9Jq4uyImE
         2ZncH1AqrVy0l4yCgZ5i4Tcw0Tm5XcaTukqCSJA4Nf82wcMP2DRj9eUDqJpSqRi7ASYL
         1e8HWvOmPoebN/b0Qqmzy1w0r/yZpjnYJU6/t3DVD7tUsxycxQ3/dIIeQ9eoQ/h4PAo1
         el44JxiDm+dH4Fx1cv8/2yd5WXX7PWqGnLML+HeUtA1BHVlmBEEedeQOXFbRzHU8Qgrp
         Ya/w==
X-Gm-Message-State: APjAAAXnXC3hFxSB2Av1lvt4eH29WOyUNDfEoBfBVDvkhbFrNBTqs4sC
        /oNpb+7xJpJCTS36pyl7vj2YcM+f
X-Google-Smtp-Source: APXvYqw3C7x+FsI6OUFtrwBE5EEzLMQ9x81ocTuyF10ov7Sj+7r07N4dKob9w1E2TE0tmnrTDM+Vgw==
X-Received: by 2002:a63:1310:: with SMTP id i16mr7389668pgl.187.1562893382395;
        Thu, 11 Jul 2019 18:03:02 -0700 (PDT)
Received: from localhost ([220.240.228.224])
        by smtp.gmail.com with ESMTPSA id u23sm7183631pfn.140.2019.07.11.18.03.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 18:03:01 -0700 (PDT)
Date:   Fri, 12 Jul 2019 10:59:54 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 1/8] KVM: PPC: Ultravisor: Introduce the MSR_S bit
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Michael Anderson <andmike@linux.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        kvm-ppc@vger.kernel.org, Ram Pai <linuxram@us.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
        <20190628200825.31049-2-cclaudio@linux.ibm.com>
        <87muhkg258.fsf@concordia.ellerman.id.au>
In-Reply-To: <87muhkg258.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1562893118.ys3k642fnf.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Michael Ellerman's on July 11, 2019 10:57 pm:
> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
>> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>>
>> The ultravisor processor mode is introduced in POWER platforms that
>> supports the Protected Execution Facility (PEF). Ultravisor is higher
>> privileged than hypervisor mode.
>>
>> In PEF enabled platforms, the MSR_S bit is used to indicate if the
>> thread is in secure state. With the MSR_S bit, the privilege state of
>> the thread is now determined by MSR_S, MSR_HV and MSR_PR, as follows:
>>
>> S   HV  PR
>> -----------------------
>> 0   x   1   problem
>> 1   0   1   problem
>> x   x   0   privileged
>> x   1   0   hypervisor
>> 1   1   0   ultravisor
>> 1   1   1   reserved
>=20
> What are you trying to express with the 'x' value?
>=20
> I guess you mean it as "either" or "don't care" - but then you have
> cases where it could only have one value, such as hypervisor. I think it
> would be clearer if you spelled it out more explicitly.
>=20
>> The hypervisor doesn't (and can't) run with the MSR_S bit set, but a
>> secure guest and the ultravisor firmware do.
>=20
> I know you're trying to be helpful, but this comment is really just
> confusing to someone who doesn't have all the documentation.
>=20
> I'd really like to see something in Documentation/powerpc describing at
> least the outline of how the system works. I'm pretty sure most of that
> is public, so even if it's mostly a list of references to other
> documentations or presentations that would be fine. But I'm not really
> happy with a whole new processor mode appearing with zero documentation
> in the tree.
>=20
>> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
>> [ Update the commit message ]
>=20
> It's normal to prefix these comments with your handle to make it clear
> who is saying it.
>=20
>> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
>> ---
>>  arch/powerpc/include/asm/reg.h | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/r=
eg.h
>> index 10caa145f98b..39b4c0a519f5 100644
>> --- a/arch/powerpc/include/asm/reg.h
>> +++ b/arch/powerpc/include/asm/reg.h
>> @@ -38,6 +38,7 @@
>>  #define MSR_TM_LG	32		/* Trans Mem Available */
>>  #define MSR_VEC_LG	25	        /* Enable AltiVec */
>>  #define MSR_VSX_LG	23		/* Enable VSX */
>> +#define MSR_S_LG	22		/* Secure VM bit */
>=20
> I don't think that's the best description, because it's also the
> Ultravisor bit when MSR[HV] =3D 1.
>=20
> So "Secure state" as you have below would be better IMO.

Ooops I see Michael covered everything I wrote, sorry for the noise
I missed the thread.

Thanks,
Nick

=
